#' Add files to GitAI object.
#' @name add_files
#' @param gitai A GitAI object.
#' @param files A character vector of file paths. May be defined with
#'   regular expression.
#' @return GitAI object.
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

is_file_path_pattern <- function(string) {
  all(grepl("([/\\\\]|\\w+\\.\\w{2,4}|\\w{1,255})$", string)) &&
    all(!grepl("^\\*?\\.\\w{2,4}$", string))
}

is_file_type_regex <- function(string){
  all(grepl("^\\*?\\.\\w{2,4}$|^.*\\*\\.\\w{2,4}$", string))
}
