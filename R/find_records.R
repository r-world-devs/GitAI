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