#' Initialize a `GitAI` project.
#' @param project_id A character, ID of the project.
#' @return A \code{GitAI} object.
#' @export
initialize_project <- function(project_id) {

  GitAI$new(project_id = project_id)

}
