library(shiny)
library(ggplot2)

# CSV upload module -------------------------------------------------------

inputModuleUI <- function(id) {
  ns <- NS(id)
  fileInput(ns("upload"), "CSV file")
}

inputModule <- function(input, output, session) {
  df <- reactive({
    req(input$upload)
    
    read.csv(input$upload$datapath)
  })
  return(df)
}

paramsModuleUI <- function(id) {
  ns <- NS(id)
  tagList(
    selectInput(ns("x"), "X variable", character(0)),
    selectInput(ns("y"), "Y variable", character(0)),
    selectInput(ns("color"), "Color by", character(0))
  )  
}

# Parameter chooser module ------------------------------------------------

paramsModule <- function(input, output, session, data_frame) {
  observe({
    req(data_frame())

    updateSelectInput(session, "x", choices = names(data_frame()), selected = character(0))
    updateSelectInput(session, "y", choices = names(data_frame()), selected = character(0))
    updateSelectInput(session, "color", choices = names(data_frame()), selected = character(0))
  })
  
  list(
    x = reactive(input$x),
    y = reactive(input$y),
    color = reactive(input$color)
  )
}

plotModuleUI <- function(id) {
  ns <- NS(id)
  
  plotOutput(ns("plot"), click = ns("click"))
}

# Plot output module ------------------------------------------------------

plotModule <- function(input, output, session, data_frame, x, y, color) {
  output$plot <- renderPlot({
    req(x(), y(), color())
    
    ggplot(data_frame(), aes_string(x = x(), y = y(), color = color())) +
      geom_point()
  })
  
  reactive({
    nearPoints(data_frame(), input$click, maxpoints = 1)
  })
}

detailModuleUI <- function(id) {
  ns <- NS(id)
  
  verbatimTextOutput(ns("detail"))
}

# Data point detail module ------------------------------------------------

detailModule <- function(input, output, session, data_point) {
  output$detail <- renderPrint({
    req(data_point(), nrow(data_point()) > 0)
    
    print(data_point())
  })
}

# Top-level app -----------------------------------------------------------

ui <- fluidPage(
  sidebarLayout(
    sidebarPanel(
      inputModuleUI("upload"),
      paramsModuleUI("params")
    ),
    mainPanel(
      plotModuleUI("plot"),
      detailModuleUI("detail")
    )
  )
)

server <- function(input, output, session) {
  df <- callModule(inputModule, "upload")
  params <- callModule(paramsModule, "params", df)
  clicked <- callModule(plotModule, "plot",
    df, params$x, params$y, params$color
  )
  callModule(detailModule, "detail", clicked)
}

shinyApp(ui, server)