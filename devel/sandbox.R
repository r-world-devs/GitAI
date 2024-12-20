my_project <- initialize_project("gitai-demo") |>
  set_database(
    provider = "Pinecone", 
    index = "gitai",
    namespace = NULL
  ) |>
  set_llm(seed = 1014, api_args = list(temperature = 0))

my_project <- my_project |>
  set_github_repos(
    # repos = c(
      # "r-world-devs/GitStats", 
      # "r-world-devs/GitAI", 
      # "r-world-devs/cohortBuilder", 
      # "r-world-devs/shinyCohortBuilder", 
      # "r-world-devs/shinyQueryBuilder", 
      # "r-world-devs/queryBuilder", 
      # "r-world-devs/shinyGizmo", 
      # "r-world-devs/shinyTimelines",
      # "openpharma/DataFakeR"
    # )
    orgs = c(
      "insightsengineering",
      "openpharma",
      "pharmaverse",
      "tidymodels",
      "r-lib",
      "rstudio",
      "tidyverse"
    )
  ) |>
  add_files(c(
    "DESCRIPTION",
    "*.md",
    "*.Rmd"
  ))
  
my_project <- my_project |>
  set_prompt(r"(
    Write up to ten paragraphs of summary for a project based on given input.
    Be precise and to the point in your answers.
    Mention core functionality and all main features of the project.
    If available, mention brifly the technology used in the project 
    (like R, Python, etc).
    If available, mention brifly if a project is an R package, shiny app, 
    or other type of tool.
  )")

custom_function <- function(provider, req) {

  req |> 
    httr2::req_timeout(60) |>
    httr2::req_perform() |> 
    httr2::resp_body_json()
}
unlockBinding("chat_perform_value", asNamespace("elmer"))
assign("chat_perform_value", custom_function, envir = asNamespace("elmer"))
lockBinding("chat_perform_value", asNamespace("elmer"))

results <- process_repos(my_project)
# results |> dplyr::glimpse()
# purrr::map(results, ~.$text)

my_project |> 
  find_records("How can I create synthetic datasets?", top_k = 3)

my_project |> 
  find_records("How can I check statisting of git repositories.", top_k = 3)

my_project |> 
  find_records("Can I somehow extract information from file content from git repositories using LLM?")

run_demo()
