library(shiny)
library(ggplot2)

ui <- fluidPage(
  sidebarLayout(
    sidebarPanel(
      fileInput("file", "CSV file"),
      uiOutput("field_chooser_ui")
    ),
    mainPanel(
      plotOutput("plot"),
      verbatimTextOutput("summary")
    )
  )
)

server <- function(input, output, session) {
  full_data <- reactive({
    read.csv(input$file$datapath, stringsAsFactors = FALSE)
  })
  
  subset_data <- reactive({
    full_data()[, c(input$xvar, input$yvar)]
  })
  
  output$field_chooser_ui <- renderUI({
    col_names <- names(full_data())
    tagList(
      selectInput("xvar", "X variable", col_names),
      selectInput("yvar", "Y variable", col_names, selected = col_names[[2]])
    )
  })
  
  output$plot <- renderPlot({
    ggplot(subset_data(), aes_string(x = input$xvar, y = input$yvar)) +
      geom_point()
  })
  
  output$summary <- renderPrint({
    summary(subset_data())
  })
}

shinyApp(ui, server)