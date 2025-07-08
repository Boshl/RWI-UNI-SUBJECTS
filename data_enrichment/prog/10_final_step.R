#___________________________________________________________________________####
# Project                                                                   ####
#
# Project-Title: RWI-UNI-SUBJECTS (Dataset)
#
# Filename of Code: 10_final_steps.R
#
# Filename(s) of Input-File(s): - RWI-UNI-SUBJECTS.csv
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
library(haven)     # For .dta Data
library(dplyr)     # Datamanipulation
library(labelled)  # Variablenlabels
library(xtable)    # LaTeX-Tabellen
library(stringr)   # String-Verarbeitung
library(tibble)
library(tidyr)
library(readr)
setwd("N:/StudiBUCH/RWI-UNI-SUBJECTS-main/RWI-UNI-SUBJECTS-main/data_enrichment")

#STEP 1: Read data / view the dataset used########################
arbeitsdaten <- read_csv("data_final/RWI-UNI-SUBJECTS_prefinal.csv")
View(arbeitsdaten)

#Variable Labels########################################################
var_label(arbeitsdaten) <- list(
  Year = "Jahr des Studienführers/ Study Guide Publication Year",
  Type = "Institutionstyp/ Institutional type",
  HE_name_orig = "Originaler Institutionsname/ Original institution",
  Subject_orig = "Originale Studienfachbezeichnung/ Original study program name",
  Study_Type = "Studientyp/ Type of study mode",
  HE_number = "Institutionskennziffer/ Institution code",
  HE_name_destat = "Standardisierter Institutionsname/ Institution name",
  HE_name_destat_last = "Letzter bekannter Name bei Namensänderungen/ Last previous institution´s name",
  HE_change = "Institutionsänderungen/ Changes in the institution ",
  Subject = "Standardisierte Studienfachbezeichnung/ Study program",
  Subject_area = "Fachbereich/ Subject area",
  Subject_group = "Fachgruppe/ Subject group",
  Subject_code = "Fachkennziffer/ Subject code",
  Subject_area_code = "Fachbereichscode/ Subject area code",
  Subject_group_code = "Fachgruppencode/ Subject group code",
  AGS = "Amtlicher Gemeindeschlüssel/ Municipality code",
  Location_name = "Standort der Institution/ Location of the institution",
  Detailed_field = "Standardisierte Studienfachbezeichnung ISCED-F 2013/ Study program ISCED-F 2013",
  Detailed_field_code =  "Fachkennziffer ISCED-F 2013/ Subject code ISCED-F 2013",
  Narrow_field = "Fachgruppe ISCED-F 2013/ Subject group ISCED-F 2013",
  Narrow_field_code = "Fachgruppencode ISCED-F 2013/ Subject group code ISCED-F 2013",
  Broad_field = "Fachbereich ISCED-F 2013/ Subject area ISCED-F 2013",
  Broad_field_code = "Fachbereichscode ISCED-F 2013/ Subject area code ISCED-F 2013"
)

arbeitsdaten <- arbeitsdaten %>%
  rename(
    year = Year,
    type = Type,
    hei_name = HE_name_orig,
    subject = Subject_orig,
    study_type = Study_Type,
    Destatis_hei_number = HE_number,
    Destatis_hei_name = HE_name_destat,
    Destatis_hei_name_last = HE_name_destat_last,
    hei_change = HE_change,
    Destatis_subject = Subject,
    Destatis_subject_area = Subject_area,
    Destatis_subject_group = Subject_group,
    Destatis_subject_code = Subject_code,
    Destatis_subject_area_code = Subject_area_code,
    Destatis_subject_group_code = Subject_group_code,
    BKG_municipality_code = AGS,
    BKG_location_name = Location_name,
    ISCED_detailed_field = Detailed_field,
    ISCED_narrow_field = Narrow_field,
    ISCED_broad_field = Broad_field,
    ISCED_detailed_field_code = Detailed_field_code,
    ISCED_narrow_field_code = Narrow_field_code,
    ISCED_broad_field_code = Broad_field_code,
    #subject_EN = subject_EN,
    #Destatis_subject_EN = Destatis_subject_EN,
    #Destatis_subject_area_EN = Destatis_subject_area_EN,
    #Destatis_subject_group_EN = Destatis_subject_group_EN
  )



#Output LaTeX Table##############################################
# Subject_group
tab3 <- arbeitsdaten %>%
  filter(Subject_group_code %in% c(NA, "", "NA", "na", "null", "NULL")) %>%
  count(Subject_orig, sort = TRUE)
print(xtable(tab3, caption = "Missing Subject\\_group\\_code by Subject\\_orig"), include.rownames = FALSE)

# Subject_area_code
tab1 <- arbeitsdaten %>%
  filter(Subject_area_code %in% c(NA, "", "NA", "na", "null", "NULL")) %>%
  count(Subject_orig, sort = TRUE)

print(xtable(tab1, caption = "Missing Subject\\_area\\_code by Subject\\_orig"), include.rownames = FALSE)

# Subject_code
tab2 <- arbeitsdaten %>%
  filter(Subject_code %in% c(NA, "", "NA", "na", "null", "NULL")) %>%
  count(Subject_orig, sort = TRUE)

print(xtable(tab2, caption = "Missing Subject\\_code by Subject\\_orig"), include.rownames = FALSE)

#___________________________________________________________________________####
# Export                                                                    ####

write_csv(arbeitsdaten, "data_final\\RWI-UNI-SUBJECTS.csv")
write_dta(arbeitsdaten, "data_final\\RWI-UNI-SUBJECTS.dta")

