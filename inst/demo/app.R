library(shiny)
library(shinychat)
library(GitAI)

readRenviron(".Renviron")

gitai <- initialize_project("gitai-demo") |>
  set_database(index = "gitai") |> 
  set_llm(seed = 1014, api_args = list(temperature = 0)) |> 
  set_prompt(r"(
    As a helpful assistant, answer user question 
    using only the provided input. 
    Use only provided with the query known input 
    that is most relevent to the user's query.
    Do know use any other information apart from input provided with the query.
    Be concise and to the point in your answers.
    Also awalys provide link to mentioned git repositories 
    with visible full URL for example: https://github.com/some_repository. 
    Do not mask it with any other text.
  )")

ui <- bslib::page_fluid(
  bslib::layout_sidebar(
    sidebar = shiny::sliderInput(
      "top_k", 
      "Use top K results", 
      step = 1,
      min = 1, 
      max = 5, 
      value = 5
    ),
    chat_ui("chat")
  )
)

server <- function(input, output, session) {

  user_chatbot <- gitai$llm$clone()

  shiny::observeEvent(input$chat_user_input, {

    query <- input$chat_user_input

    stream <- user_chatbot$stream_async(
      paste(
        "User query:", query, "\n\n",
        "Known input provided for the answer:\n\n", 
        gitai$db$find_records(query = query, top_k = input$top_k)
      )
    )
    chat_append("chat", stream)
  })
}

shinyApp(ui, server)


