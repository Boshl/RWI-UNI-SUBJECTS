# erstmal entsprechenden Datensatz für descriptives erstellen:
# das ist der (veraltete) final_CS_and_HEI_openings_withEast_byCZ.csv

#Code wie er erstellt wurde liegt unter:
# N:\StudiBUCH\LocalLaborMarket\StudiBuch_data\prog\alt 01 und 01_1 code


#rewrite code such that no output file is written and extension is not added
#01_1 code can be shortened drastically; as i only need the one dataset finalCSandHEI...



library(readr)
library(stringr)
library(dplyr)
library(writexl)
library(tidyr)
library(ggplot2)
library(readxl)
library(lfe)
library(haven)
library(tidyverse)

setwd("N:/StudiBUCH/RWI-UNI-SUBJECTS-main/RWI-UNI-SUBJECTS-main/data_enrichment")
df <- read_csv("data_final\\RWI-UNI-SUBJECTS_prefinal.csv")


########## sf2_openings is created from df in the following way: ########

df_filtered <- df %>%
  filter(!is.na(Subject_area_code) & !is.na(AGS))  #remove missings


# Wide-format data frame  - create a dataframe which has every sf_3_code as a separate variable and has the first appearance by AGS as the respective value
sf2_opening_OnlyByKreis <- df_filtered %>%
  group_by(AGS, Subject_area_code) %>%
  summarise(year = min(Year)) %>%
  pivot_wider(names_from = Subject_area_code, values_from = year, names_prefix = "Subject_area_code_")

sf2_opening_OnlyByKreis <- filter(sf2_opening_OnlyByKreis, AGS != "nicht in Li")

sf2_opening_OnlyByKreis$AGS <- as.integer(sf2_opening_OnlyByKreis$AGS)

sf2_opening_OnlyByKreis <- filter(sf2_opening_OnlyByKreis, !is.na(AGS))

#repeat - split by Type
sf2_opening_bytype <- df_filtered %>%
  group_by(AGS, Subject_area_code, Type) %>%
  summarise(year = min(Year)) %>%
  pivot_wider(names_from = Subject_area_code, values_from = year, names_prefix = "Subject_area_code_")

sf2_opening_bytype <- filter(sf2_opening_bytype, AGS != "nicht in Li")

sf2_opening_bytype$AGS <- as.integer(sf2_opening_bytype$AGS)

sf2_opening_bytype <- filter(sf2_opening_bytype, !is.na(AGS))

sf2_opening_OnlyByKreis <- sf2_opening_OnlyByKreis %>%
  mutate(Type = "All") %>%
  relocate(Type, .after = 1)

#combine both
sf2_opening_bytype <- sf2_opening_bytype %>% rbind(sf2_opening_OnlyByKreis)
sf2_opening_bytype <- arrange(sf2_opening_bytype, AGS, Type)


# creating the simpler Dataset final_CS_and_HEI_openings_withEast_byCZ.csv

sf2_opening_bytype_woO_East <- sf2_opening_bytype 

kreis_namen <- read_excel("data_input\\kreis_namen_2013.xlsx")
clean_CZ_KW <- read_csv("data_input\\clean_CZ_KW.csv")

clean_CZ_KW$AGScode <- as.character(clean_CZ_KW$AGScode)
#add a leading 0 for AGS numbers which only have 4 characters
clean_CZ_KW$AGScode <- ifelse(nchar(clean_CZ_KW$AGScode) == 4, 
                              paste0("0", clean_CZ_KW$AGScode), 
                              clean_CZ_KW$AGScode)




#####   dealing with sf2_opening_bytype_woO_East   #####
#add a leading 0 for AGS numbers which only have 4 characters
sf2_opening_bytype_woO_East$AGS <- ifelse(nchar(sf2_opening_bytype_woO_East$AGS) == 4, 
                                          paste0("0", sf2_opening_bytype_woO_East$AGS), 
                                          sf2_opening_bytype_woO_East$AGS)

#add Kreis names
sf2_opening_bytype_woO_East$AGS <- as.character(sf2_opening_bytype_woO_East$AGS)
kreis_namen$Kreis_AGS <- as.character(kreis_namen$Kreis_AGS)
sf2_opening_bytype_woO_East <-left_join(sf2_opening_bytype_woO_East, kreis_namen, by=c("AGS" = "Kreis_AGS")) 

#add CZ number
sf2_opening_bytype_woO_East <- left_join(sf2_opening_bytype_woO_East, clean_CZ_KW, by=c("AGS" = "AGScode"))
sf2_opening_bytype_woO_East <- sf2_opening_bytype_woO_East %>%
  select(AGS, Kreis_name, RAM, Type, Subject_area_code_71, everything())

#from this dataset create separate dataset on opening years within commuting zone
subject_area_cols <- grep("^Subject_area_code_", names(sf2_opening_bytype_woO_East), value = TRUE)

# Function to create filtered datasets for each Subject_area_code_* column
filter_min_per_group <- function(col_name) {
  sf2_opening_bytype_woO_East %>%
    group_by(Type, RAM) %>%
    slice(which.min(.data[[col_name]])) %>%
    select(RAM, Type, !!col_name := .data[[col_name]]) # Rename dynamically
}

# Apply function to each Subject_area_code_* column and store results in a list
filtered_datasets <- map(subject_area_cols, filter_min_per_group)

# Merge all datasets together using left_join
sf2_opening_bytype_woO_East_CZ <- reduce(filtered_datasets, left_join, by = c("RAM", "Type"))


#first set all variables of the dataset sf2_opening_bytype_woO_East which are in subject_area_cols to be numeric.
sf2_opening_bytype_woO_East_CZ <- sf2_opening_bytype_woO_East_CZ %>%
  mutate(across(all_of(subject_area_cols), as.numeric))

# Filter dataset where Type == "All" and calculate HEI_founding as the minimum of all subject_area_cols
df2 <- sf2_opening_bytype_woO_East_CZ %>%
  filter(Type == "All") %>%
  rowwise() %>%  # Ensure row-wise operation
  mutate(HEI_founding =
           ifelse(all(is.na(c_across(all_of(subject_area_cols)))), 
                  NA, 
                  min(c_across(all_of(subject_area_cols)), na.rm = TRUE))) %>%
  ungroup() %>%  
  select(RAM, HEI_founding)

#same but for university:
df3 <- sf2_opening_bytype_woO_East_CZ %>%
  filter(Type == "university") %>%
  rowwise() %>%  # Ensure row-wise operation
  mutate(University_founding =
           ifelse(all(is.na(c_across(all_of(subject_area_cols)))), 
                  NA, 
                  min(c_across(all_of(subject_area_cols)), na.rm = TRUE))) %>%
  ungroup() %>%  
  select(RAM, University_founding)

#same but for UAS:
df4 <- sf2_opening_bytype_woO_East_CZ %>%
  filter(Type == "UAS") %>%
  rowwise() %>%  # Ensure row-wise operation
  mutate(FH_founding =
           ifelse(all(is.na(c_across(all_of(subject_area_cols)))), 
                  NA, 
                  min(c_across(all_of(subject_area_cols)), na.rm = TRUE))) %>%
  ungroup() %>%  
  select(RAM, FH_founding)

#CS_71_opening
df7 <- sf2_opening_bytype_woO_East_CZ %>%
  filter(Type == "All") %>%
  rowwise() %>%  # Ensure row-wise operation
  mutate(CS_71_opening = ifelse(all(is.na(Subject_area_code_71)), 
                                NA, 
                                min(Subject_area_code_71, na.rm = TRUE))) %>%
  ungroup() %>%  
  select(RAM, CS_71_opening)

#CS_71_opening_at_Uni
df8 <- sf2_opening_bytype_woO_East_CZ %>%
  filter(Type == "university") %>%
  rowwise() %>%  # Ensure row-wise operation
  mutate(CS_71_opening_at_Uni = ifelse(all(is.na(Subject_area_code_71)), 
                                       NA, 
                                       min(Subject_area_code_71, na.rm = TRUE))) %>%
  ungroup() %>%  
  select(RAM, CS_71_opening_at_Uni)

#CS_71_opening_at_FH
df9 <- sf2_opening_bytype_woO_East_CZ %>%
  filter(Type == "UAS") %>%
  rowwise() %>%  # Ensure row-wise operation
  mutate(CS_71_opening_at_FH = ifelse(all(is.na(Subject_area_code_71)), 
                                      NA, 
                                      min(Subject_area_code_71, na.rm = TRUE))) %>%
  ungroup() %>%  
  select(RAM, CS_71_opening_at_FH)

#combine all
df2 <- left_join(df2, df3 , by= "RAM")
df2 <- left_join(df2, df4, by = "RAM")
df2 <- left_join(df2, df7 , by= "RAM")
df2 <- left_join(df2, df8, by = "RAM")
df2 <- left_join(df2, df9, by = "RAM")


df_for_descr <- df2






########## Create Plots ##########
### Remove all prior data ###
rm(list = setdiff(ls(), "df_for_descr"))
options(java.parameters = "-Xmx16g")
#Sys.setlocale("LC_ALL", "de_DE.UTF-8")
gc()
#
### Set working directory
getwd()
setwd("N:/StudiBUCH/RWI-UNI-SUBJECTS-main/RWI-UNI-SUBJECTS-main/data_enrichment")
#
#### SINK if necessary ####-
#
# I. Load required packages and write major functions #####
#
library(geodata) # for geodata
library(ggplot2) # for figures
library(dplyr)   # for datawrangling
library(data.table) # for reading csv-tables
library(readxl) # for reading excel-files
library(sf) # for spatial
library(RColorBrewer) # for colors

library(mapproj)
library(readr)
library(knitr)
library(kableExtra)
library(tidyverse)
library(readxl)
library(haven)


#library(readr)
#library(tidyverse)
#library(sf)


# write function for "not in"
`%notin%` <- function(x,y) !(x %in% y) 
#

# II. Load and adjust relevant data #####
##### II.1 Opening of computer science ######

cs_openings <- df_for_descr
cs_openings <- cs_openings %>% select(RAM, CS_71_opening, CS_71_opening_at_Uni, CS_71_opening_at_FH)

germany_counties <- geodata::gadm(country = "DEU", level = 2, path = tempdir())
germany_counties <- st_as_sf(germany_counties)
# change AGS to numeric
germany_counties$CC_2 <- as.numeric(germany_counties$CC_2)

LMR <- fread("N:\\StudiBUCH\\LocalLaborMarket\\StudiBuch_data\\clean_CZ_KW.csv")
colnames(LMR) <- c("CZ", "AGS", "AGS_name")

combined_data <- left_join(germany_counties, LMR, by = c("CC_2" = "AGS"))
combined_data <- left_join(combined_data, cs_openings, by = c("CZ" = "RAM"))
combined_data <- combined_data %>%
  rename(CS_opening_CZ_uni = CS_71_opening_at_Uni,
         CS_opening_CZ_fh = CS_71_opening_at_FH,
         CS_opening_CZ = CS_71_opening)


# Define Western and Eastern states
east_states <- c("Brandenburg", "Mecklenburg-Vorpommern", 
                 "Sachsen", "Sachsen-Anhalt", "Thüringen",
                 "Berlin")

# add West and East
combined_data <- combined_data %>%
  mutate(GDR_states = case_when(NAME_1 %in% east_states ~ "East",
                                NAME_1 %notin% east_states ~ "West"))

# Filter Eichsfeld and change it to NA (because of unis in West)
combined_data[which(combined_data$CZ == 8), c("CS_opening_CZ", "CS_opening_CZ_uni", "CS_opening_CZ_fh")] <- NA

# create founding periods in West and East
combined_data <- combined_data %>%
  mutate(founding_period_uni = case_when(CS_opening_CZ_uni <= 1971 & GDR_states == "West"~ "up to 1971",
                                         CS_opening_CZ_uni >= 1972 & CS_opening_CZ_uni <= 1975 & GDR_states == "West"~ "1972–1975",
                                         CS_opening_CZ_uni >= 1976 & CS_opening_CZ_uni <= 1980 & GDR_states == "West"~ "1976–1980",
                                         CS_opening_CZ_uni >= 1981 & CS_opening_CZ_uni <= 1985 & GDR_states == "West"~ "1981–1985",
                                         CS_opening_CZ_uni >= 1986 & CS_opening_CZ_uni <= 1990 & GDR_states == "West"~ "1986–1990",
                                         CS_opening_CZ_uni >= 1991 & CS_opening_CZ_uni <= 1996 & GDR_states == "West"~ "1991–1996",
                                         CS_opening_CZ_uni <= 1991 & GDR_states == "East" ~ "up to 1991 (GDR only)",
                                         CS_opening_CZ_uni >= 1992 & GDR_states == "East" ~ "1992–1996 (GDR only)")) %>%
  mutate(founding_period_fh = case_when(CS_opening_CZ_fh <= 1971 & GDR_states == "West"~ "up to 1971",
                                        CS_opening_CZ_fh >= 1972 & CS_opening_CZ_fh <= 1975 & GDR_states == "West"~ "1972–1975",
                                        CS_opening_CZ_fh >= 1976 & CS_opening_CZ_fh <= 1980 & GDR_states == "West"~ "1976–1980",
                                        CS_opening_CZ_fh >= 1981 & CS_opening_CZ_fh <= 1985 & GDR_states == "West"~ "1981–1985",
                                        CS_opening_CZ_fh >= 1986 & CS_opening_CZ_fh <= 1990 & GDR_states == "West"~ "1986–1990",
                                        CS_opening_CZ_fh >= 1991 & CS_opening_CZ_fh <= 1996 & GDR_states == "West"~ "1991–1996",
                                        CS_opening_CZ_fh <= 1991 & GDR_states == "East" ~ "up to 1991 (GDR only)",
                                        CS_opening_CZ_fh >= 1992 & GDR_states == "East" ~ "1992–1996 (GDR only)")) %>%
  mutate(founding_period_any = case_when(CS_opening_CZ <= 1971 & GDR_states == "West"~ "up to 1971",
                                         CS_opening_CZ >= 1972 & CS_opening_CZ <= 1975 & GDR_states == "West"~ "1972–1975",
                                         CS_opening_CZ >= 1976 & CS_opening_CZ <= 1980 & GDR_states == "West"~ "1976–1980",
                                         CS_opening_CZ >= 1981 & CS_opening_CZ <= 1985 & GDR_states == "West"~ "1981–1985",
                                         CS_opening_CZ >= 1986 & CS_opening_CZ <= 1990 & GDR_states == "West"~ "1986–1990",
                                         CS_opening_CZ >= 1991 & CS_opening_CZ <= 1996 & GDR_states == "West"~ "1991–1996",
                                         CS_opening_CZ <= 1991 & GDR_states == "East" ~ "up to 1991 (GDR only)",
                                         CS_opening_CZ >= 1992 & GDR_states == "East" ~ "1992–1996 (GDR only)"))


# Define Eastern and Western German states
east_lmr <- combined_data %>%
  filter(NAME_1 %in% east_states)

west_lmr <- combined_data %>%
  filter(NAME_1 %notin% east_states)

#### NEW: PLOT FOR CS WITH GDR POST-UNIFICATION

# UNIFIED GERMANY
germany_states <- geodata::gadm(country = "DEU", level = 1, path = tempdir()) %>%
  st_as_sf()
#selected_states <- germany_states %>%
#filter(NAME_1 %in% c("Brandenburg", "Sachsen", "Mecklenburg-Vorpommern", "Sachsen-Anhalt", "Thüringen", "Bayern", "Hessen", "Niedersachsen", "Schleswig-Holstein"))
east_germany_unified <- east_lmr %>%
  st_union() %>%
  st_sf()
west_germany_unified <- west_lmr %>%
  st_union() %>%
  st_sf()

#### CS at uni 1971 only ####
# plot for University befoer 1971
plot_uni_1971 <- ggplot() +
  geom_sf(
    data = west_lmr,
    fill = "grey70",
    color = "grey75",
    size = 0.4
  ) +
  geom_sf(
    data = east_lmr,
    fill = "grey80",
    color = "lightgray",
    size = 0.4
  ) +
  # Daten aus Westen und Osten
  geom_sf(
    data = combined_data %>% 
      filter(!is.na(founding_period_uni)) %>%
      filter(founding_period_uni == "up to 1971"),
    aes(fill = founding_period_uni),
    color = "grey75",
    size = 0.4
  ) +
  scale_fill_manual(
    values = c(
      "up to 1971" = rgb(232/255, 225/255, 0/255, 0.9)
    ),
    na.value = NA,
    breaks = c("up to 1971")
  ) +
  # Grenzen von West und Ost:
  #geom_sf(data=germany_states, fill = NA, color="black", size=0.2)+
  geom_sf(
    data = east_germany_unified,
    fill = NA,
    color = "black",
    linewidth = 0.6
  ) +
  geom_sf(
    data = west_germany_unified,
    fill = NA,
    color = "black",
    linewidth = 0.6
  ) +
  theme_void() +
  theme(legend.title = element_text(size=18),
        legend.text = element_text(size=16))+
  labs(fill = "Foundation of \nComputer Science") #+
#  ggtitle("CS Programs at HEI per labor market region")

plot_uni_1971

ggsave("fig\\CS_openings_UNI_forScientificDATA_1971.png", 
       plot = plot_uni_1971, device = "png", width = 9, height = 9)


#### CS at uni all years ####
# plot for University over all years
plot_uni <- ggplot() +
  geom_sf(
    data = west_lmr,
    fill = "grey70",
    color = "grey75",
    size = 0.4
  ) +
  geom_sf(
    data = east_lmr,
    fill = "grey80",
    color = "lightgray",
    size = 0.4
  ) +
  # Daten aus Westen und Osten
  geom_sf(
    data = combined_data %>% 
      filter(!is.na(founding_period_uni)),
    aes(fill = founding_period_uni),
    color = "grey75",
    size = 0.3
  ) +
  scale_fill_manual(
    values = c(
      "up to 1971" = rgb(232/255, 225/255, 0/255, 0.9),
      "1972–1975" = rgb(0/255, 120/255, 88/255),
      "1976–1980" = rgb(24/255, 29/255, 82/255),
      "1981–1985" = rgb(0/255, 88/255, 114/255),
      "1986–1990" = rgb(0/255, 157/255, 208/255),
      "up to 1991 (GDR only)" = rgb(232/255, 225/255, 0/255, 0.5),
      "1991–1996" = rgb(0/255, 157/255, 208/255),
      "1992–1996 (GDR only)" = rgb(0/255, 157/255, 208/255, 0.5)
    ),
    na.value = NA,
    breaks = c("up to 1971", "1972–1975", "1976–1980", 
               "1981–1985", "1985–1990", "1991–1996", "up to 1991 (GDR only)", "1992–1996 (GDR only)")
  ) +
  # Grenzen von West und Ost:
  #geom_sf(data=germany_states, fill = NA, color="black", size=0.2)+
  geom_sf(
    data = east_germany_unified,
    fill = NA,
    color = "black",
    linewidth = 0.6
  ) +
  geom_sf(
    data = west_germany_unified,
    fill = NA,
    color = "black",
    linewidth = 0.6
  ) +
  theme_void() +
  theme(legend.title = element_text(size=18),
        legend.text = element_text(size=16))+
  labs(fill = "Foundation of \nComputer Science") #+
#  ggtitle("CS Programs at HEI per labor market region")

plot_uni

ggsave("fig\\CS_openings_UNI_forScientificDATA.png", 
       plot = plot_uni, device = "png", width = 9, height = 9)


# Fachhochschulen
# plot for Fachhochschule for 1971 only
plot_fh_1971 <- ggplot() +
  geom_sf(
    data = west_lmr,
    fill = "grey70",
    color = "grey75",
    size = 0.4
  ) +
  geom_sf(
    data = east_lmr,
    fill = "grey80",
    color = "lightgray",
    size = 0.4
  ) +
  # Daten aus Westen und Osten
  geom_sf(
    data = combined_data %>% 
      filter(!is.na(founding_period_fh)) %>%
      filter(founding_period_fh == "up to 1971"),
    aes(fill = founding_period_fh),
    color = "grey75",
    size = 0.4
  ) +
  scale_fill_manual(
    values = c(
      "up to 1971" = rgb(232/255, 225/255, 0/255, 0.9)
    ),
    na.value = NA,
    breaks = c("up to 1971")
  ) +
  # Grenzen von West und Ost:
  #geom_sf(data=germany_states, fill = NA, color="black", size=0.2)+
  geom_sf(
    data = east_germany_unified,
    fill = NA,
    color = "black",
    linewidth = 0.6
  ) +
  geom_sf(
    data = west_germany_unified,
    fill = NA,
    color = "black",
    linewidth = 0.6
  ) +
  theme_void() +
  theme(legend.title = element_text(size=18),
        legend.text = element_text(size=16))+
  labs(fill = "Foundation of \nComputer Science")
#  ggtitle("CS Programs at HEI per labor market region")

plot_fh_1971

ggsave("fig\\CS_openings_FH_forScientificDATA_1971.png", 
       plot = plot_fh_1971, device = "png", width = 9, height = 9)


# plot for Fachhochschule all years
plot_fh <- ggplot() +
  geom_sf(
    data = west_lmr,
    fill = "grey70",
    color = "grey75",
    size = 0.4
  ) +
  geom_sf(
    data = east_lmr,
    fill = "grey80",
    color = "lightgray",
    size = 0.4
  ) +
  # Daten aus Westen und Osten
  geom_sf(
    data = combined_data %>% 
      filter(!is.na(founding_period_fh)),
    aes(fill = founding_period_fh),
    color = "grey75",
    size = 0.4
  ) +
  scale_fill_manual(
    values = c(
      "up to 1971" = rgb(232/255, 225/255, 0/255, 0.9),
      "1972–1975" = rgb(0/255, 120/255, 88/255),
      "1976–1980" = rgb(24/255, 29/255, 82/255),
      "1981–1985" = rgb(0/255, 88/255, 114/255),
      "1986–1990" = rgb(0/255, 157/255, 208/255),
      "up to 1991 (GDR only)" = rgb(232/255, 225/255, 0/255, 0.5),
      "1991–1996" = rgb(0/255, 157/255, 208/255),
      "1992–1996 (GDR only)" = rgb(0/255, 157/255, 208/255, 0.5)
    ),
    na.value = NA,
    breaks = c("up to 1971", "1972–1975", "1976–1980", 
               "1981–1985", "1985–1990", "1991–1996", "up to 1991 (GDR only)", "1992–1996 (GDR only)")
  ) +
  # Grenzen von West und Ost:
  #geom_sf(data=germany_states, fill = NA, color="black", size=0.2)+
  geom_sf(
    data = east_germany_unified,
    fill = NA,
    color = "black",
    linewidth = 0.6
  ) +
  geom_sf(
    data = west_germany_unified,
    fill = NA,
    color = "black",
    linewidth = 0.6
  ) +
  theme_void() +
  theme(legend.title = element_text(size=18),
        legend.text = element_text(size=16))+
  labs(fill = "Foundation of \nComputer Science")
#  ggtitle("CS Programs at HEI per labor market region")

plot_fh

ggsave("fig\\CS_openings_FH_forScientificDATA.png", 
       plot = plot_fh, device = "png", width = 9, height = 9)






#### Hochschulen über die Zeit ####

#read RWI-UNI-SUBJECTS
panel <- read_csv("data_final\\RWI-UNI-SUBJECTS.csv")

# We are interested in the first appearance of a uni or fh in a district (AGS). 
# We therefore check the first appearance per district.

first_per_district <- panel %>%
  select(AGS, Location_name,
         Year, Type) %>%
  group_by(AGS, Type) %>%
  slice(which.min(Year))

first_per_district <- spread(first_per_district, Type, Year)

first_per_district$AGS <- as.double(first_per_district$AGS)

# um alles in einer Abbildung darzustellen, müssen noch ein paar Variablen erstellt werden.
first_per_district <- first_per_district %>%
  mutate(HEI_district = case_when(UAS > 1900 & is.na(university) ~ "UAS",
                                  university > 1900 & is.na(UAS) ~ "uni",
                                  UAS > 1900 & university > 1900 ~ "both")) %>%
  mutate(first_of_both = UAS - university) %>%
  mutate(first_type = case_when(first_of_both >= 0 ~ "uni_first",
                                first_of_both < 0 ~ "UAS_first",
                                TRUE ~ "other")) %>%
  mutate(year_relevant = case_when(HEI_district == "UAS" ~ UAS,
                                   HEI_district == "uni" ~ university,
                                   first_type == "uni_first" ~ university,
                                   first_type == "UAS_first" ~ UAS))

# merge with shapefile data and add info on east and west
first_combined <- left_join(germany_counties, first_per_district, by = c("CC_2" = "AGS")) %>%
  mutate(GDR_states = case_when(NAME_1 %in% east_states ~ "East",
                                NAME_1 %notin% east_states ~ "West")) 

# put founding periods into same categories as computer science before
first_combined <- first_combined %>%
  mutate(founding_any = case_when(year_relevant <= 1971 & GDR_states == "West"~ "up to 1971",
                                  year_relevant >= 1972 & year_relevant <= 1975 & GDR_states == "West"~ "1972–1975",
                                  year_relevant >= 1976 & year_relevant <= 1980 & GDR_states == "West"~ "1976–1980",
                                  year_relevant >= 1981 & year_relevant <= 1985 & GDR_states == "West"~ "1981–1985",
                                  year_relevant >= 1986 & year_relevant <= 1990 & GDR_states == "West"~ "1986–1990",
                                  year_relevant >= 1991 & year_relevant <= 1996 & GDR_states == "West"~ "1991–1996",
                                  year_relevant <= 1991 & GDR_states == "East" ~ "up to 1991 (GDR only)",
                                  year_relevant >= 1992 & GDR_states == "East" ~ "1992–1996 (GDR only)")) %>%
  mutate(founding_period_uni = case_when(university <= 1971 & GDR_states == "West"~ "up to 1971",
                                         university >= 1972 & university <= 1975 & GDR_states == "West"~ "1972–1975",
                                         university >= 1976 & university <= 1980 & GDR_states == "West"~ "1976–1980",
                                         university >= 1981 & university <= 1985 & GDR_states == "West"~ "1981–1985",
                                         university >= 1986 & university <= 1990 & GDR_states == "West"~ "1986–1990",
                                         university >= 1991 & university <= 1996 & GDR_states == "West"~ "1991–1996",
                                         university <= 1991 & GDR_states == "East" ~ "up to 1991 (GDR only)",
                                         university >= 1992 & GDR_states == "East" ~ "1992–1996 (GDR only)")) %>%
  mutate(founding_period_fh = case_when(UAS <= 1971 & GDR_states == "West"~ "up to 1971",
                                        UAS >= 1972 & UAS <= 1975 & GDR_states == "West"~ "1972–1975",
                                        UAS >= 1976 & UAS <= 1980 & GDR_states == "West"~ "1976–1980",
                                        UAS >= 1981 & UAS <= 1985 & GDR_states == "West"~ "1981–1985",
                                        UAS >= 1986 & UAS <= 1990 & GDR_states == "West"~ "1986–1990",
                                        UAS >= 1991 & UAS <= 1996 & GDR_states == "West"~ "1991–1996",
                                        UAS <= 1991 & GDR_states == "East" ~ "up to 1991 (GDR only)",
                                        UAS >= 1992 & GDR_states == "East" ~ "1992–1996 (GDR only)")) 

# Create plots fpr FHs all years
plot_evolution_fh_1971 <- ggplot() +
  geom_sf(
    data = west_lmr,
    fill = "grey70",
    color = "grey75",
    size = 0.4
  ) +
  geom_sf(
    data = east_lmr,
    fill = "grey80",
    color = "lightgray",
    size = 0.4
  ) +
  # Daten aus Westen und Osten
  geom_sf(
    data = first_combined %>% 
      filter(!is.na(founding_period_fh)) %>%
      filter(founding_period_fh == "up to 1971"),
    aes(fill = founding_period_fh),
    color = "grey75",
    size = 0.4
  ) +
  scale_fill_manual(
    values = c(
      "up to 1971" = rgb(232/255, 225/255, 0/255, 0.9)
    ),
    na.value = NA,
    breaks = c("up to 1971")
  ) +
  # Grenzen von West und Ost:
  #geom_sf(data=germany_states, fill = NA, color="black", size=0.2)+
  geom_sf(
    data = east_germany_unified,
    fill = NA,
    color = "black",
    linewidth = 0.6
  ) +
  geom_sf(
    data = west_germany_unified,
    fill = NA,
    color = "black",
    linewidth = 0.6
  ) +
  theme_void() +
  theme(legend.title = element_text(size=18),
        legend.text = element_text(size=16))+
  labs(fill = "Foundation of \nUniversities of \nApplied Sciences")
#  labs(fill = "UAS openings") #+
#  ggtitle("CS Programs at HEI per labor market region")

plot_evolution_fh_1971

ggsave("fig\\plot_evolution_FH_forScientificDATA_1971.png", 
       plot = plot_evolution_fh_1971, device = "png", width = 9, height = 9)



# Create plots for FHs all years
plot_evolution_fh <- ggplot() +
  geom_sf(
    data = west_lmr,
    fill = "grey70",
    color = "grey75",
    size = 0.3
  ) +
  geom_sf(
    data = east_lmr,
    fill = "grey80",
    color = "lightgray",
    size = 0.3
  ) +
  # Daten aus Westen und Osten
  geom_sf(
    data = first_combined %>% 
      filter(!is.na(founding_period_fh)),
    aes(fill = founding_period_fh),
    color = "grey75",
    size = 0.3
  ) +
  scale_fill_manual(
    values = c(
      "up to 1971" = rgb(232/255, 225/255, 0/255, 0.9),
      "1972–1975" = rgb(0/255, 120/255, 88/255),
      "1976–1980" = rgb(24/255, 29/255, 82/255),
      "1981–1985" = rgb(0/255, 88/255, 114/255),
      "1986–1990" = rgb(0/255, 157/255, 208/255),
      "up to 1991 (GDR only)" = rgb(232/255, 225/255, 0/255, 0.5),
      "1991–1996" = rgb(0/255, 157/255, 208/255),
      "1992–1996 (GDR only)" = rgb(0/255, 157/255, 208/255, 0.5)
    ),
    na.value = NA,
    breaks = c("up to 1971", "1972–1975", "1976–1980", 
               "1981–1985", "1985–1990", "1991–1996", "up to 1991 (GDR only)", "1992–1996 (GDR only)")
  ) +
  # Grenzen von West und Ost:
  #geom_sf(data=germany_states, fill = NA, color="black", size=0.2)+
  geom_sf(
    data = east_germany_unified,
    fill = NA,
    color = "black",
    linewidth = 0.6
  ) +
  geom_sf(
    data = west_germany_unified,
    fill = NA,
    color = "black",
    linewidth = 0.6
  ) +
  theme_void() +
  theme(legend.title = element_text(size=18),
        legend.text = element_text(size=16))+
  labs(fill = "Foundation of \nUniversities of \nApplied Sciences")
#  labs(fill = "UAS openings") #+
#  ggtitle("CS Programs at HEI per labor market region")

plot_evolution_fh

ggsave("fig\\plot_evolution_FH_forScientificDATA.png", 
       plot = plot_evolution_fh, device = "png", width = 9, height = 9)

#
# Create plots for uni openings only 1971
plot_evolution_uni_1971 <- ggplot() +
  geom_sf(
    data = west_lmr,
    fill = "grey70",
    color = "grey75",
    size = 0.4
  ) +
  geom_sf(
    data = east_lmr,
    fill = "grey80",
    color = "lightgray",
    size = 0.4
  ) +
  # Daten aus Westen und Osten
  geom_sf(
    data = first_combined %>% 
      filter(!is.na(founding_period_uni)) %>%
      filter(founding_period_uni == "up to 1971"),
    aes(fill = founding_period_uni),
    color = "grey75",
    size = 0.4
  ) +
  scale_fill_manual(
    values = c(
      "up to 1971" = rgb(232/255, 225/255, 0/255, 0.9)
    ),
    na.value = NA,
    breaks = c("up to 1971")
  ) +
  # Grenzen von West und Ost:
  #geom_sf(data=germany_states, fill = NA, color="black", size=0.2)+
  geom_sf(
    data = east_germany_unified,
    fill = NA,
    color = "black",
    linewidth = 0.6
  ) +
  geom_sf(
    data = west_germany_unified,
    fill = NA,
    color = "black",
    linewidth = 0.6
  ) +
  theme_void() +
  theme(legend.title = element_text(size=18),
        legend.text = element_text(size=16))+
  labs(fill = "Foundation of \nUniversities")
#  labs(fill = "University openings") #+
#  ggtitle("CS Programs at HEI per labor market region")

plot_evolution_uni_1971

ggsave("fig\\plot_evolution_UNI_forScientificDATA_1971.png", 
       plot = plot_evolution_uni_1971, device = "png", width = 9, height = 9)




# Create plots for uni all years
plot_evolution_uni <- ggplot() +
  geom_sf(
    data = west_lmr,
    fill = "grey70",
    color = "grey75",
    size = 0.4
  ) +
  geom_sf(
    data = east_lmr,
    fill = "grey80",
    color = "lightgray",
    size = 0.4
  ) +
  # Daten aus Westen und Osten
  geom_sf(
    data = first_combined %>% 
      filter(!is.na(founding_period_uni)),
    aes(fill = founding_period_uni),
    color = "grey75",
    size = 0.4
  ) +
  scale_fill_manual(
    values = c(
      "up to 1971" = rgb(232/255, 225/255, 0/255, 0.9),
      "1972–1975" = rgb(0/255, 120/255, 88/255),
      "1976–1980" = rgb(24/255, 29/255, 82/255),
      "1981–1985" = rgb(0/255, 88/255, 114/255),
      "1986–1990" = rgb(0/255, 157/255, 208/255),
      "up to 1991 (GDR only)" = rgb(232/255, 225/255, 0/255, 0.5),
      "1991–1996" = rgb(0/255, 157/255, 208/255),
      "1992–1996 (GDR only)" = rgb(0/255, 157/255, 208/255, 0.5)
    ),
    na.value = NA,
    breaks = c("up to 1971", "1972–1975", "1976–1980", 
               "1981–1985", "1985–1990", "1991–1996", "up to 1991 (GDR only)", "1992–1996 (GDR only)")
  ) +
  # Grenzen von West und Ost:
  #geom_sf(data=germany_states, fill = NA, color="black", size=0.2)+
  geom_sf(
    data = east_germany_unified,
    fill = NA,
    color = "black",
    linewidth = 0.6
  ) +
  geom_sf(
    data = west_germany_unified,
    fill = NA,
    color = "black",
    linewidth = 0.6
  ) +
  theme_void() +
  theme(legend.title = element_text(size=18),
        legend.text = element_text(size=16))+
  labs(fill = "Foundation of \nUniversities")
#  labs(fill = "University openings") #+
#  ggtitle("CS Programs at HEI per labor market region")

plot_evolution_uni

ggsave("fig\\plot_evolution_UNI_forScientificDATA.png", 
       plot = plot_evolution_uni, device = "png", width = 9, height = 9)


