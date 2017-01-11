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

# Parameter chooser module ------------------------------------------------

paramsModuleUI <- function(id) {
  ns <- NS(id)
  tagList(
    selectInput(ns("x"), "X variable", character(0)),
    selectInput(ns("y"), "Y variable", character(0)),
    selectInput(ns("color"), "Color by", character(0))
  )  
}

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

# Plot output module ------------------------------------------------------

plotModuleUI <- function(id) {
  ns <- NS(id)
  
  plotOutput(ns("plot"))
}

plotModule <- function(input, output, session, data_frame, x, y, color) {
  output$plot <- renderPlot({
    req(x(), y(), color())
  
    ggplot(data_frame(), aes_string(x = x(), y = y(), color = color())) +
      geom_point()
  })
}

ui <- fluidPage(
  sidebarLayout(
    sidebarPanel(
      inputModuleUI("upload"),
      paramsModuleUI("params")
    ),
    mainPanel(
      plotModuleUI("plot")
    )
  )
)

# Top-level app -----------------------------------------------------------

server <- function(input, output, session) {
  df <- callModule(inputModule, "upload")
  params <- callModule(paramsModule, "params", df)
  callModule(plotModule, "plot", df, params$x, params$y, params$color)
}

shinyApp(ui, server)