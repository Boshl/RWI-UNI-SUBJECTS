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
# Short description: This Script is the Master Script for the RWI-UNI-SUBJECTS data set
#
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

# 5: update and correct the panel.csv
source("prog\\05_ags_sf_he_corr.R")

# 6: Write a formatted version of the dataset
source("prog\\06_write_dataset.R")

# 7: Perform quality control of Excel spreadsheets
# source("prog\\07_plausibility_check.R")

# 8: Create descriptive statistics
source("prog\\08_descriptives.R")
print("Deskriptive statistics done")

# 9: Further corrections after review and writing the RWI-UNI-SUBJECTS data set
source("prog\\09_post_corrections.R")

print("Your master script successfully executed! The final file is saved as 'RWI-UNI-SUBJECTS.csv'")
