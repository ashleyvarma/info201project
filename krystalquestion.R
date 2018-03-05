library("dplyr")
library("ggplot2")
library(maps)
library(tidyr)



# Reads the csv file that contains all the data needed for Q3
shooting.data <- read.csv(file="police_killings.csv", stringsAsFactors = FALSE)

states.data <- read.csv(file="states.csv", stringsAsFactors = FALSE)

usa.map <- map_data("state")

race.prop <- shooting.data %>%
  select(raceethnicity, city, state, pov) %>%
  group_by(raceethnicity) %>%
  summarize(n = n()) 

# Plot that shows the proportion of races killed 
race.prop.bar.graph <- ggplot(race.prop, aes(raceethnicity, n)) + 
  geom_bar(stat = "identity") +
  xlab("Race/Ethnicity") + ylab("Number of People Killed") +
  ggtitle("Proportion Of People Killed Based On Race/Ethnicity") +
  theme_bw() +
  theme(plot.title = element_text(hjust = 0.5))

## In America the percentage of people who are White are about 70% leaving the rest of the
## people colored of "unidentified". If you add up the values for those who are of color vs.
## the amount of were killed who were white, ignoring the "unknown" column, you can see that
## the numbers are almost even. However, this reveals that more people of color were killed
## in the year of 2014 in all of the US compared to white people as the population of 
## white people are higher so less white people died altogether. This is true to what the 
## media displays as well, as we see in the media that usually more people of color are killed
## compared to white people. 

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

colnames(race.pov.data)[4]<-("region")
race.pov.data$region <- tolower(race.pov.data$region)

race.pov.with.map.data <- left_join(usa.map, race.pov.data) 

race.poverty.map <- ggplot() + geom_polygon(data = race.pov.with.map.data, 
                                            color = "white", 
                                            fill = "black",
                                            aes(x = long, y = lat, 
                                                group = group))
