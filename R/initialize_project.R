#' Initialize GitAI project
#' @param project_id A character, ID of the project.
#' @return GitAI object.
#' @export
initialize_project <- function(project_id) {

  GitAI$new(project_id = project_id)

}
