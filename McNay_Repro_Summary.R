

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


file_paths <- fs::dir_ls("/Users/sarah/Desktop/Heifer_Development/HD_Project/McNay_repro_summary/year_sheets")
  

# For Loop for Files ------------------------------------------------------

file_contents <- list()

for(i in seq_along(file_paths)) {
  file_contents[[i]] <- read.csv(
    file = file_paths[[i]])
}

file_contents <- set_names(file_contents, file_paths)






