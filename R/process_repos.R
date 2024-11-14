#' @name process_repos
#' @param gitai A GitAI object.
#' 
#' @export

process_repos <- function(gitai) {

  gitstats <- gitai$gitstats 

  gitai$repos_metadata <- 
    GitStats::get_repos(gitstats, 
                        add_contributors = FALSE)
  file_paths <- gitai$file_paths
  file_types <- gitai$file_types

  if (!is.null(file_paths)) {
    files_content <- gitstats |>
      GitStats::get_files_content(
        file_path = file_paths,
        use_files_structure = FALSE
      )
  }

  if (!is.null(file_types)) {
    GitStats::get_files_structure(
      gitstats_object = gitstats,
      pattern = file_types,
      depth = 1L
    )
    files_content <- GitStats::get_files_content(gitstats)
  }
  
  results <- 
    files_content$repo_name |> 
    purrr::map(function(repo_name) {
      
      cli::cli_alert_info("Processing repository: {.pkg {repo_name}}")
      
      content_to_process <- 
        files_content |> 
        dplyr::filter(repo_name == !!repo_name) |> 
        dplyr::pull(file_content) |> 
        paste(collapse = "\n\n")
      
      process_content(gitai = gitai, content = content_to_process) 
                
    }) |> purrr::set_names(files_content$repo_name)

  results
}
