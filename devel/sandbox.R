my_project <- initialize_project("gitai-demo") |>
  set_database(
    provider = "Pinecone", 
    index = "gitai",
    namespace = NULL
  ) |>
  set_llm(seed = 1014, api_args = list(temperature = 0))

my_project <- my_project |>
  set_github_repos(
    repos = c(
      "r-world-devs/GitStats", 
      "r-world-devs/GitAI", 
      "r-world-devs/cohortBuilder", 
      "r-world-devs/shinyCohortBuilder", 
      "r-world-devs/shinyQueryBuilder", 
      "r-world-devs/queryBuilder", 
      "r-world-devs/shinyGizmo", 
      "r-world-devs/shinyTimelines",
      "openpharma/DataFakeR"
    )
    # orgs = c(
    #   # "r-lib",
    #   # "rstudio",
    #   "tidyverse"
    # )
  ) |>
  add_files(c(
    # "DESCRIPTION",
    # "project_metadata.yaml",
    # "*.md",
    "README.md"
  ))
    
  
my_project <- my_project |>
  set_prompt(r"(
    Write about five paragraphs of summary for a project based on given input.
    Be precise and to the point in your answers.
    Mention core functionality and all main features of the project.
    If available, mention brifly the technology used in the project 
    (like R, Python, etc).
    If available, mention brifly if a project is an R package, shiny app, 
    or other type of tool.
  )")

results <- process_repos(my_project)

results |> dplyr::glimpse()
purrr::map(results, ~.$text)

my_project |> 
  find_records("How can I create synthetic datasets?")

my_project |> 
  find_records("How can I check statisting of git repositories.")

my_project |> 
  find_records("Can I somehow extract information from file content from git repositories using LLM?")

my_project |> 
  find_records("What could help me managing  many git repositories?", top_k = 2)

run_demo()
