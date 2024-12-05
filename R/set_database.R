#' @export
set_database <- function(
  gitai,
  provider = "Pinecone",
  ...
) {

  provider_class <- get(provider)

  args <- list(...)

  if (is.null(args$namespace)) {
    args$namespace <- gitai$project_id
  }

  db <- do.call(
    what = provider_class$new, 
    args = args
  )
  
  gitai$db <- db
  invisible(gitai)
}