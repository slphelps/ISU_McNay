
# McNay Performance Script ------------------------------------------------




# Load Libraries and Data -------------------------------------------------


library(readr)
library(stringr)
library(Hmisc)
library(corrplot)
library(tidyverse)
library(emmeans)
library(car)
library(DT)
library(lubridate)
library(gridExtra)
library(expss)
library(tibble)
library(fs)
library(tools)

# ensure you are working in the directory that has the folder containing "year_sheets"

file_paths <- fs::dir_ls("year_sheets") # path to files 





# For Loop for New Files ------------------------------------------------------

file_contents <- list() #empty list

for(i in seq_along(file_paths)) { # for each file in the "year_sheets"
  file_contents[[i]] <- read.csv( # read the csv file at "i" index in the vector
    file = file_paths[[i]])  #file path for the read.csv function to use
}
# loop that reads each file in the file path 




file_names <- basename(file_paths) # remove directory path and just return csv file names of files
file_names <- file_path_sans_ext(file_names) # remove the cvs extension from the name 


# Assign the file contents generated from the loop to the file names
file_contents <- set_names(file_contents, file_names) 
# file contents is a list of the all of the generated calving season and years
## calving_season_year









# Group sets  -------------------------------------------------------------

# Create new files for each group within the calving year
## Group sets: Heifers, Threes, Youngs, Olds, Fall

group_sets <- list() # create an empty list to store group data frames

# outer loop to extract unique combinations of year and group from each data frame in "file_contents"
for (i in seq_along(file_contents)) { # for each data frame in the list
  data <- file_contents[[i]] # The data frame from current iteration 
  unique_combinations <- unique(data[, c("Year", "Group")])  # extract unique combinations of Year and Group from the current data frame
  
  
# inner loop
  for (j in seq_len(nrow(unique_combinations))) { # for each unique combination of year and group in the current file 
    year <- unique_combinations$Year[j] # extract year
    group <- unique_combinations$Group[j] # extract group
    

    filtered_data <- subset(data, Year == year & Group == group)  # subset data for year and group
    

    key <- paste0(group, sep = "_", year ) # name each data subset based on group and year
    
    # Store data subsets
    group_sets[[key]] <- filtered_data
  }
}





## Convert DOB to a Date
# Column names: calfID cowID DOB calf_died AI Preg_loss Twin No_breed Group Year


# loop through each data frame and convert 'DOB' to Date type
for (key in names(group_sets)) { # for each data subset in the list
  data <- group_sets[[key]]
  
  # convert 'DOB' to Date type if not already
  if ("DOB" %in% names(data)) { # for each DOB column in the list "data" containing all the data frames
    data$DOB <- as.Date(data$DOB, format = "%Y-%m-%d")  # change data type to date
    group_sets[[key]] <- data  # updates the modified data 
  } else {
    message(paste("Column 'DOB' not found in dataset:", key))
  }
}

# convert the rest of the columns to a factor 
columns_to_factor <- c("calf_died", "AI", "Preg_loss", "Twin", "No_breed")  
for (col in columns_to_factor) {
  if (col %in% names(data)) {
    data[[col]] <- as.factor(as.character(data[[col]]))
  } else {
    message(paste("Column", col, "not found in dataset:", key))
  }
} 









# Calving Distribution ----------------------------------------------------

# create a directory to save the plots in 
dir.create("calving_distribution", showWarnings = FALSE)

for (key in names(group_sets)) { # for each group_year sheet in the list
  data <- group_sets[[key]]
  
  # density plot
  plot <- ggplot(data, aes(x = DOB)) + 
    geom_density(fill = "blue", alpha = 0.5) +
    labs(title = paste("Calving Distribution for", key),
         x = "Date of Birth",
         y = "Density") +
    scale_x_date(date_labels = "%b %d", date_breaks = "15 days") +
    theme_minimal() +
    theme(axis.ticks.x = element_line(), 
          panel.background = element_rect(fill = "white"),
          plot.background = element_rect(fill = "white"))

  
  # name each density plot file generated 
  file_name <- paste0("calving_distribution/density", key, ".png")
  
  # save the plot to the file name
  ggsave(filename = file_name, plot = plot, width = 8, height = 6)
}










# Breeding Summary --------------------------------------------------------
# Artificial insemination percentages, natural service percentages, open percentages

# Create empty lists to store results for each group set
AIcalves <- list()
NScalves <- list()
open <- list()
exposed <- list()
NB <- list()
AIexposed <- list()
AIper <- list()
AIperNB <- list()
NSper <- list()
open_per <- list()

# loop through each group_year df 
for (key in names(group_sets)) {
  data <- group_sets[[key]]
  
  # count AI calves
  AIcalves[[key]] <- length(data$calfID[!is.na(data$AI) & data$AI == 1])   
  
  # count NS calves
  NScalves[[key]] <- length(data$calfID[!is.na(data$AI) & data$AI == 2])
  
  # count open cows
  open[[key]] <- length(data$calfID[!is.na(data$AI) & data$AI == 0])
  
  # total exposed
  exposed[[key]] <- n_distinct(data$cowID)
  
  # no Breeds
  NB[[key]] <- length(data$calfID[!is.na(data$No_breed) & data$No_breed == 1])
  
  # AI total exposed
  AIexposed[[key]] <- exposed[[key]] - NB[[key]]
  
  # AI rates
  AIper[[key]] <- (AIcalves[[key]] / AIexposed[[key]]) * 100
  AIperNB[[key]] <- (AIcalves[[key]] / exposed[[key]]) * 100
  
  # NS rates
  NSper[[key]] <- (NScalves[[key]] / exposed[[key]]) * 100
  
  # Open heifers
  open_per[[key]] <- (open[[key]] / exposed[[key]]) * 100
}

# convert the lists a data frame
group_results <- data.frame(
  Group = names(group_sets),
  AI_Percent = unlist(AIper),
  AI_Percent_NB = unlist(AIperNB),
  NS_Percent = unlist(NSper),
  Open_Percent = unlist(open_per)
)

print(group_results)

# write the data frame as a csv file
write.csv(group_results, file = "group_results.csv", row.names = FALSE)

library(writexl)

# write the data frame as an excel file
write_xlsx(group_results, path = "group_results.xlsx")








# Reproductive Performance Bar Charts ------------------------------

group_results_reduced <- group_results %>% select(-AI_Percent) 
# AI_percent removes the females that were not exposed to AI. For the bar chart we only want the AI% that includes no breeds


# format the data frame so it is easier to graph
group_results_longer <- group_results_reduced %>% pivot_longer(
  cols = c(AI_Percent_NB, NS_Percent, Open_Percent), 
  names_to = "Status",
  values_to = "Percent")

# create a directory for repro bar plots
dir.create("reproductive_performance_plots", showWarnings = FALSE) 


for (group in unique(group_results_longer$Group)) { # for each unique group in the data frame
  plot_data <- group_results_longer %>%
    filter(Group == group)

  # bar graph using the group results
repro_bar <- ggplot(plot_data, aes(x=Group, y= Percent, fill = Status)) + # create 3 bars for each pregnancy status
  geom_bar(stat = "identity", position = "dodge") +  
  facet_wrap(~ Group) + # create a new plot for each "Group" or year sheet
  labs(title = "Reproductive Performance",
       x = "Group",
       y = "Percent",
       fill = "Status") +
  theme_minimal() +
   theme(axis.ticks.x = element_line(), 
          axis.text.x = element_text(angle = 45, hjust = 1), 
         axis.text.y = element_text(size = 10),
         panel.background = element_rect(fill = "white"),
         plot.background = element_rect(fill = "white")) +  
    scale_fill_brewer(palette = "Set2") +
  scale_y_continuous(labels = scales::percent_format(scale = 1),
                     breaks = seq(0, 100, by = 10)) 

# Create the filename
repro_bar_name <- paste0("reproductive_performance_plots/Reproductive_Performance_", gsub(" ", "_", group), ".png")

# Save the plot to a file
ggsave(filename = repro_bar_name, plot = repro_bar, width = 8, height = 6)

# Optional: Print a message indicating that the plot was saved
message(paste("Saved plot for group", group, "to", repro_bar_name))
}






# Pregnancy and Calf Loss ----------------------------------------------------------

# create an empty list to store preg results

preg_loss <- list() # pregnancy loss list
calf_loss <- list() # calf loss list 
preg <- list() # number pregnant
calves <- list() # number of calves 
preg_loss_percent <- list()
calf_loss_percent <- list()

# loop through each group_year df 
for (key in names(group_sets)) {
  data <- group_sets[[key]]
  
  # count preg loss
  preg_loss[[key]] <- length(data$Preg_loss[!is.na(data$Preg_loss) & data$Preg_loss == 1])
  
  # count calf loss
  calf_loss[[key]] <- length(data$calf_died[!is.na(data$calf_died) & data$calf_died == 1])
  
  # count pregnant cows
  filtered_data1 <- data$AI[!is.na(data$AI) & data$AI > 0]
  filtered_data2 <- data$Preg_loss[!is.na(data$Preg_loss) & data$Preg_loss == 1]
  preg[[key]] <- length(filtered_data1) + length(filtered_data2)
  
  # count calves
  calves[[key]] <- length(data$calfID[!is.na(data$calfID)])
  
  # preg loss percent
  preg_loss_percent[[key]] <-  (preg_loss[[key]] /  preg[[key]]) * 100
  
  # calf loss percent
  calf_loss_percent[[key]] <- (calf_loss[[key]] / calves[[key]]) * 100
}


# convert the lists a data frame
loss_results <- data.frame(
  Group = names(group_sets),
  Preg_loss = unlist(preg_loss),
  Calf_loss = unlist(calf_loss), 
  Preg_loss_percent = unlist(preg_loss_percent), 
  Calf_loss_percent = unlist(calf_loss_percent))

print(loss_results)

# write the data frame as a csv file
write.csv(loss_results, file = "loss_results.csv", row.names = FALSE)

library(writexl)

# write the data frame as an excel file
write_xlsx(loss_results, path = "loss_results.xlsx")

  
    
  





# Pregnancy and Calf Loss Bar Charts -----------------------------------------------

loss_results_reduced <- loss_results %>% select(-Preg_loss, -Calf_loss)

# format the data frame so it is easier to graph
loss_results_longer <- loss_results_reduced %>% pivot_longer(
  cols = c(Preg_loss_percent, Calf_loss_percent), 
  names_to = "Loss",
  values_to = "Percent")


# create a directory for loss bar plots
dir.create("Preg_Calf_Loss_plots", showWarnings = FALSE) 


for (group in unique(loss_results_longer$Group)) { # for each unique group in the data frame
  plot_data2 <- loss_results_longer %>%
    filter(Group == group)
  
  # bar graph using the group results
  loss_bar <- ggplot(plot_data2, aes(x=Group, y= Percent, fill = Loss)) + # create 2 bars for each loss type
    geom_bar(stat = "identity", position = "dodge") +  
    facet_wrap(~ Group) + # create a new plot for each "Group" or year sheet
    labs(title = "Reproductive Performance",
         x = "Group",
         y = "Percent",
         fill = "Loss Type") +
    theme_minimal() +
    theme(axis.ticks.x = element_line(), 
          axis.text.x = element_text(angle = 45, hjust = 1), 
          axis.text.y = element_text(size = 10),
          panel.background = element_rect(fill = "white"),
          plot.background = element_rect(fill = "white")) +  
    scale_fill_brewer(palette = "Set2") +
    scale_y_continuous(labels = scales::percent_format(scale = 1),
                       breaks = seq(0, 100, by = 2))
                      
  
  # Create the filename
  loss_bar_name <- paste0("Preg_Calf_Loss_plots/Loss_", gsub(" ", "_", group), ".png")
  
  # Save the plot to a file
  ggsave(filename = loss_bar_name, plot = loss_bar, width = 8, height = 6)
}



