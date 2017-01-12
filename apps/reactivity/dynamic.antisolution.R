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
    if (is.null(input$file))
      return(NULL)
    
    read.csv(input$file$datapath, stringsAsFactors = FALSE)
  })
  
  subset_data <- reactive({
    if (is.null(full_data()) || is.null(input$xvar) || is.null(input$yvar))
      return(NULL)

    full_data()[, c(input$xvar, input$yvar)]
  })
  
  output$field_chooser_ui <- renderUI({
    if (is.null(full_data()))
      return(NULL)

    col_names <- names(full_data())
    tagList(
      selectInput("xvar", "X variable", col_names),
      selectInput("yvar", "Y variable", col_names, selected = col_names[[2]])
    )
  })
  
  output$plot <- renderPlot({
    if (is.null(subset_data()))
      return(NULL)

    ggplot(subset_data(), aes_string(x = input$xvar, y = input$yvar)) +
      geom_point()
  })
  
  output$summary <- renderPrint({
    if (is.null(subset_data()))
      return(invisible())

    summary(subset_data())
  })
}

shinyApp(ui, server)