library(shiny)

ui <- fluidPage(
  actionButton("increment", "Increment"),
  actionButton("decrement", "Decrement"),
  actionButton("reset", "Reset"),
  
  p(
    textOutput("value")
  )
)

server <- function(input, output, session) {
  output$value <- renderText({
    0
  })
}

shinyApp(ui, server)