#' Checks if \code{GitAI} is verbose
#'
#' The function searches for \code{GITAI_VERBOSE} environmental variable
#' and tries to read it value as logical.
#'
#' @returns A logical. Default is \code{TRUE}.
#'
#' @export
is_verbose <- function() {

  verbose <- Sys.getenv("GITAI_VERBOSE", TRUE)
  verbose <- as.logical(verbose)
  verbose <- ifelse(is.na(verbose), TRUE, verbose)
  verbose
}

#' Sets \code{GitAI} to be verbose
#'
#' The function sets the \code{GITAI_VERBOSE} environmental variable
#' to \code{TRUE}.
#'
#' @export
verbose_on <- function() {

  Sys.setenv("GITAI_VERBOSE" = TRUE)
}

#' Sets \code{GitAI} to be quiet.
#'
#' The function sets the \code{GITAI_VERBOSE} environmental variable
#' to \code{FALSE}.
#'
#' @export
verbose_off <- function() {

  Sys.setenv("GITAI_VERBOSE" = FALSE)
}
