# remotes::install_github("r-world-devs/GitStats@devel")

gitai_demo <- initialize_project("gitai-demo-2") |>
  set_database(index = "gitai-mb") |>
  set_github_repos(
    orgs = "pharmaverse"
  ) |>
  add_files(files = "\\.md") |>
  set_llm() |>
  set_prompt("Provide a one-two sentence description of the product based on input.")

process_repos(gitai_demo)
