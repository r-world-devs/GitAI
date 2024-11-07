pak::pak("tidyverse/elmer")


chat <- elmer::chat_openai(
  model = "gpt-4o-mini",
  # system_prompt = "You are a friendly but terse assistant.",
  echo = "none"
)
chat
chat$system_prompt <- "You always start with 'HI'"
chat |> str()
result <- chat$chat("What is the meaning of life?")
result
