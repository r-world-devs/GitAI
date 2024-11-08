GitAI <- R6::R6Class(
  classname = "GitAI",
  public = list(
    initialize = function(project_id) {

      private$.project_id <- project_id
    },

    set_prompt = function(system_prompt) {

      private$.llm$system_prompt <- system_prompt
      invisible(self)
    }
  ),

  active = list(

    project_id = function() {
      private$.project_id
    },

    llm = function(value) {

      if (missing(value)) return(private$.llm)
      private$.llm <- value
    }
  ),

  private = list(
    .project_id = NULL,
    .llm = NULL,

    # TODO:
    .gitstats = NULL

  )
)