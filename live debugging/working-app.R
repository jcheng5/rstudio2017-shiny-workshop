library(shiny)

anagrams <- list(
  c("aligned", "dealing"),
  c("related", "related"),
  c("allergy", "gallery"),
  c("astride", "tirades"),
  c("despair", "diapers"),
  c("nectars", "trances"),
  c("capitol", "optical"),
  c("realist", "saltier")
)

shinyApp(
  ui = fluidPage(
    titlePanel("Fix me, Joe, please!"),
    helpText("The goal of this app is to allow users to choose",
      "some words and then present them with an anagram of each word"),
    sidebarLayout(
      sidebarPanel(
        checkboxGroupInput("choices", "Choose your favorite words:", 
          lapply(anagrams, `[[`, 1))
      ),
      mainPanel(uiOutput("res"))
    )
  ), 
  
  server = function(input, output, session) {
    
    # returns a list of strings (one string for each selected word), with the 
    # appropriate anagram pair
    myAnagrams <- function() {
      
      # finds indices of every word the user chose (by comparing the input$choices 
      # to the first element of each sub-vector in the "anagrams" list)
      idx <- which(lapply(anagrams, `[[`, 1) %in% input$choices)
      
      lst <- list()
      for (i in idx) {
        el <- paste("The anagram of", anagrams[[i]][1], "is", anagrams[[i]][2])
        lst <- c(lst, el)
      }
      lst
    }
    
    # prints a paragraph for each selected word, with the appropriate anagram pair
    # (must call `myAnagrams()`)
    output$res <- renderUI({
      result <- myAnagrams()
      lst <- tagList()
      for (i in seq_len(length(result))) {
        lst[[i]] <- tags$p(result[[i]])
      }
      lst
    })
  }
)
