#' export
set_llm <- function(gitai, 
                    provide = "openai",
                    model = "gpt-4o-mini") {
  
  gitai$llm <- elmer::chat_openai(
    model = model,
    echo = "none"
  )

  invisible(gitai)
}

#' export
set_system_prompt <- function(gitai, system_prompt) {

  gitai$llm$system_prompt <- system_prompt
  invisible(gitai)
}