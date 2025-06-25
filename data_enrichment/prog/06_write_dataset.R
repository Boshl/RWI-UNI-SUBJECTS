#___________________________________________________________________________####
# Project                                                                   ####
#
# Project-Title: RWI-UNI-SUBJECTS (Dataset)
#
# Filename of Code: 06_write_dataset.R
#
# Filename(s) of Input-File(s): - panel_corr.csv
#
# Filename(s) of Output-File(s): - HEI_and_subjects_1971-1996_v2.dta
#
# Short description: This code reads a panel dataset and prepares it for export
#                    as Stata dta-file
#
#
# Software Version: R 4.4.2

#___________________________________________________________________________####
# Preparation                                                               ####

library(readr)
library(dplyr)
library(haven)

final <- read_csv("data_final\\panel_corr.csv")



#reorder variables
final <- final %>%
  select(Year, Type, HE_name_orig, Subject_orig, Study_Type, HE_number, HE_name_destat, HE_name_destat_last, HE_change, Subject, Subject_area, Subject_group, Subject_code, Subject_area_code, Subject_group_code, AGS, Location_name)

#Study_Type - so far only numbers
final$Study_Type <- recode(final$Study_Type,
                           `1` = "Full study",
                           `11` = "Full study Winter term (WS) required",
                           `12` = "Full study Winter term (WS) recommended",
                           `13` = "Full study Summer term (SS) required",
                           `2` = "Full study admission-restricted",
                           `21` = "Full study admission-restricted Winter term (WS) required",
                           `22` = "Full study admission-restricted Winter term (WS) recommended",
                           `3` = "Specialization",
                           `31` = "Specialization Winter term (WS) required",
                           `32` = "Specialization Winter term (WS) recommended",
                           `4` = "Specialization admission-restricted",
                           `5` = "Advanced study",
                           `51` = "Advanced study Winter term (WS) required",
                           `52` = "Advanced study Winter term (WS) recommended",
                           `6` = "Advanced study admission-restricted",
                           `7` = "Partial study",
                           `71` = "Partial study Winter term (WS) required",
                           `72` = "Partial study Winter term (WS) recommended",
                           `7a` = "Partial study starting from",
                           `7b` = "Partial study until",
                           `8` = "Minor subject",
                           `81` = "Minor subject Winter term (WS) required",
                           `82` = "Minor subject Winter term (WS) recommended",
                           `X` = "No new students",
                           `Xa` = "No new students soon"
)

#recode numeric HE_change to have text:
final$HE_change <- recode(final$HE_change,
                          `0` = "No observed change",
                          `1` = "Change of institution name",
                          `2` = "Merger or integration (location retains HE number)",
                          `3` = "Merger or integration (location loses HE number)",
                          `4` = "Separate campus without its own HE number",
                          `5` = "Former comprehensive university"
)

#Without Type "Other"
#type other is not considered for this publication due to its limited availability and inconsistency
final <- filter(final, Type != "Other")
#___________________________________________________________________________####
# Export                                                                    ####



write_dta(final, "data_final\\HEI_and_subjects_1971-1996_v2_saved.dta")