#' @noRd
add_metadata <- function(result, content) {
  web_url <- content$repo_url[1]
  api_url <- content$api_url[1]
  if (grepl("github", api_url)) {
    api_url <- github_repo(api_url)
  } else {
    api_url <- gitlab_repo(api_url)
  }
  result[["metadata"]] <- list(
    repo_url = web_url,
    files = paste0(content$file_path, collapse = ", "),
    timestamp = get_repo_date(api_url)
  )
  result
}

get_repo_date <- S7::new_generic("get_repo_date", "repo_api_url")

github_repo <- S7::new_class(
  "github_repo",
  properties = list(repo = S7::class_character)
)

gitlab_repo <- S7::new_class(
  "gitlab_repo",
  properties = list(repo = S7::class_character)
)

S7::method(get_repo_date, github_repo) <- function(repo_api_url) {
  repo_data <- get_response(repo_api_url@repo)
  lubridate::as_datetime(repo_data$updated_at)
}

S7::method(get_repo_date, gitlab_repo) <- function(repo_api_url) {
  repo_data <- get_response(
    endpoint = repo_api_url@repo,
    token = Sys.getenv("GITLAB_PAT")
  )
  lubridate::as_datetime(repo_data$last_activity_at)
}

get_response <- function(endpoint, token = Sys.getenv("GITHUB_PAT")) {
  httr2::request(endpoint) |>
    httr2::req_headers("Authorization" = paste0("Bearer ", token)) |>
    httr2::req_perform() |>
    httr2::resp_body_json()
}
