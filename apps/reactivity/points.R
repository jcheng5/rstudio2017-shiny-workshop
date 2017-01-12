library(shiny)

ui <- fluidPage(
  plotOutput("plot", click = "click", width = 400),
  verbatimTextOutput("summary")
)

server <- function(input, output, session) {
  # We'll use rv$data to track the points clicked so far
  rv <- reactiveValues(data = data.frame(x=numeric(), y=numeric()))
  
  # Handle click events by adding a new row to the rv$data data frame
  observeEvent(input$click, {
    rv$data <- rbind(
      rv$data,
      data.frame(x=input$click$x, y=input$click$y)
    )
  })
  
  output$plot <- renderPlot({
    ggplot(rv$data, aes(x=x, y=y)) + geom_point() +
      xlim(0, 1) + ylim(0, 1)
  })
  
  # Wrap rv$data and ensure that it's not empty
  data <- reactive({
    req(nrow(rv$data) > 0)
    rv$data
  })
  
  output$summary <- renderPrint({
    # Insert artificial slowness
    on.exit(Sys.sleep(1))
    
    summary(data())
  })
}

shinyApp(ui, server)