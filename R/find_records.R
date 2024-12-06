#' Finding top K records in a vector database.
#' 
#' @param query A character, user query.
#' @param top_k A numeric, number of top K records to return.
#' @inheritParams process_repos
#' 
#' @export
find_records <- function(
  gitai, 
  query,
  top_k = 1,
  verbose = is_verbose()
) {

  gitai$db$find_records(
    query = query, 
    top_k = top_k
  )
}
