#' Set Large Language Model in GitAI
#' @name set_llm
#' @param gitai A GitAI object.
#' @param provider A LLM provider.
#' @param model A LLM model.
#' @param seed An integer to make results more reproducible.
#' @return GitAI object.
#' @export
set_llm <- function(gitai,
                    provider = "openai",
                    model = "gpt-4o-mini",
                    seed = NULL,
                    ...) {

  if (provider == "openai") {

    gitai$llm <- elmer::chat_openai(
      model = model,
      echo = "none",
      seed = seed,
      ...
    )
  }

  invisible(gitai)
}

#' Set prompt
#' @name set_prompt
#' @param gitati A GitAI object.
#' @param system_prompt A system prompt.
#' @return GitAI object.
#' @export
set_prompt <- function(gitai, system_prompt) {

  gitai$system_prompt <- system_prompt
  invisible(gitai)
}
