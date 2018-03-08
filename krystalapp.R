library("shiny")
source("krystalquestion.R")

# Define UI for viz app ----
my.ui <- fluidPage(
    
    # Output: Tabset w/ plot, summary, and table ----
    tabsetPanel(type = "tabs",
                tabPanel("Bar Graph", plotOutput("plot")),
                tabPanel("Map", plotOutput("map"))
    )
  )

# Define the server for the viz app
my.server <- function(input, output) {
  
  output$plot <- renderPlot({
    return(bar.graph)
  })
  
  output$map <- renderPlot({
    return(p)
  })
}

# Create and run the Shiny app
shinyApp(ui = my.ui, server = my.server)

