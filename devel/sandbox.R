my_project <- 
  initialize_project("gitai-demo") |>
  set_database(
    provider = "Pinecone", 
    index = "gitai",
    namespace = NULL
  ) |>
  set_llm(seed = 1014, api_args = list(temperature = 0))

my_project <- 
  my_project |>
  set_github_repos(repos = c(
    "r-world-devs/GitStats", 
    "r-world-devs/GitAI", 
    "openpharma/DataFakeR"
  )) |>
  add_files(files = c("README.md")) 
  
my_project <- 
  my_project |>
  set_prompt(paste(
    "Write two paragraphs of summary for a project based on given input.",
    "Highlight business value of the project, its functionality, main features,",
    "and use cases."
  ))

results <- process_repos(my_project)

results |> dplyr::glimpse()
purrr::map(results, ~.$text)






# my_project <- 
#   initialize_project(project_id = "gitai-demo") |>
#   set_database(index = "gitai")

my_project |> find_records("I'm looking for an R package to create synthetic datasets.")

my_project |> find_records("How can I check statisting of git repositories.")

my_project |> find_records("Can I somehow extract information from code from git repositories?")

my_project |> find_records("What are the tools that can help me in my work as a Data Scientist?")

my_project |> 
  find_records("As a Manager I look for tools which let me learn what tools can be reused in my company", top_k = 2)

my_project |> find_records("Which data products could have large impact in global company that maintains many repositories?", top_k = 3)

my_project |> find_records("Szukam narzędzi które wykorzystują sztuczną inteligencję?")







my_chatbot <- 
  initialize_project("gitai-demo") |>
  set_database(index = "gitai") |> 
  set_llm(seed = 1014, api_args = list(temperature = 0)) |> 
  set_prompt(paste(
    "As a helpful assistant, answer user question using only the provided input."
  ))

get_answer <- function(my_chatbot, query) {

  cat("\n")
  my_chatbot$llm$chat(paste(
    "User query:", query, "\n\n",
    "Known input for the answer:", 
    my_project$db$find_records(query = query, top_k = 1)
  )) |> 
    cat()
}  
  
my_chatbot |> 
  get_answer("I'm looking for an R package to create synthetic datasets.")

my_chatbot |> 
  get_answer("How can I check statisting of git repositories?")

my_chatbot |> 
  get_answer("Can I somehow extract information from code from git repositories?")

my_chatbot |> 
  get_answer("I would love to use AI to process code files. Is it possible? Give me the answer writting in one sentence with very funny style.")

