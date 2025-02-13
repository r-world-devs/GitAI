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
    Do not use any other information 
    apart from the input provided with the query.
    Be concise but provide all important information.
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
      max = 10, 
      value = 5
    ),
    shiny::HTML(markdown::markdownToHTML(fragment.only = TRUE,
      "This is a demo app of the outputs from the `GitAI` open-source framework.The `GitAI` allows to extract knowledge from GitHub and GitLab repositories with the use of AI/LLM (Large Language Models) on scale and with minimum costs.\n\nThe results you see in the chatbot are from processing **800+** repositories in multiple public GitHub organizations: `r-world-devs`, `openpharma`, `pharmaverse`, `tidymodels`, `r-lib`, `rstudio`, `tidyverse`, `insightsengineering`. In the repositories we have scanned the following files types: `DESCRIPTION`, `*.md`, and `*.Rmd`, so it includes files like `README.md` or R package vignettes.\n\nFor this demo we have used simple and cheap LLM `gpt-4o-mini` from OpenAI. As embedings we use `multilingual-e5-large` embedding model from Pinecone as well as its vector database with 1024 dimensions. The overall one-time cost of processing all 800+ repositories is **less then $1** with this setup (yes, one USD!). \nEven more impressive results can be achieved with more powerful LLMs, and higher-dimensional embeddings.\n See more: [GitAI](https://github.com/r-world-devs/GitAI)\n\nTry to chat with the chatbot to find and reuse tools for your specific needs, for example, you can ask:\n\n`I need to filter datasets and build cohorts interactively in a shiny dashboard. What dashboarding component could I use?`"
    )),

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


