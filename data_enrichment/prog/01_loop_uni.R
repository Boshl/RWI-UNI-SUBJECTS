#___________________________________________________________________________####
# Project                                                                   ####
#
# Project-Title: RWI-UNI-SUBJECTS (Dataset)
#
# Filename of Code: 01_loop_uni.R
#
# Filename(s) of Input-File(s): - ags.xlsx (AGS/municipality-name key)
#                               - Uni_71-96.xlsx (raw StudiBUCH data on study
#                                 subjects at universities from 1971 to 1996)
#
# Filename(s) of Output-File(s): "uni_results.xlsx"
#
# Short description: Reads in all raw data from StudiBUCH for universities and
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
duplicate_stadt <- as.data.frame(duplicate_stadt)

# Filter AGS to keep only unique cities
ags_unique <- ags[!duplicate_stadt, ]

jahre <- 71:96
ergebnisse2 <- data.frame()

#___________________________________________________________________________####
# Import and Wrangling                                                      ####

# Read data for universities for all years (1971-1996) in loop 
for (jahr in jahre) {
  # Create filenames
  dateiname <- paste0("Uni_", jahr, ".xlsx")
  
  # Create path to file
  pfad <- paste0("input_tables\\Uni\\", jahr, "\\", dateiname)
  
  # Read data
  Matrix <- read_excel(pfad)
  Matrix <- as.data.frame(Matrix)
  
  # Rename the first column 
  names(Matrix)[1] <- "Studienfach"
  
  # Reshaping the Matrix data
  Matrix <- melt(Matrix, id='Studienfach', variable="HE")
  
  # Convert NA values to 0
  Matrix$HE <- as.character(Matrix$HE)
  
  #Matrix$binary_value <- as.integer(nchar(Matrix[, "value"]) > 0)
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
  df_neu <- cbind(Typ = rep("Uni", nrow(df_neu)), df_neu)
  df_neu$neue_spalte <- paste0(df_neu$Stadt, " U")
  
  # Join
  merged_data <- left_join(df_neu, ags_unique, by = "Stadt")
  
  # Fill missing values in merged_data with 0
  merged_data[is.na(merged_data)] <- 0
  
  # Add results to the overall result
  ergebnisse2 <- rbind(ergebnisse2, merged_data)
}

#___________________________________________________________________________####
# Export                                                                    ####

# Export the results
writexl::write_xlsx(ergebnisse2, "data_output\\uni_results.xlsx" )
