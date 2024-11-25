#' Set Large Language Model in `GitAI` object.
#' @name set_llm
#' @param gitai A \code{GitAI} object.
#' @param provider A LLM provider.
#' @param model A LLM model.
#' @param seed An integer to make results more reproducible.
#' @param ... Other arguments to pass to `elmer::chat_openai()` function.
#' @return A \code{GitAI} object.
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
