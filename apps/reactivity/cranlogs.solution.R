library(cranlogs)
library(dplyr)
library(lubridate)
library(ggplot2)
library(shiny)

ui <- fluidPage(
  sidebarLayout(
    sidebarPanel(
      textInput("packages", "Package names (comma separated)"),
      actionButton("update", "Update")
    ),
    mainPanel(
      plotOutput("plot")
    )
  )
)

server <- function(input, output, session) {
  # Parses comma-separated string into a proper vector
  packages <- eventReactive(input$update, {
    strsplit(input$packages, " *, *")[[1]]
  })
  
  daily_downloads <- reactive({
    cranlogs::cran_downloads(
      packages = packages(),
      from = "2016-01-01", to = "2016-12-31"
    )
  })
  
  weekly_downloads <- reactive({
    daily_downloads() %>% mutate(date = ceiling_date(date, "week")) %>%
      group_by(date, package) %>%
      summarise(count = sum(count))
  })
  
  output$plot <- renderPlot({
    # Plot weekly downloads, plus trendline
    ggplot(weekly_downloads(), aes(date, count, color = package)) +
      geom_line() +
      geom_smooth()
  })
}

shinyApp(ui, server)
