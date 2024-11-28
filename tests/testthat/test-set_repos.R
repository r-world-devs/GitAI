test_that("set_*_repos creates GitStats object inside GitAI with repos set", {
  verbose_off()

  my_project <- initialize_project("gitai_test_project")

  my_project <-
    my_project |>
    set_github_repos(
      repos = c("r-world-devs/GitStats", "openpharma/DataFakeR")
    )
  expect_true("GitStats" %in% class(my_project$gitstats))
  my_project <-
    my_project |>
    set_gitlab_repos(
      repos = "mbtests/gitstatstesting"
    )
  expect_length(
    my_project$gitstats$.__enclos_env__$private$hosts,
    2
  )
})
