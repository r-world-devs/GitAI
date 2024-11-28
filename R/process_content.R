process_content <- function(gitai, content) {

  # TODO: check if it fits in the context window

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
