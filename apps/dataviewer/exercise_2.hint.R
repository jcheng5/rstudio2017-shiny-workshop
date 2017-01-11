library(shiny)
library(ggplot2)

ui <- fluidPage(
  sidebarLayout(
    sidebarPanel(
      fileInput("upload", "CSV file"),
      selectInput("x", "X variable", character(0)),
      selectInput("y", "Y variable", character(0)),
      selectInput("color", "Color by", character(0))
    ),
    mainPanel(
      plotOutput("plot")
    )
  )
)

server <- function(input, output, session) {
  
  df <- reactive({
    req(input$upload)
    
    read.csv(input$upload$datapath)
  })
  
  observe({
    updateSelectInput(session, "x", choices = names(df()), selected = character(0))
    updateSelectInput(session, "y", choices = names(df()), selected = character(0))
    updateSelectInput(session, "color", choices = names(df()), selected = character(0))
  })
  
  output$plot <- renderPlot({
    req(input$x, input$y, input$color)
    
    ggplot(df(), aes_string(x = input$x, y = input$y, color = input$color)) +
      geom_point()
  })
}

shinyApp(ui, server)