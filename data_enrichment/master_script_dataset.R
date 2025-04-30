#___________________________________________________________________________####
# Project                                                                   ####
#
# Project-Title: RWI-UNI-SUBJECTS (Dataset)
#
# Filename of Code: master_script_dataset.R
#
# Filename(s) of Input-File(s): 
#
# Filename(s) of Output-File(s):
#
# Short description: This Script is the Master Script for the StudiBUCH Dataset
#
# Last Change: 10.02.2025
#
# Editor: Serife Yasar
# E-Mail: Serife.Yasar@rwi-essen.de
#
# Software Version: R 4.4.2

#___________________________________________________________________________####
# Preparation                                                               ####

# 1: Read StudiBUCH University tables and generate a dataset from them
source("prog\\01_loop_uni.R")

# 2: Read StudiBUCH University of applied science tables and generate a data set 
# from them
source("prog\\02_loop_fh.R")

# 3: Read StudiBUCH Other higher education institution tables and generate a 
# data set from them
source("prog\\03_loop_other.R")

# 4: Merge 1 and 2 and make many manual adjustments. Result: panel.csv
source("prog\\04_combined.R") 

# 5: Change panel.csv to the final dataset, a list of all German cities with the
# first occurrence of HS or SF in StudiBUCH
source("prog\\05_data_prep_spillover_dplyr.R")

# 6: Write final dataset for publication
source("prog\\06_write_dataset.R")

# 7: Perform quality control of Excel spreadsheets
# source("prog\\07_plausibility_check.R")

# 8: Perform quality control and update he final panel dataset
source("prog\\08_ags_sf_he_check.R")

# 9: Create descriptive statistics
source("prog\\09_descriptives.R")
print("Deskriptive statistics done")

print("Your master script successfully executed! The final file is saved as 'data_final/HEI_and_subjects_1971-1996_v2_saved.dta'")
