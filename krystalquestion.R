library("dplyr")
library("ggplot2")
library(plotly)
library(tidyr)

# Reads the csv file that contains all the data needed for Q3
shooting.data <- read.csv(file="police_killings.csv", stringsAsFactors = FALSE)
states.data <- read.csv(file="states.csv", stringsAsFactors = FALSE)
shooting.data$pov <- suppressWarnings(as.numeric(as.character(shooting.data$pov)))

# Data wrangling in order to get DF needed for 1st visualization
race.prop <- shooting.data %>%
  select(raceethnicity, city, state, pov) %>%
  group_by(raceethnicity) %>%
  summarize(n = n()) 

#Using plotly to make the bar graph that shows the proportion of races killed
font <- list(
  family = "Arial",
  size = 18,
  color = "black"
)
bar.graph.x.names <- c("Native American", "Asian/Pacific Is.", "Unknown", 
                       "Hispanic/Latino", "Black", "White")
bar.graph.x <- list(title = "Race/Ethnicity",
                    titlefont = font,
                    tickangle = 0,
                    categoryorder = "array",
                    categoryarray = c("Native American", "Asian/Pacific Is.", "Unknown", 
                                      "Hispanic/Latino", "Black", "White"))
bar.graph.y <- c(4, 10, 15, 67, 135, 236)
bar.graph.text <- c('4 People Killed', '10 People Killed', '15 People Killed', 
                    '67 People Killed', '135 People Killed', '236 People Killed')
bar.graph.data <- data.frame(bar.graph.x.names, bar.graph.y, bar.graph.text)


bar.graph <- plot_ly(bar.graph.data, x = ~bar.graph.x.names, y = ~bar.graph.y, type = 'bar', 
             text = bar.graph.text,
             marker = list(color = 'LightBlue',
                           line = list(color = 'rgb(8,48,107)', width = 1.5))) %>%
            layout(title = "Proportion Of People Killed Based On Race/Ethnicity In the US",
                   titlefont = font,
                   margin = list(b = 100,
                                 t = 50),
                   xaxis = bar.graph.x,
                   yaxis = list(title = "Number of People Killed",
                                tickangle = 0,
                                titlefont = font))

## In America the percentage of people who are White are about 70% leaving the rest of the
## people colored of "unidentified". If you add up the values for those who are of color vs.
## the amount of were killed who were white, ignoring the "unknown" column, you can see that
## the numbers are almost even. However, this reveals that more people of color were killed
## in the year of 2014 in all of the US compared to white people as the population of 
## white people are higher so less white people died altogether. This is true to what the 
## media displays as well, as we see in the media that usually more people of color are killed
## compared to white people. 

## https://www.census.gov/quickfacts/fact/table/US#viewtop

## According to the United States Census Bureu data, in 2017, the estimated population for the 
## country was 325,719,178 people. More specifically, according to 2016 data, 61.3% of the 
## population were only white with no Hispanic or Latino origin. In contrast, 1.3% were 
## American Indian and Alaskan Native alone, 5.7% were Asian alone, 0.2% were Hawaiian and/or
## Pacific Islander, 13.3% were Black or African American.


## You may think at first, "but the bar shows that more white people were killed altogether,
## but that's when you have to read into the US and how our population's races are proportioned

race.poverty <- shooting.data %>%
  select(raceethnicity, city, state, pov)

colnames(race.poverty)[3]<-("Abbreviation")
race.pov.with.state <- left_join(race.poverty, states.data) 
race.pov.with.state$pov <- as.numeric(race.pov.with.state$pov, na.rm = TRUE)
race.pov.with.means <- race.pov.with.state %>%
  group_by(Abbreviation) %>%
  summarize(mean = round(mean(pov, na.rm = TRUE)), n = n())

race.pov.data <- left_join(race.pov.with.means, states.data)
colnames(race.pov.data)[4]<- ("state")
colnames(race.pov.data)[1]<- ("code")

race.pov.data$hover <- with(race.pov.data, paste(state, '<br>', "Average Poverty Rate: ", 
mean, "\nNumber of People Killed: ", n))

# give state boundaries a white border
l <- list(color = toRGB("white"), width = 2)
# specify some map projection/options
g <- list(
  scope = 'usa',
  projection = list(type = 'albers usa'),
  showlakes = TRUE,
  lakecolor = toRGB('white')
)

p <- plot_geo(race.pov.data, locationmode = 'USA-states') %>%
  add_trace(
    z = ~mean, text = ~hover, locations = ~code,
    color = ~mean, colors = 'Blues'
  ) %>%
  add_trace(lon = shooting.data$longitude, lat = shooting.data$latitude, 
            marker = list(size = 3, color = 'red', hoverinfo = 'none'), 
            hoverinfo = 'skip', type = "scattergeo") %>%
  colorbar(title = "Poverty Rates") %>%
  layout(
    title = 'Average Poverty Rates vs. Number of Deaths',
    geo = list(scope='usa')
  )
  

