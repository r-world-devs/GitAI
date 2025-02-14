# pak::pkg_install("r-world-devs/GitAI@waisk/34/prepare_release")
# pak::pkg_install("r-world-devs/GitStats")
# pak::pkg_install("tidyverse/ellmer")
# pak::pkg_install("shinychat")
# rstudioapi::restartSession()

my_project <- initialize_project("gitai-demo") |>
  set_database(
    provider  = "Pinecone", 
    index     = "gitai"
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
    # ),
    # orgs = c(
    #   "insightsengineering",
    #   "openpharma",
    #   "pharmaverse",
    #   "tidymodels",
    #   "r-lib",
    #   "rstudio",
    #   "tidyverse"
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
    If available, mention briefly the technology used in the project 
    (like R, Python, etc).
    If available, mention brifly if a project is an R package, shiny app, 
    or other type of tool.
  )")

ellmer:::chat_perform_value
custom_function <- function(provider, req) {

  req <- req |> 
    httr2::req_timeout(60 * 10) |>
    httr2::req_retry(
      max_tries = 10,
      retry_on_failure = TRUE
    ) 
  
  req|> 
    httr2::req_perform() |> 
    httr2::resp_body_json()
}
unlockBinding("chat_perform_value", asNamespace("ellmer"))
assign("chat_perform_value", custom_function, envir = asNamespace("ellmer"))
lockBinding("chat_perform_value", asNamespace("ellmer"))

# ids <- my_project$db$list_record_ids()
ids <- c("GitStats", "GitAI", "cohortBuilder", "shinyCohortBuilder",
"shinyQueryBuilder", "queryBuilder", "shinyGizmo", "shinyTimelines")
if (!is.null(ids)) my_project$db$purge_records(ids = ids)
"GitStats" %in% my_project$db$list_record_ids() 

verbose_on()
t <- Sys.time()
results <- process_repos(my_project)
(time <- Sys.time() - t)

(minutes <- as.numeric(time))
NROW(results) / minutes # ~5
results$DataFakeR <- NULL
input_tokens <- sum(purrr::map_int(results, ~.$tokens[1]))
output_tokens <- sum(purrr::map_int(results, ~.$tokens[2]))
total_tokens <- input_tokens + output_tokens
total_tokens / minutes # 34000 for tidyverse, 20000 for r-world-devs

(input_tokens / NROW(results))  * 10000 * 12 * 1 / 1000000 * 0.150 + 
(output_tokens / NROW(results)) * 10000 * 12 * 1 / 1000000 * 0.600
# 115 USD for gpt-4o-mini
(input_tokens / NROW(results))  * 10000 * 12 * 1 / 1000000 * 2.5 + 
(output_tokens / NROW(results)) * 10000 * 12 * 1 / 1000000 * 10
# 2000 USD

my_project |> 
  find_records("How can I create synthetic datasets?", top_k = 3)

my_project |> 
  find_records("How can I check statisting of git repositories.", top_k = 3)

my_project |> 
  find_records("Can I somehow extract information from file content from git repositories using LLM?")

# run_demo()


rsconnect::setAccountInfo(
  name   = 'kalimu',
  token  = Sys.getenv("SHINYAPPSIO_TOKEN"),
  secret = Sys.getenv("SHINYAPPSIO_SECRET")
)

rsconnect::deployApp(
  appDir = "inst/demo-app",
  account = "kalimu", 
  appName = "GitAI-demo"
)

# https://kalimu.shinyapps.io/GitAI-demo/