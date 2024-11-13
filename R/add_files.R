#' @name add_files
#' @param file_paths A character vector of file names.
#' @param file_types A regular expression.
#' @export
add_files <- function(gitai, file_paths = NULL, file_types = NULL) {
  if (is.null(file_paths) && is.null(file_types)) {
    cli::cli_abort("You need to define `file_paths` or `file_types`.")
  }
  if (!is.null(file_paths)) {
    if (!is.character(file_paths)) {
      cli::cli_abort("`file_paths` must be a character.")
    } else if (!is_file_path_pattern(file_paths)) {
      cli::cli_abort(c(
        "x" = "`file_path` is not a file path pattern."
      ))
    }
    gitai$file_paths <- file_paths
  }
  if (!is.null(file_types)) {
    if (!is.character(file_types)) {
      cli::cli_abort("`file_types` must be a character.")
    } else if (!is_file_type_regex(file_types)) {
      cli::cli_abort("`file_types` is not a regex.")
    }
    gitai$file_types <- file_types
  }
  invisible(gitai)
}

is_file_path_pattern <- function(string) {
  all(grepl("([/\\\\]|\\w+\\.\\w{2,4}|\\w{1,255})$", string)) &&
    all(!grepl("^\\*?\\.\\w{2,4}$", string))
}

is_file_type_regex <- function(string){
  all(grepl("^\\*?\\.\\w{2,4}$|^.*\\*\\.\\w{2,4}$", string))
}
