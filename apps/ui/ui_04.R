library(shiny)

ui <- fluidPage(
  div(class = "thumbnail",
    div(class = "embed-responsive embed-responsive-16by9",
      tags$iframe(class = "embed-responsive-item", src = "https://www.youtube.com/embed/hou0lU8WMgo", allowfullscreen = NA)
    ),
    div(class = "caption",
      h3("You are technically correct"),
      div("The best kind of correct!")
    )
  )
)

server <- function(input, output, session) {
  
}

shinyApp(ui, server)
