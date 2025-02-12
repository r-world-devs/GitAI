#' Set Large Language Model in `GitAI` object.
#'
#' @name set_llm
#' @param gitai A \code{GitAI} object.
#' @param provider Name of LLM provider, a string. Results with setting up LLM using
#'   \code{ellmer::chat_<provider>} function.
#' @param ... Other arguments to pass to corresponding \code{ellmer::chat_<provider>} function.
#'   Please use \link{get_llm_defaults} to get default model arguments.
#' @return A \code{GitAI} object.
#' @export
set_llm <- function(gitai, provider = "openai", ...) {

  provider_method <- rlang::env_get(
    env = asNamespace("ellmer"),
    nm = glue::glue("chat_{provider}")
  )
  provider_args <- purrr::list_modify(
    get_llm_defaults(provider),
    !!!rlang::dots_list(...)
  )

  gitai$llm <- rlang::exec(provider_method, !!!provider_args)

  invisible(gitai)
}

llm_default_args <- list(
  openai = list(model = "gpt-4o-mini", seed = NULL, echo = "none"),
  ollama = list(model = "llama3.2", seed = NULL),
  bedrock = list(model = "anthropic.claude-3-5-sonnet-20240620-v1:0")
)

#' @rdname set_llm
get_llm_defaults <- function(provider) {
  llm_defaults <- llm_default_args[[provider]]
  if (!is.null(llm_defaults)) {
    return(llm_defaults)
  }
  list()
}

#' Set prompt.
#' @name set_prompt
#' @param gitai A \code{GitAI} object.
#' @param system_prompt A system prompt.
#' @return A \code{GitAI} object.
#' @export
set_prompt <- function(gitai, system_prompt) {

  gitai$system_prompt <- system_prompt
  invisible(gitai)
}
