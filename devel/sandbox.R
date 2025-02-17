gitai_demo <- initialize_project("gitai-demo-2") |>
  set_database(index = "gitai-mb") |>
  set_github_repos(
    orgs = "r-world-devs"
  ) |>
  add_files(files = "\\.md") |>
  set_llm() |>
  set_prompt("Provide a one-two sentence description of the product based on input.")

process_repos(gitai_demo)

gitai_demo$db$find_records("Find package with which I can plot data.")

gitai_demo$db$read_record("GitStats")

record_ids <- gitai_demo$db$list_record_ids()

gitai_demo$db$purge_records(record_ids)
