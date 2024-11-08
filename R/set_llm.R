#' export
set_llm <- function(gitai, 
                    provider = "openai",
                    model = "gpt-4o-mini") {
  
  if (provider == "openai") {

    gitai$llm <- elmer::chat_openai(
      model = model,
      echo = "none"
    )
  }

  invisible(gitai)
}

#' export
set_system_prompt <- function(gitai, system_prompt) {

  gitai$llm$system_prompt <- system_prompt
  invisible(gitai)
}