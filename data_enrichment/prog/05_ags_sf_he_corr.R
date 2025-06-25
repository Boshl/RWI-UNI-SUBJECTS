#___________________________________________________________________________####
# Project                                                                   ####
#
# Project-Title: RWI-UNI-SUBJECTS (Dataset)
#
# Filename of Code: 08_ags_sf_he_check.R
#
# Filename(s) of Input-File(s): - HEI_and_subjects_1971-1996_v2.dta
#
# Filename(s) of Output-File(s): - HEI_and_subjects_1971-1996_v2_saved.dta
#
# Short description: Order dataframe and conduct corrections
#
#
# Software Version: R 4.4.2

#___________________________________________________________________________####
# Preparation                                                               ####

library(readxl)
library(dplyr)
library(writexl)
library(haven)
library(openxlsx)

df <- read.csv("data_final/panel.csv")


df <- select(df, Typ, Jahr, HE, Stadt_full_duplicated, Studienfach_orig, 
                sf_3_code, sf_2_code, sf_1_code, sf_3, sf_2, sf_1, HS_number, 
                name_for_number, Last_name, HE_Change, AGS, value)

# Reordering variables
df <- df[,c(2,1,3,12,13,5, 6,7,8,9,10,11,16,4,14,15, 17)]

# Rest of codes has to remain character as it has leading zeros
df$sf_1_code <- as.numeric(df$sf_1_code)

# Rename variables
names(df)[1] <- "Year"
names(df)[2] <- "Type"
names(df)[3] <- "HE_name_orig"
names(df)[4] <- "HE_number"
names(df)[5] <- "HE_name_destat"
names(df)[6] <- "Subject_orig"
names(df)[7] <- "Subject_code"
names(df)[8] <- "Subject_area_code"
names(df)[9] <- "Subject_group_code"
names(df)[10] <- "Subject"
names(df)[11] <- "Subject_area"
names(df)[12] <- "Subject_group"
names(df)[13] <- "AGS"
names(df)[14] <- "Location_name"
names(df)[15] <- "HE_name_destat_last"
names(df)[16] <- "HE_change"
names(df)[17] <- "Study_Type"

# Rename types:
df$Type <- ifelse(df$Type == "FH", "UAS", df$Type)
df$Type <- ifelse(df$Type == "Uni", "university", df$Type)


# Corrections (HiWi 1)                                                      ####

df$AGS[df$HE_name_orig=="Weiden FH" & df$HE_name_destat=="Ostbayerische TH Amberg-Weiden in Weiden (FH)"]<-"09363"
df$AGS_name[df$HE_name_orig=="Weiden FH" & df$HE_name_destat=="Ostbayerische TH Amberg-Weiden in Weiden (FH)"]<-"Weiden in der Oberpfalz"

df$AGS[df$HE_name_orig=="Hof FH" & df$HE_name_destat=="H für angewandte Wissenschaften Hof in Hof (FH)"]<-"09464"
df$AGS_name[df$HE_name_orig=="Hof FH" & df$HE_name_destat=="H für angewandte Wissenschaften Hof in Hof (FH)"]<-"Hof"

df$AGS[df$HE_name_orig=="Weilheim (Bierbronnen GSA)" & df$HE_name_destat=="Priv. wissenschaftliche H Bierbronnen"]<-"08337"
df$AGS_name[df$HE_name_orig=="Weilheim (Bierbronnen GSA)" & df$HE_name_destat=="Priv. wissenschaftliche H Bierbronnen"]<-"Weilheim (Baden)"
df$AGS[df$HE_name_orig=="Fachhochschule Ulm in Geislingen" & df$HE_name_destat=="Technische Hochschule Ulm (FH)"]<-"08117"
df$AGS_name[df$HE_name_orig=="Fachhochschule Ulm in Geislingen" & df$HE_name_destat=="Technische Hochschule Ulm (FH)"]<-"Geislingen an der Steige"

df$AGS[df$HE_name_orig=="Hochschule Nürtingen in Geislingen (FH)" & df$HE_name_destat=="Hochschule Nürtingen in Geislingen (FH)"]<-"08117"
df$AGS_name[df$HE_name_orig=="Hochschule Nürtingen in Geislingen (FH)" & df$HE_name_destat=="Hochschule Nürtingen in Geislingen (FH)"]<-"Geislingen an der Steige"

df$AGS[df$HE_name_orig=="Bingen FH" & df$HE_name_destat=="Technische Hochschule Bingen (FH)"]<-"07339"
df$AGS_name[df$HE_name_orig=="Bingen FH" & df$HE_name_destat=="Technische Hochschule Bingen (FH)"]<-"Bingen am Rhein"

df$AGS[df$HE_name_orig=="Schneeberg FH" & df$HE_name_destat=="Westsächsische H Zwickau in Schneeberg (FH)"]<-"14521"
df$AGS_name[df$HE_name_orig=="Schneeberg FH" & df$HE_name_destat=="Westsächsische H Zwickau in Schneeberg (FH)"]<-"Schneeberg"

df$AGS[df$HE_name_orig=="Friedberg FH" & df$HE_name_destat=="Techn. H Mittelhessen (THM) in Friedberg (FH)"]<-"06440"
df$AGS_name[df$HE_name_orig=="Friedberg FH" & df$HE_name_destat=="Techn. H Mittelhessen (THM) in Friedberg (FH)"]<-"Friedberg (Hessen)"

df$AGS[df$HE_name_orig=="Friedberg FH_gesamt"]<-"06440"
df$AGS_name[df$HE_name_orig=="Friedberg FH_gesamt"]<-"Friedberg (Hessen)"

df$AGS[df$HE_name_orig=="Landsberg FH_gesamt"]<-"09181"
df$AGS_name[df$HE_name_orig=="Landsberg FH_gesamt"]<-"Landsberg am Lech"

df$AGS[df$HE_name_orig=="Bingen FH_gesamt"]<-"07339"
df$AGS_name[df$HE_name_orig=="Bingen FH_gesamt"]<-"Bingen am Rhein"

df$AGS[df$City=="Oldenburg"]<-"03403"
df$AGS[df$City=="Göttingen"]<-"03159"
df$AGS[df$City=="Hagen"]<-"05914"
df$AGS[df$City=="Halle"]<-"15002"
df$AGS[df$City=="Weilheim"]<-"08337"
df$AGS[df$City=="Triesdorf"]<-"09571"

df$City[df$HE_name_destat=="Wiss. H f. Unternehmensführung Vallendar (Priv. U)" & df$Year >= "1988"]<-"Vallendar" #WHU ist im Jahr 1988 nach Vallendar umgezogen
df$AGS[df$City=="Vallendar" & df$HE_name_destat=="Wiss. H f. Unternehmensführung Vallendar (Priv. U)"]<-"07137"

df$AGS[df$HE_name_orig=="Naumburg KH"]<-"15084"
df$AGS_name[df$HE_name_orig=="Naumburg KH"]<-"Naumburg (Saale)"

df$City[df$City=="Wodel"]<-"Wedel"
df$City[df$AGS=="04012"]<-"Bremerhaven"

df$City[df$HE_name_orig=="Nordostniedersachsen FH_gesamt"]<-"Buxtehude"
df$AGS[df$HE_name_orig=="Nordostniedersachsen FH_gesamt"]<- "03359"

df$City[df$HE_name_orig=="Lahr Beruf FH" & df$HE_name_destat=="Allensbach Hochschule Konstanz (Priv. FH)"]<-"Lahr/Schwarzwald" 
df$AGS[df$City=="Lahr/Schwarzwald"]<-"08317"

df$AGS[df$HE_name_orig=="Eßlingen FH_gesamt"]<-"08116"
df$AGS_name[df$HE_name_orig=="Eßlingen FH_gesamt"]<-"Esslingen am Neckar"

df$AGS[df$HE_name_orig=="Biberach FH" & df$HE_name_destat=="Hochschule Biberach a. d. Riss (FH)"]<-"08426"
df$AGS_name[df$HE_name_orig=="Biberach FH" & df$HE_name_destat=="Hochschule Biberach a. d. Riss (FH)"]<-"Biberach an der Riß"

# Corrections (HiWi 2)                                                      ####

df$HE_number[df$HE_name_destat=="Charlotte Fresenius H Wiesb. in Wiesbaden (Priv.U)"]<-6289

# Corrections (HiWi 3)                                                      ####

df$Subject_code[df$Subject_orig=="Schulgartenunterricht LA GS"]<-"254"
df$Subject[df$Subject_orig=="Schulgartenunterricht LA GS"]<-"Sachunterricht (einschl. Schulgarten)"
df$Subject_area_code[df$Subject_orig=="Schulgartenunterricht LA GS"]<-"33"
df$Subject_area[df$Subject_orig=="Schulgartenunterricht LA GS"]<-"Erziehungswissenschaften"
df$Subject_group_code[df$Subject_orig=="Schulgartenunterricht LA GS"]<-"3"
df$Subject_group[df$Subject_orig=="Schulgartenunterricht LA GS"]<-"Rechts- Wirtschafts- und Sozialwissenschaften"


df$Subject_code[df$Subject_orig=="Heimat- und Sachunterricht LA GS"]<-"254"
df$Subject[df$Subject_orig=="Heimat- und Sachunterricht LA GS"]<-"Sachunterricht (einschl. Schulgarten)"
df$Subject_area_code[df$Subject_orig=="Heimat- und Sachunterricht LA GS"]<-"33"
df$Subject_area[df$Subject_orig=="Heimat- und Sachunterricht LA GS"]<-"Erziehungswissenschaften"
df$Subject_group_code[df$Subject_orig=="Heimat- und Sachunterricht LA GS"]<-"3"
df$Subject_group[df$Subject_orig=="Heimat- und Sachunterricht LA GS"]<-"Rechts- Wirtschafts- und Sozialwissenschaften"

df$Subject_code[df$Subject_orig=="Sachunterricht LA SoS"]<-"254"
df$Subject[df$Subject_orig=="Sachunterricht LA SoS"]<-"Sachunterricht (einschl. Schulgarten)"
df$Subject_area_code[df$Subject_orig=="Sachunterricht LA SoS"]<-"33"
df$Subject_area[df$Subject_orig=="Sachunterricht LA SoS"]<-"Erziehungswissenschaften"
df$Subject_group_code[df$Subject_orig=="Sachunterricht LA SoS"]<-"3"
df$Subject_group[df$Subject_orig=="Sachunterricht LA SoS"]<-"Rechts- Wirtschafts- und Sozialwissenschaften"

df$Subject_code[df$Subject_orig=="Sachunterricht LA PrimarS"]<-"254"
df$Subject[df$Subject_orig=="Sachunterricht LA PrimarS"]<-"Sachunterricht (einschl. Schulgarten)"
df$Subject_area_code[df$Subject_orig=="Sachunterricht LA PrimarS"]<-"33"
df$Subject_area[df$Subject_orig=="Sachunterricht LA PrimarS"]<-"Erziehungswissenschaften"
df$Subject_group_code[df$Subject_orig=="Sachunterricht LA PrimarS"]<-"3"
df$Subject_group[df$Subject_orig=="Sachunterricht LA PrimarS"]<-"Rechts- Wirtschafts- und Sozialwissenschaften"

df$Subject_code[df$Subject_orig=="Sachunterricht LA GS"]<-"254"
df$Subject[df$Subject_orig=="Sachunterricht LA GS"]<-"Sachunterricht (einschl. Schulgarten)"
df$Subject_area_code[df$Subject_orig=="Sachunterricht LA GS"]<-"33"
df$Subject_area[df$Subject_orig=="Sachunterricht LA GS"]<-"Erziehungswissenschaften"
df$Subject_group_code[df$Subject_orig=="Sachunterricht LA GS"]<-"3"
df$Subject_group[df$Subject_orig=="Sachunterricht LA GS"]<-"Rechts- Wirtschafts- und Sozialwissenschaften"

df$Subject_code[df$Subject_orig=="Sachunterricht LA GS/HS"]<-"254"
df$Subject[df$Subject_orig=="Sachunterricht LA GS/HS"]<-"Sachunterricht (einschl. Schulgarten)"
df$Subject_area_code[df$Subject_orig=="Sachunterricht LA GS/HS"]<-"33"
df$Subject_area[df$Subject_orig=="Sachunterricht LA GS/HS"]<-"Erziehungswissenschaften"
df$Subject_group_code[df$Subject_orig=="Sachunterricht LA GS/HS"]<-"3"
df$Subject_group[df$Subject_orig=="Sachunterricht LA GS/HS"]<-"Rechts- Wirtschafts- und Sozialwissenschaften"

df$Subject_code[df$Subject_orig=="Medienwirtschaft"]<-"304"
df$Subject[df$Subject_orig=="Medienwirtschaft"]<-"Medienwirtschaft/Medienmanagement"
df$Subject_area_code[df$Subject_orig=="Medienwirtschaft"]<-"30"
df$Subject_area[df$Subject_orig=="Medienwirtschaft"]<-"Wirtschaftswissenschaften"
df$Subject_group_code[df$Subject_orig=="Medienwirtschaft"]<-"3"
df$Subject_group[df$Subject_orig=="Medienwirtschaft"]<-"Rechts- Wirtschafts- und Sozialwissenschaften"

df$Subject_code[df$Subject_orig=="Medien/-wissenschaft D"]<-"302"
df$Subject[df$Subject_orig=="Medien/-wissenschaft D"]<-"Medienwissenschaft"

df$Subject_code[df$Subject_orig=="Medien/-wissenschaft M"]<-"302"
df$Subject[df$Subject_orig=="Medien/-wissenschaft M"]<-"Medienwissenschaft"

df$Subject_code[df$Subject_orig=="Ost(Südost)europastudien/-geschichte M"]<-"044"
df$Subject[df$Subject_orig=="Ost(Südost)europastudien/-geschichte M"]<-"Ost- und Südosteuropa-Studien"
df$Subject_area_code[df$Subject_orig=="Ost(Südost)europastudien/-geschichte M"]<-"24"
df$Subject_area[df$Subject_orig=="Ost(Südost)europastudien/-geschichte M"]<-"Regionalwissenschaften"
df$Subject_group_code[df$Subject_orig=="Ost(Südost)europastudien/-geschichte M"]<-"3"
df$Subject_group[df$Subject_orig=="Ost(Südost)europastudien/-geschichte M"]<-"Rechts- Wirtschafts- und Sozialwissenschaften"

df$Subject_area_code[df$Subject_orig=="Lehramt an Sonderschulen"]<-"33"
df$Subject_area[df$Subject_orig=="Lehramt an Sonderschulen"]<-"Erziehungswissenschaften"
df$Subject_group_code[df$Subject_orig=="Lehramt an Sonderschulen"]<-"3"
df$Subject_group[df$Subject_orig=="Lehramt an Sonderschulen"]<-"Rechts- Wirtschafts- und Sozialwissenschaften"

df$Subject_area_code[df$Subject_orig=="Lehramt an beruflichen Schulen"]<-"33"
df$Subject_area[df$Subject_orig=="Lehramt an beruflichen Schulen"]<-"Erziehungswissenschaften"
df$Subject_group_code[df$Subject_orig=="Lehramt an beruflichen Schulen"]<-"3"
df$Subject_group[df$Subject_orig=="Lehramt an beruflichen Schulen"]<-"Rechts- Wirtschafts- und Sozialwissenschaften"

df$Subject_area_code[df$Subject_orig=="Lehramt an Grund- und Hauptschulen"]<-"33"
df$Subject_area[df$Subject_orig=="Lehramt an Grund- und Hauptschulen"]<-"Erziehungswissenschaften"
df$Subject_group_code[df$Subject_orig=="Lehramt an Grund- und Hauptschulen"]<-"3"
df$Subject_group[df$Subject_orig=="Lehramt an Grund- und Hauptschulen"]<-"Rechts- Wirtschafts- und Sozialwissenschaften"


#Journalsitik
df$Subject_code[df$Subject_orig=="Publizistik, Journalistik, Lektorat"]<-"303"
df$Subject[df$Subject_orig=="Publizistik, Journalistik, Lektorat"]<-"Kommunikationswissenschaft/Publizistik"
df$Subject_area_code[df$Subject_orig=="Publizistik, Journalistik, Lektorat"]<-"34"
df$Subject_area[df$Subject_orig=="Publizistik, Journalistik, Lektorat"]<-"Kommunikationswissenschaft/Publizistik"
df$Subject_group_code[df$Subject_orig=="Publizistik, Journalistik, Lektorat"]<-"3"
df$Subject_group[df$Subject_orig=="Publizistik, Journalistik, Lektorat"]<-"Rechts- Wirtschafts- und Sozialwissenschaften"

df$Subject_code[df$Subject_orig=="Journalistik"]<-"303"
df$Subject[df$Subject_orig=="Journalistik"]<-"Kommunikationswissenschaft/Publizistik"
df$Subject_area_code[df$Subject_orig=="Journalistik"]<-"34"
df$Subject_area[df$Subject_orig=="Journalistik"]<-"Kommunikationswissenschaft/Publizistik"
df$Subject_group_code[df$Subject_orig=="Journalistik"]<-"3"
df$Subject_group[df$Subject_orig=="Journalistik"]<-"Rechts- Wirtschafts- und Sozialwissenschaften"

df$Subject_code[df$Subject_orig=="Journalistik M"]<-"303"
df$Subject[df$Subject_orig=="Journalistik M"]<-"Kommunikationswissenschaft/Publizistik"
df$Subject_area_code[df$Subject_orig=="Journalistik M"]<-"34"
df$Subject_area[df$Subject_orig=="Journalistik M"]<-"Kommunikationswissenschaft/Publizistik"
df$Subject_group_code[df$Subject_orig=="Journalistik M"]<-"3"
df$Subject_group[df$Subject_orig=="Journalistik M"]<-"Rechts- Wirtschafts- und Sozialwissenschaften"

df$Subject_code[df$Subject_orig=="Journalistik D"]<-"303"
df$Subject[df$Subject_orig=="Journalistik D"]<-"Kommunikationswissenschaft/Publizistik"
df$Subject_area_code[df$Subject_orig=="Journalistik D"]<-"34"
df$Subject_area[df$Subject_orig=="Journalistik D"]<-"Kommunikationswissenschaft/Publizistik"
df$Subject_group_code[df$Subject_orig=="Journalistik D"]<-"3"
df$Subject_group[df$Subject_orig=="Journalistik D"]<-"Rechts- Wirtschafts- und Sozialwissenschaften"

#___________________________________________________________________________####
# Export                                                                    ####

write.csv(df, "data_final/panel_corr.csv", row.names = FALSE)

