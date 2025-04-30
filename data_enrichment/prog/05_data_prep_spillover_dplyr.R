#___________________________________________________________________________####
# Project                                                                   ####
#
# Project-Title: RWI-UNI-SUBJECTS (Dataset)
#
# Filename of Code: 05_data_prep_spillover_dplyr.R
#
# Filename(s) of Input-File(s): - panel.csv
#
# Filename(s) of Output-File(s): - final_data_spillover_dplyr.csv
#
# Short description: This code reads the panel dataset and generates the final
#                    dataset. This code is identical to the sister 06 file. 
#                    STR+F replace city with county_name and adjust AGS below.
#
# Last Change: 10.02.2025
#
# Editor: Serife Yasar
# E-Mail: Serife.Yasar@rwi-essen.de
#
# Software Version: R 4.4.2

#___________________________________________________________________________####
# Preparation                                                               ####

library(dplyr)
library(ggplot2)
library(readr)
library(reshape2)
library(readxl)
library(dplyr)
library(writexl)
library(ggplot2)
library(readr)
library(tidyr)

# Read panel data set
df <- read_csv("data_final\\panel.csv")

# Filter dataset: remove institutions of type other due to their specifics
df <- filter(df, Typ != "Other")

no_kreis <- unique(df$Kreis_name)
no_kreis <- as.data.frame(no_kreis)
no_city <- unique(df$Stadt)
no_city <- as.data.frame(no_city)

# Finding out every Uni foundation or every FH foundation at the county level
# Caution: replace "Stadt" mit "Kreis_name"

## sf_3 - Codes                                                             #### 

# Filter where "sf_3_code" not NA and "sf_3_code" not duplicated in "Kreis_name"
df_filtered <- df %>%
  filter(!is.na(sf_3_code) & !duplicated(paste(Kreis_name, sf_3_code)))

# Wide-format data frame
df_sf3_all <- df_filtered %>%
  group_by(Kreis_name, sf_3_code) %>%
  summarise(Year = min(Jahr)) %>%
  pivot_wider(
    names_from = sf_3_code, 
    values_from = Year,
    names_prefix = "sf_3_code_"
  )

# Replace missing values with NA
df_sf3_all[is.na(df_sf3_all)] <- NA

# Filter "sf_3_code"s for types Uni/FH 
# Filter where "sf_3_code" not NA and "sf_3_code" not duplicated in "Kreis_name"
df_filtered <- df %>%
  filter(!is.na(sf_3_code) & !duplicated(paste(Kreis_name, sf_3_code, Typ)))

# Wide-format data frame for Uni
df_sf3_all_uni <- df_filtered %>%
  filter(Typ == "Uni") %>%
  group_by(Kreis_name, sf_3_code) %>%
  summarise(Year = min(Jahr)) %>%
  pivot_wider(
    names_from = sf_3_code,
    values_from = Year,
    names_prefix = "sf_3_code_"
  )

# Wide-format data frame for FH
df_sf3_all_fh <- df_filtered %>%
  filter(Typ == "FH") %>%
  group_by(Kreis_name, sf_3_code) %>%
  summarise(Year = min(Jahr)) %>%
  pivot_wider(
    names_from = sf_3_code, 
    values_from = Year, 
    names_prefix = "sf_3_code_"
  )

# Replace missing values with NA
df_sf3_all_uni[is.na(df_sf3_all_uni)] <- NA
df_sf3_all_fh[is.na(df_sf3_all_fh)] <- NA

# Adding the suffix "_uni" and "_fh" to all variables
names(df_sf3_all_uni) <- paste(names(df_sf3_all_uni), "_uni", sep = "")
names(df_sf3_all_uni)[names(df_sf3_all_uni) == "Kreis_name_uni"] <- "Kreis_name"
names(df_sf3_all_fh) <- paste(names(df_sf3_all_fh), "_fh", sep = "")
names(df_sf3_all_fh)[names(df_sf3_all_fh) == "Kreis_name_fh"] <- "Kreis_name"

df_sf3_typ <- merge(df_sf3_all_uni, df_sf3_all_fh, by = "Kreis_name", all = TRUE)

## sf_2 - Codes                                                             #### 

# Filter where "sf_2_code" not NA and "sf_2_code" not duplicated in "Kreis_name"
df_filtered <- df %>%
  filter(!is.na(sf_2_code) & !duplicated(paste(Kreis_name, sf_2_code)))

# Wide-format data frame
df_sf2_all <- df_filtered %>%
  group_by(Kreis_name, sf_2_code) %>%
  summarise(Year = min(Jahr)) %>%
  pivot_wider(
    names_from = sf_2_code,
    values_from = Year, 
    names_prefix = "sf_2_code_"
  )

# Replace missing values with NA
df_sf2_all[is.na(df_sf2_all)] <- NA

# Filter "sf_2_code"s for types Uni/FH 
# Filter where "sf_2_code" not NA and "sf_2_code" not duplicated in "Kreis_name"
df_filtered <- df %>%
  filter(!is.na(sf_2_code) & !duplicated(paste(Kreis_name, sf_2_code, Typ)))

# Wide-format data frame for Uni
df_sf2_all_uni <- df_filtered %>%
  filter(Typ == "Uni") %>%
  group_by(Kreis_name, sf_2_code) %>%
  summarise(Year = min(Jahr)) %>%
  pivot_wider(
    names_from = sf_2_code, 
    values_from = Year, 
    names_prefix = "sf_2_code_"
  )

# Wide-format data frame for FH
df_sf2_all_fh <- df_filtered %>%
  filter(Typ == "FH") %>%
  group_by(Kreis_name, sf_2_code) %>%
  summarise(Year = min(Jahr)) %>%
  pivot_wider(
    names_from = sf_2_code, 
    values_from = Year, 
    names_prefix = "sf_2_code_"
  )

# Replace missing values with NA
df_sf2_all_uni[is.na(df_sf2_all_uni)] <- NA
df_sf2_all_fh[is.na(df_sf2_all_fh)] <- NA

# Adding the suffix "_uni" and "_fh" to all variables
names(df_sf2_all_uni) <- paste(names(df_sf2_all_uni), "_uni", sep = "")
names(df_sf2_all_uni)[names(df_sf2_all_uni) == "Kreis_name_uni"] <- "Kreis_name"
names(df_sf2_all_fh) <- paste(names(df_sf2_all_fh), "_fh", sep = "")
names(df_sf2_all_fh)[names(df_sf2_all_fh) == "Kreis_name_fh"] <- "Kreis_name"

df_sf2_typ <- merge(df_sf2_all_uni, df_sf2_all_fh, by = "Kreis_name", all = TRUE)

## sf_1 - Codes                                                              #### 

# Filter where "sf_1_code" not NA and "sf_1_code" not duplicated in "Kreis_name"
df_filtered <- df %>%
  filter(!is.na(sf_1_code) & !duplicated(paste(Kreis_name, sf_1_code)))


# Wide-format data frame
df_sf1_all <- df_filtered %>%
  group_by(Kreis_name, sf_1_code) %>%
  summarise(Year = min(Jahr)) %>%
  pivot_wider(
    names_from = sf_1_code, 
    values_from = Year, 
    names_prefix = "sf_1_code_"
  )

# Replace missing values with NA
df_sf1_all[is.na(df_sf1_all)] <- NA

# Filter "sf_1_code"s for types Uni/FH
# Filter where "sf_1_code" not NA and "sf_1_code" not duplicated in "Kreis_name"
df_filtered <- df %>%
  filter(!is.na(sf_1_code) & !duplicated(paste(Kreis_name, sf_1_code, Typ)))

# Wide-format data frame for Uni
df_sf1_all_uni <- df_filtered %>%
  filter(Typ == "Uni") %>%
  group_by(Kreis_name, sf_1_code) %>%
  summarise(Year = min(Jahr)) %>%
  pivot_wider(
    names_from = sf_1_code, 
    values_from = Year, 
    names_prefix = "sf_1_code_"
  )

# Wide-format data frame for FH
df_sf1_all_fh <- df_filtered %>%
  filter(Typ == "FH") %>%
  group_by(Kreis_name, sf_1_code) %>%
  summarise(Year = min(Jahr)) %>%
  pivot_wider(
    names_from = sf_1_code,
    values_from = Year, 
    names_prefix = "sf_1_code_"
  )

# Replace missing values with NA
df_sf1_all_uni[is.na(df_sf1_all_uni)] <- NA
df_sf1_all_fh[is.na(df_sf1_all_fh)] <- NA

# Adding the suffix "_uni" and "_fh" to all variables
names(df_sf1_all_uni) <- paste(names(df_sf1_all_uni), "_uni", sep = "")
names(df_sf1_all_uni)[names(df_sf1_all_uni) == "Kreis_name_uni"] <- "Kreis_name"
names(df_sf1_all_fh) <- paste(names(df_sf1_all_fh), "_fh", sep = "")
names(df_sf1_all_fh)[names(df_sf1_all_fh) == "Kreis_name_fh"] <- "Kreis_name"

df_sf1_typ <- merge(df_sf1_all_uni, df_sf1_all_fh, by = "Kreis_name", all = TRUE)

# First occurrences in StudiBuch                                            ####

# Initialization of the transformed data set
df_appeareance <- data.frame(
  Kreis_name = unique(df$Kreis_name), 
  fh_appear = NA, 
  uni_appear = NA, 
  exist = NA, 
  AGS = NA, 
  stringsAsFactors = FALSE
)

# Loop over each "Kreis_name"
for (i in 1:length(unique(df$Kreis_name))) {
  stadt <- unique(df$Kreis_name)[i]
  
  # Filtering the data for the current "Kreis_name"
  subset_data <- subset(df, Kreis_name == stadt)
  
  # Checking that the data is not empty
  if (nrow(subset_data) > 0) {
    # Set the value for "hs_appear" as the minimum year in df in which the 
    # "Kreis_name" occurs for the first time.
    df_appeareance$hs_appear[i] <- min(subset_data$Jahr) 
    
    # Check whether "Kreis_name" has a FH-entry
    has_fh <- "FH" %in% subset_data$Typ
    
    # Check whether "Kreis_name" has a Uni-entry
    has_uni <- "Uni" %in% subset_data$Typ
    
    # Set the value for "fh_appear" and "uni_appear" accordingly
    if (has_fh) {
      df_appeareance$fh_appear[i] <- min(subset_data$Jahr[subset_data$Typ == "FH"])
    }
    
    if (has_uni) {
      df_appeareance$uni_appear[i] <- min(subset_data$Jahr[subset_data$Typ == "Uni"])
    }
    
    # Set the value for "exist" accordingly
    if (has_fh && has_uni) {
      df_appeareance$exist[i] <- "Beide"
    } else if (has_fh) {
      df_appeareance$exist[i] <- "FH"
    } else if (has_uni) {
      df_appeareance$exist[i] <- "Uni"
    }
  }
  
  # Set the value for AGS accordingly
  df_appeareance$AGS[i] <- subset_data$AGS[1]
}

final_data <- left_join(df_appeareance, df_sf1_all, by = "Kreis_name")
final_data <- left_join(final_data, df_sf1_typ, by = "Kreis_name")
final_data <- left_join(final_data, df_sf2_all, by = "Kreis_name")
final_data <- left_join(final_data, df_sf2_typ, by = "Kreis_name")
final_data <- left_join(final_data, df_sf3_all, by = "Kreis_name")
final_data <- left_join(final_data, df_sf3_typ, by = "Kreis_name")

# Adjust AGS                                                                ####

# List of all variables in final_data that end in "x" or "y". 
variable_names <- names(final_data)
variable_names_with_x_y <- grep("[xy]$", variable_names, value = TRUE)

# Print the variables
print(variable_names_with_x_y)

#___________________________________________________________________________####
# Export                                                                    ####

# Saving result dataset
write.csv(
  final_data, 
  file = "data_final\\final_data_spillover_dplyr.csv", 
  row.names = FALSE
)

