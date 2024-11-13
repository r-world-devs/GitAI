#' @name process_repos
#' @param gitai A GitAI object.
process_repos <- function(gitai) {
  gitstats <- gitai$gitstats |>
    GitStats::verbose_off()
  gitai$repos_metadata <- GitStats::get_repos(gitstats)
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
  gitai$files_content <- files_content
  invisible(gitai)
}
