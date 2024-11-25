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

      if (missing(value)) return(private$.llm$get_system_prompt())
      private$.llm$set_system_prompt(value)
    },

    gitstats = function(value) {
      if (missing(value)) return(private$.gitstats)
      private$.gitstats <- value
    },

    files = function(value) {
      if (missing(value)) return(private$.files)
      private$.files <- value
    },

    repos_metadata = function(value) {
      if (missing(value)) return(private$.repos_metadata)
      private$.repos_metadata <- value
    }

  ),

  private = list(
    .project_id = NULL,
    .llm = NULL,
    .gitstats = NULL,
    .files = NULL,
    .repos_metadata = NULL,
    .files_content = NULL
  )
)
