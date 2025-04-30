#___________________________________________________________________________####
# Project                                                                   ####
#
# Project-Title: RWI-UNI-SUBJECTS (Dataset)
#
# Filename of Code: 01_loop_uni.R
#
# Filename(s) of Input-File(s): - HEI_and_subjects_1971-1996_v2_saved.dta
#
# Filename(s) of Output-File(s): - multiple figures, maps and tables
#
# Short description: Reads in final panel dataset and generates descriptives
#
# Last Change: 10.02.2025
#
# Editor: Serife Yasar
# E-Mail: Serife.Yasar@rwi-essen.de
#
# Software Version: R 4.4.2

#___________________________________________________________________________####
# Preparation                                                               ####

library(mapproj)
library(geodata)
library(ggplot2)
library(dplyr)
library(readr)
library(knitr)
library("stargazer")
library(kableExtra)
library(tidyverse)
library(readxl)
library(haven)

# Read panel data set
panel <- read_dta("data_final\\HEI_and_subjects_1971-1996_v2_saved.dta")

# We do not consider the other colleges within the following, due to their 
# limited availability and significance!
panel <- filter(panel, Type != "Other")

#___________________________________________________________________________####
# Descriptives                                                              ####

## Fig. 1                                                                   ####

# Number of degree programs over time, total Uni + FH
anzahl_beobachtungen <- panel %>%
  # Group the data set by year
  group_by(Year) %>% #
  # Get the number of observations per year
  summarise(Anzahl_Beobachtungen = n()) 

# Plot the number of observations per year as a line graph
ggplot(anzahl_beobachtungen, aes(x = Year, y = Anzahl_Beobachtungen)) +
  geom_line() +
  geom_point() +
  xlab("Year") +
  ylab("Anzahl der Beobachtungen") +
  ggtitle("Anzahl der Beobachtungen pro Jahr") +
  theme_minimal()

ggsave(
  "fig\\sf_over_time.png", 
  plot = last_plot(),
  device = "png",
  width = 10, 
  height = 6
)

## Fig. 2                                                                   ####

# Number of different sf_3 codes per year
number_sf3 <- panel %>% 
  group_by(Year) %>%
  summarize(sf_3_count = n_distinct(Subject_code, na.rm = TRUE))

# Number of degree programmes over time, FH + Uni separately
anzahl_beobachtungen <- panel %>%
  # Group the data set by year and Type
  group_by(Year, Type) %>% 
  # Get the number of observations per year
  summarise(Anzahl_Beobachtungen = n()) 

anzahl_beobachtungen$Type <- ifelse(
  anzahl_beobachtungen$Type == "UAS", 
  "UAS", 
  anzahl_beobachtungen$Type
)
anzahl_beobachtungen <- rename(anzahl_beobachtungen, Type = Type)

ggplot(
  anzahl_beobachtungen, 
  aes(x = Year, y = Anzahl_Beobachtungen, color = Type)
) +
  geom_line() +
  geom_point() +
  xlab("Year") +
  ylab("Number of observations") +
  ggtitle("Number of subjects observed by type") +
  theme_minimal() +
  scale_color_manual(
    values = c("university" = "#B3AD12", "UAS" = "#183152"),
    # Legendenbeschriftung
    labels = c("university" = "Uni", "UAS" = "UAS") 
  ) +
  theme(
    plot.title = element_text(hjust = 0.5, size = 14),
    legend.title = element_text(size = 10),
    legend.text = element_text(size = 10),
    legend.position = "bottom",
    axis.text.x = element_text(size = 10),
    axis.text.y = element_text(size = 10)
  )

ggsave(
  "fig\\sf_over_time_type.png", 
  plot = last_plot(),
  device = "png",
  width = 10, 
  height = 6
)

## Table 1                                                                  ####

anzahl_beobachtungen <- panel %>%
  # Group the data set by year and type
  group_by(Year, Type) %>% 
  # Get the number of observations per year
  summarise(Anzahl_Beobachtungen = n()) %>% 
  # Spread the Typ column into separate columns
  spread(key = Type, value = Anzahl_Beobachtungen) %>% 
  # Add a column for the total
  mutate(Gesamt = UAS + university) %>%
  # Select relevant columns
  select(Year, UAS, university, Gesamt) 

kable(
  anzahl_beobachtungen, 
  format = "latex", 
  booktabs = TRUE, 
  caption = "Anzahl der Studiengänge pro Jahr und Typ"
) %>%
  kable_styling() %>%
  save_kable("tab\\n_observations_fh_uni.tex")

## Fig. 3                                                                   #### 

# Number of study programmes over time according to sf group 1, total Uni + FH
anzahl_beobachtungen <- panel %>%
  # Group the data set by year and Subject_group_factor
  group_by(Year, Subject_group) %>% 
  # Get the number of observations per year and Subject_group_factor
  summarise(Anzahl_Beobachtungen = n(), na.rm = TRUE) 

# Remove NA values from the data set
anzahl_beobachtungen <- na.omit(anzahl_beobachtungen)

# Plot the number of observations per year for each level of 
# "Subject_group_factor" in a single line graph
ggplot(
  anzahl_beobachtungen, 
  aes(
    x = Year, 
    y = Anzahl_Beobachtungen, 
    color = Subject_group, 
    linetype = Subject_group
  )
) +
  geom_line() +
  geom_point() +
  xlab("Year") +
  ylab("Anzahl der Beobachtungen") +
  ggtitle("Anzahl der Beobachtungen pro Jahr (nach Subject_group)") +
  theme_minimal()+
  theme(legend.position = "bottom", legend.text = element_text(size = 8))

ggsave(
  "fig\\subject_group.png", 
  plot = last_plot(),
  device = "png", 
  width = 10, 
  height = 6
)

warnings()

## Fig. 4 + 5                                                               #### 

# Number of study programmes over time according to sf group 1, separated by
# UNI + FH

# Number of study programmes over time according to sf group 1, FH only
anzahl_beobachtungen_fh <- panel %>%
  filter(Type == "UAS") %>%
  group_by(Year, Subject_group) %>%
  summarise(Anzahl_Beobachtungen = n(), na.rm = TRUE)

# Remove NA values from the data set
anzahl_beobachtungen_fh <- na.omit(anzahl_beobachtungen_fh)

# Plot the number of observations per year for each level of 
# "Subject_group_factor" in a single line chart (FH)
ggplot(
  anzahl_beobachtungen_fh, 
  aes(
    x = Year, 
    y = Anzahl_Beobachtungen, 
    color = Subject_group, 
    linetype = Subject_group
  )
) +
  geom_line() +
  geom_point() +
  xlab("Year") +
  ylab("Anzahl der Beobachtungen") +
  ggtitle("Anzahl der Beobachtungen pro Jahr (nach Subject_group) - FH") +
  theme_minimal() +
  theme(legend.position = "bottom", legend.text = element_text(size = 8))

ggsave(
  "fig\\subject_group_type_fh.png", 
  plot = last_plot(), 
  device = "png", 
  width = 10, 
  height = 6
)

# Number of study programmes over time according to SF Group 1, Uni only
anzahl_beobachtungen_uni <- panel %>%
  filter(Type == "university") %>%
  group_by(Year, Subject_group) %>%
  summarise(Anzahl_Beobachtungen = n(), na.rm = TRUE)

# Remove NA values from the data set
anzahl_beobachtungen_uni <- na.omit(anzahl_beobachtungen_uni)

# Plot the number of observations per year for each level of 
# "Subject_group_factor" in a single line chart (Uni)
ggplot(
  anzahl_beobachtungen_uni, 
  aes(
    x = Year, 
    y = Anzahl_Beobachtungen, 
    color = Subject_group, 
    linetype = Subject_group
  )
) +
  geom_line() +
  geom_point() +
  xlab("Year") +
  ylab("Anzahl der Beobachtungen") +
  ggtitle("Anzahl der Beobachtungen pro Jahr (nach Subject_group) - Uni") +
  theme_minimal() +
  theme(legend.position = "bottom", legend.text = element_text(size = 8))

ggsave(
  "fig\\subject_group_type_uni.png", 
  plot = last_plot(), 
  device = "png", 
  width = 10, 
  height = 6
)

## Fig. 6                                                                   #### 

# Number of study programmes over time according to SF Group 2, total Uni + FH
anzahl_beobachtungen <- panel %>%
  # Group the data set by year and Subject_area_factor
  group_by(Year, Subject_area) %>% 
  # Get the number of observations per year and Subject_area_factor
  summarise(Anzahl_Beobachtungen = n(), na.rm = TRUE) 

# Number of different Subject_area groups per year
number_sf2_groups <- panel %>% 
  group_by(Year) %>%
  summarize(Subject_area_count = n_distinct(Subject_area_code, na.rm = TRUE))

# Remove NA values from the data set
anzahl_beobachtungen <- na.omit(anzahl_beobachtungen)

# Plot the number of observations per year for each level of 
# "Subject_area_factor" in a single line graph
ggplot(
  anzahl_beobachtungen,
  aes(
    x = Year, 
    y = Anzahl_Beobachtungen, 
    color = Subject_area, 
    linetype = Subject_area
  )
) +
  geom_line() +
  geom_point() +
  xlab("Year") +
  ylab("Anzahl der Beobachtungen") +
  ggtitle("Anzahl der Beobachtungen pro Jahr (nach Subject_area)") +
  theme_minimal() +
  theme(legend.position = "bottom",legend.text = element_text(size = 8))

ggsave(
  "fig\\subject_area.png", 
  plot = last_plot(), 
  device = "png",
  width = 10, 
  height = 6
)

warnings()

#Number of Studienbereiche over time
unique_Subject_area <- anzahl_beobachtungen %>% 
  group_by(Year) %>% 
  summarize(n_Studienbereich = n_distinct(Subject_area))

anzahl_beobachtungen_sf1 <- panel %>%
  # Group the data set by year and Subject_area_factor
  group_by(Year, Subject_group) %>%
  # Get the number of observations per year and Subject_area_factor
  summarise(Anzahl_Beobachtungen = n(), na.rm = TRUE)

# Remove NA values from the data set
anzahl_beobachtungen_sf1 <- na.omit(anzahl_beobachtungen_sf1)

unique_Subject_group <- anzahl_beobachtungen_sf1 %>% 
  group_by(Year) %>%
  summarize(n_Studienbereich = n_distinct(Subject_group))

## Fig. 7                                                                   #### 

# Number of counties with Uni per year
anzahl_kreise_uni <- panel %>%
  filter(Type == "university") %>%
  group_by(Year) %>%
  summarise(Anzahl_Kreise_Uni = n_distinct(AGS))

# Number of counties with FH per year
anzahl_kreise_fh <- panel %>%
  filter(Type == "UAS") %>%
  group_by(Year) %>%
  summarise(Anzahl_Kreise_FH = n_distinct(AGS))

# Merging the data
anzahl_kreise <- merge(
  anzahl_kreise_uni, 
  anzahl_kreise_fh, 
  by = "Year", 
  all = TRUE
)

# Plot of the number of counties with Uni and FH over time
ggplot(anzahl_kreise, aes(x = Year)) +
  geom_line(aes(y = Anzahl_Kreise_Uni, color = "Uni"), linetype = "solid") +
  geom_point(aes(y = Anzahl_Kreise_Uni, color = "Uni"), shape = 16) +
  geom_line(aes(y = Anzahl_Kreise_FH, color = "FH"), linetype = "dashed") +
  geom_point(aes(y = Anzahl_Kreise_FH, color = "FH"), shape = 16) +
  xlab("Year") +
  ylab("Anzahl der Kreise") +
  ggtitle("Anzahl der Kreise mit Uni und FH über die Zeit") +
  theme_minimal() +
  scale_color_manual(values = c("Uni" = "light blue", "FH" = "dark blue")) +
  guides(color = guide_legend(title = "Typ"))

ggsave(
  "fig\\number_of_counties_with_fh_uni.png", 
  plot = last_plot(),
  device = "png", 
  width = 10, 
  height = 6
)

## Table 2                                                                  ####

anzahl_kreise_table <- merge(
  anzahl_kreise_uni, 
  anzahl_kreise_fh, 
  by = "Year", 
  all = TRUE
)

# Add a column for the total number of counties
anzahl_kreise_table$Gesamt <- anzahl_kreise_table$Anzahl_Kreise_FH + 
  anzahl_kreise_table$Anzahl_Kreise_Uni

# Rename columns for clarity
colnames(anzahl_kreise_table) <- c("Year", "Anzahl FHs", "Anzahl Unis", "Gesamt")

# Save the resulting table
kable(
  anzahl_kreise_table,
  format = "latex", 
  booktabs = TRUE,
  caption = "Anzahl der Kreise mit Uni und FH über die Zeit"
) %>%
  kable_styling() %>%
  save_kable("tab\\table_kreise.tex")

## Fig. 8                                                                   #### 

# Number of HE_numbers by Uni and FH over time
anzahl_HS_uni <- panel %>%
  filter(Type == "university") %>%
  group_by(Year) %>%
  summarise(Anzahl_HS_Uni = n_distinct(HE_number))

anzahl_HS_fh <- panel %>%
  filter(Type == "UAS") %>%
  group_by(Year) %>%
  summarise(Anzahl_HS_FH = n_distinct(HE_number))

anzahl_HS_fh$Anzahl_HS_FH <- ifelse(
  anzahl_HS_fh$Anzahl_HS_FH == 1, 
  0,
  anzahl_HS_fh$Anzahl_HS_FH
)

# Merging the data
anzahl_HE_numbers <- merge(
  merge(anzahl_HS_uni, anzahl_HS_fh, by = "Year", all = TRUE), 
  anzahl_kreise_fh, 
  by = "Year", 
  all = TRUE
)

anzahl_HE_numbers$Anzahl_HS_FH <- ifelse(
  anzahl_HE_numbers$Anzahl_HS_FH == 0, 
  NA, 
  anzahl_HE_numbers$Anzahl_HS_FH
)

# Plot of the number of Hochschuleinrichtungen with Uni and FH over time
anzahl_HE_numbers <- rename(anzahl_HE_numbers, Year = Year)

ggplot(anzahl_HE_numbers, aes(x = Year)) +
  geom_line(aes(y = Anzahl_HS_Uni, color = "Uni"), linetype = "solid") +
  geom_point(aes(y = Anzahl_HS_Uni, color = "Uni"), shape = 16) +
  geom_line(aes(y = Anzahl_HS_FH, color = "UAS"), linetype = "dashed") +
  geom_point(aes(y = Anzahl_HS_FH, color = "UAS"), shape = 16) +
  geom_line(
    aes(y = Anzahl_Kreise_FH, color = "Municipalities with UAS"),
    linetype = "dashed"
  ) +
  geom_point(
    aes(y = Anzahl_Kreise_FH, color = "Municipalities with UAS"), 
    shape = 16
  ) +
  xlab("Year") +
  ylab("Number of higher education institutions") +
  ggtitle("Number of higher education institutions by type") +
  theme_minimal() +
  scale_color_manual(
    values = c(
      "Uni" = "#B3AD12", 
      "UAS" = "#183152", 
      "Municipalities with UAS" = "#009DD0"
    )
  ) +
  guides(color = guide_legend(title = "Type")) +
  theme(
    plot.title = element_text(hjust = 0.5, size=14), 
    legend.title = element_text(size=10), 
    legend.text = element_text(size=10),
    legend.position = "bottom", 
    axis.text.x = element_text(size = 10), 
    axis.text.y = element_text(size = 10)
  )

ggsave(
  "fig\\number_of_HS_numbers_with_FH_Uni.png",
  plot = last_plot(), 
  device = "png", 
  width = 10, 
  height = 6
)

## Table 3                                                                  ####

anzahl_HS_table <- merge(
  merge(anzahl_HS_uni, anzahl_HS_fh, by = "Year", all = TRUE), 
  anzahl_kreise_fh, 
  by = "Year",
  all = TRUE
)

anzahl_HS_table$Anzahl_HS_FH <- ifelse(
  anzahl_HS_fh$Anzahl_HS_FH == 0, 
  "-",
  anzahl_HS_fh$Anzahl_HS_FH
)

# Rename columns for clarity
colnames(anzahl_HS_table) <- c(
  "Year", "Anzahl Unis", "Anzahl FHs", "Anzahl Kreise mit FHs"
)

# Save the resulting table
kable(
  anzahl_HS_table,
  format = "latex",
  booktabs = TRUE, 
  caption = "Anzahl der Hochschuleinrichtungen nach Uni und FH über die Zeit"
) %>%
  kable_styling() %>%
  save_kable("tab\\table_HE_numbers.tex")

## Table 4                                                                  ####

# Png + latex table with list of all sf1 codes and title
panel <- as.data.frame(panel)

unique_values <- panel %>% distinct(Subject_group_code, Subject_group)

latex_table <- kable(
  unique_values, 
  caption = "List of sf1 codes and corresponding codes",
  format = "latex",
  booktabs = TRUE
) %>%
  kable_styling(latex_options = c("striped"), position = "center")           

# Saving
writeLines(latex_table, "tab\\sf1_table.tex")

## Overview Table                                                           #### 

# Number of counties with Uni per year
anzahl_kreise_uni <- panel %>%
  filter(Type == "university") %>%
  group_by(Year) %>%
  summarise(Anzahl_Kreise_Uni = n_distinct(AGS))

# Number of counties with FH per year
anzahl_kreise_fh <- panel %>%
  filter(Type == "UAS") %>%
  group_by(Year) %>%
  summarise(Anzahl_Kreise_FH = n_distinct(AGS))

# Number of observations for Uni per year
anzahl_beobachtungen_uni <- panel %>%
  filter(Type == "university") %>%
  group_by(Year) %>%
  summarise(Anzahl_Beobachtungen_Uni = n())

# Number of observations for FH per year
anzahl_beobachtungen_fh <- panel %>%
  filter(Type == "UAS") %>%
  group_by(Year) %>%
  summarise(Anzahl_Beobachtungen_FH = n())

# Merging the data one by one
combined_data <- merge(
  anzahl_kreise_uni,
  anzahl_kreise_fh, 
  by = "Year",
  all = TRUE
)

combined_data <- merge(
  combined_data, 
  anzahl_beobachtungen_uni, 
  by = "Year",
  all = TRUE
)

combined_data <- merge(
  combined_data,
  anzahl_beobachtungen_fh, 
  by = "Year",
  all = TRUE
)

# Filter by the desired years
filtered_data <- combined_data %>% filter(Year %in% c(1971, 1990))

# Create the table
table_data <- data.frame(
  Was = c(
    "Anzahl Kreise mit Uni", "Anzahl Kreise mit FH", 
    "Anzahl Beobachtungen für Uni", "Anzahl Beobachtungen für FH"
  ),
  `1971` = c(
    filtered_data$Anzahl_Kreise_Uni[filtered_data$Year == 1971],
    filtered_data$Anzahl_Kreise_FH[filtered_data$Year == 1971], 
    filtered_data$Anzahl_Beobachtungen_Uni[filtered_data$Year == 1971],
    filtered_data$Anzahl_Beobachtungen_FH[filtered_data$Year == 1971]
  ),
  `1990` = c(
    filtered_data$Anzahl_Kreise_Uni[filtered_data$Year == 1990], 
    filtered_data$Anzahl_Kreise_FH[filtered_data$Year == 1990], 
    filtered_data$Anzahl_Beobachtungen_Uni[filtered_data$Year == 1990], 
    filtered_data$Anzahl_Beobachtungen_FH[filtered_data$Year == 1990]
  ),
  check.names = FALSE
)

# LaTeX-Tabelle mit kable
latex_table <- kable(
  table_data, 
  format = "latex", 
  col.names = c("Was", "1971", "1990")
)

# Saving
writeLines(latex_table, "tab\\taboverview_table_sf3.tex")

# Maps                                                                      #### 

# Map for 1971, other form for Uni and FH

library("foreign")
library("tidyr")
library(terra)
library(spData)
library("tmap") 
library(units)
pacman::p_load(readstata13, sf, sp, geosphere, FNN, raster, rgdal)
library(geodata)
library(raster)
library(maps)

# Get german map from maps package
germany_2 <- map_data("world", region = "Germany")
# Retrieve the coordinate reference system
st_crs(germany_2)

# Ammend city names such that they can be merged with geo-coordinates; 
# see several lines below
corrected_city_names <- read_excel(
  "fig\\Kopie_Stadtnamen_missings_for_Standorte-Maps.xlsx"
)

panel <- panel %>% rename(Stadt_full_duplicated = City) %>% rename(Typ = Type)

panel$Stadt_full_duplicated <- ifelse(
  panel$Stadt_full_duplicated %in% corrected_city_names$Stadt, 
  corrected_city_names$Stadt_2[match(panel$Stadt_full_duplicated, 
                                     corrected_city_names$Stadt)], 
  panel$Stadt_full_duplicated
)

Jahr_71 <- filter(panel, Year == "1971")
Hochschulstandorte_71 <- as.data.frame(
  unique(Jahr_71[, c("Stadt_full_duplicated", "Typ")])
)

Jahr_96 <- filter(panel, Year == "1996") 
Hochschulstandorte_96 <- as.data.frame(
  unique(Jahr_96[, c("Stadt_full_duplicated", "Typ")])
)

# Merge city with PLZ
# https://public.opendatasoft.com/explore/dataset/georef-germany-postleitzahl/information/
geo_ref <- read.delim("data_input\\georef-germany-postleitzahl.csv", sep = ";")
names(geo_ref)[2] <- "Stadt_full_duplicated"
names(geo_ref)[10] <- "Koordinaten"
my_geo <- dplyr::select(geo_ref, Stadt_full_duplicated, Koordinaten)
split_coordinates <- as.data.frame(strsplit(my_geo$Koordinaten, ","))

Koordinaten <- t(split_coordinates)
my_geo <- bind_cols(my_geo, Koordinaten)
names(my_geo)[3] <- "lat"
names(my_geo)[4] <- "long"

# Convert the split values to numeric
my_geo <- dplyr::select(my_geo, -Koordinaten)
my_geo$lat <- as.numeric(my_geo$lat)
my_geo$long <- as.numeric(my_geo$long)

# As some cities are included several times - take mean of lat and long
my_geo2 <- my_geo %>% 
  group_by(Stadt_full_duplicated) %>% 
  summarise(lat = mean(lat), long = mean(long))

Hochschulen_71 <- left_join(
  Hochschulstandorte_71, 
  my_geo2, 
  by = "Stadt_full_duplicated"
)

Hochschulen_96 <- left_join(
  Hochschulstandorte_96,
  my_geo2,
  by = "Stadt_full_duplicated"
)

# As the graph should then be in english rename Typ to Type and FH to UAS
Hochschulen_96 <- rename(Hochschulen_96, Type = Typ)
Hochschulen_96$Type <- ifelse(
  Hochschulen_96$Type == "university",
  "university", 
  Hochschulen_96$Type
)

# Plot for 1971
# Alternativ für Grenzen der Bundesländer
states <- map_data("world", region = "Germany", exact = FALSE, resolution = 0) 


## Map 1                                                                    ####

germany_states <- geodata::gadm(country = "DEU", level = 1, path = tempdir())
 
germany_states <- st_as_sf(germany_states)

ggplot() +
  # Borders of "Bundesländer"
  geom_sf(
    data = germany_states, 
    fill = "grey95",
    color = "black", 
    linetype = "solid", 
    size = 0.5
  ) +
  # "Hochschul"-locations
  geom_point(
    data = Hochschulen_96,
    aes(x = long, y = lat, shape = Type, color = Type),
    alpha = 0.5,
    size = 3
  ) +
  # Adjust appearance
  scale_shape_manual(values = c(16, 17), labels = c("UAS", "Uni")) +
  scale_color_manual(values = c('dodgerblue', 'red'), labels = c("UAS", "Uni")) +
  coord_sf() +
  theme_void() +
  xlab("Longitude") +
  ylab("Latitude") +
  labs(shape = 'Type', color = 'Type') +
  ggtitle('Locations in 1996') +
  theme(
    plot.title = element_text(hjust = 0.6, size = 16),
    legend.title = element_text(size = 12),
    legend.text = element_text(size = 12)
  )

ggsave(
  "fig\\locations_1996.png",
  plot = last_plot(),
  device = "png",
  width = 9, 
  height = 9
)

## Map 2                                                                    ####

# Do the same for 1971
Hochschulen_71 <- rename(Hochschulen_71, Type = Typ)

Hochschulen_71$Type <- ifelse(
  Hochschulen_71$Type == "UAS", 
  "UAS", 
  Hochschulen_71$Type
)

ggplot() +
  # Borders of "Bundesländer"
  geom_sf(
    data = germany_states, 
    fill = "grey95",
    color = "black", 
    linetype = "solid", 
    size = 0.5
  ) +
  # "Hochschul"-locations
  geom_point(data = Hochschulen_71,
             aes(x = long, y = lat, shape = Type, color = Type),
             alpha = 0.5,
             size = 3) +
  # Change appearance
  scale_shape_manual(values = c(16, 17), labels = c("UAS", "Uni")) +
  scale_color_manual(values = c('dodgerblue', 'red'), labels = c("UAS", "Uni")) +
  coord_sf() +
  theme_void() +
  xlab("Longitude") +
  ylab("Latitude") +
  labs(shape = 'Type', color = 'Type') +
  ggtitle('Locations in 1971') +
  theme(
    plot.title = element_text(hjust = 0.6, size = 16),
    legend.title = element_text(size = 12),
    legend.text = element_text(size = 12)
  )

ggsave(
  "fig\\locations_1971.png", 
  plot = last_plot(), 
  device = "png",
  width = 9, 
  height = 9
)

# Comparison of our dataset with data from "Hochschulkompass"                 #### 

hs_kompass <- read_excel("data_input\\hochschul_liste_HS-Kompass.xlsx")
hs_kompass$Gründungsjahr <- as.numeric(hs_kompass$Gründungsjahr)
hs_kompass <- filter(hs_kompass, Gründungsjahr >= 1971 & Gründungsjahr < 1997)

# Plot openings over time but distinguish between data from "Hochschulkompass" 
# and Data from "StudiBuch":

# First data from "Hochschulkompass":
neu_Kompass <- hs_kompass %>%
  # Group the data set by year
  group_by(Gründungsjahr) %>% 
  summarise(Anzahl_Beobachtungen = n())

# Second from StudiBuch: use only Unis as FHs don't have a number up until 1986
panel <- panel %>% rename(Type = Typ)
unis <- filter(panel, Type == "university")

HS_opening <- unis %>% 
  filter(!is.na(HE_number)) %>%
  group_by(HE_number) %>%
  summarize(Year = min(Year, na.rm = TRUE)) %>%
  ungroup()

neu_Studi <- HS_opening %>%
  # Group the data set by year
  group_by(Year) %>%
  summarise(Anzahl_Beobachtungen = n())

neu_Kompass <- rename(neu_Kompass, Year = Gründungsjahr)
Neu_Tabelle <- left_join(neu_Kompass, neu_Studi, by = "Year")
names(Neu_Tabelle)[2] <- "Neugr_Kompass"
names(Neu_Tabelle)[3] <- "Neugr_Studi"

ggplot(Neu_Tabelle, aes(x = Year)) +
  geom_bar(
    aes(
      y = Neugr_Kompass, 
      fill = "HRK"
    ), 
    position = "dodge", 
    stat = "identity",
    alpha = 0.5
  ) +
  geom_bar(
    aes(
      y = Neugr_Studi, 
      fill = "This Dataset"
    ), 
    position = "dodge",
    stat = "identity", 
    alpha = 0.5) +
  xlab("Year") +
  ylab("Number of first appearances") +
  ggtitle("Number of first appearances by year and datasource") +
  theme_minimal() +
  theme(legend.position = "bottom") +
  scale_fill_manual(values = c("HRK" = "#183152", "This Dataset" = "#009DD0")) + 
  guides(fill = guide_legend(title = "Source: ")) +
  theme(
    plot.title = element_text(hjust = 0.5, size=14), 
    legend.title = element_text(size=10), 
    legend.text = element_text(size=10), 
    legend.position = "bottom", 
    axis.text.x = element_text(size = 10), 
    axis.text.y = element_text(size = 10)
  )

ggsave(
  "fig\\compare_n_new_HSKompass.png",
  plot = last_plot(), 
  device = "png", 
  width = 10, 
  height = 6
)
