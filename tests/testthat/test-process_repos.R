test_that("process_repos() returns results with repo metadata", {
  my_project <- initialize_project("gitai_test_project")
  my_project <-
    my_project |>
    set_github_repos(
      repos = c("r-world-devs/GitStats", "openpharma/DataFakeR")
    ) |>
    add_files(file_paths = "README.md") |>
    # set_llm() |>
    # set_prompt() |>
    process_repos()
  expect_s3_class(my_project$repos_metadata, "repos_table")
  expect_s3_class(my_project$files_content, "files_data")
})

test_that("process_repos() returns results with repo metadata", {
  my_project <- initialize_project("gitai_test_project")
  my_project <-
    my_project |>
    set_github_repos(
      repos = c("r-world-devs/GitStats", "openpharma/DataFakeR")
    ) |>
    add_files(file_types = "*.md") |>
    # set_llm() |>
    # set_prompt() |>
    process_repos()
  expect_s3_class(my_project$repos_metadata, "repos_table")
  expect_s3_class(my_project$files_content, "files_data")
})
