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
setwd("N:/StudiBUCH/RWI-UNI-SUBJECTS-main/RWI-UNI-SUBJECTS-main/data_enrichment")
isced_f_2013_table <- read_csv("data_output/isced_f_2013_table.csv")

study_programs_matched_by_llm <- read_csv("data_output/study_programs_matched_by_llm.csv")

final_scientific_data <- read_csv("data_final\\RWI-UNI-SUBJECTS_pre_isced.csv")



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

languages <- c("Dänisch", "Russisch", "Italienisch", "Amerikanistik", "Schwedisch", "Anglistik", "Spanisch", "Deutsch", "Frisisch", "Französisch", "Griechisch", "Latein", "Niederländisch")
study_programs_matched_by_llm$matched_studiengang_en[
  grepl(paste(languages, collapse = "|"), study_programs_matched_by_llm$studiengang_de, ignore.case = TRUE)
] <- "Literature and linguistics"

study_programs_matched_by_llm$matched_studiengang_en[
  grepl("arbeitslehre", study_programs_matched_by_llm$studiengang_de, ignore.case = TRUE)
] <- "Work skills"

study_programs_matched_by_llm$matched_studiengang_en[
  grepl("Antropologie", study_programs_matched_by_llm$studiengang_de, ignore.case = TRUE)
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
  grepl("Betriebswirtschaft(slehre)", study_programs_matched_by_llm$studiengang_de)
] <- "Management and administration"

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
  grepl("Polnisch LA SekundarS I", study_programs_matched_by_llm$studiengang_de, ignore.case = TRUE)
] <- "Literature and linguistics"

study_programs_matched_by_llm$matched_studiengang_en[
  grepl("Polnisch LA SekundarS II", study_programs_matched_by_llm$studiengang_de, ignore.case = TRUE)
] <- "Literature and linguistics"

study_programs_matched_by_llm$matched_studiengang_en[
  grepl("Spanisch LA SekundarS II", study_programs_matched_by_llm$studiengang_de, ignore.case = TRUE)
] <- "Literature and linguistics"

study_programs_matched_by_llm$matched_studiengang_en[
  grepl("Russisch LA SekundarS II", study_programs_matched_by_llm$studiengang_de, ignore.case = TRUE)
] <- "Literature and linguistics"

study_programs_matched_by_llm$matched_studiengang_en[
  grepl("Italienisch LA SekundarS II", study_programs_matched_by_llm$studiengang_de, ignore.case = TRUE)
] <- "Literature and linguistics"

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


   

# merge with isced 2 and 1 digits
# Umbenennen
names(study_programs_matched_by_llm)[names(study_programs_matched_by_llm) == "matched_studiengang_en"] <- "Detailed_field"
names(study_programs_matched_by_llm)[names(study_programs_matched_by_llm) == "studiengang_de"] <- "Subject_orig"

# Merge der Datensätze
merged_df <- merge(isced_f_2013_table, study_programs_matched_by_llm, by = "Detailed_field", all.y = TRUE)

# merge with ds
merged_df2 <- merge(final_scientific_data, merged_df, by = "Subject_orig", all = TRUE)


#___________________________________________________________________________####
# Export                                                                    ####
#reorder variables
merged_df2 <- merged_df2 %>%
  select(Year, Type, HE_name_orig, Subject_orig, Study_Type, HE_number, HE_name_destat, 
         HE_name_destat_last, HE_change, Subject, Subject_area, Subject_group, 
         Subject_code, Subject_area_code, Subject_group_code, AGS, Location_name,
         Detailed_field, Narrow_field, Broad_field, Detailed_field_code, Narrow_field_code, Broad_field_code)


write_csv(merged_df2, "data_final\\RWI-UNI-SUBJECTS_prefinal.csv")

