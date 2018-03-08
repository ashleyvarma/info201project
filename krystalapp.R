library("shiny")
source("krystalquestion.R")

# Define UI for viz app ----
my.ui <- fluidPage(
  plotOutput("plot1", click = "plot_click"),
  verbatimTextOutput("info"),
  
  # Input: Selecter for the state that you would like to view for ----
  selectInput("State", label="Select A State", 
              c("State", state.names), multiple = FALSE)
)

# Define the server for the viz app
my.server <- function(input, output) {
  
  viz.react <- reactive( {
    return(pov.and.death.map)
  })
  
  output$plot1 <- renderPlot({
    viz.react()
  })
  
  output$info <- renderText({
    paste("Race/Ethnicity = ", input$plot_click$x, "\nNumber of People Killed = "
          , input$plot_click$y)
  })
}

# Create and run the Shiny app
shinyApp(ui = my.ui, server = my.server)

