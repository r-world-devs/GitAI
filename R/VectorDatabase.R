VectorDatabase <- R6::R6Class(
  classname = "VectorDatabase",
  public = list(

    initialize = function(...) {

      private$.initialize(...)
    },
    
    write_record = function(id, embeddings, metadata) {
      stop(call. = FALSE, "Not implemented yet.")
    },
    
    find_records = function(query, top_k = 1) {
      stop(call. = FALSE, "Not implemented yet.")
    }
  ),
  
  private = list(

    .initialize = function(...) {},

    .get_embeddings = function(text) {
      stop(call. = FALSE, "Not implemented yet.")
    }
  )
)