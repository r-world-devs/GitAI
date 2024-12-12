process_content <- function(gitai, content) {

  # TODO: check if it fits in the context window

  num_words <- length(strsplit(content, "\\s+")[[1]])
  cli::cli_alert_info("Repo content has {num_words} words")

  llm_clone <- gitai$llm$clone(deep = TRUE)

  llm_clone$chat(content)

  turn <- llm_clone$last_turn("assistant")

  list(
    output         = turn@json,
    tokens         = turn@tokens,
    content_nchars = nchar(content),
    text           = turn@text
  )
}
