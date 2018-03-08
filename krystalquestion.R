library("dplyr")
library("ggplot2")
library(maps)
library(tidyr)
library(fiftystater)
library(plotly)
library(mapproj)

# Reads the csv file that contains all the data needed for Q3
shooting.data <- read.csv(file="police_killings.csv", stringsAsFactors = FALSE)

states.data <- read.csv(file="states.csv", stringsAsFactors = FALSE)

usa.map <- map_data("state")

race.prop <- shooting.data %>%
  select(raceethnicity, city, state, pov) %>%
  group_by(raceethnicity) %>%
  summarize(n = n()) 

#Using plotly to make the bar graph that shows the proportion of races killed
bar.graph.x <- list(title = "Race/Ethnicity",
                    titlefont = f,
                    tickangle = 10,
                    margin = 10,
                    categoryorder = "array",
                    categoryarray = c("Native American", "Asian/Pacific Islander", "Unknown", 
                                      "Hispanic/Latino", "Black", "White"))
bar.graph.y <- c(4, 10, 15, 67, 135, 236)
bar.graph.text <- c('4 People Killed', '10 People Killed', '15 People Killed', 
                    '67 People Killed', '135 People Killed', '236 People Killed')
bar.graph.data <- data.frame(bar.graph.x, bar.graph.y, bar.graph.text)

f <- list(
  family = "Arial",
  size = 18,
  color = "black"
)

bar.graph <- plot_ly(bar.graph.data, x = ~bar.graph.x, y = ~bar.graph.y, type = 'bar', 
             text = bar.graph.text,
             marker = list(color = 'rgb(158,202,225)',
                           line = list(color = 'rgb(8,48,107)', width = 1.5))) %>%
            layout(title = "Proportion Of People Killed Based On Race/Ethnicity",
                   titlefont = f,
                   margin = list(b = 100,
                                 t = 50),
                   xaxis = bar.graph.x,
                   yaxis = list(title = "Number of People Killed",
                                tickangle = 0,
                                titlefont = f))

## In America the percentage of people who are White are about 70% leaving the rest of the
## people colored of "unidentified". If you add up the values for those who are of color vs.
## the amount of were killed who were white, ignoring the "unknown" column, you can see that
## the numbers are almost even. However, this reveals that more people of color were killed
## in the year of 2014 in all of the US compared to white people as the population of 
## white people are higher so less white people died altogether. This is true to what the 
## media displays as well, as we see in the media that usually more people of color are killed
## compared to white people. 

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
race.pov.data$State <- tolower(race.pov.data$State)
colnames(race.pov.data)[4]<-("state")

crimes <- data.frame(state = tolower(rownames(USArrests)), USArrests)

race.pov.data.states <- left_join(crimes, race.pov.data) %>%
  select(state, mean, n)


state.names <- race.pov.data.states[1]

# map_id creates the aesthetic mapping to the state name column in your data
pov.and.death.map <- ggplot(race.pov.data.states, aes(map_id = state)) + 
  # map points to the fifty_states shape data
  geom_map(aes(fill = mean), color = "white", map = fifty_states) + 
  expand_limits(x = fifty_states$long, y = fifty_states$lat) +
  coord_map() +
  scale_x_continuous(breaks = NULL) + 
  scale_y_continuous(breaks = NULL) +
  labs(x = "", y = "") +
  ggtitle("Average Poverty Rates vs. Number of Deaths") +
  theme(legend.position = "bottom", 
        panel.background = element_blank())
# add border boxes to AK/HI
pov.and.death.map + fifty_states_inset_boxes()
