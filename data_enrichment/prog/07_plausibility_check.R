#___________________________________________________________________________####
# Project                                                                   ####
#
# Project-Title: RWI-UNI-SUBJECTS (Dataset)
#
# Filename of Code: 07_überprüfung.R
#
# Filename(s) of Input-File(s): - HEI_and_subjects_1971-1996_v2_saved.dta
#
# Filename(s) of Output-File(s):
#
# Short description: This code reads a panel dataset and generates the evolution
#                    of a subject over time
#
#
# Software Version: R 4.4.2

#___________________________________________________________________________####
# Preparation                                                               ####

library("stringr")
library(writexl)
library(ggplot2)
library(readr)
library(reshape2)
library(readxl)
library(dplyr)
library(writexl)
library(ggplot2)
library(readr)
library(dplyr)

mystring <- "Kassel()"
mystring <- str_replace_all(mystring, "[^[:alnum:]]", "")

panel <- read_dta("data_final\\HEI_and_subjects_1971-1996_v2_saved.dta")

# ...
panel$Subject_orig <- str_replace_all(panel$Subject_orig, "[^[:alnum:]]", "")
panel$Subject_orig <- gsub("[0-9]", "", panel$Subject_orig)
panel$City <- str_replace_all(panel$City, "[^[:alnum:]]", "")
panel$City <- gsub("[0-9]", "", panel$City)

# Rename panel
panel_1 <- panel

# List of all unique city-type combinations
city_types <- with(panel_1, paste(City, Type, sep = "_"))
city_types <- unique(city_types)

# Vector with colours
farben <- c("red", "blue", "green", "orange", "purple", "pink", "yellow")

# Conversion to dataframe and sorting by city, type of higher education 
# institution and field of study
panel <- data.frame(panel_1)
panel <- panel[order(panel$City, panel$Typ, panel$Subject_orig),]

panel <- filter(panel, !(is.na(HE_number)))
HE_numbers <- unique(panel$HE_number)

for (i in 1:length(HE_numbers)) {
  HSN <- HE_numbers[i]
  # Filter the current city-type combination
  subset_data <- subset(panel, HE_number == HSN)
  
  # Division of the subjects into groups of 15 subjects each
  studienfaecher <- unique(subset_data$Subject_orig)
  studienfaecher_gruppen <- split(
    studienfaecher, ceiling(seq_along(studienfaecher) / 15)
  )
  
  # Loop via the subject groups
  for (j in 1:length(studienfaecher_gruppen)) {
    studienfaecher_gruppe <- studienfaecher_gruppen[[j]]
    
    # Subset for the current subject group
    subset_data_gruppe <- subset(
      subset_data, 
      Subject_orig %in% studienfaecher_gruppe
    )
    
    # Sort subjects in subset_data_group alphabetically
    subset_data_gruppe$Subject_orig <- factor(
      subset_data_gruppe$Subject_orig, 
      levels = sort(studienfaecher_gruppe)
    )
    
    # Create plot
    plot <- ggplot(
      subset_data_gruppe, 
      aes(x = Year, y = Subject_orig, color = HS_number)
    ) +
      labs(title = paste(HSN, "_", j, sep = "")) +
      scale_color_manual(values = farben)
    
    # Plot with dots, red
    plot_with_points <- plot +
      geom_point(data = subset_data_gruppe,
                 aes(color = factor(!is.na(Year))),
                 size = 3, color = "red") +
      geom_text(data = data.frame(Year = unique(subset_data_gruppe$Year)), 
                aes(x = as.numeric(Year), y = 0.5, label = Year), 
                vjust = 0.5, hjust = 0.5, color = "black") +
      geom_vline(data = data.frame(Year = unique(subset_data_gruppe$Year)),
                 aes(xintercept = as.numeric(Year)),
                 linetype = "dotted", color = "gray") +
      theme(axis.text.y  = element_text(size = 12))
    
    # Saving 
    speicherpfad <- "fig\\correction_fig_HS_num"
    ggsave(
      path = speicherpfad,
      filename = paste(HSN, "_", j, ".png", sep = ""), 
      plot = plot_with_points, 
      width = 20, 
      height = 10
    )
  }
}