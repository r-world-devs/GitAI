process_content <- function(gitai, content, max_words = 80000, verbose) {

  words <- strsplit(content, "\\s+")[[1]]
  num_words <- length(words)
  if (verbose) cli::cli_alert_info("Repo content has {num_words} words")

  if (num_words > max_words) {
    if (verbose) {
      cli::cli_alert_warning("Repo content is probably too long, triming...")
    }
    trimmed_words <- words[seq_len(min(length(words), max_words))]
    content <- paste(trimmed_words, collapse = " ")
    if (verbose) {
      cli::cli_alert_info("Repo content has now {length(trimmed_words)} words.")
    }
  }

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
