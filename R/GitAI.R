GitAI <- R6::R6Class(
  classname = "GitAI",
  public = list(
    initialize = function(project_id) {

      private$.project_id <- project_id
    },

    process_repos = function() {
      private$.gitstats
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
    },

    gitstats = function(value) {
      if (missing(value)) return(private$.gitstats)
      private$.gitstats <- value
    },

    file_paths = function(value) {
      if (missing(value)) return(private$.file_paths)
      private$.file_paths <- value
    },

    file_types = function(value) {
      if (missing(value)) return(private$.file_types)
      private$.file_types <- value
    },

    repos_metadata = function(value) {
      if (missing(value)) return(private$.repos_metadata)
      private$.repos_metadata <- value
    },

    files_content = function(value) {
      if (missing(value)) return(private$.files_content)
      private$.files_content <- value
    }
  ),

  private = list(
    .project_id = NULL,
    .llm = NULL,
    .gitstats = NULL,
    .file_paths = NULL,
    .file_types = NULL,
    .repos_metadata = NULL,
    .files_content = NULL
  )
)
