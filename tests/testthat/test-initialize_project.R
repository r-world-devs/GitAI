test_that("project can be initialized", {

  expect_error(initialize_project())

  test_project_id <- "gitai_test_project"

  my_project <- initialize_project(project_id = test_project_id)

  expect_true("R6"    %in% class(my_project))
  expect_true("GitAI" %in% class(my_project))

  expect_equal(my_project$project_id,
               test_project_id)

  expect_null(my_project$llm)
})
