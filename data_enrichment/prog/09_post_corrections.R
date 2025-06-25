#___________________________________________________________________________####
# Project                                                                   ####
#
# Project-Title: RWI-UNI-SUBJECTS (Dataset)
#
# Filename of Code: 10_corrections.R
#
# Filename(s) of Input-File(s): - HEI_and_subjects_1971-1996_v2_saved.dta
#
# Filename(s) of Output-File(s): - RWI-UNI-SUBJECTS.dta
#
# Short description: This code corrects mistakes and deals with errors noticed
                    #by reviewers; it then writes the final data set
#
#
# Software Version: R 4.4.2

#___________________________________________________________________________####
# Preparation                                                              
library(readr)
library(dplyr)
library(haven)

final_scientific_data <- read_dta("data_final\\HEI_and_subjects_1971-1996_v2_saved.dta")


# Correct mistakes in HE_name_orig 
#University Hannover in 1971 is Hannover TU
replacement <- unique(final_scientific_data[final_scientific_data$Location_name == "Hannover" & final_scientific_data$Year == 1972 & final_scientific_data$HE_name_orig == "Hannover TU", 
                                            c("HE_name_orig", "HE_number", "HE_name_destat", "HE_change")])

final_scientific_data[final_scientific_data$Location_name == "Hannover" & final_scientific_data$Year == 1971 & final_scientific_data$HE_name_orig =="", 
                      c("HE_name_orig", "HE_number", "HE_name_destat", "HE_change")] <- replacement


#UAS in "Brandenburg an der Havel" was also mistakenly empty
final_scientific_data <- final_scientific_data %>%
  mutate(
    HE_name_orig = ifelse(Location_name == "Brandenburg an der Havel", "Brandenburg FH", HE_name_orig),
    HE_name_destat = ifelse(Location_name == "Brandenburg an der Havel", "Technische Hochschule Brandenburg (FH)", HE_name_destat),
    HE_number = ifelse(Location_name == "Brandenburg an der Havel", 7910, HE_number),
    HE_change = ifelse(Location_name == "Brandenburg an der Havel", "No observed change", HE_change)
  )



# clean Subject_orig from unnecessary numbers, spaces and further formatting issues

#we can delete all numbers in Subject_orig as they are the result of formatting issues
final_scientific_data$Subject_orig <- gsub("\\d+", "", final_scientific_data$Subject_orig)

#correct further issues
final_scientific_data <- final_scientific_data %>%
  mutate(Subject_orig = recode(Subject_orig,
                               " nformatik" = "Informatik",
                               "Bet r iebsw irtschaf t/Wi rtschaft" = "Betriebswirtschaft/Wirtschaft",
                               "Ch em ie (Realschule)" = "Chemie (Realschule)",
                               "Ku nststofftech nik, Ku nststoffchem ie" = "Kunststofftechnik, Kunststoffchemie",
                               "Kunst/Kunsterziehung (Gymnasium)^" = "Kunst/Kunsterziehung (Gymnasium)",
                               "Soziaipädagogik" = "Sozialpädagogik",
                               "Sozialpadagogik" = "Sozialpädagogik",
                               "Vermessunqswesen" = "Vermessungswesen",
                               "Landespfiege" = "Landespflege"
                               
  ))
# "Leibeerziehung" appears in several cases
final_scientific_data$Subject_orig <- sub("^Leibeerziehung", "Leibeserziehung", final_scientific_data$Subject_orig)

#HE_change correct for 4 occurrences where no number could be assigned
final_scientific_data$HE_change <- ifelse(final_scientific_data$HE_number == "" & final_scientific_data$HE_change != "", "", final_scientific_data$HE_change)

#replace "_gesamt" with "_total" in HE_name_orig to have the English version
final_scientific_data$HE_name_orig <- sub("_gesamt$", "_total", final_scientific_data$HE_name_orig)

#___________________________________________________________________________####
# Export                                                                    ####

write_csv(final_scientific_data, "data_final\\RWI-UNI-SUBJECTS.csv")




