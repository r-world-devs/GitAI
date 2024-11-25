test_that("setting LLM ", {

  my_project <- initialize_project("gitai_test_project")

  my_project <-
    my_project |>
    set_llm()

  expect_true("Chat" %in% class(my_project$llm))
  expect_null(my_project$llm$system_prompt)
})

test_that("setting system prompt", {

  my_project <- initialize_project("gitai_test_project")

  expect_error(
    my_project |>
      set_prompt(system_prompt = "You always return only 'Hi there!'")
  )

  my_project <-
    my_project |>
    set_llm() |>
    set_prompt(system_prompt = "You always return only 'Hi there!'")

  expect_equal(
    my_project$llm$get_system_prompt(), "You always return only 'Hi there!'"
  )

  expect_equal(
    my_project$llm$chat("Hi"),
    "Hi there!"
  )
})
