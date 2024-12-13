run_demo <- function() {

  app_folder <- system.file("demo-app", package = "GitAI")

  shiny::runApp(app_folder)
}
