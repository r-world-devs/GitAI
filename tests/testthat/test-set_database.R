test_that("setting database provider with default namespace", {
  
  gitai <- initialize_project("gitai-demo") |>
    set_database(
      provider = "Pinecone", 
      index = "gitai"
    ) 
  
  gitai$db$index |> expect_equal("gitai")
  gitai$db$namespace |> expect_equal("gitai-demo")
})

test_that("setting database provider with custom namepsace", {

  gitai <- initialize_project("gitai-demo") |>
    set_database(
      provider = "Pinecone", 
      index = "gitai",
      namespace = "test_namespace"
    ) 
  
  gitai$db$index |> expect_equal("gitai")
  gitai$db$namespace |> expect_equal("test_namespace")
})
