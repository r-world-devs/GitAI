#' Run LLM on `GitAI` repositories content
#' @name process_repos
#' @param gitai A \code{GitAI} object.
#' @param verbose A logical. If \code{FALSE} you won't be getting
#' additional diagnostic messages.
#' @return A list.
#' @export
process_repos <- function(
  gitai,
  depth = 1,
  verbose = is_verbose()
) {

  gitstats <- gitai$gitstats

  gitai$repos_metadata <- GitStats::get_repos(
    gitstats,
    add_contributors = FALSE,
    verbose = verbose
  )
  GitStats::get_files_structure(
    gitstats_object = gitstats,
    pattern = paste0(gitai$files, collapse = "|"),
    depth = depth,
    verbose = verbose
  )
  files_content <- GitStats::get_files_content(gitstats, verbose = verbose)
  repositories <- unique(files_content$repo_name)
  api_urls    <- unique(files_content$api_url) 
  
  results <-
    purrr::map2(repositories, api_urls, function(repo_name, api_url) {
      
      current_repo_number <- which(repositories == repo_name)
      
      if (verbose) {
        cli::cli_alert(paste0(
          "Processing repository ",
          "[{current_repo_number}/{length(repositories)} ",
          "{round(current_repo_number / length(repositories) * 100, 2)}%]: ",
          "{.pkg {repo_name}}"
        ))
      }

      filtered_content <- files_content |>
        dplyr::filter(repo_name == !!repo_name)

      content_to_process <- filtered_content |>
        dplyr::pull(file_content) |>
        paste(collapse = "\n\n")

      if (!is.null(gitai$db)) {
        if (verbose) {
          cli::cli_alert_info("Checking repo timestamp...")
        }
        record <- gitai$db$read_record(id = repo_name)
        
        if (NROW(record) > 0) {

          record <- record[[1]]
          record_timestamp <- as.POSIXct(record$metadata$timestamp, tz = "UTC")
          
          if (grepl("github", api_url)) {
            api_url <- github_repo(api_url)
          } else {
            api_url <- gitlab_repo(api_url)
          }
          
          repo_timestamp <- get_repo_date(api_url)
          
          if (repo_timestamp <= record_timestamp) {
            if (verbose) {
              cli::cli_alert_info("Repo has not been updated. Skipping...")
            }
            return(NULL)
          }
        }
      }

      if (verbose) {
        cli::cli_alert_info("Processing content with LLM...")
      }
      result <- process_content(
        gitai = gitai,
        content = content_to_process
      ) |>
        add_metadata(content = filtered_content)

      if (!is.null(gitai$db)) {
        if (verbose) {
          cli::cli_alert_info("Writing to database...")
        }
        gitai$db$write_record(
          id = repo_name,
          text = result$text,
          metadata = result$metadata
        )
      }
      result
    }) |>
    purrr::set_names(repositories)

  invisible(results)
}
