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
