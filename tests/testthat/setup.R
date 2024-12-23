test_mocker <- Mocker$new()

# Override other methods when needed in the future
ChatMocked <- R6::R6Class(
  "ChatMocked",
  inherit = elmer:::Chat,
  public = list(
    chat = function(..., echo = NULL) {
      if (self$get_system_prompt() == "You always return only 'Hi there!'") {
        return("Hi there!")
      }
    }
  )
)

# This method allows to skip original checks (e.g. for api or other args structure) and returns
# object of class ChatMocked that we can modify for our testing purposes.
mock_chat_method <- function(turns = NULL,
                             echo = c("none", "text", "all"),
                             ...,
                             provider_class) {

  provider_args <- rlang::dots_list(...)
  provider <- rlang::exec(provider_class, !!!provider_args)

  ChatMocked$new(provider = provider, turns = turns, echo = echo)
}

chat_openai_mocked <- function(system_prompt = NULL,
                               turns = NULL,
                               base_url = "https://api.mocked.com/v1",
                               api_key = "mocked_key",
                               model = NULL,
                               seed = NULL,
                               api_args = list(),
                               echo = c("none", "text", "all")) {

  turns <- elmer:::normalize_turns(turns, system_prompt)
  model <- elmer:::set_default(model, "gpt-4o")
  echo <- elmer:::check_echo(echo)

  if (is.null(seed)) {
    seed <- 1014
  }

  mock_chat_method(
    turns = turns,
    echo = echo,
    base_url = base_url,
    model = model,
    seed = seed,
    extra_args = api_args,
    api_key = api_key,
    provider_class = elmer:::ProviderOpenAI
  )
}

chat_bedrock_mocked <- function(system_prompt = NULL,
                                turns = NULL,
                                model = NULL,
                                profile = NULL,
                                echo = NULL) {

  credentials <- list(
    access_key_id = "access_key_id_mocked",
    secret_access_key = "access_key_id_mocked",
    session_token = "session_token_mocked",
    access_token = "access_token_mocked",
    expiration = as.numeric(Sys.time() + 3600),
    region = "eu-central-1"
  )

  turns <- elmer:::normalize_turns(turns, system_prompt)
  model <- elmer:::set_default(model, "model_bedrock")
  echo <- elmer:::check_echo(echo)

  mock_chat_method(
    turns = turns,
    echo = echo,
    base_url = "",
    model = model,
    profile = profile,
    credentials = credentials,
    provider_class = elmer:::ProviderBedrock
  )
}

PineconeMocked <- R6::R6Class(
  "PineconeMocked",
  inherit = Pinecone,
  public = list(
    get_index_metadata = function() {
      pinecone_api_key <- Sys.getenv("PINECONE_API_KEY")

      url <- paste0("https://api.pinecone.io/indexes/", private$.index)

      httr2::request(url) |>
        httr2::req_headers("Api-Key" = pinecone_api_key) |>
        httr2::req_dry_run(quiet = TRUE)
      test_fixtures[["pinecone_index_response"]]
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

      response <- request |>
        httr2::req_dry_run(quiet = TRUE)

      response_body <- test_fixtures[["embeddings"]]

      response_body$data[[1]]$values |> unlist()
    }
  )
)
