library(dplyr)
library(ggplot2)

# This section includes a variably spaced data visualization showcasing the relationship 
# between if there a relationship between Which law enforcement agencies are disproportionately 
# involved in killing those who were unarmed. It spotlights those who skew from the national 
# average in terms of highs and lows, and can potentially be related back to the department's 
# training methods. The data would provide this answer through the analysis of filtering the 
# results of law enforcement agencies and the arm status of the deceased at the time, and then 
# comparing the results with each other through a summary means, median, mode.



data <- read.csv('data/police_killings.csv', stringsAsFactors = FALSE, na.strings = c("", "NA"))
state.names <- states$StateName[1:51]
law.enforcement.agency <- c("Millbrook Police Department", "Rapides Parish Sheriff's Office", "Fremont Police Department",                 
                            "Emeryville Police Department", "Wichita County Sheriff's Office", "North Charleston Police Department",
                            "Hoover Police Department", "Muskogee Police Department", 
                            "Syracuse Police Department, Davis County Sheriff's Office",                          
                            "Mansfield Police Department", "St Louis County Police Department", "Old Bridge Police Department", 
                            "Tempe, Chandler and Mesa Police Departments [US Marshals Service Task Force]", 
                            "San Antonio Police Department",                
                            "Tehachapi Police Department")
ethnicity.victim <- c("Black", "White", "Hispanic/Latino", "Asian/Pacific Islander", "Native American","Uknown")
cause.of.death <- data %>% cause()
armed.status <- data %>% armed()
colnames(data)
plot_function <- function (data) {
  data <-  data %>% na.omit()
  p <- ggplot(data = data, aes(x = law.enforcement.agency, y = ethinicity.victim, color = cause.of.death)) +
    geom_jitter(width = 0.1, height = 0.1, alpha = 0.5, size = 4)
  
    p + labs(title = "Law Enforcement vs. Ethnicity of Victim \n vs. Cause of Death ",
           x ="Law Enforcement", y = "Ethnicity of Victim") + 
      theme(plot.title = element_text(hjust = 0.5))
      theme(
        plot.title = element_text(color="black", size=14, face="bold.italic"),
        axis.title.x = element_text(color="blue", size=14, face="bold"),
        axis.title.y = element_text(color="#993333", size=14, face="bold")
  )
      return (p)
}

