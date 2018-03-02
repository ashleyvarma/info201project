# libraries used in file:
library(shiny)
library(dplyr)
library(plotly)
library(ggplot2)

# Set up UI
shinyUI(navbarPage("Police Killings Data", theme = "bootstrap.css",
                   
  # Overview tab with information on the project
  tabPanel("Overview",
    titlePanel('Project Overview'),
    p(" [insert project overview here]"),
    h3("Data"),
    p("This data set was found through the FiveThirtyEight blog, and provides details of selected police killings from 2015 that are 
      "verified crowdsurfed" through the Guardian news agency (Casselman, 2017). The author linked data from The Guardian to census data 
      from the American Community Survey in order to combine the two to provide more insight into such cases in the data set. 
      It allows us to look at information beyond the personal of the victim, and more into the general demographics of the area in which 
      the incident occured. This provides readers a broader background to singular incidents in order to look beyond sensational media 
      narratives and examine the facts for what they really are. The data set gives information about the deceased, including their name, 
      age, gender, ethnicity, and cause of death. It also gives information about the incident, including where and when it took place, the 
      police agency involved, and whether the deceased was armed. Lastly, the dataset includes information about the socioeconomic status of 
      the county where the death took place. This includes the average household income, the percent of whites, blacks, and hispanics, the 
      poverty rates, and the share of people with college education. This information will allow us to answer critical questions about police 
      deaths and analyze trends, and is available here: ",
      a("Police Killings Data", href = "https://github.com/fivethirtyeight/data/blob/master/police-killings/police_killings.csv")
    ),
    h3("Layout"),
    p("[explains tabs of app]"),
    
    h3("Team AA7"),
    tags$ul(
      tags$li("Amy Latimer"), 
      tags$li("Krystal Liang"), 
      tags$li("Ashley Varma")
    )
  ),
  
  tabPanel("[new tab panel for q1]",
    titlePanel("Police Killings"),
    p("This map shows production, consumption, or expenditure data by State for a given year. 
       The dataset can be selected with the drop down menu, and the year can be adjusted with the slider.
        Hovering over a state will display detailed comparison information."),
    sidebarLayout(
      sidebarPanel(
        selectInput(
          inputId = 'dataset',
          label = 'Dataset',
          choices = c('Production', 'Consumption', 'Expenditure'),
          selected = 'Production'
        ),
             
        sliderInput(inputId = 'select.year',
          label = 'Year',
          min = 1970,
          max = 2014,
          value = 2014,
          sep = ''
        )
      ),
           
      mainPanel(
        plotlyOutput('map')
      )
    )
  ),
  
  tabPanel("[insert data title]",
    titlePanel(' [data title] By Type'),
    p("[describe data input]"),
    
    p("[describe information that can be extracted from the data input]"),
           
    sidebarLayout(
      sidebarPanel(
        
        selectInput('state', label = 'State', choices = c("Overall", state.names), selected = "Overall"),
        sliderInput('year', label = 'Year', min = 2015, max = 2015, value = c(2015), sep = "")
      ),
     
      mainPanel(
        tabsetPanel(
          tabPanel('Plot', plotlyOutput('Departments Heavily Involved')),
          tabPanel('Table', tableOutput('Departments Least Involved'))
        )
      )
    )
  )
)
)
