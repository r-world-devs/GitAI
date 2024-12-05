test_that("add_files adds file_paths to GitAI settings", {
  my_project <- initialize_project("gitai_test_project")

  my_project <- my_project |>
    add_files(files = "DESCRIPTION")
  expect_equal("DESCRIPTION", my_project$files)

  my_project <- my_project |>
    add_files(files = c("LICENSE", "project_metadata.yaml"))
  expect_equal(c("LICENSE", "project_metadata.yaml"), my_project$files)
})

test_that("add_files adds file_types to GitAI settings", {
  my_project <- initialize_project("gitai_test_project")
  my_project <- my_project |>
    add_files(files = "*.md")
  expect_equal("*.md", my_project$files)
})

test_that("add_files returns error when other than character type is passed", {
  my_project <- initialize_project("gitai_test_project")
  expect_snapshot_error(
    my_project <- my_project |>
      add_files(files = 12345)
  )
})
