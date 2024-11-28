test_that("getting index metadata", {

  db <- Pinecone$new(
    project_id = "test_project_id", 
    index_id = "gitai"
  )
  
  index <- db$get_index_metadata()
  index$host |> is.character() |> expect_true()
})

test_that("getting embeddings", {

  db <- Pinecone$new(project_id = "test_project_id", index_id = "gitai")
  
  test_text <- "Apple is a popular fruit known for its sweetness and crisp texture."
  embeddings <- db$get_embeddings(text = test_text)

  length(embeddings) |> expect_equal(1024)
})

test_that("writting records", {
  
  db <- Pinecone$new(project_id = "test_project_id", index_id = "gitai")
  
  test_texts <- c(
    "Apple is a popular fruit known for its sweetness and crisp texture.",
    "The tech company Apple is known for its innovative products like the iPhone.",
    "Many people enjoy eating apples as a healthy snack.",
    "Apple Inc. has revolutionized the tech industry with its sleek designs and user-friendly interfaces.",
    "An apple a day keeps the doctor away, as the saying goes.",
    "Apple Computer Company was founded on April 1, 1976, by Steve Jobs, Steve Wozniak, and Ronald Wayne as a partnership."
  )

  for (i in seq_along(test_texts)) {
    
    embeddings <- db$get_embeddings(text = test_texts[i])

    result <- db$write_record(
      id = paste0("id_", i),
      embeddings = embeddings,
      metadata = list(text = test_texts[i])
    ) 

    result$upsertedCount |> expect_equal(1)
  }
 })

test_that("finding records", {

  Sys.sleep(3)
  
  db <- Pinecone$new(project_id = "test_project_id", index_id = "gitai")

  result <- db$find_records(query = "Tell me about Apple Tech computer company.", top_k = 1)

  length(result) |> expect_equal(1)
  result[[1]]$id |> expect_equal("id_2")
  result[[1]]$metadata$text |> is.character() |> expect_true()
  result[[1]]$score |> is.numeric() |> expect_true()

  result_2 <- db$find_records(query = "Tell me about apple fruit.") 

  expect_false(result_2[[1]]$id == result[[1]]$id)
 })

