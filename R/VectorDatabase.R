VectorDatabase <- R6::R6Class(
  classname = "VectorDatabase",
  public = list(

    initialize = function(project_id, ...) {

      private$.project_id <- project_id

      private$.initialize(...)
    },

    get_embeddings = function(text) {
      stop(call. = FALSE, "Not implemented yet.")
    },

    write_record = function(id, embeddings, metadata) {
      stop(call. = FALSE, "Not implemented yet.")
    },

    find_records = function(query) {
      stop(call. = FALSE, "Not implemented yet.")
    }
  ),

  private = list(
    .project_id = NULL,

    .initialize = function(...) {}
  )
)