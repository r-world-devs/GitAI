process_content <- function(gitai, content) {

  llm_clone <- gitai$llm$clone(deep = TRUE)

  llm_clone$chat(content)

  turn <- llm_clone$last_turn("assistant")

  list(
    output = turn@json,
    tokens = turn@tokens,
    text   = turn@text
  )
}
