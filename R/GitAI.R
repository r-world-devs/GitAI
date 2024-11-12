GitAI <- R6::R6Class(
  classname = "GitAI",
  public = list(
    initialize = function(project_id) {

      private$.project_id <- project_id
    }

  ),

  active = list(

    project_id = function() {
      private$.project_id
    },

    llm = function(value) {
      if (missing(value)) return(private$.llm)
        private$.llm <- value
      },

    system_prompt = function(value) {

      if (is.null(private$.llm)) 
        stop(call. = FALSE, "LLM not set. Use set_llm() first.")
      
      if (missing(value)) return(private$.llm$system_prompt)
      private$.llm$system_prompt <- value
    }
  ),

  private = list(
    .project_id = NULL,
    .llm = NULL,

    # TODO:
    .gitstats = NULL

  )
)