#' Set GitHub repositories in `GitAI` object.
#' @name set_github_repos
#' @param gitai A \code{GitAI} object.
#' @param ... Parameters to pass to \code{\link[GitStats]{set_github_host}}
#'   function.
#' @param verbose A logical. If \code{FALSE} you won't be getting additional
#'   diagnostic messages.
#' @return A \code{GitAI} object.
#' @export
set_github_repos <- function(gitai,
                             ...,
                             verbose = is_verbose()) {
  if (is.null(gitai$gitstats)) {
    gitstats <- GitStats::create_gitstats()
  } else {
    gitstats <- gitai$gitstats
  }
  gitai$gitstats <- gitstats |>
    GitStats::set_github_host(
      ...,
      verbose = verbose
    )
  invisible(gitai)
}

#' Set GitLab repositories in `GitAI` object.
#' @name set_gitlab_repos
#' @param gitai A \code{GitAI} object.
#' @param ... Parameters to pass to \code{\link[GitStats]{set_gitlab_host}}
#'   function.
#' @param verbose A logical. If \code{FALSE} you won't be getting
#' additional diagnostic messages.
#' @return A \code{GitAI} object.
#' @export
set_gitlab_repos <- function(gitai,
                             ...,
                             verbose = is_verbose()) {
  if (is.null(gitai$gitstats)) {
    gitstats <- GitStats::create_gitstats()
  } else {
    gitstats <- gitai$gitstats
  }
  gitai$gitstats <- gitstats |>
    GitStats::set_gitlab_host(
      ...,
      verbose = verbose
    )
  invisible(gitai)
}
