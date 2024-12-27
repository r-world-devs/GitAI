#' @noRd
#' @description A helper class to cache and mock results.
Mocker <- R6::R6Class(
  "Mocker",
  public = list(

    #' @field storage A list to store objects.
    storage = list(),

    #' @description Method to cache objects.
    cache = function(object = NULL) {
      object_name <- deparse(substitute(object))
      self$storage[[paste0(object_name)]] <- object
    },

    #' @description Method to retrieve objects.
    use = function(object_name) {
      self$storage[[paste0(object_name)]]
    }
  )
)

PineconeMocked <- R6::R6Class(
  "PineconeMocked",
  inherit = Pinecone,
  public = list(
    get_index_metadata = function() {
      pinecone_api_key <- Sys.getenv("PINECONE_API_KEY")

      url <- paste0("https://api.pinecone.io/indexes/", private$.index)

      response <- httr2::response_json(
        body = test_fixtures[["pinecone_index_response"]]
      )
      httr2::resp_body_json(response)
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

      request <- httr2::request(url) |>
        httr2::req_url_path_append("vectors/upsert") |>
        httr2::req_headers(
          "Api-Key" = pinecone_api_key,
          "X-Pinecone-API-Version" = "2024-10"
        ) |>
        httr2::req_body_json(body)

      response <- httr2::response_json(
        body = list("upsertedCount" = 1)
      )

      response_body <- httr2::resp_body_json(response)
      response_body
    },

    read_record = function(id) {

      pinecone_api_key <- Sys.getenv("PINECONE_API_KEY")

      url <- paste0("https://", private$.index_host)

      request <- httr2::request(url) |>
        httr2::req_url_path_append("vectors") |>
        httr2::req_url_path_append("fetch") |>
        httr2::req_url_query(
          ids = id,
          namespace = private$.namespace
        ) |>
        httr2::req_headers(
          "Api-Key" = pinecone_api_key,
          "X-Pinecone-API-Version" = "2024-10"
        )

      response <- httr2::response_json(
        body = test_fixtures[["read_record"]]
      )

      response_body <- httr2::resp_body_json(response)
      results <- response_body$vectors

      results
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

      request <- httr2::request(url) |>
        httr2::req_url_path_append("query") |>
        httr2::req_headers(
          "Api-Key" = pinecone_api_key,
          "X-Pinecone-API-Version" = "2024-10"
        ) |>
        httr2::req_body_json(body)

      response <- httr2::response_json(
        body = test_fixtures[["matched_records"]]
      )

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

      request <- httr2::request(url) |>
        httr2::req_url_path_append("embed") |>
        httr2::req_headers(
          "Api-Key" = pinecone_api_key,
          "X-Pinecone-API-Version" = "2024-10"
        ) |>
        httr2::req_body_json(body)

      response <- httr2::response_json(
        body = test_fixtures[["embeddings"]]
      )

      response_body <- httr2::resp_body_json(response)

      response_body$data[[1]]$values |> unlist()
    }
  )
)

test_fixtures <- list()

test_fixtures[["pinecone_index_response"]] <- list(
  "name" = "gitai",
  "metric" = "cosine",
  "dimension" = 1024L,
  "status" = list(
    "ready" = TRUE,
    "state" = "Ready"
  ),
  "host" = "gitai-test-host",
  "spec" = list(
    "serverless" = list(
      "region" = "us-east-1",
      "cloud" = "aws"
    )
  )
)

test_fixtures[["embeddings"]] <- list(
  "model" = "multilingual-e5-large",
  "data" = list(
    list(
      "values" = list(
        runif(1024L, -1, 1) |> as.list()
      )
    )
  ),
  "usage" = list(
    "total_tokens" = 78L
  )
)

test_fixtures[["matched_records"]] <- list(
  "results" = list(),
  "matches" = list(
    list(
      "id" = "id_2",
      "score" = 0.820673,
      "values" = list(),
      "metadata" = list(
        "files" = c("test_file1", "test_file2"),
        "repo_url" = "test_url",
        "text" = "This package will best suite you.",
        "timestamp" = Sys.Date()
      )
    )
  ),
  "namespace" = "gitai-tests",
  "usage" = list("readUnits" = 10L)
)

test_fixtures[["read_record"]] <- list(
  "vectors" = list(
    "TestProject" = list(
      "values" = test_fixtures[["embeddings"]][["data"]][[1]]["values"],
      "metadata" = test_fixtures[["matched_records"]][["matches"]][[1]][["metadata"]]
    )
  ),
  "namespace" = "gitai-tests",
  "usage" = list("readUnits" = 1L)
)
