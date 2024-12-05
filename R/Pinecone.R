Pinecone <- R6::R6Class(
  classname = "Pinecone",
  inherit = VectorDatabase,
  public = list(

    get_index_metadata = function() {

      pinecone_api_key <- Sys.getenv("PINECONE_API_KEY")

      url <- paste0("https://api.pinecone.io/indexes/", private$.index)
      
      httr2::request(url) |> 
      httr2::req_headers(
        "Api-Key" = pinecone_api_key
      ) |> 
        httr2::req_perform() |> 
        httr2::resp_body_json()

    },  
      
    write_record = function(id, text, metadata = list()) {
      
      pinecone_api_key <- Sys.getenv("PINECONE_API_KEY") 
      
      url <- paste0("https://", private$.index_host) 
      
      embeddings <- private$.get_embeddings(text = text)
      
      metadata$text <- text
      
      body <- list(
        namespace = private$.namespace,
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
    
    find_records = function(query, top_k = 1) {
      
      embeddings <- private$.get_embeddings(query)
      
      pinecone_api_key <- Sys.getenv("PINECONE_API_KEY")
      
      url <- paste0("https://", private$.index_host)
      
      body <- list(
        namespace = private$.namespace,
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

  active = list(
    
    namespace = function(value) {
      if (missing(value)) return(private$.namespace)
      private$.namespace <- value
    },

    index = function(value) {
      if (missing(value)) return(private$.index)
      private$.index <- value
    }
  ),
    
  private = list(
    
    .project_id = NULL,
    .index      = NULL,
    .namespace  = NULL,
    .index_host = NULL,
    
    .initialize = function(index, namespace) {

      private$.index   <- index
      private$.namespace  <- namespace
      private$.index_host <- self$get_index_metadata()$host
    },

    .get_embeddings = function(text) {
  
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
      
    }
  )
)