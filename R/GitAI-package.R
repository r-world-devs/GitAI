#' Derive knowledge from GitHub or GitLab repositories with the use of AI/LLM
#'
#' @name GitAI-package
"_PACKAGE"

#' This function is meant to fix 'Namespaces in Imports field not imported from:' R check note.
#' The note shows up when namespace is used to create package object (not function) or
#' within file marked at '.Rbuildignore' file.
missing_deps_note_fix <- function() {
  R6::R6Class
  ellmer::chat_ollama
  lubridate::as_datetime
}
