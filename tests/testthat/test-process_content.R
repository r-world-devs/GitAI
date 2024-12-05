test_that("processing content have proper output structure", {
  my_project <- initialize_project("gitai_test_project") |>
    set_llm() |>
    set_prompt(system_prompt = "Say 'Hi there!' only and nothing else.")

  result <- process_content(gitai = my_project, content = "")
  expect_equal(result$text, "Hi there!")
  expect_true(is.numeric(result$tokens))
  expect_true(is.list(result$output))
  expect_true(is.numeric(result$content_nchars))
  expect_true(is.character(result$text))
})

test_that("processing a single file content with deterministic output", {
  my_project <- initialize_project("gitai_test_project") |>
    set_llm(seed = 1014, api_args = list(temperature = 0)) |>
    set_prompt(system_prompt = "Summarize provided conent with one, short sentence.")
  test_content <- r"(
    Artificial intelligence (AI) plays a crucial role in transforming industries
    by automating repetitive tasks and enhancing productivity. It enables personalized experiences
    in sectors like healthcare, finance, and entertainment by analyzing vast amounts of data. AI algorithms
    assist in decision-making processes by providing insights that humans may overlook. In addition,
    AI is vital for advancements in technologies such as self-driving cars and smart home devices. Overall,
    AI acts as a powerful tool for innovation, driving efficiencies, and solving complex problems.
  )"
  httr2::with_verbosity(verbosity = 0, {
    result <- process_content(
      gitai   = my_project,
      content = test_content
    )
  })
  expect_length(gregexpr("\\.", result$text)[[1]], 1)
  expect_equal(
    result$text,
    process_content(gitai = my_project, content = test_content)$text
  )
  expect_equal(
    result$text,
    process_content(gitai = my_project, content = test_content)$text
  )

  test_mocker$cache(result)
})
