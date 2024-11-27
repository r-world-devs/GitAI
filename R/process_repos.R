#' Run LLM on `GitAI` repositories content
#' @name process_repos
#' @param gitai A \code{GitAI} object.
#' @param verbose A logical. If \code{FALSE} you won't be getting
#' additional diagnostic messages.
#' @return A list.
#' @export
process_repos <- function(gitai, verbose = is_verbose()) {

  gitstats <- gitai$gitstats

  gitai$repos_metadata <-
    GitStats::get_repos(gitstats,
                        add_contributors = FALSE,
                        verbose = verbose)

  GitStats::get_files_structure(
    gitstats_object = gitstats,
    pattern = gitai$files,
    depth = 1L,
    verbose = verbose
  )
  files_content <- GitStats::get_files_content(gitstats, verbose = verbose)
  repositories <- unique(files_content$repo_name)
  results <-
    repositories |>
    purrr::map(function(repo_name) {
      if (verbose) {
        cli::cli_alert_info("Processing repository: {.pkg {repo_name}}")
      }

      content_to_process <-
        files_content |>
        dplyr::filter(repo_name == !!repo_name) |>
        dplyr::pull(file_content) |>
        paste(collapse = "\n\n")

      process_content(gitai = gitai, content = content_to_process)

    }) |>
    purrr::set_names(repositories)

  results
}
