test_mocker <- Mocker$new()

# Override other methods when needed in the future
ChatMocked <- R6::R6Class(
  "ChatMocked",
  inherit = ellmer:::Chat,
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
  provider <- rlang::exec(provider_class, name = "mock", !!!provider_args)

  chat <- ChatMocked$new(provider = provider, echo = echo)
  chat$set_turns(turns)
  chat
}

chat_openai_mocked <- function(system_prompt = NULL,
                               turns = NULL,
                               base_url = "https://api.mocked.com/v1",
                               api_key = "mocked_key",
                               model = NULL,
                               seed = NULL,
                               api_args = list(),
                               echo = c("none", "text", "all")) {

  turns <- ellmer:::normalize_turns(turns, system_prompt)
  model <- ellmer:::set_default(model, "gpt-4o")
  echo <- ellmer:::check_echo(echo)

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
    provider_class = ellmer:::ProviderOpenAI
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

  turns <- ellmer:::normalize_turns(turns, system_prompt)
  model <- ellmer:::set_default(model, "model_bedrock")
  echo <- ellmer:::check_echo(echo)

  mock_chat_method(
    turns = turns,
    echo = echo,
    base_url = "",
    model = model,
    profile = profile,
    credentials = credentials,
    provider_class = ellmer:::ProviderBedrock
  )
}
