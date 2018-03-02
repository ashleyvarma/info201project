#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(dplyr)
library(ggplot2)
police.killings <- read.csv('police_killings.csv', stringsAsFactors = FALSE)
# Define UI for application that draws a histogram
ui <- fluidPage(
   
   # Application title
   titlePanel("Police Killings Based on County Income"),
   
   # Sidebar with a slider input for number of bins 
   sidebarLayout(
      sidebarPanel(
         sliderInput("bin",
                     "Number of bins:",
                     min = 5,
                     max = 50,
                     value = 20)
      ),
      
      # Show a plot of the generated distribution
      mainPanel(
         plotOutput("distPlot")
      )
   )
)

# Define server logic required to draw a histogram
server <- function(input, output) {
   
   output$distPlot <- renderPlot({
      # generate bins based on input$bins from ui.R
      x    <- police.killings$county_income
      bin  <- input$bin
      
      ggplot(data=police.killings, aes(police.killings$county_income)) + 
        geom_histogram(aes(y = ..count..), bins = bin, colour = 'grey',
                       fill = 'red') +
        labs(x = "Median County Income (USD)", y = "Count") +
        geom_vline(xintercept = 57230, linetype ='dashed', 
                   color = 'black', size = 1)
   })
}

# Run the application 
shinyApp(ui = ui, server = server)

