run_demo <- function() {

  app_folder <- system.file("demo", package = "GitAI")

  shiny::runApp(app_folder)
}
