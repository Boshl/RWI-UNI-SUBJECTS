#___________________________________________________________________________####
# Project                                                                   ####
#
# Project-Title: RWI-UNI-SUBJECTS (Dataset)
#
# Filename of Code: 09b_isced.R
#
# Filename(s) of Input-File(s): - RWI-UNI-SUBJECTS_pre_isced.csv
#
# Filename(s) of Output-File(s): - RWI-UNI-SUBJECTS_prefinal.csv
#
# Short description: This code corrects isced
#
#
# Software Version: R 4.4.2

#___________________________________________________________________________####
# Preparation                                                              
library(readr)
library(dplyr)
library(haven)
library(openxlsx)
library(writexl)   # oder: library(openxlsx)
library(readxl)

setwd("N:/StudiBUCH/RWI-UNI-SUBJECTS-main/RWI-UNI-SUBJECTS-main/data_enrichment")
#isced_f_2013_table <- read_csv("data_output/isced_f_2013_table.csv")
isced_f_2013_table <- read_excel("data_output/isced_f_2013_table.xlsx")

study_programs_matched_by_llm <- read_csv("data_output/study_programs_matched_by_llm.csv")

final_scientific_data <- read_csv("data_final\\RWI-UNI-SUBJECTS_pre_isced.csv")

study_programs_matched_by_llm$matched_studiengang_en[
  grepl("Hüttenkunde|Hüttentechnik( \\(Gießereitechnik\\))?|Hüttentechnik/Gießereitechnik|Hüttenwesen( D)?", study_programs_matched_by_llm$studiengang_de, ignore.case = TRUE)
] <- "Mechanics and metal trades"
study_programs_matched_by_llm$matched_studiengang_en[
  grepl("^Informatik", study_programs_matched_by_llm$studiengang_de, ignore.case = TRUE)
] <- "Computer use"


study_programs_matched_by_llm$matched_studiengang_en[
  grepl("Kommunikationswissenschaft", study_programs_matched_by_llm$studiengang_de, ignore.case = TRUE)
] <- "Journalism and reporting"
study_programs_matched_by_llm$matched_studiengang_en[
  grepl("Kristallographie", study_programs_matched_by_llm$studiengang_de, ignore.case = TRUE)
] <- "Earth sciences"
study_programs_matched_by_llm$matched_studiengang_en[
  grepl("Landespflege/Landschaftsgestaltung LA BS", study_programs_matched_by_llm$studiengang_de, ignore.case = TRUE)
] <- "Natural environments and wildlife"

study_programs_matched_by_llm$matched_studiengang_en[
  study_programs_matched_by_llm$studiengang_de == "Brauwesen/Brennerei/Zuckerwirtschaft"] <- "Food processing"

study_programs_matched_by_llm$matched_studiengang_en[
  study_programs_matched_by_llm$studiengang_de == "Dolmetscher"] <- "Literature and linguistics"
study_programs_matched_by_llm$matched_studiengang_en[
  study_programs_matched_by_llm$studiengang_de == "Hüttenkunde"] <- "Mechanics and metal trades"
study_programs_matched_by_llm$matched_studiengang_en[
  study_programs_matched_by_llm$studiengang_de == "Hüttenwesen"] <- "Mechanics and metal trades"
study_programs_matched_by_llm$matched_studiengang_en[
  study_programs_matched_by_llm$studiengang_de == "Byzantinistik"] <- "Sociology and cultural studies"
study_programs_matched_by_llm$matched_studiengang_en[
  study_programs_matched_by_llm$studiengang_de == "Indologie"] <- "Sociology and cultural studies"
study_programs_matched_by_llm$matched_studiengang_en[
  study_programs_matched_by_llm$studiengang_de == "Agrarwissenschaft, -Ökonomie"] <- "Earth sciences"
study_programs_matched_by_llm$matched_studiengang_en[
  study_programs_matched_by_llm$studiengang_de == "Ernährungswissenschaft/"] <- "Food processing"
study_programs_matched_by_llm$matched_studiengang_en[
  study_programs_matched_by_llm$studiengang_de == "Haushaltswissenschaften"] <- "Domestic services"
study_programs_matched_by_llm$matched_studiengang_en[
  study_programs_matched_by_llm$studiengang_de == "Haushaltswissenschaf"] <- "Domestic services"
study_programs_matched_by_llm$matched_studiengang_en[
  study_programs_matched_by_llm$studiengang_de == "Limnologie (Landespflege)"] <- "Horticulture"
study_programs_matched_by_llm$matched_studiengang_en[
  study_programs_matched_by_llm$studiengang_de == "Brauwesen"] <- "Food processing"
study_programs_matched_by_llm$matched_studiengang_en[
  study_programs_matched_by_llm$studiengang_de == "Agrarbiologie"] <- "Biology"
study_programs_matched_by_llm$matched_studiengang_en[
  study_programs_matched_by_llm$studiengang_de == "Leibeserziehung, Sport (Gymnasium)"] <- "Sports"
study_programs_matched_by_llm$matched_studiengang_en[
  study_programs_matched_by_llm$studiengang_de == "Leibeserziehung, Sport (Realschule)"] <- "Sports"
study_programs_matched_by_llm$matched_studiengang_en[
  study_programs_matched_by_llm$studiengang_de == "Dänisch (Gymnasium)"] <- "Literature and linguistics"
study_programs_matched_by_llm$matched_studiengang_en[
  study_programs_matched_by_llm$studiengang_de == "Latein (Gymnasium)"] <- "Literature and linguistics"
study_programs_matched_by_llm$matched_studiengang_en[
  study_programs_matched_by_llm$studiengang_de == "Dänisch (Realschule)"] <- "Literature and linguistics"
study_programs_matched_by_llm$matched_studiengang_en[
  study_programs_matched_by_llm$studiengang_de == "Nordistik (Magister)"] <- "Sociology and cultural studies"
study_programs_matched_by_llm$matched_studiengang_en[
  study_programs_matched_by_llm$studiengang_de == "Landespflege"] <- "Horticulture"
study_programs_matched_by_llm$matched_studiengang_en[
  grepl("Leibeserziehung", study_programs_matched_by_llm$studiengang_de)
] <- "Sports"

study_programs_matched_by_llm$matched_studiengang_en[
  grepl("Dänisch", study_programs_matched_by_llm$studiengang_de)
] <- "Literature and linguistics"

languages <- c("Dänisch", "Russisch", "Norwegisch", "Italienisch", "Polnisch", "Portugisisch", "Amerikanistik", "Schwedisch", "Anglistik", "Spanisch", "Deutsch", "Frisisch", "Französisch", "Griechisch", "Latein", "Niederländisch")
study_programs_matched_by_llm$matched_studiengang_en[
  grepl(paste(languages, collapse = "|"), study_programs_matched_by_llm$studiengang_de, ignore.case = TRUE)
] <- "Literature and linguistics"
study_programs_matched_by_llm$matched_studiengang_en[
  grepl("Regionalwissenschaften", study_programs_matched_by_llm$studiengang_de, ignore.case = TRUE)
] <- "Environmental sciences"
study_programs_matched_by_llm$matched_studiengang_en[
  grepl("Restaurierung", study_programs_matched_by_llm$studiengang_de, ignore.case = TRUE)
] <- "History and archaeology"

study_programs_matched_by_llm$matched_studiengang_en[
  grepl("arbeitslehre", study_programs_matched_by_llm$studiengang_de, ignore.case = TRUE)
] <- "Work skills"

study_programs_matched_by_llm$matched_studiengang_en[
  grepl("Arbeitslehre/Arbeitswissenschaft/Polytechnik LA", study_programs_matched_by_llm$studiengang_de, ignore.case = TRUE)
] <- "Work skills"
study_programs_matched_by_llm$matched_studiengang_en[
  grepl("Sonderpädag|Sonderpäd", study_programs_matched_by_llm$studiengang_de, ignore.case = TRUE)
] <- "Education science"
study_programs_matched_by_llm$matched_studiengang_en[
  grepl("Sozial- und Wirtschaftsgeschichte", study_programs_matched_by_llm$studiengang_de, ignore.case = TRUE)
] <- "Economics"

study_programs_matched_by_llm$matched_studiengang_en[
  grepl("Sprachlehrforschung", study_programs_matched_by_llm$studiengang_de, ignore.case = TRUE)
] <- "Language acquisition"
study_programs_matched_by_llm$matched_studiengang_en[
  grepl("Sprechwissenschaft|Phonetik", study_programs_matched_by_llm$studiengang_de, ignore.case = TRUE)
] <- "Language acquisition"
study_programs_matched_by_llm$matched_studiengang_en[
  grepl("Vermessung|Kartenwesen", study_programs_matched_by_llm$studiengang_de, ignore.case = TRUE)
] <- "Building and civil engineering"
study_programs_matched_by_llm$matched_studiengang_en[
  grepl("Volkskunde", study_programs_matched_by_llm$studiengang_de, ignore.case = TRUE)
] <- "Sociology and cultural studies"
study_programs_matched_by_llm$matched_studiengang_en[
  grepl("Wasserbau|Wasserwirtschaft", study_programs_matched_by_llm$studiengang_de, ignore.case = TRUE)
] <- "Environmental protection technology"
study_programs_matched_by_llm$matched_studiengang_en[
  grepl("Werkstoff|Gießereitechnik|Glas|Keramik|Materialwissenschaft", study_programs_matched_by_llm$studiengang_de, ignore.case = TRUE)
] <- "Materials (glass, paper, plastic and wood)"

study_programs_matched_by_llm$matched_studiengang_en[
  grepl("Wirtschaftspädagogik", study_programs_matched_by_llm$studiengang_de, ignore.case = TRUE)
] <- "Economics"
study_programs_matched_by_llm$matched_studiengang_en[
  grepl("Versorgungstechnik|Versorqunqstechnik", study_programs_matched_by_llm$studiengang_de, ignore.case = TRUE)
] <- "Environmental protection technology"

study_programs_matched_by_llm$matched_studiengang_en[
  grepl("Druck|Druckerei|Druckereitechnik|Druckerei- und Papiertechnik|Druck/Graph\\.Gewerbe|Druckerei-Papiertechnik", 
        study_programs_matched_by_llm$studiengang_de, ignore.case = TRUE)
] <- "Materials (glass, paper, plastic and wood)"
study_programs_matched_by_llm$matched_studiengang_en[
  grepl("Elektrotechnik \\(Energietechnik\\)", study_programs_matched_by_llm$studiengang_de, ignore.case = TRUE)
] <- "Electronics and automation"
study_programs_matched_by_llm$matched_studiengang_en[
  grepl("Fahrzeugtechnik", study_programs_matched_by_llm$studiengang_de, ignore.case = TRUE)
] <- "Motor vehicles, ships and aircraft"
study_programs_matched_by_llm$matched_studiengang_en[
  grepl("Gemeinschaftskunde/Sozialkunde", study_programs_matched_by_llm$studiengang_de, ignore.case = TRUE)
] <- "Sociology and cultural studies"
study_programs_matched_by_llm$matched_studiengang_en[
  grepl("Geo-/Landschaftsökologie", study_programs_matched_by_llm$studiengang_de, ignore.case = TRUE)
] <- "Natural environments and wildlife"
study_programs_matched_by_llm$matched_studiengang_en[
  grepl("Geographie|Erdkunde|Geologie", study_programs_matched_by_llm$studiengang_de, ignore.case = TRUE)
] <- "Earth sciences"

study_programs_matched_by_llm$matched_studiengang_en[
  grepl("Geschichte der Naturwissenschaft M", study_programs_matched_by_llm$studiengang_de, ignore.case = TRUE)
] <- "History and archaeology"
study_programs_matched_by_llm$matched_studiengang_en[
  grepl("Geschichte LA PrimarS", study_programs_matched_by_llm$studiengang_de, ignore.case = TRUE)
] <- "History and archaeology"



study_programs_matched_by_llm$matched_studiengang_en[
  grepl("Anthropologie", study_programs_matched_by_llm$studiengang_de, ignore.case = TRUE)
] <- "Sociology and cultural studies"


study_programs_matched_by_llm$matched_studiengang_en[
  grepl("Architektur", study_programs_matched_by_llm$studiengang_de, ignore.case = TRUE)
] <- "Architecture and town planning"

study_programs_matched_by_llm$matched_studiengang_en[
  grepl("Schiffbau", study_programs_matched_by_llm$studiengang_de)
] <- "Motor vehicles, ships and aircraft"
study_programs_matched_by_llm$matched_studiengang_en[
  grepl("Nautik", study_programs_matched_by_llm$studiengang_de)
] <- "Motor vehicles, ships and aircraft"
study_programs_matched_by_llm$matched_studiengang_en[
  grepl("Schiff", study_programs_matched_by_llm$studiengang_de, ignore.case = TRUE)
] <- "Motor vehicles, ships and aircraft"
study_programs_matched_by_llm$matched_studiengang_en[
  grepl("Sport", study_programs_matched_by_llm$studiengang_de, ignore.case = TRUE)
] <- "Sports"
study_programs_matched_by_llm$matched_studiengang_en[
  grepl("Haushalt", study_programs_matched_by_llm$studiengang_de, ignore.case = TRUE)
] <- "Domestic services"
study_programs_matched_by_llm$matched_studiengang_en[
  grepl("Bergtechnik", study_programs_matched_by_llm$studiengang_de, ignore.case = TRUE)
] <- "Mining and extraction"

study_programs_matched_by_llm$matched_studiengang_en[
  grepl("Foto", study_programs_matched_by_llm$studiengang_de, ignore.case = TRUE)
] <- "Fine arts"
study_programs_matched_by_llm$matched_studiengang_en[
  study_programs_matched_by_llm$studiengang_de == "Transportwesen"] <- "Transport services"

study_programs_matched_by_llm$matched_studiengang_en[
  grepl("Vermessungswesen", study_programs_matched_by_llm$studiengang_de, ignore.case = TRUE)
] <- "Building and civil engineering"

study_programs_matched_by_llm$matched_studiengang_en[
  grepl("Markscheidewesen", study_programs_matched_by_llm$studiengang_de, ignore.case = TRUE)
] <- "Mining and extraction"

study_programs_matched_by_llm$matched_studiengang_en[
  grepl("Flugtechnik/ Luftfahrttechnik", study_programs_matched_by_llm$studiengang_de, ignore.case = TRUE)
] <- "Motor vehicles, ships and aircraft"

study_programs_matched_by_llm$matched_studiengang_en[
  grepl("Agrarwissenschaft", study_programs_matched_by_llm$studiengang_de, ignore.case = TRUE)
] <- "Crop and livestock production"

study_programs_matched_by_llm$matched_studiengang_en[
  grepl("Brauwesen/ Getränketechnologie", study_programs_matched_by_llm$studiengang_de, ignore.case = TRUE)
] <- "Food processing"

study_programs_matched_by_llm$matched_studiengang_en[
  grepl("Haushalts- & Ernährungswissenschaften", study_programs_matched_by_llm$studiengang_de, ignore.case = TRUE)
] <- "Food processing"

study_programs_matched_by_llm$matched_studiengang_en[
  grepl("Landespflege/ Landschaftsgestaltung", study_programs_matched_by_llm$studiengang_de, ignore.case = TRUE)
] <- "Horticulture"

study_programs_matched_by_llm$matched_studiengang_en[
  grepl("Papieringeneurwesen", study_programs_matched_by_llm$studiengang_de, ignore.case = TRUE)
] <- "Materials (glass, paper, plastic and wood)"

study_programs_matched_by_llm$matched_studiengang_en[
  grepl("Foto", study_programs_matched_by_llm$studiengang_de, ignore.case = TRUE)
] <- "Fine arts"

study_programs_matched_by_llm$matched_studiengang_en[
  grepl("Französische (Realschule)", study_programs_matched_by_llm$studiengang_de, ignore.case = TRUE)
] <- "Literature and linguistics"

study_programs_matched_by_llm$matched_studiengang_en[
  grepl("Luft- und Raumfahrttechnik", study_programs_matched_by_llm$studiengang_de, ignore.case = TRUE)
] <- "Motor vehicles, ships and aircraft"

study_programs_matched_by_llm$matched_studiengang_en[
  grepl("Steine und Erden", study_programs_matched_by_llm$studiengang_de, ignore.case = TRUE)
] <- "Earth sciences"
study_programs_matched_by_llm$matched_studiengang_en[
  grepl("Berufspädagog", study_programs_matched_by_llm$studiengang_de, ignore.case = TRUE)
] <- "Education science"
study_programs_matched_by_llm$matched_studiengang_en[
  grepl("Berufsschullehramt", study_programs_matched_by_llm$studiengang_de, ignore.case = TRUE)
] <- "Education science"

reporting_keywords <- c("Dokumentation", "Dokumentationswissenschaft", "Archiv- und Dokumentationswissenschaft")
study_programs_matched_by_llm$matched_studiengang_en[
  grepl(paste(reporting_keywords, collapse = "|"), study_programs_matched_by_llm$studiengang_de, ignore.case = TRUE)
] <- "Journalism and reporting"


study_programs_matched_by_llm$matched_studiengang_en[
  grepl("Betriebswirtschaft(slehre)", study_programs_matched_by_llm$studiengang_de)
] <- "Management and administration"

study_programs_matched_by_llm$matched_studiengang_en[
  grepl("Brauwesen", study_programs_matched_by_llm$studiengang_de)
] <- "Food processing"

study_programs_matched_by_llm$matched_studiengang_en[
  grepl("Iranistik", study_programs_matched_by_llm$studiengang_de, ignore.case = TRUE)
] <- "History and archaeology"

study_programs_matched_by_llm$matched_studiengang_en[
  grepl("Islamwissenschaft", study_programs_matched_by_llm$studiengang_de, ignore.case = TRUE)
] <- "History and archaeology"

study_programs_matched_by_llm$matched_studiengang_en[
  grepl("Judaistik", study_programs_matched_by_llm$studiengang_de, ignore.case = TRUE)
] <- "History and archaeology"

study_programs_matched_by_llm$matched_studiengang_en[
  grepl("Brennereiwesen", study_programs_matched_by_llm$studiengang_de, ignore.case = TRUE)
] <- "Food processing"

study_programs_matched_by_llm$matched_studiengang_en[
  grepl("Ernährungswissenschaft", study_programs_matched_by_llm$studiengang_de, ignore.case = TRUE)
] <- "Food processing"

study_programs_matched_by_llm$matched_studiengang_en[
  grepl("Assyrologie", study_programs_matched_by_llm$studiengang_de, ignore.case = TRUE)
] <- "History and archaeology"

study_programs_matched_by_llm$matched_studiengang_en[
  grepl("Leibeserziehung, Sport (Magister)", study_programs_matched_by_llm$studiengang_de, ignore.case = TRUE)
] <- "Sports"

study_programs_matched_by_llm$matched_studiengang_en[
  grepl("Leibeserziehung, Sport (Diplom)", study_programs_matched_by_llm$studiengang_de, ignore.case = TRUE)
] <- "Sports"

study_programs_matched_by_llm$matched_studiengang_en[
  grepl("Leibeserziehung. Sport (Magister)", study_programs_matched_by_llm$studiengang_de, ignore.case = TRUE)
] <- "Sports"

study_programs_matched_by_llm$matched_studiengang_en[
  grepl("Kerntechnik, Reaktortechnik", study_programs_matched_by_llm$studiengang_de, ignore.case = TRUE)
] <- "Physics"

study_programs_matched_by_llm$matched_studiengang_en[
  grepl("Feinwerktechnik", study_programs_matched_by_llm$studiengang_de, ignore.case = TRUE)
] <- "Chemical engineering and processes"

study_programs_matched_by_llm$matched_studiengang_en[
  grepl("Steine und Erden Gesteinhüttenwesen", study_programs_matched_by_llm$studiengang_de, ignore.case = TRUE)
] <- "Earth sciences"

study_programs_matched_by_llm$matched_studiengang_en[
  grepl("Leibeserziehung Sport Magister", study_programs_matched_by_llm$studiengang_de, ignore.case = TRUE)
] <- "Sports"

study_programs_matched_by_llm$matched_studiengang_en[
  grepl("Leibeserziehung Sport Diplom", study_programs_matched_by_llm$studiengang_de, ignore.case = TRUE)
] <- "Sports"

study_programs_matched_by_llm$matched_studiengang_en[
  grepl("Papiertechnik", study_programs_matched_by_llm$studiengang_de, ignore.case = TRUE)
] <- "Materials (glass, paper, plastic and wood)"

study_programs_matched_by_llm$matched_studiengang_en[
  grepl("Brennereitechnik", study_programs_matched_by_llm$studiengang_de, ignore.case = TRUE)
] <- "Food processing"

study_programs_matched_by_llm$matched_studiengang_en[
  grepl("Leibeserziehung, Sport (Magister)", study_programs_matched_by_llm$studiengang_de, ignore.case = TRUE)
] <- "Sports"

study_programs_matched_by_llm$matched_studiengang_en[
  grepl("Dänisch Gymnasium", study_programs_matched_by_llm$studiengang_de, ignore.case = TRUE)
] <- "Literature and linguistics"

study_programs_matched_by_llm$matched_studiengang_en[
  grepl("Dänisch Realschule", study_programs_matched_by_llm$studiengang_de, ignore.case = TRUE)
] <- "Literature and linguistics"

study_programs_matched_by_llm$matched_studiengang_en[
  grepl("Architektur (Diplom)", study_programs_matched_by_llm$studiengang_de, ignore.case = TRUE)
] <- "Architecture and town planning"

study_programs_matched_by_llm$matched_studiengang_en[
  grepl("Architektur (BerufLS./Sek.II)", study_programs_matched_by_llm$studiengang_de, ignore.case = TRUE)
] <- "Architecture and town planning"

study_programs_matched_by_llm$matched_studiengang_en[
  grepl("Leibeserzeihung, Sport (Gymnasium/Sek.II)", study_programs_matched_by_llm$studiengang_de, ignore.case = TRUE)
] <- "Sports"

study_programs_matched_by_llm$matched_studiengang_en[
  grepl("Haushalt sw issenschaftf Realschule/Sek. I)", study_programs_matched_by_llm$studiengang_de, ignore.case = TRUE)
] <- "Domestic services"

study_programs_matched_by_llm$matched_studiengang_en[
  grepl("Ernährungswissenschaft Diplom", study_programs_matched_by_llm$studiengang_de, ignore.case = TRUE)
] <- "Food processing"

study_programs_matched_by_llm$matched_studiengang_en[
  grepl("Maschinenbau Diplom", study_programs_matched_by_llm$studiengang_de, ignore.case = TRUE)
] <- "Mechanics and metal trades"

study_programs_matched_by_llm$matched_studiengang_en[
  grepl("Maschinenbau (Berufl.S./SekII)", study_programs_matched_by_llm$studiengang_de, ignore.case = TRUE)
] <- "Mechanics and metal trades"

study_programs_matched_by_llm$matched_studiengang_en[
  grepl("Haushaltswissenschaft (Berufl.S./SekII)", study_programs_matched_by_llm$studiengang_de, ignore.case = TRUE)
] <- "Domestic services"

study_programs_matched_by_llm$matched_studiengang_en[
  grepl("Architektur (Berufl.S./SekII)", study_programs_matched_by_llm$studiengang_de, ignore.case = TRUE)
] <- "Architecture and town planning"

study_programs_matched_by_llm$matched_studiengang_en[
  grepl("Ernärhungswissenschaft (Berufl.S./SekII)", study_programs_matched_by_llm$studiengang_de, ignore.case = TRUE)
] <- "Food processing"

study_programs_matched_by_llm$matched_studiengang_en[
  grepl("Haushaltswissenschaft (Realschule/SekI)", study_programs_matched_by_llm$studiengang_de, ignore.case = TRUE)
] <- "Domestic services"

study_programs_matched_by_llm$matched_studiengang_en[
  grepl("Ernährungswissenschaft (Diplom)", study_programs_matched_by_llm$studiengang_de, ignore.case = TRUE)
] <- "Food processing"

study_programs_matched_by_llm$matched_studiengang_en[
  grepl("Haushaltswissenschaft (Realschule/Sek.I)", study_programs_matched_by_llm$studiengang_de, ignore.case = TRUE)
] <- "Domestic services"

study_programs_matched_by_llm$matched_studiengang_en[
  grepl("Haushaltswissenschaft (Berufl.S./Sek. II)", study_programs_matched_by_llm$studiengang_de, ignore.case = TRUE)
] <- "Domestic services"

study_programs_matched_by_llm$matched_studiengang_en[
  grepl("Ernährungswissenschaft (Berufl.S./Sek.II)", study_programs_matched_by_llm$studiengang_de, ignore.case = TRUE)
] <- "Food processing"

study_programs_matched_by_llm$matched_studiengang_en[
  grepl("Architektur (Berufl.S./Sek.II)", study_programs_matched_by_llm$studiengang_de, ignore.case = TRUE)
] <- "Architecture and town planning"

study_programs_matched_by_llm$matched_studiengang_en[
  grepl("Leibeserziehung Sport Magister/Diplom", study_programs_matched_by_llm$studiengang_de, ignore.case = TRUE)
] <- "Sports"

study_programs_matched_by_llm$matched_studiengang_en[
  grepl("Informatik (Diplom/Magister)", study_programs_matched_by_llm$studiengang_de, ignore.case = TRUE)
] <- "Computer use"

study_programs_matched_by_llm$matched_studiengang_en[
  grepl("Sport (Magister/Diplom)", study_programs_matched_by_llm$studiengang_de, ignore.case = TRUE)
] <- "Sports"

study_programs_matched_by_llm$matched_studiengang_en[
  grepl("Sport (Gymnasium)", study_programs_matched_by_llm$studiengang_de, ignore.case = TRUE)
] <- "Sports"

study_programs_matched_by_llm$matched_studiengang_en[
  grepl("Informatik (Magister/Diplon)", study_programs_matched_by_llm$studiengang_de, ignore.case = TRUE)
] <- "Computer use"

study_programs_matched_by_llm$matched_studiengang_en[
  grepl("Informatik (Diplom/Magister)", study_programs_matched_by_llm$studiengang_de, ignore.case = TRUE)
] <- "Computer use"

study_programs_matched_by_llm$matched_studiengang_en[
  grepl("Wirtschaftspäd./-wissensch.", study_programs_matched_by_llm$studiengang_de, ignore.case = TRUE)
] <- "Economics"

study_programs_matched_by_llm$matched_studiengang_en[
  grepl("Sport (Realschule)", study_programs_matched_by_llm$studiengang_de, ignore.case = TRUE)
] <- "Sports"

study_programs_matched_by_llm$matched_studiengang_en[
  grepl("Turkologie", study_programs_matched_by_llm$studiengang_de, ignore.case = TRUE)
] <- "Sociology and cultural studies"

study_programs_matched_by_llm$matched_studiengang_en[
  grepl("Haushaltswissenschaft (Realschule)", study_programs_matched_by_llm$studiengang_de, ignore.case = TRUE)
] <- "Domestic services"

study_programs_matched_by_llm$matched_studiengang_en[
  grepl("Sport (Gymnasium/ Sek.II)", study_programs_matched_by_llm$studiengang_de, ignore.case = TRUE)
] <- "Sports"

study_programs_matched_by_llm$matched_studiengang_en[
  grepl("Sport (Realschule/ Sek.I)", study_programs_matched_by_llm$studiengang_de, ignore.case = TRUE)
] <- "Sports"

study_programs_matched_by_llm$matched_studiengang_en[
  grepl("Haushalts-/Ernährungswiss. (Realschule/Sek.I)", study_programs_matched_by_llm$studiengang_de, ignore.case = TRUE)
] <- "Domestic services"

study_programs_matched_by_llm$matched_studiengang_en[
  grepl("Verkehrsingenieurswesen", study_programs_matched_by_llm$studiengang_de, ignore.case = TRUE)
] <- "Building and civil engineering"

study_programs_matched_by_llm$matched_studiengang_en[
  grepl("Assyrologie M", study_programs_matched_by_llm$studiengang_de, ignore.case = TRUE)
] <- "History and archaeology"

study_programs_matched_by_llm$matched_studiengang_en[
  grepl("Biotechnologie D", study_programs_matched_by_llm$studiengang_de, ignore.case = TRUE)
] <- "Biology"

study_programs_matched_by_llm$matched_studiengang_en[
  study_programs_matched_by_llm$studiengang_de == "Indologie M"] <- "Sociology and cultural studies"

study_programs_matched_by_llm$matched_studiengang_en[
  grepl("Judaistik M", study_programs_matched_by_llm$studiengang_de, ignore.case = TRUE)
] <- "History and archaeology"

study_programs_matched_by_llm$matched_studiengang_en[
  grepl("Kristallographie D", study_programs_matched_by_llm$studiengang_de, ignore.case = TRUE)
] <- "Earth sciences"

study_programs_matched_by_llm$matched_studiengang_en[
  grepl("Kerntechnik, Reaktortechnik D", study_programs_matched_by_llm$studiengang_de, ignore.case = TRUE)
] <- "Physics"

study_programs_matched_by_llm$matched_studiengang_en[
  grepl("Mikrobiologie D", study_programs_matched_by_llm$studiengang_de, ignore.case = TRUE)
] <- "Biology"

study_programs_matched_by_llm$matched_studiengang_en[
  grepl("Mineralogie D", study_programs_matched_by_llm$studiengang_de, ignore.case = TRUE)
] <- "Mining and extraction"

study_programs_matched_by_llm$matched_studiengang_en[
  grepl("Nordistik M", study_programs_matched_by_llm$studiengang_de, ignore.case = TRUE)
] <- "Literature and linguistics"

study_programs_matched_by_llm$matched_studiengang_en[
  grepl("Sinologie M", study_programs_matched_by_llm$studiengang_de, ignore.case = TRUE)
] <- "Sociology and cultural studies"

study_programs_matched_by_llm$matched_studiengang_en[
  grepl("Iranistik, Indoiranistik M", study_programs_matched_by_llm$studiengang_de, ignore.case = TRUE)
] <- "Sociology and cultural studies"

study_programs_matched_by_llm$matched_studiengang_en[
  grepl("Maschinenbau D", study_programs_matched_by_llm$studiengang_de, ignore.case = TRUE)
] <- "Mechanics and metal trades"

study_programs_matched_by_llm$matched_studiengang_en[
  grepl("Amerikanistik M", study_programs_matched_by_llm$studiengang_de, ignore.case = TRUE)
] <- "Sociology and cultural studies"

study_programs_matched_by_llm$matched_studiengang_en[
  grepl("Französisch M", study_programs_matched_by_llm$studiengang_de, ignore.case = TRUE)
] <- "Literature and linguistics"

study_programs_matched_by_llm$matched_studiengang_en[
  grepl("Luft- und Raumfahrttechnik D", study_programs_matched_by_llm$studiengang_de, ignore.case = TRUE)
] <- "Motor vehicles, ships and aircraft"

study_programs_matched_by_llm$matched_studiengang_en[
  grepl("Metallkunde D", study_programs_matched_by_llm$studiengang_de, ignore.case = TRUE)
] <- "Mechanics and metal trades"

study_programs_matched_by_llm$matched_studiengang_en[
  grepl("Sportwissenschaft D", study_programs_matched_by_llm$studiengang_de, ignore.case = TRUE)
] <- "Sports"

study_programs_matched_by_llm$matched_studiengang_en[
  grepl("Werkstoff-/Materialwissenschaften/-technik D", study_programs_matched_by_llm$studiengang_de, ignore.case = TRUE)
] <- "Materials (glass, paper, plastic and wood)"

study_programs_matched_by_llm$matched_studiengang_en[
  grepl("Luft- und Raumfahrttechnik", study_programs_matched_by_llm$studiengang_de, ignore.case = TRUE)
] <- "Motor vehicles, ships and aircraft"

study_programs_matched_by_llm$matched_studiengang_en[
  grepl("Südostasienwissenschaft M", study_programs_matched_by_llm$studiengang_de, ignore.case = TRUE)
] <- "Sociology and cultural studies"

study_programs_matched_by_llm$matched_studiengang_en[
  grepl("Russisch M", study_programs_matched_by_llm$studiengang_de, ignore.case = TRUE)
] <- "Literature and linguistics"

study_programs_matched_by_llm$matched_studiengang_en[
  grepl("Turkologie M", study_programs_matched_by_llm$studiengang_de, ignore.case = TRUE)
] <- "Sociology and cultural studies"

study_programs_matched_by_llm$matched_studiengang_en[
  grepl("Afrikanistik M", study_programs_matched_by_llm$studiengang_de, ignore.case = TRUE)
] <- "Sociology and cultural studies"

study_programs_matched_by_llm$matched_studiengang_en[
  grepl("Byzantinistik", study_programs_matched_by_llm$studiengang_de, ignore.case = TRUE)
] <- "Sociology and cultural studies"


study_programs_matched_by_llm$matched_studiengang_en[
  grepl("Brauwesen/ Getränketechnologie D", study_programs_matched_by_llm$studiengang_de, ignore.case = TRUE)
] <- "Food processing"

study_programs_matched_by_llm$matched_studiengang_en[
  grepl("Pflegewissenschaften D", study_programs_matched_by_llm$studiengang_de, ignore.case = TRUE)
] <- "Care of the elderly and of disabled adults"

study_programs_matched_by_llm$matched_studiengang_en[
  grepl("Ernährungswissenschaft (Berufl.S./Sek.II)", study_programs_matched_by_llm$studiengang_de, ignore.case = TRUE)
] <- "Food processing"

study_programs_matched_by_llm$matched_studiengang_en[
  grepl("Schiffstechnik D", study_programs_matched_by_llm$studiengang_de, ignore.case = TRUE)
] <- "Motor vehicles, ships and aircraft"

study_programs_matched_by_llm$matched_studiengang_en[
  grepl("Technische Informatik/ Ingenieursinformatik D", study_programs_matched_by_llm$studiengang_de, ignore.case = TRUE)
] <- "Computer use"

study_programs_matched_by_llm$matched_studiengang_en[
  grepl("Russisch D", study_programs_matched_by_llm$studiengang_de, ignore.case = TRUE)
] <- "Literature and linguistics"

study_programs_matched_by_llm$matched_studiengang_en[
  grepl("Hüttenwesen D", study_programs_matched_by_llm$studiengang_de, ignore.case = TRUE)
] <- "Mechanics and metal trades"

study_programs_matched_by_llm$matched_studiengang_en[
  grepl("Markscheidewesen D", study_programs_matched_by_llm$studiengang_de, ignore.case = TRUE)
] <- "Mechanics and metal trades"

study_programs_matched_by_llm$matched_studiengang_en[
  grepl("Landbau", study_programs_matched_by_llm$studiengang_de, ignore.case = TRUE)
] <- "Horticulture"

study_programs_matched_by_llm$matched_studiengang_en[
  grepl("Druckerei-Papiertechnik", study_programs_matched_by_llm$studiengang_de, ignore.case = TRUE)
] <- "Materials (glass, paper, plastic and wood)"

study_programs_matched_by_llm$matched_studiengang_en[
  grepl("Fahrzeugtechnik", study_programs_matched_by_llm$studiengang_de, ignore.case = TRUE)
] <- "Motor vehicles, ships and aircraft"

study_programs_matched_by_llm$matched_studiengang_en[
  grepl("Flugzeuabau/ Flugtechnik", study_programs_matched_by_llm$studiengang_de, ignore.case = TRUE)
] <- "Motor vehicles, ships and aircraft"

study_programs_matched_by_llm$matched_studiengang_en[
  grepl("Sportwissenschaft/Leibeserziehung LA RS/GesS", study_programs_matched_by_llm$studiengang_de, ignore.case = TRUE)
] <- "Sports"

study_programs_matched_by_llm$matched_studiengang_en[
  grepl("Chemie LA RS/GesS", study_programs_matched_by_llm$studiengang_de, ignore.case = TRUE)
] <- "Chemistry"

study_programs_matched_by_llm$matched_studiengang_en[
  grepl("Sportwissenschaft/Leibeserziehung LA HS/GesS", study_programs_matched_by_llm$studiengang_de, ignore.case = TRUE)
] <- "Sports"

study_programs_matched_by_llm$matched_studiengang_en[
  grepl("Chemie LA HS/GesS", study_programs_matched_by_llm$studiengang_de, ignore.case = TRUE)
] <- "Chemistry"

study_programs_matched_by_llm$matched_studiengang_en[
  grepl("Sportwissenschaft/Leibeserziehung LA GYM/GesS", study_programs_matched_by_llm$studiengang_de, ignore.case = TRUE)
] <- "Sports"

study_programs_matched_by_llm$matched_studiengang_en[
  grepl("Spanisch LA GYM/GesS", study_programs_matched_by_llm$studiengang_de, ignore.case = TRUE)
] <- "Literature and linguistics"

study_programs_matched_by_llm$matched_studiengang_en[
  grepl("Russisch LA GYM/GesS", study_programs_matched_by_llm$studiengang_de, ignore.case = TRUE)
] <- "Literature and linguistics"

study_programs_matched_by_llm$matched_studiengang_en[
  grepl("Latein LA GYM/GesS", study_programs_matched_by_llm$studiengang_de, ignore.case = TRUE)
] <- "Literature and linguistics"

study_programs_matched_by_llm$matched_studiengang_en[
  grepl("Italienisch LA GYM/GesS", study_programs_matched_by_llm$studiengang_de, ignore.case = TRUE)
] <- "Literature and linguistics"

study_programs_matched_by_llm$matched_studiengang_en[
  grepl("Griechisch LA GYM/GesS", study_programs_matched_by_llm$studiengang_de, ignore.case = TRUE)
] <- "Literature and linguistics"

study_programs_matched_by_llm$matched_studiengang_en[
  grepl("Franz√∂sisch LA GYM/GesS", study_programs_matched_by_llm$studiengang_de, ignore.case = TRUE)
] <- "Literature and linguistics"

study_programs_matched_by_llm$matched_studiengang_en[
  grepl("Geschichte LA GYM/GesS", study_programs_matched_by_llm$studiengang_de, ignore.case = TRUE)
] <- "History and archaeology"

study_programs_matched_by_llm$matched_studiengang_en[
  grepl("Chemie LA GYM/GesS", study_programs_matched_by_llm$studiengang_de, ignore.case = TRUE)
] <- "Chemistry"

study_programs_matched_by_llm$matched_studiengang_en[
  grepl("Portugiesisch LA GYM", study_programs_matched_by_llm$studiengang_de, ignore.case = TRUE)
] <- "Literature and linguistics"

study_programs_matched_by_llm$matched_studiengang_en[
  grepl("Sorbisch LA GYM", study_programs_matched_by_llm$studiengang_de, ignore.case = TRUE)
] <- "Literature and linguistics"

study_programs_matched_by_llm$matched_studiengang_en[
  grepl("Sorbisch LA RS", study_programs_matched_by_llm$studiengang_de, ignore.case = TRUE)
] <- "Literature and linguistics"

study_programs_matched_by_llm$matched_studiengang_en[
  grepl("Latein LA BS", study_programs_matched_by_llm$studiengang_de, ignore.case = TRUE)
] <- "Literature and linguistics"

study_programs_matched_by_llm$matched_studiengang_en[
  grepl("Friesisch LA GYM", study_programs_matched_by_llm$studiengang_de, ignore.case = TRUE)
] <- "Literature and linguistics"

study_programs_matched_by_llm$matched_studiengang_en[
  grepl("Friesisch LA RS", study_programs_matched_by_llm$studiengang_de, ignore.case = TRUE)
] <- "Literature and linguistics"

study_programs_matched_by_llm$matched_studiengang_en[
  grepl("Friesisch LA GS/HS", study_programs_matched_by_llm$studiengang_de, ignore.case = TRUE)
] <- "Literature and linguistics"

study_programs_matched_by_llm$matched_studiengang_en[
  grepl("Dänisch LA RS", study_programs_matched_by_llm$studiengang_de, ignore.case = TRUE)
] <- "Literature and linguistics"

study_programs_matched_by_llm$matched_studiengang_en[
  grepl("Dänisch LA GS/HS", study_programs_matched_by_llm$studiengang_de, ignore.case = TRUE)
] <- "Literature and linguistics"

study_programs_matched_by_llm$matched_studiengang_en[
  grepl("Lebensmitteltechnologie LA SekundarS II", study_programs_matched_by_llm$studiengang_de, ignore.case = TRUE)
] <- "Food processing"

study_programs_matched_by_llm$matched_studiengang_en[
  grepl("Geographie/ Erkunde LA PrimarS", study_programs_matched_by_llm$studiengang_de, ignore.case = TRUE)
] <- "Earth sciences"

study_programs_matched_by_llm$matched_studiengang_en[
  grepl("Wirtschaftsinformatik LA SekundarS II", study_programs_matched_by_llm$studiengang_de, ignore.case = TRUE)
] <- "Economics"

study_programs_matched_by_llm$matched_studiengang_en[
  grepl("Niederländisch LA SekundarS II", study_programs_matched_by_llm$studiengang_de, ignore.case = TRUE)
] <- "Literature and linguistics"

study_programs_matched_by_llm$matched_studiengang_en[
  grepl("Niederländisch LA SekundarS I", study_programs_matched_by_llm$studiengang_de, ignore.case = TRUE)
] <- "Literature and linguistics"

study_programs_matched_by_llm$matched_studiengang_en[
  grepl("Griechsch LA SekundarS II", study_programs_matched_by_llm$studiengang_de, ignore.case = TRUE)
] <- "Literature and linguistics"

study_programs_matched_by_llm$matched_studiengang_en[
  grepl("Maschinenbau/ Maschinentechnik LA SekundarS II", study_programs_matched_by_llm$studiengang_de, ignore.case = TRUE)
] <- "Mechanics and metal trades"

study_programs_matched_by_llm$matched_studiengang_en[
  grepl("Latein LA SekundarS II", study_programs_matched_by_llm$studiengang_de, ignore.case = TRUE)
] <- "Literature and linguistics"

study_programs_matched_by_llm$matched_studiengang_en[
  grepl("Technik LA PrimarS", study_programs_matched_by_llm$studiengang_de, ignore.case = TRUE)
] <- "Electronics and automation"

study_programs_matched_by_llm$matched_studiengang_en[
  grepl("Niederländisch LA BS", study_programs_matched_by_llm$studiengang_de, ignore.case = TRUE)
] <- "Literature and linguistics"

study_programs_matched_by_llm$matched_studiengang_en[
  grepl("Niederländisch LA GYM", study_programs_matched_by_llm$studiengang_de, ignore.case = TRUE)
] <- "Literature and linguistics"

study_programs_matched_by_llm$matched_studiengang_en[
  grepl("Niederländisch LA RS", study_programs_matched_by_llm$studiengang_de, ignore.case = TRUE)
] <- "Literature and linguistics"
study_programs_matched_by_llm$matched_studiengang_en[
  grepl("Lebensmittelchemie|Lebensmittelcheme|Lebensmitteltechnik|Lebensmitteltechnologie|Lebensmitteltechnol[oq]ie", 
        study_programs_matched_by_llm$studiengang_de, ignore.case = TRUE)
] <- "Food processing"

study_programs_matched_by_llm$matched_studiengang_en[
  grepl("Lehramt an beruflichen Schulen", study_programs_matched_by_llm$studiengang_de, ignore.case = TRUE)
] <- "Education science"

study_programs_matched_by_llm$matched_studiengang_en[
  grepl("Polnisch LA SekundarS I", study_programs_matched_by_llm$studiengang_de, ignore.case = TRUE)
] <- "Literature and linguistics"

study_programs_matched_by_llm$matched_studiengang_en[
  grepl("Polnisch LA SekundarS II", study_programs_matched_by_llm$studiengang_de, ignore.case = TRUE)
] <- "Literature and linguistics"
# Markscheidewesen
study_programs_matched_by_llm$matched_studiengang_en[
  grepl("Markscheidewesen", study_programs_matched_by_llm$studiengang_de, ignore.case = TRUE)
] <- "Mining and extraction"

# Maschinenbau (alle Varianten)
#study_programs_matched_by_llm$matched_studiengang_en[
 # grepl("Maschinenbau", study_programs_matched_by_llm$studiengang_de, ignore.case = TRUE)
#] <- "Mechanical engineering and manufacturing"

study_programs_matched_by_llm$matched_studiengang_en[
  grepl("Spanisch LA SekundarS II", study_programs_matched_by_llm$studiengang_de, ignore.case = TRUE)
] <- "Literature and linguistics"

study_programs_matched_by_llm$matched_studiengang_en[
  grepl("Russisch LA SekundarS II", study_programs_matched_by_llm$studiengang_de, ignore.case = TRUE)
] <- "Literature and linguistics"

study_programs_matched_by_llm$matched_studiengang_en[
  grepl("Italienisch LA SekundarS II", study_programs_matched_by_llm$studiengang_de, ignore.case = TRUE)
] <- "Literature and linguistics"
# Alle Pädagogik-Varianten
study_programs_matched_by_llm$matched_studiengang_en[
  grepl("Pädagogik", study_programs_matched_by_llm$studiengang_de, ignore.case = TRUE)
] <- "Education science"

# Alle Paläontologie-Varianten
study_programs_matched_by_llm$matched_studiengang_en[
  grepl("Paläontologie", study_programs_matched_by_llm$studiengang_de, ignore.case = TRUE)
] <- "Biology"
study_programs_matched_by_llm$matched_studiengang_en[
  grepl("Pflege", study_programs_matched_by_llm$studiengang_de, ignore.case = TRUE)
] <- "Nursing and midwifery"


study_programs_matched_by_llm$matched_studiengang_en[
  grepl("Informatik LA SekundarS II", study_programs_matched_by_llm$studiengang_de, ignore.case = TRUE)
] <- "Computer use"

study_programs_matched_by_llm$matched_studiengang_en[
  grepl("Russisch LA SekundarS I", study_programs_matched_by_llm$studiengang_de, ignore.case = TRUE)
] <- "Literature and linguistics"

study_programs_matched_by_llm$matched_studiengang_en[
  grepl("Italienisch LA SekundarS I", study_programs_matched_by_llm$studiengang_de, ignore.case = TRUE)
] <- "Literature and linguistics"

study_programs_matched_by_llm$matched_studiengang_en[
  grepl("Informatik LA SekundarS I", study_programs_matched_by_llm$studiengang_de, ignore.case = TRUE)
] <- "Computer use"

study_programs_matched_by_llm$matched_studiengang_en[
  grepl("Russisch LA PrimarS", study_programs_matched_by_llm$studiengang_de, ignore.case = TRUE)
] <- "Literature and linguistics"

study_programs_matched_by_llm$matched_studiengang_en[
  grepl("Russisch LA PrimarS", study_programs_matched_by_llm$studiengang_de, ignore.case = TRUE)
] <- "Literature and linguistics"

study_programs_matched_by_llm$matched_studiengang_en[
  grepl("Foto/ Fotoingenieurwesen", study_programs_matched_by_llm$studiengang_de, ignore.case = TRUE)
] <- "Fine arts"




study_programs_matched_by_llm$matched_studiengang_en[
  grepl("Nordistik|Arabistik|Byzantistik|Afrinologie|Afrikanistik|Sorbistik", study_programs_matched_by_llm$studiengang_de, ignore.case = TRUE)
] <- "Sociology and cultural studies"







# Architecture and town planning
study_programs_matched_by_llm$matched_studiengang_en[
  grepl("Raumordnung, Landespflege", study_programs_matched_by_llm$studiengang_de, ignore.case = TRUE)
] <- "Architecture and town planning"

# Horticulture
study_programs_matched_by_llm$matched_studiengang_en[
  grepl("Gartenbau und Landespflege", study_programs_matched_by_llm$studiengang_de, ignore.case = TRUE)
] <- "Horticulture"




# 1. Chemie immer "Chemistry", außer Chemieingenieurwesen, -technik etc.
study_programs_matched_by_llm$matched_studiengang_en[
  grepl("^Chemie(?!ingenieur|technik|verfahren|technologie|rektor|kern|kernverfahren|technik/chemie|technik/Verfahren|ingenieurwesen)", 
        study_programs_matched_by_llm$studiengang_de, ignore.case = TRUE, perl = TRUE)
] <- "Chemistry"

# Chemieingenieurwesen, Chemietechnik, Technische Chemie, Verfahrenstechnik → "Chemical engineering and processes"
study_programs_matched_by_llm$matched_studiengang_en[
  grepl("Chemieingenieur|Verfahrenstechnik|Chemietechnik|Technische Chemie", 
        study_programs_matched_by_llm$studiengang_de, ignore.case = TRUE)
] <- "Chemical engineering and processes"

# Energietechnik (alle Varianten) → "Electricity and energy"
study_programs_matched_by_llm$matched_studiengang_en[
  grepl("Energie-|Energietechnik|Energie- und Wärmetechnik", 
        study_programs_matched_by_llm$studiengang_de, ignore.case = TRUE)
] <- "Electricity and energy"

# Fahrzeugtechnik, Kraftfahrzeugbau, Flugtechnik, Luftfahrttechnik, Flugzeugbau → "Motor vehicles, ships and aircraft"
study_programs_matched_by_llm$matched_studiengang_en[
  grepl("Fahrzeugtechnik|Fahrzeuqtechnik|Kraftfahrzeugbau|Flugtechnik|Luftfahrttechnik|Flugzeugbau", 
        study_programs_matched_by_llm$studiengang_de, ignore.case = TRUE)
] <- "Motor vehicles, ships and aircraft"



# Fremdenverkehr, Tourismus → "Travel, tourism and leisure"
study_programs_matched_by_llm$matched_studiengang_en[
  grepl("Fremdenverkehr|Tourismus", 
        study_programs_matched_by_llm$studiengang_de, ignore.case = TRUE)
] <- "Travel, tourism and leisure"

# Geschichte, Archäologie, Judaistik, Iranistik, Assyrologie → "History and archaeology"
study_programs_matched_by_llm$matched_studiengang_en[
  grepl("Geschichte|Archäologie|Restaurierung|Judaistik|Iranistik|Assyrologie|Geschichtswissenschaft|Museumskunde", 
        study_programs_matched_by_llm$studiengang_de, ignore.case = TRUE)
] <- "History and archaeology"

# Hüttenkunde, Hüttenwesen, Hüttentechnik (ohne Gießereitechnik) → "Mechanics and metal trades"
study_programs_matched_by_llm$matched_studiengang_en[
  grepl("Hüttenkunde|Hüttenwesen|Hüttentechnik(?!.*Gießereitechnik)", 
        study_programs_matched_by_llm$studiengang_de, ignore.case = TRUE, perl = TRUE)
] <- "Mechanics and metal trades"

# Hüttentechnik (mit Gießereitechnik) → "Materials (glass, paper, plastic and wood)"
study_programs_matched_by_llm$matched_studiengang_en[
  grepl("Hüttentechnik.*Gießereitechnik", 
        study_programs_matched_by_llm$studiengang_de, ignore.case = TRUE)
] <- "Materials (glass, paper, plastic and wood)"

# Islamwissenschaft, Islamwissenschaft/Semitistik/Arabistik → "Literature and linguistics"
study_programs_matched_by_llm$matched_studiengang_en[
  grepl("Islamwissenschaft|Islam Wissenschaft|Islamwissenschaft/Semitistik|Islamwissenschaft/Semitistik.*Arabistik", 
        study_programs_matched_by_llm$studiengang_de, ignore.case = TRUE)
] <- "Literature and linguistics"

# Kulturpädagogik → "Education science"
study_programs_matched_by_llm$matched_studiengang_en[
  grepl("Kulturpädagogik", study_programs_matched_by_llm$studiengang_de, ignore.case = TRUE)
] <- "Education science"

# Kulturwissenschaft (ohne Pädagogik) → "Sociology and cultural studies"
study_programs_matched_by_llm$matched_studiengang_en[
  grepl("Kulturwissenschaft", study_programs_matched_by_llm$studiengang_de, ignore.case = TRUE) &
    !grepl("pädagogik", study_programs_matched_by_llm$studiengang_de, ignore.case = TRUE)
] <- "Sociology and cultural studies"

# Amerikanistik, Anglistik, Germanistik, Romanistik, Slawistik, Italianistik, Hispanistik, Orientalistik, Linguistik → Literature and linguistics
study_programs_matched_by_llm$matched_studiengang_en[
  grepl("Amerikanistik|Anglistik|Germanistik|Romanistik|Slawistik|Italianistik|Hispanistik|Orientalistik|Linguistik", 
        study_programs_matched_by_llm$studiengang_de, ignore.case = TRUE)
] <- "Literature and linguistics"

# Kunst, Kunstpädagogik, Kunsterziehung, Kunsttherapie, Kunst, freie/Kunstpädagogik etc. → "Fine arts"
study_programs_matched_by_llm$matched_studiengang_en[
  grepl("Kunst", study_programs_matched_by_llm$studiengang_de, ignore.case = TRUE)
] <- "Fine arts"

# Lebensmitteltechnik, -technologie, -chemie etc. (alle Varianten, auch mit Doppelfach) → "Food processing"
study_programs_matched_by_llm$matched_studiengang_en[
  grepl("Lebensmitteltech|Lebensmittelchemie|Lebensmitteltechnol", 
        study_programs_matched_by_llm$studiengang_de, ignore.case = TRUE)
] <- "Food processing"

# Musik (alle Varianten) → "Music and performing arts"
study_programs_matched_by_llm$matched_studiengang_en[
  grepl("Musik", study_programs_matched_by_llm$studiengang_de, ignore.case = TRUE)
] <- "Music and performing arts"

# Ozeanographie (alle Varianten) → "Environmental sciences"
study_programs_matched_by_llm$matched_studiengang_en[
  grepl("Ozeanographie", study_programs_matched_by_llm$studiengang_de, ignore.case = TRUE)
] <- "Environmental sciences"

# Papieringenieurwesen, Papiertechnik → "Materials (glass, paper, plastic and wood)"
study_programs_matched_by_llm$matched_studiengang_en[
  grepl("Papieringenieurwesen|Papiertechnik", study_programs_matched_by_llm$studiengang_de, ignore.case = TRUE)
] <- "Materials (glass, paper, plastic and wood)"

# Portugiesisch (alle Varianten) → Literature and linguistics
study_programs_matched_by_llm$matched_studiengang_en[
  grepl("Portugiesisch", study_programs_matched_by_llm$studiengang_de, ignore.case = TRUE)
] <- "Literature and linguistics"

# Rechtspflege (alle Varianten) → Law
study_programs_matched_by_llm$matched_studiengang_en[
  grepl("Rechtspflege", study_programs_matched_by_llm$studiengang_de, ignore.case = TRUE)
] <- "Law"

# Sozialwesen, Sozialarbeit, Sozialpädagogik, Sozialtherapie, Heilpädagogik → Social work and counselling
study_programs_matched_by_llm$matched_studiengang_en[
  grepl("Sozialwesen|Sozialarbeit|Sozialpädagogik|Sozialtherapie|Heilpädagogik", study_programs_matched_by_llm$studiengang_de, ignore.case = TRUE)
] <- "Social work and counselling"

# Sprachlehrforschung, Sprechwissenschaft, Phonetik → Language acquisition
study_programs_matched_by_llm$matched_studiengang_en[
  grepl("Sprachlehrforschung|Sprechwissenschaft|Phonetik", study_programs_matched_by_llm$studiengang_de, ignore.case = TRUE)
] <- "Language acquisition"

# Sprachwissenschaft, Linguistik (inkl. Varianten) → Literature and linguistics
study_programs_matched_by_llm$matched_studiengang_en[
  grepl("Sprachwissenschaft|Linguistik", study_programs_matched_by_llm$studiengang_de, ignore.case = TRUE)
] <- "Literature and linguistics"

# Technik (alle Lehramt-Varianten und Kombis) → Electronics and automation
study_programs_matched_by_llm$matched_studiengang_en[
  grepl("Technik LA|Technik \\(Lehramt|^Technik|^Technische |Technik \\(Diplom|Technik \\(Berufl\\.S|Technom", study_programs_matched_by_llm$studiengang_de, ignore.case = TRUE)
] <- "Electronics and automation"

# Technikpädagogik → Education science
study_programs_matched_by_llm$matched_studiengang_en[
  grepl("Technikpädagogik", study_programs_matched_by_llm$studiengang_de, ignore.case = TRUE)
] <- "Education science"

# Textilchemie, Textiltechnik, Textil- und Bekleidungstechnik → Textiles (clothes, footwear and leather)
study_programs_matched_by_llm$matched_studiengang_en[
  grepl("Textilchemie|Textiltechnik|Textil- und Bekleidungstechnik|Textil- und Konfektionstechnik", study_programs_matched_by_llm$studiengang_de, ignore.case = TRUE)
] <- "Textiles (clothes, footwear and leather)"

# Textilgestaltung → Fashion, interior and industrial design
study_programs_matched_by_llm$matched_studiengang_en[
  grepl("Textilgestaltung|Gestaltung", study_programs_matched_by_llm$studiengang_de, ignore.case = TRUE)
] <- "Fashion, interior and industrial design"

# Theaterwissenschaft → Music and performing arts
study_programs_matched_by_llm$matched_studiengang_en[
  grepl("Theaterwissenschaft", study_programs_matched_by_llm$studiengang_de, ignore.case = TRUE)
] <- "Music and performing arts"

# Wirtschaft... ALLES → Economics
study_programs_matched_by_llm$matched_studiengang_en[
  grepl("Wirtschaft|Wirtschafts-|Wirtschaftsinformatik|Wirtschaftsmathematik|Wirtschaftsingenieurwesen|Wirtschafts- und Betriebstechnik|Betriebstechnik|Sozialkunde", 
        study_programs_matched_by_llm$studiengang_de)
] <- "Economics"

# Nachrichtentechnik → Electronics and automation
study_programs_matched_by_llm$matched_studiengang_en[
  grepl("Nachrichtentechnik", study_programs_matched_by_llm$studiengang_de, ignore.case = TRUE)
] <- "Electronics and automation"

# Fernsehtechnik, Medientechnik, audiovisuelle Medien → Audio-visual techniques and media production
study_programs_matched_by_llm$matched_studiengang_en[
  grepl("Fernseh|Medientechnik|audio|video", study_programs_matched_by_llm$studiengang_de, ignore.case = TRUE)
] <- "Audio-visual techniques and media production"

study_programs_matched_by_llm$matched_studiengang_en[
  grepl("Arbeitslehre/Arbeitswissenschaft/Polytechnik", study_programs_matched_by_llm$studiengang_de, ignore.case = TRUE)
] <- "Work skills"

# Begriffe, die zur Kategorie "Biology" gehören sollen
bio_related <- c("Biotechnologie", "Biotechnik", "Biophysik")

# Mapping auf "Biology", wenn einer dieser Begriffe im Studiengang (de) enthalten ist – Groß-/Kleinschreibung beachten
study_programs_matched_by_llm$matched_studiengang_en[
  grepl(paste(bio_related, collapse = "|"), study_programs_matched_by_llm$studiengang_de, ignore.case = TRUE)
] <- "Biology"


study_programs_matched_by_llm$matched_studiengang_en[
  grepl("Bauingenieurwesen", study_programs_matched_by_llm$studiengang_de, ignore.case = TRUE)
] <- "Building and civil engineering"
study_programs_matched_by_llm$matched_studiengang_en[
  grepl("Computerlinguistik", study_programs_matched_by_llm$studiengang_de, ignore.case = TRUE)
] <- "Computer use"
study_programs_matched_by_llm$matched_studiengang_en[
  grepl("Kerntechnik", study_programs_matched_by_llm$studiengang_de, ignore.case = TRUE)
] <- "Chemical engineering and processes"
study_programs_matched_by_llm$matched_studiengang_en[
  grepl("Sozialwissenschaft|Soziologie|Sozialkunde|Politik", study_programs_matched_by_llm$studiengang_de, ignore.case = TRUE)
] <- "Political sciences and civics"
# Fertigungstechnik, Konstruktion → "Mechanical engineering and manufacturing"
study_programs_matched_by_llm$matched_studiengang_en[
  grepl("Fertigungstechnik|Fertigungstechnik/-systeme|Fertigungstechnik/Konstruktion", 
        study_programs_matched_by_llm$studiengang_de, ignore.case = TRUE)
] <- "Mechanical engineering and manufacturing"
# Natural environments and wildlife
study_programs_matched_by_llm$matched_studiengang_en[
  grepl("Limnologie|Landespflege(/Landschaftsgestaltung|/Landschaftsplanung)?|Landespflege$|Landespflege/Landschaftsplanung D|Landespflege/Landschaftsgestaltung LA BS", 
        study_programs_matched_by_llm$studiengang_de, ignore.case = TRUE)
] <- "Natural environments and wildlife"
# Textilchemie, Textiltechnik, Textil- und Bekleidungstechnik → Textiles (clothes, footwear and leather)
study_programs_matched_by_llm$matched_studiengang_en[
  grepl("Textilchemie|Textiltechnik|Texttil|Textil- und Bekleidungstechnik|Textil- und Konfektionstechnik", study_programs_matched_by_llm$studiengang_de, ignore.case = TRUE)
] <- "Textiles (clothes, footwear and leather)"

study_programs_matched_by_llm$matched_studiengang_en[
  study_programs_matched_by_llm$studiengang_de == "Ernährung (Realschule/ Sek.I)"] <- "Food processing"






#________________________________________________________
# Zusammenführen & Exportieren


# merge with isced 2 and 1 digits
# Umbenennen
names(study_programs_matched_by_llm)[names(study_programs_matched_by_llm) == "matched_studiengang_en"] <- "Detailed_field"
names(study_programs_matched_by_llm)[names(study_programs_matched_by_llm) == "studiengang_de"] <- "Subject_orig"

# Merge der Datensätze
merged_df <- merge(isced_f_2013_table, study_programs_matched_by_llm, by = "Detailed_field", all.y = TRUE)

# merge with ds
merged_df2 <- merge(final_scientific_data, merged_df, by = "Subject_orig", all = TRUE)



# Extrahiere Kombinationen
#unique_combinations <- merged_df2 %>%
#  select(Subject, Subject_orig, Detailed_field) %>%
#  distinct()

# Exportiere als Excel-Datei
#write.xlsx(unique_combinations, "unique_subject_combinations.xlsx")


#___________________________________________________________________
#Excel einlesen und korrigieren 
isced_matching <- read_excel("data_input/ISCED_matching_corr.xlsx") 

merged_df2 <- merged_df2 %>%
  left_join(isced_matching, by = "Subject_orig", suffix = c("", "_kor")) %>%
  mutate(
    Detailed_field = ifelse(!is.na(Detailed_field_kor) & Detailed_field_kor != "", 
                            Detailed_field_kor, 
                            Detailed_field),
    Detailed_field_code = ifelse(!is.na(Detailed_field_kor) & Detailed_field_kor != "", 
                                 NA, 
                                 Detailed_field_code),
    Narrow_field = ifelse(!is.na(Detailed_field_kor) & Detailed_field_kor != "", 
                          NA, 
                          Narrow_field),
    Narrow_field_code = ifelse(!is.na(Detailed_field_kor) & Detailed_field_kor != "", 
                               NA, 
                               Narrow_field_code),
    Broad_field = ifelse(!is.na(Detailed_field_kor) & Detailed_field_kor != "", 
                         NA, 
                         Broad_field),
    Broad_field_code = ifelse(!is.na(Detailed_field_kor) & Detailed_field_kor != "", 
                              NA, 
                              Broad_field_code)
  ) %>%
  select(-Detailed_field_kor)


# Merge der Datensätze
merged_df2 <- left_join(merged_df2, isced_f_2013_table, by = "Detailed_field")
merged_df2 <- merged_df2 %>%
  mutate(
    Broad_field = Broad_field.y,
    Broad_field_code = Broad_field_code.y,
    Narrow_field = Narrow_field.y,
    Narrow_field_code = Narrow_field_code.y,
    Detailed_field_code = Detailed_field_code.y
  ) %>%
  select(-ends_with(".x"), -ends_with(".y"))



#Teacher Training

#teacher-related pattern
teacher_pattern <- " LA |Gymnasium|Sek\\.|schule|Primar|Berufl\\. S|Lehramt|Gym\\.|Sekundar| GYM"

#specific exclusions for non-subject-specialised teacher training
non_subject_specialisations <- c(
  "Lehramt an beruflichen Schulen",
  "Lehramt an Grund- und Hauptschulen",
  "Lehramt an Sonderschulen",
  "Berufsschullehramt",
  "Sonderpäd"
)

# Define conditions for replacement
teacher_with_subject <- grepl(teacher_pattern, merged_df2$Subject_orig) &
  !grepl(paste(non_subject_specialisations, collapse = "|"), merged_df2$Subject_orig)

teacher_without_subject <- grepl(paste(non_subject_specialisations, collapse = "|"), merged_df2$Subject_orig)

# Apply correction
merged_df2 <- merged_df2 %>%
  mutate(
    Detailed_field = case_when(
      teacher_with_subject ~ "Teacher training with subject specialisation",
      teacher_without_subject ~ "Teacher training without subject specialisation",
      TRUE ~ Detailed_field
    ),
    Narrow_field = case_when(
      teacher_with_subject | teacher_without_subject ~ "",
      TRUE ~ Narrow_field
    ),
    Broad_field = case_when(
      teacher_with_subject | teacher_without_subject ~ "",
      TRUE ~ Broad_field
    ),
    Detailed_field_code = case_when(
      teacher_with_subject | teacher_without_subject ~ "",
      TRUE ~ Detailed_field_code
    ),
    Narrow_field_code = case_when(
      teacher_with_subject | teacher_without_subject ~ "",
      TRUE ~ Narrow_field_code
    ),
    Broad_field_code = case_when(
      teacher_with_subject | teacher_without_subject ~ "",
      TRUE ~ Broad_field_code
    )
  )


# Merge der Datensätze
merged_df2 <- left_join(merged_df2, isced_f_2013_table, by = "Detailed_field")
merged_df2 <- merged_df2 %>%
  mutate(
    Broad_field = Broad_field.y,
    Broad_field_code = Broad_field_code.y,
    Narrow_field = Narrow_field.y,
    Narrow_field_code = Narrow_field_code.y,
    Detailed_field_code = Detailed_field_code.y
  ) %>%
  select(-ends_with(".x"), -ends_with(".y"))



#missing <- merged_df2 %>%
 # filter(is.na(Detailed_field_code)) %>%
  #distinct(Detailed_field)



#___________________________________________________________________________####
# Export                                                                    ####
#reorder variables
merged_df2 <- merged_df2 %>%
  select(Year, Type, HE_name_orig, Subject_orig, Study_Type, HE_number, HE_name_destat, 
         HE_name_destat_last, HE_change, Subject, Subject_area, Subject_group, 
         Subject_code, Subject_area_code, Subject_group_code, AGS, Location_name,
         Detailed_field, Narrow_field, Broad_field, Detailed_field_code, Narrow_field_code, Broad_field_code)


write_csv(merged_df2, "data_final\\RWI-UNI-SUBJECTS_prefinal.csv")

