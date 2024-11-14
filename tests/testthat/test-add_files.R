test_that("add_files adds file_paths to GitAI settings", {
  my_project <- initialize_project("gitai_test_project")
  my_project <-
    my_project |>
    add_files(file_path = "README.md")
  expect_equal("README.md", my_project$file_paths)
  expect_null(my_project$file_types)
  my_project <-
    my_project |>
    add_files(file_path = "DESCRIPTION")
  expect_equal("DESCRIPTION", my_project$file_paths)
  expect_null(my_project$file_types)
  my_project <-
    my_project |>
    add_files(file_path = c("LICENSE", "project_metadata.yaml"))
  expect_equal(c("LICENSE", "project_metadata.yaml"), my_project$file_paths)
  expect_null(my_project$file_types)
})

test_that("add_files adds file_types to GitAI settings", {
  my_project <- initialize_project("gitai_test_project")
  my_project <-
    my_project |>
      add_files(file_type = "*.md")
    expect_equal("*.md", my_project$file_types)
    expect_null(my_project$file_paths)
})

test_that("add_files returns error when other than character type is passed", {
  
  my_project <- initialize_project("gitai_test_project")
  expect_snapshot_error(
    my_project <-
      my_project |>
      add_files(file_paths = 12345)
  )
  expect_snapshot_error(
    my_project <-
      my_project |>
      add_files(file_types = 12345)
  )
})

test_that("add_files returns error when file_path is passed to file_type", {

  my_project <- initialize_project("gitai_test_project")
  expect_snapshot_error(
    my_project <-
      my_project |>
      add_files(file_types = "README.md")
  )
  expect_snapshot_error(
    my_project <-
      my_project |>
      add_files(file_paths = "*.md")
  )
  expect_snapshot_error(
    my_project <-
      my_project |>
      add_files(file_paths = c("README.md", "*.md"))
  )
})
