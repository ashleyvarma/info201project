library(dplyr)
library(dygraphs)
library(xts)
police.killings <- read.csv('police_killings.csv', stringsAsFactors=FALSE) 
police.killings2 <- read.csv('fatal-police-shootings-data.csv', stringsAsFactors=FALSE)

police.killings2.short <- select(police.killings2, date) %>%
  aggregate(by = list(police.killings2$date), length)

qxts <- xts(police.killings2.short$date, order.by = as.POSIXct(police.killings2.short$Group.1))
colnames(qxts) <- 'Total Police Killings'
count.month <- apply.monthly(qxts, FUN=length)

monthly.killings <- dygraph(count.month, main = "Monthly Police Killings 2015-Present") %>%
  dyAxis("y", label = "Total Police Killings", valueRange = c(20, 35)) %>%
  dyOptions(fillGraph = TRUE, drawGrid = FALSE) %>%
  dyEvent('2016-7-6', "Philando Castile & Alton Sterling", labelLoc = "bottom") %>%
  dyRangeSelector()