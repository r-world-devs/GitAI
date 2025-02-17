GitAI <- R6::R6Class(
  classname = "GitAI",
  public = list(
    initialize = function(project_id) {

      private$.project_id <- project_id
    },

    print = function() {
      cat(cli::style_bold("A ", cli::col_yellow("GitAI"), " object: \n"))
      private$print_project_id()
      private$print_files()
      private$print_llm_data()
      private$print_db_data()
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

    db = function(value) {
      if (missing(value)) return(private$.db)
      private$.db <- value
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
    .db = NULL,
    .gitstats = NULL,
    .files = NULL,
    .repos_metadata = NULL,
    .files_content = NULL,

    print_project_id = function() {
      cat(cli::col_br_yellow("Project ID:"), private$.project_id, "\n")
    },

    print_files = function() {
      if (is.null(private$.files)) {
        cat(cli::col_br_yellow("Files:"), cli::col_grey("not added"), "\n")
      } else {
        cat(cli::col_br_yellow("Files:"),
            paste0(private$.files, collapse = ", ")
            , "\n")
      }
    },

    print_llm_data = function() {
      if (is.null(private$.llm)) {
        cat(cli::col_br_yellow("LLM:"), cli::col_grey("not set"), "\n")
      } else {
        cat(cli::col_br_yellow("LLM:"), "set", "\n")
      }
    },

    print_db_data = function() {
      if (is.null(private$.db)) {
        cat(cli::col_br_yellow("Database:"), cli::col_grey("not set"), "\n")
      } else {
        browser()
        cat(cli::col_br_yellow("Database:"), "set", "\n")
      }
    }
  )
)
