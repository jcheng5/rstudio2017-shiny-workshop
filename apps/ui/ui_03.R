library(shiny)

ui <- fluidPage(
  includeHTML("youtube_thumbnail.html")
)

server <- function(input, output, session) {
  
}

shinyApp(ui, server)
