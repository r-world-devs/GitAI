# integration tests

test_that("setting LLM ", {
  my_project <- initialize_project("gitai_test_project") |> set_llm()
  expect_true("Chat" %in% class(my_project$llm))
  expect_null(my_project$llm$system_prompt)
})

test_that("setting system prompt", {
  my_project <- initialize_project("gitai_test_project")
  expect_error(
    my_project |> set_prompt(system_prompt = "You always return only 'Hi there!'")
  )

  my_project <- my_project |>
    set_llm() |>
    set_prompt(system_prompt = "You always return only 'Hi there!'")
  expect_equal(
    my_project$llm$get_system_prompt(),
    "You always return only 'Hi there!'"
  )
  expect_equal(
    my_project$llm$chat("Hi"),
    "Hi there!"
  )
})

# mocked llm and provider tests

test_that("setting LLM with default provider ", {
  my_project <- initialize_project("gitai_test_project")
  testthat::local_mocked_bindings(
    chat_openai = chat_openai_mocked,
    .package = "ellmer"
  )
  my_project <- my_project |> set_llm()
  expect_true("Chat" %in% class(my_project$llm))
  expect_in(
    "ellmer::ProviderOpenAI",
    class(my_project$llm$.__enclos_env__$private$provider)
  )
})

test_that("setting LLM with non-existing provider ", {
  my_project <- initialize_project("gitai_test_project")
  expect_error(
    my_project <- my_project |> set_llm(provider = "non_existing_provider"),
    "Can't find `chat_non_existing_provider` in environment."
  )
})

test_that("setting arguments for selected provider ", {
  my_project <- initialize_project("gitai_test_project")
  testthat::local_mocked_bindings(
    chat_openai = chat_openai_mocked,
    .package = "ellmer"
  )

  # Provider-related argument overrides the default from `llm_default_args`
  my_project <- my_project |>
    set_llm(provider = "openai", model = "model_mocked")
  expect_equal(
    my_project$llm$.__enclos_env__$private$provider@model,
    "model_mocked"
  )

  # Provider-related, non-default argument (not included within `llm_default_args`) is properly set
  my_project <- my_project |>
    set_llm(provider = "openai", api_key = "api_key_mocked")
  expect_equal(
    my_project$llm$.__enclos_env__$private$provider@api_key,
    "api_key_mocked"
  )

  # Chat-related, non-default argument (not included within `llm_default_args`) is properly set
  my_project <- my_project |>
    set_llm(provider = "openai", echo = "all")
  expect_equal(
    my_project$llm$.__enclos_env__$private$echo,
    "all"
  )
})

test_that("setting LLM without system prompt", {
  testthat::local_mocked_bindings(
    chat_openai = chat_openai_mocked,
    .package = "ellmer"
  )
  my_project <- initialize_project("gitai_test_project") |> set_llm()
  expect_null(my_project$llm$system_prompt)
})

test_that("setting system prompt", {
  testthat::local_mocked_bindings(
    chat_openai = chat_openai_mocked,
    .package = "ellmer"
  )

  my_project <- initialize_project("gitai_test_project")
  expect_error(
    my_project |>
      set_prompt(system_prompt = "You always return only 'Hi there!'")
  )

  my_project <- my_project |>
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
