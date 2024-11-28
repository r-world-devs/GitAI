

my_project <- 
  initialize_project("gitai-demo") |>
  set_github_repos(repos = c(
    "r-world-devs/GitStats", 
    "r-world-devs/GitAI", 
    "openpharma/DataFakeR"
  )) |>
  add_files(files = "README.md") |>
  set_llm() |>
  set_prompt(paste(
    "Write a paragraph of summary for a project based on given input.",
    "Highlight business value of the project, its use cases and target audience."
  ))

process_repos(my_project)
