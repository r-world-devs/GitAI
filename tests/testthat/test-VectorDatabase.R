test_that("superclass has expected methods", {
  
  db <- VectorDatabase$new(namespace = "test_project_id")
  
  db$write_record() |> 
    expect_error("Not implemented yet.")

  db$find_records(query = "test_query") |> 
    expect_error("Not implemented yet.")
})
