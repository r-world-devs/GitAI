#' Run LLM on repositories content
#' @name process_repos
#' @param gitai A GitAI object.
#' @return A list.
#' @export
process_repos <- function(gitai) {

  gitstats <- gitai$gitstats

  gitai$repos_metadata <-
    GitStats::get_repos(gitstats,
                        add_contributors = FALSE)

  GitStats::get_files_structure(
    gitstats_object = gitstats,
    pattern = gitai$files,
    depth = 1L
  )
  files_content <- GitStats::get_files_content(gitstats)

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
