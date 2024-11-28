test_that("superclass has expected methods", {
  
  db <- VectorDatabase$new(project_id = "test_project_id")
  
  db$get_embeddings(text = "test_text") |> expect_error("Not implemented yet.")
  
  db$write_record(record = "test_record") |> expect_error("Not implemented yet.")
  
  db$find_records(query = "test_query") |> expect_error("Not implemented yet.")
})
