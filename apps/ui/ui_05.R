library(shiny)

videoThumbnail <- function(videoUrl, title, description) {
  div(class = "thumbnail",
    div(class = "embed-responsive embed-responsive-16by9",
      tags$iframe(class = "embed-responsive-item", src = videoUrl, allowfullscreen = NA)
    ),
    div(class = "caption",
      h3(title),
      div(description)
    )
  )
}

ui <- fluidPage(
  h1("Random videos"),
  fluidRow(
    column(6,
      videoThumbnail("https://www.youtube.com/embed/hou0lU8WMgo",
        "You are technically correct",
        "The best kind of correct!"
      )
    ),
    column(6,
      videoThumbnail("https://www.youtube.com/embed/4F4qzPbcFiA",
        "Admiral Ackbar",
        "It's a trap!"
      )
    )
  )
)

server <- function(input, output, session) {
  
}

shinyApp(ui, server)
