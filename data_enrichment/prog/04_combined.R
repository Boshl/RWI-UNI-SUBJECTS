#___________________________________________________________________________####
# Project                                                                   ####
#
# Project-Title: RWI-UNI-SUBJECTS (Dataset)
#
# Filename of Code: 04_combined.R
#
# Filename(s) of Input-File(s): - uni_results.xlsx
#                               - fh_results.xlsx
#                               - other_results.xlsx
#                               - 01_full_stadt_namen_harmonisiert.xlsx
#                               - 01_full_he_namen_harmonisiert.xlsx
#                               - he_namen_for_HS_Nummern.xlsx
#                               - HS_Nummern.xlsx
#                               - 01_full_sf_namen_harmonisiert.xlsx
#                               - studenten-pruefungsstatistik.xlsx
#                               - Kopie von StadtOhneAGS.xlsx
#                               - Kopie von Kopie von 01_full_stadt_namen_harmonisiert_Alina.xlsx
#                               - kreis_namen_2013.xlsx
#
# Filename(s) of Output-File(s): - 01_full_sf_namen.xlsx 
#                                - 01_full_stadt_namen.xlsx 
#                                - 01_full_he_namen.xlsx
#                                - 01_full_he_namen_orig.xlsx 
#                                - 01_name_ganz.xlsx
#                                - StadtOhneAGS.xlsx 
#                                - double.xlsx 
#                                - panel.csv
#
# Short description: Reads uni and fh panel and generates the full panel.(Panel
#                    with harmonized HE names/SF/AGS)
#
# Last Change: 10.02.2025
#
# Editor: Serife Yasar
# E-Mail: Serife.Yasar@rwi-essen.de
#
# Software Version: R 4.4.2

#___________________________________________________________________________####
# Preparation                                                               ####

library(reshape2)
library(readxl)
library(dplyr)
library(writexl)
library(ggplot2)
library(readr)
library(data.table)

# Import                                                                    ####

## Uni                                                                      ####

# Read Uni data 
uni <- read_excel("data_output\\uni_results.xlsx")

### Corrections                                                             ####

# Correct names such that they are according to Studibuch

# Hannover H in Excel is actually Hannover TU in StudiBuch; 
# and Hannover Uni in Excel is actually Hannover H (which is MedHo)

# Correction 1:
uni$HE <- ifelse(
  uni$HE == "Hannover H" & uni$Jahr == "1971", 
  "Hannover TU", 
  ifelse(
    uni$HE == "Hannover Uni" & uni$Jahr == "1971", 
    "Hannover H", 
    uni$HE
  )
)

# Correction 2:
uni$name_orig <- ifelse(
  uni$name_orig == "Hannover H" & uni$Jahr == "1971", 
  "Hannover TU", 
  ifelse(
    uni$name_orig == "Hannover Uni" & uni$Jahr == "1971", 
    "Hannover H", 
    uni$name_orig
  )
)

# Rename HEs from 1971 according to their names in Studibuch

# all that do not have extra abbreviation: add U
uni$HE <- ifelse(
  !(uni$HE %in% c("Braunschweig", "Clausthal", "Aachen", "Darmstadt", 
                  "Karlsruhe", "Berlin FU", "Berlin TU", "Hannover H", 
                  "Hannover TiHo", "Hannover Uni", "München TU", "Kassel")) & 
    uni$Jahr == "1971",
    paste0(uni$HE, " U"),
    uni$HE
)

# all that do not have extra abbreviation: add TH
uni$HE <- ifelse(
  uni$HE %in% c("Aachen", "Darmstadt", "Karlsruhe") & uni$Jahr == "1971",
  paste0(uni$HE, " TH"),
  uni$HE
)

# all that do not have extra abbreviation: add TU
uni$HE <- ifelse(
  uni$HE %in% c("Braunschweig", "Clausthal") & uni$Jahr == "1971",
  paste0(uni$HE, " TU"),
  uni$HE
)

# all that do not have extra abbreviation: add GH
uni$HE <- ifelse(
  uni$HE == "Kassel" & uni$Jahr == "1971",
  paste0(uni$HE, " GH"),
  uni$HE
)

# Rename HEs from 1972 according to their name in Studibuch
uni$HE <- ifelse(
  !(uni$HE %in% c("Braunschweig", "Clausthal TU", "Aachen TH", "Darmstadt", 
                  "Berlin FU", "Berlin TH", "Hannover TU", "Hannover TiHo", 
                  "Hannover  MedHo", "München TU", "Kassel", "Bamberg")) & 
    uni$Jahr == "1972",
    paste0(uni$HE, " U"),
    uni$HE
)

uni$HE <- ifelse(
  uni$HE  %in% c("Kassel", "Bamberg") & uni$Jahr == "1972",
  paste0(uni$HE, " GH"),
  uni$HE
)

uni$HE <- ifelse(
  uni$HE == "Braunschweig" & uni$Jahr == "1972",
  paste0(uni$HE, " TU"),
  uni$HE
)

# Wrong name
uni$HE <- ifelse(
  uni$HE == "Berlin TH" & uni$Jahr == "1972",
  "Berlin TU",
  uni$HE
)

# Rename some HEs from 1976 according to their name in Studibuch; others are
# already as in Studibuch
uni$HE <- ifelse(
  uni$HE %in% c("Augsburg", "Kiel", "Köln", "Ulm") & uni$Jahr == "1976",
  paste0(uni$HE, " U"),
  uni$HE
)

uni$HE <- ifelse(
  uni$HE == "Aachen" & uni$Jahr == "1976",
  paste0(uni$HE, " TH"),
  uni$HE
)

# Rename some HEs from 1977 according to their name in Studibuch; others are 
# already as in Studibuch
uni$HE <- ifelse(
  uni$HE %in% c("Kassel","Siegen") & uni$Jahr == "1977",
  paste0(uni$HE, " GH"),
  uni$HE
)

uni$HE <- ifelse(
  uni$HE == "Köln" & uni$Jahr == "1977",
  paste0(uni$HE, " U"),
  uni$HE
)

# Rename HEs from 1985 according to their name in Studibuch
uni$HE <- ifelse(
  !(uni$HE %in% c("Braunschweig", "Clausthal", "Aachen", "Darmstadt", 
                  "Berlin...21", "Berlin...22", "Hannover...34", 
                  "Hannover...35", "Hamburg-Harburg", "München...17", "Kassel", 
                  "Duisburg", "Essen", "Paderborn", "Siegen", "Wuppertal", 
                  "Hildesheim", "Lüneburg", "Hagen", "Lübeck")) & 
    uni$Jahr == "1985",
    paste0(uni$HE, " U"),
    uni$HE
)

uni$HE <- ifelse(
  uni$HE == "Lübeck" & uni$Jahr == "1985",
  paste0(uni$HE, " MeU"),
  uni$HE
)

uni$HE <- ifelse(
  uni$HE == "Hagen" & uni$Jahr == "1985", 
  paste0(uni$HE, " FernU"),
  uni$HE
)

uni$HE <- ifelse(
  uni$HE %in% c("Hildesheim", "Lüneburg") & uni$Jahr == "1985",
  paste0(uni$HE, " HS"),
  uni$HE
)

uni$HE <- ifelse(
  uni$HE == "Hannover...35" & uni$Jahr == "1985",
  paste0(uni$HE, " TiHo"),
  uni$HE
)

uni$HE <- ifelse(
  uni$HE == "Hannover...34" & uni$Jahr == "1985",
  paste0(uni$HE, " MeHo"),
  uni$HE
)

uni$HE <- ifelse(
  uni$HE == "Berlin...21" & uni$Jahr == "1985",
  paste0(uni$HE, " FU"),
  uni$HE
)

uni$HE <- ifelse(
  uni$HE %in% c("Aachen", "Darmstadt") & uni$Jahr == "1985",
  paste0(uni$HE, " TH"),
  uni$HE
)

uni$HE <- ifelse(
  uni$HE %in% c("Braunschweig", "Clausthal", "Hamburg-Harburg", "München...17", 
                "Berlin...22") & uni$Jahr == "1985",
  paste0(uni$HE, " TU"),
  uni$HE
)

uni$HE <- ifelse(
  uni$HE %in% c("Kassel", "Duisburg", "Essen", "Paderborn", "Siegen", 
                "Wuppertal") & uni$Jahr == "1985",
  paste0(uni$HE, " U-GH"),
  uni$HE
)

# Extract three dots plus number from names; e.g. München...16 U to München U;
uni$HE <- ifelse(uni$Jahr == "1985", gsub("\\.{3}\\d*", "", uni$HE), uni$HE)

## FH                                                                       ####

# Read FH data
fh <- read_excel("data_output\\fh_results.xlsx")

# Identify duplicated names ending with ...
names_double_FH <- as.data.frame(unique(fh$HE[grep("\\.{3}", fh$HE)]))
names(names_double_FH)[1] <- "names"

# As character
cities_doubleFH <- unique(gsub("\\.{3}\\d*", "", names_double_FH$names))
name_has_already_FH <- unique(fh$HE)
name_has_already_FH <- name_has_already_FH[name_has_already_FH %like% "FH"]
names_with_dots <- unique(fh$HE[grep("\\.{3}", fh$HE)])

Bundesländer <- c(
  "Baden-Württemberg", "Bayern", "Berlin", "Brandenburg", "Bremen", "Hamburg", 
  "Hessen", "Niedersachsen","Mecklenburg-Vorpommern", "Nordrhein-Westfalen", 
  "Rheinland-Pfalz", "Saarland", "Sachsen", "Sachsen-Anhalt", 
  "Schleswig-Holstein", "Thüringen"
)

### Corrections                                                             ####

# Add FH to name unless name is included at least twice (cities_double_FH and 
# names_with_dots) and unless the name already has FH in its name and unless the 
# name is just the name of a Bundesland. This might not be the actual name of 
# the FH, but it helps with the identification and prevents mistakes during the 
# Harmonisierung
fh$HE <- ifelse(
  !(fh$HE %in% cities_doubleFH) & !(fh$HE %in% names_with_dots) & 
    !(fh$HE %in% name_has_already_FH) & !(fh$HE %in% Bundesländer),
  paste0(fh$HE, " FH"),
  fh$HE
)

# Treat Stadtstaaten-FHs separately: Berlin, Bremen, Hamburg, but also 
# Brandenburg as those are the assigned names of some FHs
fh$HE <- ifelse(fh$HE == "Berlin" & fh$Jahr < "1986", "Berlin FH", fh$HE)
fh$HE <- ifelse(fh$HE == "Bremen" & fh$Jahr < "1986", "Bremen FH", fh$HE)
fh$HE <- ifelse(fh$HE == "Hamburg", "Hamburg FH", fh$HE)
fh$HE <- ifelse(fh$HE == "Brandenburg", "Brandenburg FH", fh$HE)

names_FH <- as.data.frame(unique(fh$HE))

# Manually correct all names with dots and Geislingen (2) FH - check with 
# STUDIBuch

names_double_FH <- mutate(names_double_FH, true_name = "NA")
names(names_double_FH)[1] <- "HE"

# Aachen Aachen...113, Aachen...114, Aachen...116, Aachen...117, Aachen...118, 
# Aachen...120, Aachen...123, Aachen...133, Aachen...135, Aachen...141, 
# Aachen...142, Aachen...147,Aachen...94, Aachen...96, Aachen...98
Aachen <- names_with_dots[names_with_dots %like% "Aachen"]
Aachen_subset <- filter(fh, HE %in% Aachen)

#which names are present in which years?
unique_combinations <- unique(Aachen_subset[, c("Jahr", "HE")])

fh$HE <- ifelse(
  fh$HE %in% c("Aachen...94", "Aachen...96", "Aachen...98", "Aachen...113", 
               "Aachen...120", "Aachen...123"), 
  "Aachen FH", 
  fh$HE
)

fh$HE <- ifelse(
  fh$HE == "Aachen...114" & fh$Jahr == "1993", 
  "Aachen FH",
  fh$HE
)

fh$HE <- ifelse(
  fh$HE %in% c("Aachen...116", "Aachen...117", "Aachen...118", "Aachen...133", 
               "Aachen...135", "Aachen...141","Aachen...142", "Aachen...147"), 
  "Kath. H Nordrhein-Westfalen in Aachen (FH)",
  fh$HE
)

fh$HE <- ifelse(
  fh$HE == "Aachen...114" & (fh$Jahr == "1986" | fh$Jahr == "1987"),
  "Kath. H Nordrhein-Westfalen in Aachen (FH)", 
  fh$HE
)

#HE name Aachen is then only Aachen FH
fh$HE <- ifelse(fh$HE == "Aachen", "Aachen FH", fh$HE)

# Göttingen: Göttingen...90, Göttingen...99
Göttingen <- names_with_dots[names_with_dots %like% "Göttingen"]
Göttingen <- filter(fh, HE %in% Göttingen)

#which names are present in which years?
Göttingen <- unique(Göttingen[, c("Jahr", "HE")])

names_double_FH$true_name <- ifelse(
  names_double_FH$HE == "Göttingen...90", 
  "H Hildesh./Holzminden/Göttingen in Göttingen (FH)", 
  names_double_FH$true_name
)
fh$HE <- ifelse(
  fh$HE == "Göttingen...90", 
  "H Hildesh./Holzminden/Göttingen in Göttingen (FH)", 
  fh$HE
)

# Wilhemshaven in Göttingen could not be found; only present in one year of the
# STUDIBuch
fh$HE <- ifelse(
  fh$HE == "Göttingen...99", 
  "FH Wilhelmshaven in Göttingen", 
  fh$HE
)

# HE name Göttingen is Hildesheim
fh$HE <- ifelse(
  fh$HE == "Göttingen",
  "H Hildesh./Holzminden/Göttingen in Göttingen (FH)", 
  fh$HE
)

#Rendsburg: Rendsburg...112, Rendsburg...114 , Rendsburg...111, Rendsburg...113, 
#           Rendsburg...146, Rendsburg...148, Rendsburg...149, Rendsburg...150, 
#           Rendsburg...151, Rendsburg...153
Rendsburg <- names_with_dots[names_with_dots %like% "Rendsburg"]
Rendsburg <- filter(fh, HE %in% Rendsburg)

#which names are present in which years?
Rendsburg <- unique(Rendsburg[, c("Jahr", "HE")])

# Name not clear; 
fh$HE <- ifelse(
  fh$HE %in% c("Rendsburg...111", "Rendsburg...112", "Rendsburg...146",
               "Rendsburg...149"), 
  "Kiel FH in Rendsburg", 
  fh$HE
)

fh$HE <- ifelse(
  fh$HE == "Rendsburg...148" & fh$Jahr == "1988", 
  "Kiel FH in Rendsburg", 
  fh$HE
)

fh$HE <- ifelse(
  fh$HE == "Rendsburg...148" & fh$Jahr == "1990", 
  "Kiel FH in Rendsburg", 
  fh$HE
)

fh$HE <- ifelse(
  fh$HE == "Rendsburg...151" & fh$Jahr == "1991", 
  "Kiel FH in Rendsburg", 
  fh$HE
)

# The respective second is probably "Rendsburg FH Beruf" - see Studibuch 1992, 1993
fh$HE <- ifelse(
  fh$HE %in% c("Rendsburg...113", "Rendsburg...114", "Rendsburg...150", 
               "Rendsburg...153"), 
  "Rendsburg FH Beruf", 
  fh$HE
)

fh$HE <- ifelse(
  fh$HE == "Rendsburg...148" & fh$Jahr == "1986", 
  "Rendsburg FH Beruf", 
  fh$HE
)

fh$HE <- ifelse(
  fh$HE == "Rendsburg...148" & fh$Jahr == "1987", 
  "Rendsburg FH Beruf", 
  fh$HE
)

fh$HE <- ifelse(
  fh$HE == "Rendsburg...151" & fh$Jahr == "1989", 
  "Rendsburg FH Beruf", 
  fh$HE
)

# Rendsburg is then only Kiel FH in Rendsburg
fh$HE <- ifelse(fh$HE == "Rendsburg", "Kiel FH in Rendsburg", fh$HE)

# Münster: Münster...115, Münster...117, Münster...118, Münster...119, 
#          Münster...121, Münster...123, Münster...124, Münster...125, 
#          Münster...134, Münster...136, Münster...140, Münster...142, 
#          Münster...143, Münster...148, Münster...149. Münster...154
Münster <- names_with_dots[names_with_dots %like% "Münster"]
Münster <- filter(fh, HE %in% Münster)
#which names are present in which years?

Münster <- unique(Münster[, c("Jahr", "HE")])

fh$HE <- ifelse(
  fh$HE %in% c("Münster...115", "Münster...117", "Münster...118", 
               "Münster...119", "Münster...134", "Münster...136", 
               "Münster...143"), 
  "Kath. H Nordrhein-Westfalen in Münster (FH)", 
  fh$HE
)

fh$HE <- ifelse(
  fh$HE == "Münster...142" & fh$Jahr == "1994", 
  "Kath. H Nordrhein-Westfalen in Münster (FH)", 
  fh$HE
)

fh$HE <- ifelse(
  fh$HE == "Münster...148" & fh$Jahr == "1996", 
  "Kath. H Nordrhein-Westfalen in Münster (FH)", 
  fh$HE
)

fh$HE <- ifelse(
  fh$HE %in% c("Münster...121", "Münster...123", "Münster...124", 
               "Münster...125", "Münster...140", "Münster...149", 
               "Münster...154"), 
  "Münster FH", 
  fh$HE
)

fh$HE <- ifelse(
  fh$HE == "Münster...142" & fh$Jahr == "1993", 
  "Münster FH", 
  fh$HE
)

fh$HE <- ifelse(
  fh$HE == "Münster...148" & fh$Jahr == "1994", 
  "Münster FH", 
  fh$HE
)

#Münster is then only Münster FH
fh$HE <- ifelse(fh$HE == "Münster", "Münster FH", fh$HE)

#Paderborn: Paderborn...116, Paderborn...118, Paderborn...119, Paderborn...120,
#           Paderborn...123, Paderborn...125, Paderborn...126, Paderborn...127, 
#           Paderborn...135, Paderborn...137, Paderborn...142, Paderborn...143, 
#           Paderborn...144, Paderborn...148, Paderborn...149, Paderborn...150, 
#           Paderborn...151, Paderborn...154, Paderborn...155, Paderborn...156, 
#           Paderborn...160
Paderborn <- names_with_dots[names_with_dots %like% "Paderborn"]
Paderborn <- filter(fh, HE %in% Paderborn)

#which names are present in which years?
Paderborn <- unique(Paderborn[, c("Jahr", "HE")])

fh$HE <- ifelse(
  fh$HE %in% c("Paderborn...116", "Paderborn...118", "Paderborn...119", 
               "Paderborn...120", "Paderborn...135", "Paderborn...137", 
               "Paderborn...143", "Paderborn...149"), 
  "Kath. H Nordrhein-Westfalen in Paderborn (FH)", 
  fh$HE
)

fh$HE <- ifelse(
  fh$HE == "Paderborn...144" & fh$Jahr == "1995", 
  "Kath. H Nordrhein-Westfalen in Paderborn (FH)", 
  fh$HE
)

fh$HE <- ifelse(
  fh$HE %in% c("Paderborn...123", "Paderborn...125", "Paderborn...126", 
               "Paderborn...127", "Paderborn...142", "Paderborn...150", 
               "Paderborn...151", "Paderborn...156"), 
  "Paderborn U-GH", 
  fh$HE
)

fh$HE <- ifelse(
  fh$HE == "Paderborn...144" & fh$Jahr == "1993", 
  "Paderborn U-GH", 
  fh$HE
)

fh$HE <- ifelse(
  fh$HE %in% c("Paderborn...148", "Paderborn...154", "Paderborn...155", 
               "Paderborn...160"), 
  "Paderborn FH der Wirtschaft", 
  fh$HE
)

# Paderborn is then only Paderborn U-GH
fh$HE <- ifelse(fh$HE == "Paderborn", "Paderborn U-GH", fh$HE)

#Hagen: Hagen...100, Hagen...102, Hagen...105,Hagen...110, Hagen...111
Hagen <- names_with_dots[names_with_dots %like% "Hagen"]
Hagen <- filter(fh, HE %in% Hagen)
#which names are present in which years?

Hagen <- unique(Hagen[, c("Jahr", "HE")])

# "Fachhochschule Bochum in Hagen" can not be found; still naming it
fh$HE <- ifelse(
  fh$HE %in% c("Hagen...100", "Hagen...102"), 
  "Bochum FH in Hagen", 
  fh$HE
)

fh$HE <- ifelse(
  fh$HE %in% c("Hagen...110", "Hagen...111"), 
  "Märkische FH in Hagen", 
  fh$HE
)

# "Fachhochschule Dortmund in Hagen" can not be found; still naming it
fh$HE <- ifelse(fh$HE == "Hagen...105", "Dortmund FH in Hagen", fh$HE)

# Hagen is then only "Hagen FH" before 1988 and "Märkische FH in Hagen" for the 
# years after 1989
fh$HE <- ifelse(fh$HE == "Hagen" & fh$Jahr < "1988", "Hagen FH", fh$HE)
fh$HE <- ifelse(
  fh$HE == "Hagen" & fh$Jahr > "1989", 
  "Märkische FH in Hagen", 
  fh$HE
)

# Geislingen: Geislingen...18, Geislingen...21, Geislingen...22, 
#             Geislingen...23, Geislingen...33, Geislingen...34, 
#             Geislingen...36, Geislingen...37
Geislingen <- names_with_dots[names_with_dots %like% "Geislingen"]
Geislingen <- filter(fh, HE %in% Geislingen)
#which names are present in which years?
Geislingen <- unique(Geislingen[, c("Jahr", "HE")])

fh$HE <- ifelse(
  fh$HE %in% c("Geislingen...18", "Geislingen...22", "Geislingen...23",
               "Geislingen...21"), 
  "Hochschule Nürtingen in Geislingen (FH)", 
  fh$HE
)

fh$HE <- ifelse(
  fh$HE %in% c("Geislingen...33", "Geislingen...34", "Geislingen...37", 
               "Geislingen...36"), 
  "Fachhochschule Ulm in Geislingen", 
  fh$HE
)

fh$HE <- ifelse(
  fh$HE == "Geislingen (2) FH", 
  "Fachhochschule Ulm in Geislingen", 
  fh$HE
)

# Geislingen is then only Hochschule Nürtingen 
fh$HE <- ifelse(
  fh$HE == "Geislingen", 
  "Hochschule Nürtingen in Geislingen (FH)", 
  fh$HE
)

# Wiesbaden: Wiesbaden...69, Wiesbaden...71, Wiesbaden...73, Wiesbaden...75, 
#            Wiesbaden...77
Wiesbaden <- names_with_dots[names_with_dots %like% "Wiesbaden"]
Wiesbaden <- filter(fh, HE %in% Wiesbaden)

# Which names are present in which years?
Wiesbaden <- unique(Wiesbaden[, c("Jahr", "HE")])

# "Wiesbaden FH" actually "Hochschule RheinMain in Wiesbaden (FH)"
fh$HE <- ifelse(
  fh$HE %in% c("Wiesbaden...69", "Wiesbaden...71"), 
  "Wiesbaden FH", 
  fh$HE
)

fh$HE <- ifelse(
  fh$HE == "Wiesbaden...73" & fh$Jahr == "1991", 
  "Wiesbaden FH", 
  fh$HE
)

fh$HE <- ifelse(
  fh$HE %in% c("Wiesbaden...75", "Wiesbaden...77"), 
  "Wiesbaden Fresenius", 
  fh$HE
)

fh$HE <- ifelse(
  fh$HE == "Wiesbaden...73" & fh$Jahr == "1986", 
  "Wiesbaden Fresenius", 
  fh$HE
)

fh$HE <- ifelse(
  fh$HE == "Wiesbaden...73" & fh$Jahr == "1987", 
  "Wiesbaden Fresenius", 
  fh$HE
)

fh$HE <- ifelse(
  fh$HE == "Wiesbaden...73" & fh$Jahr == "1988", 
  "Wiesbaden Fresenius", 
  fh$HE
)

# "Wiesbaden" is then only "Wiesbaden FH" 
fh$HE <- ifelse(fh$HE == "Wiesbaden", "Wiesbaden FH", fh$HE)

## Sonstige                                                                 ####

# Read Sonstige - other higher education institutions:
sonst <- read_excel("data_output\\other_results.xlsx")

# Append all three
df <- rbind(uni, fh, sonst)

# Convent to df
df <- as.data.frame(df)

# Get list of all SF names
sf_namen <- unique(df$Studienfach)
sf_namen <- as.data.frame(sf_namen)

writexl::write_xlsx(sf_namen,"data_output\\01_full_sf_namen.xlsx" )

# Get list of all city names
stadt_namen <- unique(df$Stadt)
stadt_namen <- as.data.frame(stadt_namen)

writexl::write_xlsx(stadt_namen,"data_output\\01_full_stadt_namen.xlsx" )

# Get list of all HE names
he_namen <- unique(df$neue_spalte)
he_namen <- as.data.frame(he_namen)

writexl::write_xlsx(he_namen,"data_output\\01_full_he_namen.xlsx")

# Get list of all original StudiBUCH HE names
he_namen_orig <- unique(df$name)
he_namen_orig <- as.data.frame(he_namen_orig)

writexl::write_xlsx(he_namen_orig,"data_output\\01_full_he_namen_orig.xlsx")

# Extract unique original HE names, create 'name_ganz' by combining 'name' and 
# 'Typ'
df$name_ganz <- paste(df$name, df$Typ, sep = " ")
name_ganz <- unique(df$name_ganz)
name_ganz <- as.data.frame(name_ganz)

writexl::write_xlsx(name_ganz,"data_output\\01_name_ganz.xlsx")

# Harmonization                                                             ####

# As shown in "Potential_mistakes_Harmonisierung.R" there are some Städte 
# missing; excel "01_full_stadt_namen_harmonisiert.xlsx" is appended such that 
# it contains the missing names.
# Niederrhein is left out, because it only enters in 1972 and at Niederrhein 
# there are no programs offered, instead they are displayed in its branches 
# Krefeld and Mönchengladbach 

## Names                                                                    ####

### Cities                                                                  ####

# Read customized records
stadt_namen_harmonisiert <- read_excel(
  "data_input\\01_full_stadt_namen_harmonisiert.xlsx"
)

## Rename name in excel (stadt_namen) and name in df (Stadt)
stadt_namen_harmonisiert$Stadt <- stadt_namen_harmonisiert$stadt_namen

## In the dataset panel stadt_namen_harmonisiert specifies the final cities
panel <- left_join(df, stadt_namen_harmonisiert, by = "Stadt")

# Correct AGS of Landsberg; FH Niederrhein; Lahr Beruf
panel$AGS <- ifelse(panel$Stadt=="Landsberg am Lech", "09181130", panel$AGS)

panel$stadt_namen_harmonisiert <- ifelse(
  panel$Stadt == "Niederrhein", 
  "Krefeld, Stadt", 
  panel$stadt_namen_harmonisiert
)

panel$AGS <- ifelse(
  panel$stadt_namen_harmonisiert == "Krefeld, Stadt", 
  "05114000", 
  panel$AGS
)

panel$stadt_namen_harmonisiert <- ifelse(
  panel$name == "Lahr Beruf", 
  "Lahr", 
  panel$stadt_namen_harmonisiert
)

panel$AGS <- ifelse(
  panel$stadt_namen_harmonisiert == "Lahr", 
  "07135050", 
  panel$AGS
)

### HEs                                                                     ####

he_namen_harmonisiert <- read_excel(
  "data_input\\01_full_he_namen_harmonisiert.xlsx"
)

panel <- left_join(panel, he_namen_harmonisiert, by = "HE")

# The were no distictions within one municipality for FHs before 1986 so adjust
# names
panel$he_namen_harmonisiert <- ifelse(
  panel$Typ == "FH" & panel$Jahr < "1986", 
  paste0(panel$he_namen_harmonisiert, "_gesamt"), 
  panel$he_namen_harmonisiert 
)

# Import the excel file which includes the manually matched HE names from the 
# "destatis schlüsselverzeichnis" to the names in our dataset
he_namen_for_HS_Nummern <- read_excel(
  "data_input\\he_namen_for_HS_Nummern.xlsx"
)
he_namen_for_HS_Nummern <- select(
  he_namen_for_HS_Nummern, he_namen_harmonisiert, name_for_number, Last_name, 
  HE_Change
)

# Import the "Schlüsselverzeichnis"
HS_Nummern <- read_excel("data_input\\HS_Nummern.xlsx")

# Match the above two datasets such that we have a number for each 
# "he_namen_harmonisiert"
he_namen_for_HS_Nummern <- left_join(
  he_namen_for_HS_Nummern,
  HS_Nummern, 
  by = "name_for_number"
)

# Match that to the panel dataset
panel<- left_join(panel, he_namen_for_HS_Nummern, by = "he_namen_harmonisiert")

# Which HEs don't have a HS_number? Test proofs that only those of FHs before 
# 1986 (_gesamt) and the few which could not be assigned a number are missings
missing_HS_number <- filter(
  panel, 
  is.na(HS_number), 
  !(he_namen_harmonisiert %like% "_gesamt")
)
missing_HEs <- as.data.frame(unique(missing_HS_number$he_namen_harmonisiert))

### SF                                                                      ####

# Read customized records
sf_namen_harmonisiert <- read_excel(
  "data_input\\01_full_sf_namen_harmonisiert.xlsx"
)

# Rename name in excel(sf_namen)
sf_namen_harmonisiert$Studienfach <- sf_namen_harmonisiert$sf_namen


# In the dataset panel "sf_names_harmonized_systematics" specifies the final sf,
# sf from StudiBUCH has a counterpart from systematics manually
panel <- left_join(panel, sf_namen_harmonisiert, by = "Studienfach")

# Destatis                                                                  ####

# Read destatis "Prüfungsstatistik"
studenten_pruefungsstatistik <- read_excel(
  "data_input\\studenten-pruefungsstatistik.xlsx"
)

# Rename 3-digit equal 
studenten_pruefungsstatistik$sf_namen_harmonisiert_systematik <- 
  studenten_pruefungsstatistik$`Text des Studienfachs`

panel <- left_join(
  panel, 
  studenten_pruefungsstatistik, 
  by = "sf_namen_harmonisiert_systematik"
)

# Keep only relevant variable
panel <- subset(
  panel, 
  select = c(Typ, Jahr, name, name_orig, stadt_namen_harmonisiert, 
             Studienfach_orig, sf_namen_harmonisiert_systematik, 
             stadt_namen_harmonisiert_full, sf_namen_harmonisiert_systematik_2, 
             sf_namen_harmonisiert_systematik_1, AGS, he_namen_harmonisiert, 
             Studienfach, sf_namen_harmonisiert_systematik_all, 
             `Verschlüsselungdes Studienfachs`, 
             `Systematische Nummerdes Studienbereichs`, `Text des Studienfachs`, 
             `Text des Studienbereichs`, `Systematische Nummer der Fächergruppe`, 
             `Text der Fächergruppe`,HS_number, name_for_number, Last_name, 
             HE_Change,value)
)

names(panel)

# Rename variables
names(panel)[names(panel) == "stadt_namen_harmonisiert"] <- "Stadt"
names(panel)[names(panel) == "stadt_namen_harmonisiert_full"] <- "Stadt_full"
names(panel)[names(panel) == "he_namen_harmonisiert"] <- "HE"
names(panel)[names(panel) == "Verschlüsselungdes Studienfachs"] <- "sf_3_code"
names(panel)[names(panel) == "Systematische Nummerdes Studienbereichs"] <- "sf_2_code"
names(panel)[names(panel) == "Text des Studienfachs"] <- "sf_3"
names(panel)[names(panel) == "Text des Studienbereichs"] <- "sf_2"
names(panel)[names(panel) == "Systematische Nummer der Fächergruppe"] <- "sf_1_code"
names(panel)[names(panel) == "Text der Fächergruppe"] <- "sf_1"
names(panel)[names(panel) == "Orig_Studienfach"] <- "Studienfach"

# Keep only the courses that really exist
panel <- subset(panel, value != 0)

names(studenten_pruefungsstatistik)[1] <- "sf_1_code"
names(studenten_pruefungsstatistik)[2] <- "sf_1"
names(studenten_pruefungsstatistik)[3] <- "sf_2_code"
names(studenten_pruefungsstatistik)[4] <- "sf_2"
names(studenten_pruefungsstatistik)[5] <- "sf_3_code"
names(studenten_pruefungsstatistik)[6] <- "sf_3"

# Rename destatis and search for a match
destatis <- studenten_pruefungsstatistik

# Idea: 
# If sf_1 is empty, then search for the match of the variable 
# "sf_namen_harmonisiert_systematik_all" with in sf_1 in destatis, replace 
# sf_1 and sf_1_code 
# If sf_2 is empty, then search for the match of the variable 
# "sf_namen_harmonisiert_systematik_all" with in sf_2 in destatis, replace sf_2, 
# sf_1. sf_2_code and sf_1_code
# It was only merged to sf2 or sf3 not sf_1

# Fill for the courses that were only merged on sf2 the variable sf2 was set to
panel$sf_2_code <- ifelse(
  is.na(panel$sf_2_code) & panel$sf_namen_harmonisiert_systematik_all %in% 
    studenten_pruefungsstatistik$sf_2,
  studenten_pruefungsstatistik$sf_2_code[match(
    panel$sf_namen_harmonisiert_systematik_all, studenten_pruefungsstatistik$sf_2
  )],
  panel$sf_2_code
)

panel$sf_2<- ifelse(
  is.na(panel$sf_2) & panel$sf_namen_harmonisiert_systematik_all %in% 
    studenten_pruefungsstatistik$sf_2,
  studenten_pruefungsstatistik$sf_2[match(
    panel$sf_namen_harmonisiert_systematik_all, studenten_pruefungsstatistik$sf_2
  )],
  panel$sf_2
)

sf1 <- unique(panel$sf_1)
sf1 <- as.data.frame(sf1)

# Fill the variable "sf1" for the courses that were only merged on "sf2"to
panel$sf_1_code <- ifelse(
  is.na(panel$sf_1_code) & panel$sf_namen_harmonisiert_systematik_all %in% 
    studenten_pruefungsstatistik$sf_2,
  studenten_pruefungsstatistik$sf_1_code[match(
    panel$sf_namen_harmonisiert_systematik_all, studenten_pruefungsstatistik$sf_2
  )],
  panel$sf_1_code
)

panel$sf_1<- ifelse(
  is.na(panel$sf_1) & panel$sf_namen_harmonisiert_systematik_all %in% 
    studenten_pruefungsstatistik$sf_2,
  studenten_pruefungsstatistik$sf_1[match(
    panel$sf_namen_harmonisiert_systematik_all, studenten_pruefungsstatistik$sf_2
  )],
  panel$sf_1
)

sf1 <- unique(panel$sf_1)
sf1 <- as.data.frame(sf1)


# Fill the variable "sf1" for the courses that were only merged on "sf1" to
panel$sf_1_code <- ifelse(
  is.na(panel$sf_1_code) & panel$sf_namen_harmonisiert_systematik_all %in% 
    studenten_pruefungsstatistik$sf_1,
  studenten_pruefungsstatistik$sf_1_code[match(
    panel$sf_namen_harmonisiert_systematik_all, studenten_pruefungsstatistik$sf_1
  )],
  panel$sf_1_code
)

panel$sf_1<- ifelse(
  is.na(panel$sf_1) & panel$sf_namen_harmonisiert_systematik_all %in% 
    studenten_pruefungsstatistik$sf_1,
  studenten_pruefungsstatistik$sf_1[match(
    panel$sf_namen_harmonisiert_systematik_all, studenten_pruefungsstatistik$sf_1
  )],
  panel$sf_1
)

# Final dataset                                                             ####

## Data cleansing                                                           ####            

# Not all cities have an AGS
# Create a lookup dataframe with the unique city AGS mappings
lookup_df <- unique(panel[, c("Stadt", "AGS")])

# Sometimes Essen AGS, sometimes a 0
panel$AGS <- ifelse(
  panel$AGS == 0, 
  lookup_df$AGS[match(panel$Stadt, lookup_df$Stadt)], 
  panel$AGS
)

# Filter out the records with missing AGS
stadtOhneAGS <- unique(panel$Stadt[panel$AGS == 0])
daten <- data.frame(Stadt = stadtOhneAGS)

# Save the dataframe as an Excel file
writexl::write_xlsx(daten, "data_output\\StadtOhneAGS.xlsx")

# Read the data and replace AGS with the value in Excel  
stadtOhneAGS_ko <- read_excel("data_input\\Kopie von StadtOhneAGS.xlsx")

# If AGS in panel is 0, replace it with the variable ags from stadtOhneAGS_ko
panel$AGS <- ifelse(
  panel$AGS == 0, 
  stadtOhneAGS_ko$ags[match(panel$Stadt, stadtOhneAGS_ko$Stadt)], 
  panel$AGS
)

neuer_datensatz <- subset(panel,Stadt == "false" | Stadt == "double")
double <- unique(neuer_datensatz$HE)
double <- as.data.frame(double)

# Save the data set
writexl::write_xlsx(double, "data_output\\double.xlsx")

## AGS1                                                                     ####

double_false <- read_excel(
  "data_input\\Kopie von Kopie von 01_full_stadt_namen_harmonisiert_Alina.xlsx"
)


# Here is an AGS for the double and false cities, if city is double/false, then
# replace AGS with ags
# Give the same name in both datasets
double_false$Stadt_full <- double_false$stadt_namen_harmonisiert_full
panel$AGS <- ifelse(
  is.na(panel$AGS), 
  double_false$ags[match(panel$Stadt_full, double_false$Stadt_full)], 
  panel$AGS
)

# Then enter the name of the county , from shapefile list AGS and create name 
# then merge sf names
liste_city <- unique(panel$Stadt_full)
liste_city <- as.data.frame(liste_city)

## AGS2 - county level                                                      ####

# Manually adjusting the county names
panel$Stadt[panel$Stadt == "Wodel"] <- "Wedel"
panel$Stadt[panel$Stadt == "Salb"] <- "Selb"
panel$Stadt[panel$Stadt == "Elberswalde"] <- "Eberswalde"
panel$Stadt[panel$Stadt == "Bergsteinfurt"] <- "Burgsteinfurt"
panel$Stadt[panel$Stadt == "false" & panel$AGS == "06412000"] <- "Frankfurt M"
panel$Stadt[panel$Stadt == "Frankfurf M" & panel$AGS == "06412000"] <- "Frankfurt M"
panel$Stadt[panel$Stadt == "false" & panel$AGS == "12053000"] <- "Frankfurt O"
panel$Stadt[panel$Stadt == "double" & panel$AGS == "03153004"] <- "Clausthal-Zellerfeld"

# Final false
final_false <- unique(panel$Stadt_full[panel$Stadt == "false"])
final_false <- as.data.frame(final_false)

# Caution: replace "Stadt" with "Stadt_full" 
panel$Stadt <- ifelse(panel$Stadt == "false", panel$Stadt_full, panel$Stadt)
panel$Stadt <- gsub(",.*", "", panel$Stadt)

# Final false
final_false <- unique(panel$Stadt_full[panel$Stadt == "false"])
final_false <- as.data.frame(final_false) # Only once false Lahr occupation/ AGS missing also only there

# My doubles
final_doubles <- unique(panel$Stadt_full[panel$Stadt == "double"])
final_doubles <- as.data.frame(final_doubles)

# Manual adjustments
panel$Stadt[panel$name == "Idar-Oberstein"] <- "Idar-Oberstein"
panel$Stadt[panel$Stadt_full == "Freising"] <- "Freising"
panel$Stadt[panel$Stadt_full == "Hamburg"] <- "Hamburg"
panel$Stadt[panel$Stadt_full == "Landshut"] <- "Landshut"

# Würzburg-Schweinfurt in the variable name
panel$Stadt[panel$Stadt_full == "Oestrich-Winkel, Stadt"] <- "Oestrich-Winkel"
panel$Stadt[panel$Stadt_full == "Villingen-Schwenningen"] <- "Villingen-Schwenningen"
panel$Stadt[panel$Stadt_full == "Höhr-Grenzhausen"] <- "Höhr-Grenzhausen" 

# My doubles
final_doubles <- unique(panel$Stadt_full[panel$Stadt == "double"])
final_doubles <- as.data.frame(final_doubles)

# Too many missings in sf_1
sf_1 <- unique(panel$sf_namen_harmonisiert_systematik_all[is.na(panel$sf_1)])
sf_1 <- as.data.frame(sf_1)

# Controlling all sf to 1, 2, 3 positions
sf1 <- unique(panel$sf_1)
sf1 <- as.data.frame(sf1)

# Add two indicators for dissolution and merging
panel$auflösung <- 0
panel$auflösung[panel$Stadt_full == "Trier, Kaiserslautern" & panel$Typ == "Uni"] <- 1
panel$auflösung[panel$Stadt_full == "Trier" & panel$Typ == "Uni"] <- 1
panel$auflösung[panel$Stadt_full == "Kaiserslautern"& panel$Typ == "Uni"] <- 1

# Checked all final doubles, no further changes

## Cleansing Duplicates                                                     ####

# New city name
panel$Stadt_full_duplicated <- panel$Stadt_full
panel$Stadt_full_duplicated[panel$Stadt_full == "Trier, Kaiserslautern" & panel$Typ == "Uni"] <- "Trier"
panel$Stadt_full_duplicated[panel$Stadt_full == "Erlangen,Nürnberg" & panel$Typ == "Uni"] <- "Erlangen"
panel$Stadt_full_duplicated[panel$Stadt_full == "Witten,Herdecke" & panel$Typ == "Uni"] <- "Witten"
panel$Stadt_full_duplicated[panel$Stadt_full == "Chemnitz, Zwickau" & panel$Typ == "Uni"] <- "Chemnitz"
panel$Stadt_full_duplicated[panel$Stadt_full == "Würzburg, Schweinfurt" & panel$Typ == "FH"] <- "Würzburg"
panel$Stadt_full_duplicated[panel$Stadt_full == "Rendsburg,Osterrönfeld" & panel$Typ == "FH"] <- "Rendsburg"
panel$Stadt_full_duplicated[panel$Stadt_full == "Ravensburg,Weingarten" & panel$Typ == "FH"] <- "Ravensburg"
panel$Stadt_full_duplicated[panel$Stadt_full == "Zittau,Görlitz" & panel$Typ == "FH"] <- "Zittau"

# AGS Duplicated (Actually, I can only do this via AGS, but then I don't know which city it is :-))
panel$AGS_duplicated <- panel$AGS
panel$AGS_duplicated[panel$Stadt_full == "Trier, Kaiserslautern" & 
                       panel$Typ == "Uni" & 
                       panel$AGS == "07211000, 07312000"] <- "07211000"
panel$AGS_duplicated[panel$Stadt_full == "Erlangen,Nürnberg" & 
                       panel$Typ == "Uni" & 
                       panel$AGS == "09562000,09564000"] <- "09562000"
panel$AGS_duplicated[panel$Stadt_full == "Witten,Herdecke" & 
                       panel$Typ == "Uni" &
                       panel$AGS =="05954036,05954020"] <- "05954036"
panel$AGS_duplicated[panel$Stadt_full == "Chemnitz, Zwickau" & 
                       panel$Typ == "Uni" & 
                       panel$AGS == "14511000, 14524330"] <- "14511000"
panel$AGS_duplicated[panel$Stadt_full == "Würzburg, Schweinfurt" & 
                       panel$Typ == "FH" & 
                       panel$AGS == "09663000,09662000"] <- "09663000"
panel$AGS_duplicated[panel$Stadt_full == "Rendsburg,Osterrönfeld" & 
                       panel$Typ == "FH" & 
                       panel$AGS == "01058135,01058124"] <- "01058135"
panel$AGS_duplicated[panel$Stadt_full == "Ravensburg,Weingarten" & 
                       panel$Typ == "FH" & 
                       panel$AGS == "08436064,08436082"] <- "08436064"
panel$AGS_duplicated[panel$Stadt_full == "Zittau,Görlitz" & 
                       panel$Typ == "FH" & 
                       panel$AGS == "14626610,14626110"] <- "14626610"

# Create a list of combinations of city and type
combos <- list(
  c("Trier, Kaiserslautern", "Uni"),
  c("Erlangen,Nürnberg", "Uni"),
  c("Witten,Herdecke", "Uni"),
  c("Chemnitz, Zwickau", "Uni"),
  c("Würzburg, Schweinfurt", "FH"),
  c("Rendsburg,Osterrönfeld", "FH"),
  c("Ravensburg,Weingarten", "FH"),
  c("Zittau,Görlitz", "FH")
)

# Duplicate data and add to the record
for (combo in combos) {
  subset_rows <- panel[panel$Stadt_full == combo[1] & panel$Typ == combo[2], ]
  
  # Change city names of duplicated Cities
  subset_rows$Stadt_full_duplicated[
    subset_rows$Stadt_full == "Trier, Kaiserslautern" & subset_rows$Typ == "Uni"
  ] <- "Kaiserslautern"
  subset_rows$Stadt_full_duplicated[
    subset_rows$Stadt_full == "Erlangen,Nürnberg" & subset_rows$Typ == "Uni"
  ] <- "Nürnberg"
  subset_rows$Stadt_full_duplicated[
    subset_rows$Stadt_full == "Witten,Herdecke" & subset_rows$Typ == "Uni"
  ] <- "Herdecke"
  subset_rows$Stadt_full_duplicated[
    subset_rows$Stadt_full == "Chemnitz, Zwickau" & subset_rows$Typ == "Uni"
  ] <- "Zwickau"
  subset_rows$Stadt_full_duplicated[
    subset_rows$Stadt_full == "Würzburg, Schweinfurt" & subset_rows$Typ == "FH"
  ] <- "Schweinfurt"
  subset_rows$Stadt_full_duplicated[
    subset_rows$Stadt_full == "Rendsburg,Osterrönfeld" & subset_rows$Typ == "FH"
  ] <- "Osterrönfeld"
  subset_rows$Stadt_full_duplicated[
    subset_rows$Stadt_full == "Ravensburg,Weingarten" & subset_rows$Typ == "FH"
  ] <- "Weingarten"
  subset_rows$Stadt_full_duplicated[
    subset_rows$Stadt_full == "Zittau,Görlitz" & subset_rows$Typ == "FH"
  ] <- "Görlitz"
  
  # Change AGS of Duplicated Lines
  subset_rows$AGS_duplicated[
    subset_rows$Stadt_full == "Trier, Kaiserslautern" & 
      subset_rows$Typ == "Uni" & 
      subset_rows$AGS == "07211000, 07312000"
  ] <- "07312000"
  subset_rows$AGS_duplicated[
    subset_rows$Stadt_full == "Erlangen,Nürnberg" & 
      subset_rows$Typ == "Uni" & 
      subset_rows$AGS == "09562000,09564000"
  ] <- "09564000"
  subset_rows$AGS_duplicated[
    subset_rows$Stadt_full == "Witten,Herdecke" & 
      subset_rows$Typ == "Uni" & 
      subset_rows$AGS =="05954036,05954020"
  ] <- "05954020"
  subset_rows$AGS_duplicated[
    subset_rows$Stadt_full == "Chemnitz, Zwickau" & 
      subset_rows$Typ == "Uni" & 
      subset_rows$AGS == "14511000, 14524330"
  ] <- "14524330"
  subset_rows$AGS_duplicated[
    subset_rows$Stadt_full == "Würzburg, Schweinfurt" & 
      subset_rows$Typ == "FH" & 
      subset_rows$AGS == "09663000,09662000"
  ] <- "09662000"
  subset_rows$AGS_duplicated[
    subset_rows$Stadt_full == "Rendsburg,Osterrönfeld" & 
      subset_rows$Typ == "FH" & 
      subset_rows$AGS == "01058135,01058124"
  ] <- "01058124"
  subset_rows$AGS_duplicated[
    subset_rows$Stadt_full == "Ravensburg,Weingarten" & 
      subset_rows$Typ == "FH" & 
      subset_rows$AGS == "08436064,08436082"
  ] <- "08436082"
  subset_rows$AGS_duplicated[
    subset_rows$Stadt_full == "Zittau,Görlitz" & 
      subset_rows$Typ == "FH" & 
      subset_rows$AGS == "14626610,14626110"
  ] <- "14626110"
  
  panel <- rbind(panel, subset_rows)
}

#Now the duplicates need to be given the correct HS_number and name, if there is
# one for each location
panel$HS_number <- ifelse(
  panel$HE == "Trier-Kaiserslautern U" & 
    panel$Stadt_full_duplicated == "Kaiserslautern",
  "1210",
  panel$HS_number
)

panel$name_for_number <- ifelse(
  panel$HE == "Trier-Kaiserslautern U" & 
    panel$Stadt_full_duplicated == "Kaiserslautern", 
  "Rhl.-Pfälz. TU Kaiserslautern-Landau in Kaisersl.", 
  panel$name_for_number
)

panel$HS_number <- ifelse(
  panel$HE == "Erlangen-Nürnberg U" & 
    panel$Stadt_full_duplicated == "Nürnberg", 
  "1312",
  panel$HS_number
)

panel$name_for_number <- ifelse(
  panel$HE == "Erlangen-Nürnberg U" & 
    panel$Stadt_full_duplicated == "Nürnberg", 
  "U Erlangen-Nürnberg in Nürnberg (siehe HS1310)", 
  panel$name_for_number
)

panel$HS_number <- ifelse(
  panel$HE == "Zittau-Görlitz FH" & 
    panel$Stadt_full_duplicated == "Zittau", 
  "5151", 
  panel$HS_number
)

panel$name_for_number <- ifelse(
  panel$HE == "Zittau-Görlitz FH" & 
    panel$Stadt_full_duplicated == "Zittau", 
  "Hochschule Zittau/Görlitz in Zittau (FH)", 
  panel$name_for_number
)

# Clean the data set
panel <- panel[rowSums(is.na(panel)) < ncol(panel), ]

## Add county level                                                         ####

# Convert AGS at county level (at the moment municipal)
panel$Kreis_AGS <- substr(
  panel$AGS_duplicated, 1, nchar(panel$AGS_duplicated) - 3
)

# Create indicator "Ost"
panel$Bula <- substr(panel$Kreis_AGS, 1, nchar(panel$Kreis_AGS) - 3)
panel$Bula <- as.numeric(panel$Bula)
panel$Ost <- ifelse(panel$Bula >= 11, "Ost", "West")

# Read an Excel with county names here (previously used municipality names in 
# the StudiBUCH!)
kreis_namen <- read_excel("data_input\\kreis_namen_2013.xlsx")

# Merging
panel <- left_join(panel, kreis_namen, by = "Kreis_AGS") 

# Caution: Kreis_nameN is the data set, Kreis_namE is the variable

## Finalization                                                             ####

# !!!! CAUTION !!!! I rename AGS here to AGS_alt and Kreis_AGS to AGS, so that
# the following spatial analyses run at county level
names(panel)[names(panel) == "AGS"] <- "AGS_alt"
names(panel)[names(panel) == "Kreis_AGS"] <- "AGS"

#___________________________________________________________________________####
# Export                                                                    ####

# Save final panel
write.csv(panel, file = "data_final\\panel.csv", row.names = FALSE)
