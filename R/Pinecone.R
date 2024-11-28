Pinecone <- R6::R6Class(
  classname = "Pinecone",
  inherit = VectorDatabase,
  public = list(

    get_index_metadata = function() {

      pinecone_api_key <- Sys.getenv("PINECONE_API_KEY")

      url <- paste0("https://api.pinecone.io/indexes/", private$.index_id)
      
      httr2::request(url) |> 
      httr2::req_headers(
        "Api-Key" = pinecone_api_key
      ) |> 
        httr2::req_perform() |> 
        httr2::resp_body_json()

    },  

    get_embeddings = function(text) {

      pinecone_api_key <- Sys.getenv("PINECONE_API_KEY") 

      url <- "https://api.pinecone.io"

      body <- list(
        model = "multilingual-e5-large",
        parameters = list(
          input_type = "passage",
          truncate = "END"
        ),  
        inputs = list(
          list(text = text)
        )  
      )  
    
      request <- 
        httr2::request(url) |> 
        httr2::req_url_path_append("embed") |> 
        httr2::req_headers(
          "Api-Key" = pinecone_api_key,
          "X-Pinecone-API-Version" = "2024-10"
        ) |> 
        httr2::req_body_json(body) 

      response <- 
        request |>  
        httr2::req_perform()
      
      response_body <- httr2::resp_body_json(response)

      response_body$data[[1]]$values |> unlist()
    },

    write_record = function(id, embeddings, metadata) {

      pinecone_api_key <- Sys.getenv("PINECONE_API_KEY") 

      url <- paste0("https://", private$.index_host) 

      body <- list(
        namespace = private$.project_id,
        vectors = list(
          id = id,
          values = embeddings,
          metadata = metadata
        )
      )

      request <- 
        httr2::request(url) |> 
        httr2::req_url_path_append("vectors/upsert") |> 
        httr2::req_headers(
          "Api-Key" = pinecone_api_key,
          "X-Pinecone-API-Version" = "2024-10"
        ) |> 
        httr2::req_body_json(body) 

      response <- 
        request |>  
        httr2::req_perform()
      
      response_body <- httr2::resp_body_json(response)
      response_body
    },

    find_records = function(query, top_k = 3) {

      embeddings <- self$get_embeddings(query)
      
      pinecone_api_key <- Sys.getenv("PINECONE_API_KEY")
      
      url <- paste0("https://", private$.index_host)
      
      body <- list(
        namespace = private$.project_id,
        vector = embeddings,
        topK = top_k,
        includeValues = FALSE,
        includeMetadata = TRUE
      )
      
      request <-
        httr2::request(url) |>
        httr2::req_url_path_append("query") |>
        httr2::req_headers(
          "Api-Key" = pinecone_api_key,
          "X-Pinecone-API-Version" = "2024-10"
        ) |>
        httr2::req_body_json(body)
      
      response <-
        request |> 
        httr2::req_perform()

      response_body <- httr2::resp_body_json(response)
      results <- response_body$matches

      results |> 
        purrr::map(function(result) {
          result$values <- NULL
          result
        })
    }
  ),

  private = list(

    .project_id = NULL,
    .index_id   = NULL,
    .index_host = NULL,

    .initialize = function(index_id) {

      private$.index_id <- index_id

      private$.index_host <- self$get_index_metadata()$host
    }
  )
)