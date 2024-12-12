#' Add files to `GitAI` object.
#' @name add_files
#' @param gitai A \code{GitAI} object.
#' @param files A character vector of file paths. May be defined with
#'   regular expression.
#' @return A \code{GitAI} object.
#' @export
add_files <- function(gitai, files) {
  if (!is.null(files)) {
    if (!is.character(files)) {
      cli::cli_abort("`files` must be a character.")
    }
  }
  gitai$files <- files
  invisible(gitai)
}
