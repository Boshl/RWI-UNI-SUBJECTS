#___________________________________________________________________________####
# Project                                                                   ####
#
# Project-Title: RWI-UNI-SUBJECTS (Dataset)
#
# Filename of Code: 03_loop_other.R
#
# Filename(s) of Input-File(s): - ags.xlsx (AGS/municipality-name key)
#                               - Sonstiges_71-96.xlsx (raw StudiBUCH data on 
#                                 some certain study subjects at universities 
#                                 from 1978 to 1996)
#
# Filename(s) of Output-File(s): "other_results.xlsx"
#
# Short description: Reads in raw data from StudiBUCH for universities and
#                    summarizes them.
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
library(conflicted)

# Preperation                                                               ####

# Specifically tell R to use select() from the dplyr package (otherwise there
# is a conflict with the raster package)
conflicts_prefer(dplyr::select)

# Specifically tell R to use filter() from the dplyr package (otherwise there
# is a conflict with the stats package)
conflicts_prefer(dplyr::filter)

# Prepare AGS
ags <- read_excel("input_tables\\ags.xlsx", col_names = FALSE)

# Add AGS 2013, as well as study subject combi
names(ags)[1] <- "AGS"
names(ags)[2] <- "Stadt"

# Remove comma and following text at the end
ags$Stadt <- sub(",.*$", "", ags$Stadt)
ags <- as.data.frame(ags)

# Find duplicated cities
duplicate_stadt <- duplicated(ags$Stadt)
duplicate_stadt<-as.data.frame(duplicate_stadt)

# Filter AGS to keep only unique cities
ags_unique <- ags[!duplicate_stadt, ]

# There are the 
#   - Sonstiges_Jahr.xlsx tables for 1979 to 1995 in the usual format,
#   - Sonstiges_91_neue_Länder.xlsx table for former East German states in 1991,
#   - Sonstiges_Jahr_Sonstiges_Bundeswehr, _Kirche, _Kunst and _Musik tables 
#     from 1992 to 1995 (and those for _Kunst and _Musik also in 1996) 
#   - and separate Lehramt-tables for 1996

ergebnisse <- data.frame()

# Write a function to read Sonstige data tables
process_data <- function(pfad, dateiname) {
  # Read data
  Matrix <- read_excel(pfad)
  Matrix <- as.data.frame(Matrix)
  
  # Rename the first column 
  names(Matrix)[1] <- "Studienfach"
  
  # Reshaping the Matrix data, basically stacks columns below each other
  Matrix <- melt(Matrix, id='Studienfach', variable="HE")   
  
  # Convert NA values to 0
  Matrix$HE <- as.character(Matrix$HE)
  
  Matrix[is.na(Matrix)] <- 0
  
  # Creating new columns and a separate data frame
  Matrix$name_orig <- Matrix$HE
  Matrix$Studienfach_orig <- Matrix$Studienfach
  Matrix$name <- Matrix$HE
  Staedte <- Matrix$HE
  
  # Remove capital letters at the end
  Staedte <- gsub("[A-Z]+$", "", Staedte)
  Staedte <- gsub("-", "", Staedte)
  Staedte <- gsub("[A-Z]+$", "", Staedte)
  
  Matrix$Stadt <- Staedte
  Matrix$Stadt <- trimws(Matrix$Stadt, "right")
  
  df <- as.data.frame(Matrix)
  
  # Add new first column
  df_neu <- cbind(Jahr = rep(1900 + jahr, nrow(df)), df)
  
  # Add new first column
  df_neu <- cbind(Typ = rep("Other", nrow(df_neu)), df_neu)
  df_neu$neue_spalte <- paste0(df_neu$Stadt, " O")
  
  # Join
  merged_data <- left_join(df_neu, ags_unique, by = "Stadt")
  
  # Fill missing values in merged_data with 0
  merged_data[is.na(merged_data)] <- 0
  
  # Add results to the overall result
  ergebnisse <- rbind(ergebnisse, merged_data)
  
  return(ergebnisse)
}

#___________________________________________________________________________####
# Import and Wrangling                                                      ####

## Sonstiges_91_neue_Länder.xlsx table in 1991                              ####
jahr <- 91
dateiname <- paste0("Sonstiges_", jahr, "_neue_Länder.xlsx")
pfad <- paste0("input_tables\\Other\\", jahr, "\\", dateiname)
ergebnisse <- process_data(pfad, dateiname)

print(unique(ergebnisse$HE))

# Now need to manually change Typ and neue_spalte for the universities and 
# universities of applied sciences that are within this table
Unis <- c("Berlin HU", "Cottbus TU", "Rostock U","Postdam U", "Greifswald U", 
          "Chemnitz TU", "Dresden TU", "Leipzig U", "Halle U", "Magdeburg TU", 
          "Jena U")
ergebnisse$Typ <- ifelse(ergebnisse$HE %in% Unis, "Uni", ergebnisse$Typ)

FHs <- c("Berlin FH TW", "Neubrandenbg. FH", "Stralsund FH", 
         "Stralsund FH - Abt. Heiligendamm","Wismar TH", "Leipzig TH", 
         "Mittweida FH","Zittau TH", "Zwickau TH", "Köthen TH", "Merseburg TH",
         "Erfurt FH", "Ilmenau TH", "Jena FH", "Schmalkalden FH")
ergebnisse$Typ <- ifelse(ergebnisse$HE %in% FHs, "FH", ergebnisse$Typ)

ergebnisse$neue_spalte <- ifelse(ergebnisse$HE %in% Unis, 
                               gsub("O$", "U", ergebnisse$neue_spalte ),
                               ergebnisse$neue_spalte)
ergebnisse$neue_spalte <- ifelse(ergebnisse$HE %in% FHs, 
                                 gsub("O$", "FH", ergebnisse$neue_spalte ),
                                 ergebnisse$neue_spalte)

## Sonstiges_78-91.xlsx                                                     ####

# Combine all the data from the typical Sonstige-tables and add it to ergebnisse
jahre <- 78:91

for (jahr in jahre) {
  # Create filenames
  dateiname <- paste0("Sonstiges_", jahr, ".xlsx")
  
  # Create path to file
  pfad <- paste0("input_tables\\Other\\", jahr, "\\", dateiname)

  # Read tables
  ergebnisse <- process_data(pfad, dateiname)
}


# add the tables Sonstiges_Jahr_Sonstiges_Bundeswehr
#                                        _Kirche
#                                        _Kunst
#                                        _Musik
# from 1992 to 1995; and Kunst and Musik also in 1996

## Sonstiges_Jahr_Sonstiges_Bundeswehr.xlsx                                 ####

jahre <- 92:95
for (jahr in jahre) {
  # Create filenames
  dateiname <- paste0("Sonstiges", jahr, "_Sonstiges_Bundeswehr.xlsx")
  
  # Create path to file
  pfad <- paste0("input_tables\\Other\\", jahr, "\\", dateiname)
  
  # Read tables
  ergebnisse <- process_data(pfad, dateiname)
}

## Sonstiges_Jahr_Sonstiges_Kirche.xlsx                                     ####

for (jahr in jahre) {
  # Create filenames
  dateiname <- paste0("Sonstiges", jahr, "_Sonstiges_Kirche.xlsx")
  
  # Create path to file
  pfad <- paste0("input_tables\\Other\\", jahr, "\\", dateiname)
  
  # Read tables
  ergebnisse <- process_data(pfad, dateiname)
}

## Sonstiges_Jahr_Sonstiges_Kunst.xlsx                                      ####

jahre <- 92:96
for (jahr in jahre) {
  # Create filenames
  dateiname <- paste0("Sonstiges", jahr, "_Sonstiges_Kunst.xlsx")
  
  # Create path to file
  pfad <- paste0("input_tables\\Other\\", jahr, "\\", dateiname)
  
  # Read tables
  ergebnisse <- process_data(pfad, dateiname)
}

## Sonstiges_Jahr_Sonstiges_Kunst.xlsx                                      ####
for (jahr in jahre) {
  # Create filenames
  dateiname <- paste0("Sonstiges", jahr, "_Sonstiges_Musik.xlsx")
  
  # Create path to file
  pfad <- paste0("input_tables\\Other\\", jahr, "\\", dateiname)
  
  # Read tables
  ergebnisse <- process_data(pfad, dateiname)
}

## Sonstiges_96_Sonstiges_Lehramt1-8.xlsx                                   ####

# Now prepare the Lehramt-tables from 1996 as they follow a different format

LA_1 <- read_excel(
  "input_tables\\Other\\96\\Sonstiges_96_Sonstiges_Lehramt_1_2_joined.xlsx"
)
LA_2 <- read_excel(
  "input_tables\\Other\\96\\Sonstiges_96_Sonstiges_Lehramt_3_4_joined.xlsx"
)
LA_3 <- read_excel(
  "input_tables\\Other\\96\\Sonstiges_96_Sonstiges_Lehramt_5_6_joined.xlsx"
)
LA_4 <- read_excel(
  "input_tables\\Other\\96\\Sonstiges_96_Sonstiges_Lehramt_7_8_joined.xlsx"
)

# First extract the names/abbreviations for the school types in the column names
# Thankfully, they all start with LA
la_abk <- character(0)
la_columns <- grep(" LA ", colnames(LA_1), value = TRUE)
for (col in la_columns) {
  la_abk <- c(la_abk, sub(".* LA ", "LA ", col))
}
la_abk1 <- unique(la_abk)

la_abk <- character(0)
la_columns <- grep(" LA ", colnames(LA_2), value = TRUE)
for (col in la_columns) {
  la_abk <- c(la_abk, sub(".* LA ", "LA ", col))
}
la_abk2 <- unique(la_abk)

la_abk <- character(0)
la_columns <- grep(" LA ", colnames(LA_3), value = TRUE)
for (col in la_columns) {
  la_abk <- c(la_abk, sub(".* LA ", "LA ", col))
}
la_abk3 <- unique(la_abk)

la_abk <- character(0)
la_columns <- grep(" LA ", colnames(LA_4), value = TRUE)
for (col in la_columns) {
  la_abk <- c(la_abk, sub(".* LA ", "LA ", col))
}
la_abk4 <- unique(la_abk)

LA_abk <- c(la_abk1, la_abk2, la_abk3, la_abk4)
# This list contains all school type names present in the column names of the 
# Lehramt tables in 1996
LA_abk <- unique(LA_abk)
print(LA_abk)


# Create a separate dataframe for each school type, transpose it and then join 
# them together. This is done to split the subjects into school types, e.g. 
# afterwards there exists Biologie LA GS, Biologie LA HS, ... instead of 
# Biologie and the institution names do not have the information of school type 
# of the subject in it anymore

### Table 1                                                                 ####
LA_tabl <- data.frame(HE = character(0))

liste <- 1:14

for (i in liste) {
  LA_typ <- select(LA_1, c(1, ends_with(LA_abk[i])))
  names(LA_typ)[1] <- "Studienfach"
  
  # Add the school type to the subject name
  LA_typ$Studienfach <- paste(LA_typ$Studienfach, LA_abk[i])
  
  # Remove school type from institution names
  colnames(LA_typ) <- sub(LA_abk[i], "", colnames(LA_typ))
  
  # Remove remaining whitespace from right
  colnames(LA_typ) <- trimws(colnames(LA_typ), "right") 
  
  LA_typ_t <- as.data.frame(t(LA_typ))
  
  # Use first row as column names
  colnames(LA_typ_t)=LA_typ_t[c(1),]
  
  # Remove the first row as it is double otherwise
  LA_typ_t=LA_typ_t[-c(1),] 
  
  # Create first column HE and use the rownames
  LA_typ_t$HE <- rownames(LA_typ_t)
  # Reorder the columns with "HE" as the first column
  LA_typ_t <- LA_typ_t %>%
    select(HE, everything())
  
  rownames(LA_typ_t) <- NULL
  
  LA_tabl <- full_join(LA_tabl, LA_typ_t, by = "HE")
}

LA_tabl1 <- LA_tabl

# Now repeat this also for the other joined-Lehramt-tables:

### Table 2                                                                 ####
LA_tabl <- data.frame(HE = character(0))

liste <- 1:14
for (i in liste) {
  LA_typ <- select(LA_2, c(1, ends_with(LA_abk[i])))
  names(LA_typ)[1] <- "Studienfach"
  
  # Add the school type to the subject name
  LA_typ$Studienfach <- paste(LA_typ$Studienfach, LA_abk[i])
  
  # Remove school type from institution names
  colnames(LA_typ) <- sub(LA_abk[i], "", colnames(LA_typ))
  
  # Remove remaining whitespace from right
  colnames(LA_typ) <- trimws(colnames(LA_typ), "right")   
  
  LA_typ_t <- as.data.frame(t(LA_typ))
  
  # Use first row as column names
  colnames(LA_typ_t)=LA_typ_t[c(1),]
  
  # Remove the first row as it is double otherwise
  LA_typ_t=LA_typ_t[-c(1),]  
  
  # Create first column HE and use the rownames
  LA_typ_t$HE <- rownames(LA_typ_t)
  
  # Reorder the columns with "HE" as the first column
  LA_typ_t <- LA_typ_t %>%
    select(HE, everything())
  
  rownames(LA_typ_t) <- NULL
  
  LA_tabl <- full_join(LA_tabl, LA_typ_t, by = "HE")
}

LA_tabl2 <- LA_tabl

### Table 3                                                                 ####
LA_tabl <- data.frame(HE = character(0))

liste <- 1:14
for (i in liste) {
  LA_typ <- select(LA_3, c(1, ends_with(LA_abk[i])))
  names(LA_typ)[1] <- "Studienfach"
  
  # Add the school type to the subject name
  LA_typ$Studienfach <- paste(LA_typ$Studienfach, LA_abk[i])  
  
  # Remove school type from institution names
  colnames(LA_typ) <- sub(LA_abk[i], "", colnames(LA_typ))
  
  # Remove remaining whitespace from right
  colnames(LA_typ) <- trimws(colnames(LA_typ), "right")   
  
  LA_typ_t <- as.data.frame(t(LA_typ))
  
  # Use first row as column names
  colnames(LA_typ_t)=LA_typ_t[c(1),] 
  
  # Remove the first row as it is double otherwise
  LA_typ_t=LA_typ_t[-c(1),]   
  
  # Create first column HE and use the rownames
  LA_typ_t$HE <- rownames(LA_typ_t) 
  
  # Reorder the columns with "HE" as the first column
  LA_typ_t <- LA_typ_t %>%
    select(HE, everything())
  
  rownames(LA_typ_t) <- NULL
  
  LA_tabl <- full_join(LA_tabl, LA_typ_t, by = "HE")
}

LA_tabl3 <- LA_tabl

### Table 4                                                                 ####
LA_tabl <- data.frame(HE = character(0))

liste <- 1:14
for (i in liste) {
  LA_typ <- select(LA_4, c(1, ends_with(LA_abk[i])))
  names(LA_typ)[1] <- "Studienfach"
  
  # Add the school type to the subject name
  LA_typ$Studienfach <- paste(LA_typ$Studienfach, LA_abk[i])
  
  # Remove school type from institution names
  colnames(LA_typ) <- sub(LA_abk[i], "", colnames(LA_typ))
  
  # Remove remaining whitespace from right
  colnames(LA_typ) <- trimws(colnames(LA_typ), "right")   
  
  LA_typ_t <- as.data.frame(t(LA_typ))
  
  # Use first row as column names
  colnames(LA_typ_t)=LA_typ_t[c(1),]
  
  # Remove the first row as it is double otherwise
  LA_typ_t=LA_typ_t[-c(1),]  
  
  # Create first column HE and use the rownames
  LA_typ_t$HE <- rownames(LA_typ_t)
  
  # Reorder the columns with "HE" as the first column
  LA_typ_t <- LA_typ_t %>%
    select(HE, everything())
  
  rownames(LA_typ_t) <- NULL
  
  LA_tabl <- full_join(LA_tabl, LA_typ_t, by = "HE")
}

LA_tabl4 <- LA_tabl

# Then transpose them again and combine all by Studienfach

# Transposing
LA_t1 <- as.data.frame(t(LA_tabl1))
colnames(LA_t1)=LA_t1[c(1),]
LA_t1=LA_t1[-c(1),]   
LA_t1$Studienfach <- rownames(LA_t1) 
LA_t1 <- LA_t1 %>%
  select(Studienfach, everything())
rownames(LA_t1) <- NULL

LA_t2 <- as.data.frame(t(LA_tabl2))
colnames(LA_t2)=LA_t2[c(1),]
LA_t2=LA_t2[-c(1),]   
LA_t2$Studienfach <- rownames(LA_t2) 
LA_t2 <- LA_t2 %>%
  select(Studienfach, everything())
rownames(LA_t2) <- NULL

LA_t3 <- as.data.frame(t(LA_tabl3))
colnames(LA_t3)=LA_t3[c(1),]
LA_t3=LA_t3[-c(1),]   
LA_t3$Studienfach <- rownames(LA_t3) 
LA_t3 <- LA_t3 %>%
  select(Studienfach, everything())
rownames(LA_t3) <- NULL

LA_t4 <- as.data.frame(t(LA_tabl4))
colnames(LA_t4)=LA_t4[c(1),]
LA_t4=LA_t4[-c(1),]   
LA_t4$Studienfach <- rownames(LA_t4) 
LA_t4 <- LA_t4 %>%
  select(Studienfach, everything())
rownames(LA_t4) <- NULL

# Joining
LA_tabl <- full_join(LA_t1, LA_t2, by = "Studienfach") %>%
  full_join(LA_t3, by = "Studienfach") %>%
  full_join(LA_t4, by = "Studienfach")

writexl::write_xlsx(LA_tabl, "data_output\\Lehramt_tabelle_1996.xlsx" )

# Now we can finally work with the Lehramt-table as with the other tables
dateiname <- "Lehramt_tabelle_1996.xlsx"
pfad <- paste0("data_output\\", dateiname)
ergebnisse <- process_data(pfad, dateiname)

# But do have to change the Typ for most of the institutions in the 
# Lehramt-table, as they are often Unis
ergebnisse <- ergebnisse %>%
  mutate(
    Typ = ifelse(
      grepl(" U| TU| HU| FU| U-GH| TH", HE) & grepl(" LA ", Studienfach), 
      "Uni", 
      Typ
    )
  )

Unis <- ergebnisse %>%
   filter(Typ == "Uni") %>%
   distinct(HE)

# Find out false names
names_fehler <- unique(ergebnisse$HE[grep("\\.{3}", ergebnisse$HE)])
fehler <- filter(ergebnisse, HE %in% names_fehler)

# Correct false names
ergebnisse$HE <- gsub("\\.{3}\\d*", "", ergebnisse$HE)
ergebnisse$name_orig <- gsub("\\.{3}\\d*", "", ergebnisse$name_orig)
ergebnisse$name <- gsub("\\.{3}\\d*", "", ergebnisse$name)
ergebnisse$Stadt <- gsub("\\.{3}\\d*", "", ergebnisse$Stadt)
ergebnisse$neue_spalte <- gsub("\\.{3}\\d*", "", ergebnisse$neue_spalte)

#___________________________________________________________________________####
# Export                                                                    ####

# Export the results
writexl::write_xlsx(ergebnisse, "data_output\\other_results.xlsx" )



