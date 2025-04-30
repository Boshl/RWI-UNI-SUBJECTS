#___________________________________________________________________________####
# Project                                                                   ####
#
# Project-Title: RWI-UNI-SUBJECTS (Dataset)
#
# Filename of Code: 06_write_dataset.R
#
# Filename(s) of Input-File(s): - panel.csv
#
# Filename(s) of Output-File(s): - HEI_and_subjects_1971-1996_v2.dta
#
# Short description: This code reads a panel dataset and prepares it for export
#                    as Stata dta-file
#
# Last Change: 10.02.2025
#
# Editor: Serife Yasar
# E-Mail: Serife.Yasar@rwi-essen.de
#
# Software Version: R 4.4.2

#___________________________________________________________________________####
# Preparation                                                               ####

library(readr)
library(dplyr)
library(haven)

final <- read_csv("data_final\\panel.csv")

final <- select(final, Typ, Jahr, HE, Stadt_full_duplicated, Studienfach_orig, 
                sf_3_code, sf_2_code, sf_1_code, sf_3, sf_2, sf_1, HS_number, 
                name_for_number, Last_name, HE_Change, AGS, value)

# Reordering variables
final <- final[,c(2,1,3,12,13,5, 6,7,8,9,10,11,16,4,14,15, 17)]

# Rest of codes has to remain character as it has leading zeros
final$sf_1_code <- as.numeric(final$sf_1_code)

# Rename variables
names(final)[1] <- "Year"
names(final)[2] <- "Type"
names(final)[3] <- "HE_name_orig"
names(final)[4] <- "HE_number"
names(final)[5] <- "HE_name_destat"
names(final)[6] <- "Subject_orig"
names(final)[7] <- "Subject_code"
names(final)[8] <- "Subject_area_code"
names(final)[9] <- "Subject_group_code"
names(final)[10] <- "Subject"
names(final)[11] <- "Subject_area"
names(final)[12] <- "Subject_group"
names(final)[13] <- "AGS"
names(final)[14] <- "City"
names(final)[15] <- "HE_name_destat_last"
names(final)[16] <- "HE_change"
names(final)[17] <- "Study_Type"

# Rename types:
final$Type <- ifelse(final$Type == "FH", "UAS", final$Type)
final$Type <- ifelse(final$Type == "Uni", "university", final$Type)

#___________________________________________________________________________####
# Export                                                                    ####

write_dta(final, "data_final\\HEI_and_subjects_1971-1996_v2.dta")
