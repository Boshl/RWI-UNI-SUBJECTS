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
arbeitsdaten <- read_csv("data_final/RWI-UNI-SUBJECTS-Translated.csv")

# Correction of English Translation
arbeitsdaten$Subject_orig_EN <- dplyr::recode(arbeitsdaten$Subject_orig_EN,
                                          "Civil Engineering/Bautechnik LA BS" = "Civil Engineering/Construction Engineering LA BS",
                                          "Civil Engineering/Bautechnik LA SekundarS II" = "Civil Engineering/Construction Engineering LA SekundarS II",
                                          "Civil Engineering/Ingenieurbau/Bauwesen/Bauwesen" = "Civil Engineering/Structural Engineering/Civil Engineering/Civil Engineering",
                                          "Clothing/Textile Technology/Textilerceuuna/Textileveredluna" = "Clothing/Textile Technology/Textile Refinement/Textile Finishing",
                                          "Design/Desiqn" = "Design/Design",
                                          "Household Swissenschaftf Realschule/Sek. I)" = "Household Science Realschule/Sek. I",
                                          "Metallurgy Technology (Gießereitechnik)" = "Metallurgy Technology (Foundry Technology)",
                                          "Metallurgy Technology/Giessentechnik" = "Metallurgy Technology/Foundry Technology",
                                          "Teacher Training in Primary and Hauptschulen" = "Teacher Training in Primary and Lower Secondary Schools",
                                          "Versorqunqtechnik" = "Supply Engineering",
                                          "Work Studies/Arbeitswissenschaft/Polytechnik LA HS" = "Work Studies/Ergonomics/Engineering Education LA HS",
                                          "Work Studies/Arbeitswissenschaft/Polytechnik LA HS/RS" = "Work Studies/Ergonomics/Engineering Education LA HS/RS",
                                          "Work Studies/Arbeitswissenschaft/Polytechnik LA PrimaryS" = "Work Studies/Ergonomics/Engineering Education LA PrimaryS",
                                          "Work Studies/Arbeitswissenschaft/Polytechnik LA SekundarS I" = "Work Studies/Ergonomics/Engineering Education LA SekundarS I",
                                          "Work Studies/Arbeitswissenschaft/Polytechnik LA SekundarS II" = "Work Studies/Ergonomics/Engineering Education LA SekundarS II",
                                          "Work Studies/Arbeitswissenschaft/Polytechnik LA SoS" = "Work Studies/Ergonomics/Engineering Education LA SoS",
                                          "Electronics/Reqeluna Technology" = "Electronics/Control Technology",
                                          "Theoloqie, ca. (Diploma)" = "Theology, ca. (Diploma)",
                                          "Philosophy (Maqister)" = "Philosophy (Magister)",
                                          "Psychology (Diploma/Maqister)" = "Psychology (Diploma/Magister)",
                                          "Theology, Prov. (Maqister)" = "Theology, Prov. (Magister)",
                                          "Theoloqie, ca. (Magister, Licentiate)" = "Theology, ca. (Magister, Licentiate)",
                                          "Theoloqie, evan. (Circ.)" = "Theology, evan. (Circ.)",
                                          "Theoloqie, ca. (Diploma, Magister, Licentiate)" = "Theology, ca. (Diploma,Magister,Licentiate)",
                                          "Theoloqie, ca. (Diploma/Magister, Licentiate)" = "Theology, ca. (Diploma/Magister, Licentiate)",
                                          "Lanbdbau" = "Farming",
                                          "Metals/Materials Technology" = "Metal Finishing/Materials Technology",
                                          "Theogy, Catholic (Kirchliehe Prüfung)" = "Theology, Cath. (Church Examination)",
                                          "Design/Design/..." = "Design/Communication Design/Spatial Design/Stage Design/Fashion/Textile Design/Sculpture"

)


arbeitsdaten$Subject_orig_EN <- arbeitsdaten$Subject_orig_EN %>%
  str_replace_all("Linguistics \\(general/cf\\.\\)", "Linguistics (general/comp.)") %>%
  str_replace_all("Circ\\.", "Church Examination") %>%
  str_replace_all(" ca\\.", " Catholic") %>%
  str_replace_all(" Prov\\.", "Protestant")

# Corrections of Subject_orig missspelings
arbeitsdaten$Subject_orig <- dplyr::recode(arbeitsdaten$Subject_orig,
                                      "Bekleidunus-/Textiltechnik/Textilerzeuüuna/Textilveredluna" = "Bekleidungs-/Textiltechnik/Textilerzeugung/Textilveredlung",
                                      "Bibiiothekswissenschaft (Magister)" = "Bibliothekswissenschaft (Magister)",
                                      "Chemieinqenieurwesen" = "Chemieingenieurswesen",
                                      "Elektratechnik" = "Elektrotechnik",
                                      "Fahrzeuqtechnik" = "Fahrzeugtechnik",
                                      "Fotograf ie/Fotoingenieurwesen" = "Fotografie/Fotoingenieurwesen",
                                      "Griechisch, Klassisch (Gymnasium)" = "Griechisch, Klassisch (Gymnasium)",
                                      "Haushalts- u. Ernährungswiss. LA BS" = "Haushalts- und Ernährungswissenschaften LA BS",
                                      "Innenarchitecktur" = "Innenarchitektur",
                                      "Lanbdbau" = "Landbau",
                                      "Landwirt schatt/Agrarwirtschaft" = "Landwirtschaft/Agrarwirtschaft",
                                      "Lateinisch Philologie des Mittelalters" = "Lateinische Philologie des Mittelalters",
                                      "Lebensmittelcheme" = "Lebensmittelchemie",
                                      "Lebensmitteltechnoloqie" = "Lebensmitteltechnologie",
                                      "Metallveradelung/Werkstofftechnik" = "Metallveredelung/Werkstofftechnik",
                                      "Sozial Wissenschaften" = "Sozialwissenschaften",
                                      "Versorqunqstechnik" = "Versorgungstechnik",
                                      "W irtschaftsmathematik" = "Wirtschaftsmathematik",
                                      "Wasserbau/Wasserwirt schäft" = "Wasserbau/Wasserwirtschaft",
                                      "Elektronik/Reqelunastechnik" = "Elektronik/Regelungstechnik",
                                      "Bauinqenieur-/Bau-/Verkehrswesen" = "Bauingenieur-/Bau-/Verkehrswesen",
                                      "Gestaltung/Desiqn" = "Gestaltung/Design",
                                      "Philosophie (Maqister)" = "Philosophie (Magister)",
                                      "Psychologie (Diplom/Maqister)" = "Psychologie (Diplom/Magister)",
                                      "Theologie, evang. (Maqister)" = "Theologie, evang. (Magister)",
                                      "Theoloqie, evang. (Kirchliche Prüfung)" = "Theologie, evang. (Kirchliche Prüfung)",
                                      "Theoloqie, kath. (Diplom)" = "Theologie, kath. (Diplom)",
                                      "Theoloqie, kath. (Diplom, Magister, Lizentiat)" = "Theologie, kath. (Diplom, Magister, Lizentiat)",
                                      "Theoloqie, kath. (Diplom/Magister, Lizentiat)" = "Theologie, kath. (Diplom/Magister, Lizentiat)",
                                      "Theoloqie, kath. (Magister, Lizentiat)" = "Theologie, kath. (Magister, Lizentiat)",
                                      "Übersetzunqswesen" = "Übersetzungswesen",
                                      "TheoIogie, kath. (Kirchliehe Prüfung)" = "Theologie, kath. (Kirchliche Prüfung)",
                                      "Gestaltung/Design/..." = "Gestaltung/Design/Grafik/Kommunikationsgestaltung/ Flächen-/Bühnengestaltung/Mode/Textilgestaltung/Plastik"
                                      
)


#generate one new variable, replacing the "_total" suffix in hei_name
arbeitsdaten$exact_hei_name <- ifelse(grepl("_total$", arbeitsdaten$HE_name_orig), 0, 1)
arbeitsdaten$HE_name_orig <- gsub("_total$", "", arbeitsdaten$HE_name_orig)
arbeitsdaten <- arbeitsdaten %>%
  relocate(exact_hei_name, .after = 8)

#Further reordering of variables


#Variable Labels########################################################
var_label(arbeitsdaten) <- list(
  Year = "Jahr des Studienführers/ Study guide publication year",
  Type = "Institutionstyp/ Institutional type",
  HE_name_orig = "Originaler Institutionsname/ Original institution",
  exact_hei_name = "Binäre Variable für exakten Institutionsnamen/ Binary variable indicating exact institution name",
  Subject_orig = "Originale Studienfachbezeichnung/ Original study program name",
  Study_Type = "Studientyp/ Type of study mode",
  HE_number = "Institutionskennziffer/ Institution code",
  HE_name_destat = "Standardisierter Institutionsname/ Institution name",
  HE_name_destat_last = "Letzter bekannter Name bei Namensänderungen/ Last previous name of institution",
  HE_change = "Institutionsänderungen/ Changes in the institution ",
  Subject = "Standardisierte Studienfachbezeichnung/ Study program",
  Subject_area = "Fachbereich/ Subject area",
  Subject_group = "Fachgruppe/ Subject group",
  Subject_code = "Fachkennziffer/ Subject code",
  Subject_area_code = "Fachbereichscode/ Subject area code",
  Subject_group_code = "Fachgruppencode/ Subject group code",
  Location_name = "Standort der Institution/ Location of the institution",
  AGS = "Amtlicher Gemeindeschlüssel/ Municipality code",
  Detailed_field = "Standardisierte Studienfachbezeichnung ISCED-F 2013/ Study program ISCED-F 2013",
  Detailed_field_code =  "Fachkennziffer ISCED-F 2013/ Subject code ISCED-F 2013",
  Narrow_field = "Fachgruppe ISCED-F 2013/ Subject group ISCED-F 2013",
  Narrow_field_code = "Fachgruppencode ISCED-F 2013/ Subject group code ISCED-F 2013",
  Broad_field = "Fachbereich ISCED-F 2013/ Subject area ISCED-F 2013",
  Broad_field_code = "Fachbereichscode ISCED-F 2013/ Subject area code ISCED-F 2013",
  Subject_orig_EN = "Übersetzung von subject/ Translation of subject",
  Subject_EN = "Übersetzung von Destatis_subject/ Translation of Destatis_subject",
  Subject_area_EN = "Übersetzung von Destatis_subject_area/ Translation of Destatis_subject_area",
  Subject_group_EN = "Übersetzung von Destatis_subject_group/ Translation of Destatis_subject_group",
  Author = "Author des Buchs/ Author of study guide",
  Institution = "Verantwortliche Institution des Buchs/ Organization responsible for study guide",
  Title = "Titel des Buchs/ Full title of study guide",
  Publisher = "Herausgeber des Buch/ Publishing institution of the study guide"
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
    location_name = Location_name,
    BKG_municipality_code = AGS,
    ISCED_detailed_field = Detailed_field,
    ISCED_narrow_field = Narrow_field,
    ISCED_broad_field = Broad_field,
    ISCED_detailed_field_code = Detailed_field_code,
    ISCED_narrow_field_code = Narrow_field_code,
    ISCED_broad_field_code = Broad_field_code,
    subject_EN = Subject_orig_EN,
    Destatis_subject_EN = Subject_EN,
    Destatis_subject_area_EN = Subject_area_EN,
    Destatis_subject_group_EN = Subject_group_EN,
    author = Author,
    commissioning_body = Institution,
    title = Title,
    publisher = Publisher
  )



#Output LaTeX Table##############################################
# Subject_group
tab3 <- arbeitsdaten %>%
  filter(Destatis_subject_group_code %in% c(NA, "", "NA", "na", "null", "NULL")) %>%
  count(subject, sort = TRUE)
print(xtable(tab3, caption = "Missing Subject\\_group\\_code by Subject\\_orig"), include.rownames = FALSE)

# Subject_area_code
tab1 <- arbeitsdaten %>%
  filter(Destatis_subject_area_code %in% c(NA, "", "NA", "na", "null", "NULL")) %>%
  count(subject, sort = TRUE)

print(xtable(tab1, caption = "Missing Subject\\_area\\_code by Subject\\_orig"), include.rownames = FALSE)

# Subject_code
tab2 <- arbeitsdaten %>%
  filter(Destatis_subject_code %in% c(NA, "", "NA", "na", "null", "NULL")) %>%
  count(subject, sort = TRUE)

print(xtable(tab2, caption = "Missing Subject\\_code by Subject\\_orig"), include.rownames = FALSE)

#___________________________________________________________________________####
# Export                                                                    ####
arbeitsdaten <- arbeitsdaten %>%
  arrange(year, hei_name, subject)


write_csv(arbeitsdaten, "data_final\\RWI-UNI-SUBJECTS.csv")
write_dta(arbeitsdaten, "data_final\\RWI-UNI-SUBJECTS.dta")

