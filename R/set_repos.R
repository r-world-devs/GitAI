#' Set GitHub repositories in GitAI object.
#' @name set_github_repos
#' @param gitai A GitAI object.
#' @param host A character, GitHub host.
#' @param repos A character vector or repositories full names.
#' @return GitAI object.
#' @export
set_github_repos <- function(gitai,
                             host = NULL,
                             repos) {
  if (is.null(gitai$gitstats)) {
    gitstats <- GitStats::create_gitstats()
  } else {
    gitstats <- gitai$gitstats
  }
  gitai$gitstats <- gitstats |>
    GitStats::set_github_host(
      host = host,
      repos = repos,
      verbose = FALSE
    )
  invisible(gitai)
}

#' Set GitLab repositories in GitAI object.
#' @name set_gitlab_repos
#' @param gitai A GitAI object.
#' @param host A character, GitLab host.
#' @param repos A character vector or repositories full names.
#' @return GitAI object.
#' @export
set_gitlab_repos <- function(gitai,
                             host = NULL,
                             repos) {
  if (is.null(gitai$gitstats)) {
    gitstats <- GitStats::create_gitstats()
  } else {
    gitstats <- gitai$gitstats
  }
  gitai$gitstats <- gitstats |>
    GitStats::set_gitlab_host(
      host = host,
      repos = repos,
      verbose = FALSE
    )
  invisible(gitai)
}
