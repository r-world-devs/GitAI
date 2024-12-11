test_that("process_repos() returns results with repo metadata", {
  withr::local_envvar(new = c("GITAI_VERBOSE" = FALSE))
  my_project <- initialize_project("gitai_test_project") |>
    set_github_repos(
      repos = c("r-world-devs/GitStats", "openpharma/DataFakeR")
    ) |>
    add_files(files = "README.md") |>
    set_llm() |>
    set_prompt(system_prompt = "Summarize the user content if one sentence.")
  results <- my_project |> process_repos()

  expect_true(is.list(results))
  expect_equal(c("GitStats", "DataFakeR"), names(results))
  expect_true(
    results |>
      purrr::map(~ nchar(.x$text) > 10) |>
      unlist() |>
      all()
  )
  results |> purrr::walk(~ expect_true("metadata" %in% names(.)))
})
