# RWI-UNI-SUBJECTS

This repository contains the extraction scripts for the [RWI-UNI-SUBJECTS](https://doi.org/10.7807/studi:buch:suf:v1) dataset. It is the first extensive collection of study opportunities across German higher education institutions between 1971 and 1996. The dataset is based on yearly printed study guides provided by the German Federal Employment Agency to inform high school students about their post-secondary choices. To extract the data from these books, a custom-developed computer vision algorithm was used. We further enriched the dataset with administrative codes for fields, institutions, and districts, enabling seamless integration with additional datasets, such as social security data, official student statistics, or the National Educational Panel Study (NEPS). Covering a total of 106,831 study programs between 1971 and 1996, [RWI-UNI-SUBJECTS](https://doi.org/10.7807/studi:buch:suf:v1) offers a publicly available, valuable foundation for interdisciplinary research on education, innovation, and economic development.

## Citation:
If you use this dataset, please cite it as:

```bibtex
@techreport{hertweck2024rwi,
  title={RWI-UNI-SUBJECTS: Complete records of all subjects across German HEIs (1971-1996)},
  author={Hertweck, Friederike and Jonas, Lukas and Thome, Boris and Yasar, Serife},
  year={2024},
  type={RWI-Micro Dataset}
  institution={RWI -- Leibniz Institute for Economic Research}
}
```
## Repository Overiew
The repository is organized into two main parts:

- `table_extraction/`: Contains all scripts used to extract tables from the “Study and Career Choice” books.
- `data_enrichment/`: Contains scripts used to enrich the extracted dataset with additional information, such as administrative codes for study fields, institutions, and districts.

## Table Extraction Documentation 
The script `table_extractor.py` contains the core functionality for table extraction, including line detection and template matching methods.  
The `Table_Extractor` class has been adapted individually for each book year to account for variations in scan quality and changes in table formatting. As a result, each year is handled by a dedicated script—for example, `71.py` for the 1971 edition.

Screenshots of the extracted tables are stored in the `tables/` subfolder, organized by type (university or UAS) and year (1971–1996). 
Due to copyright restrictions, we are unable to provide screenshots for all editions. Instead, we selected the year 1984 as a representative example. 

A demo of the full extraction process can be found in the accompanying notebook:  
👉 [1984 Table Extraction Demo (extraction_demo.ipynb)](https://github.com/Boshl/RWI-UNI-SUBJECTS/blob/main/extraction_demo.ipynb)

## Setup Instructions

This project uses a Conda environment to manage its dependencies.  
To run the scripts locally, please follow the steps below to create and activate the environment.

### Create the environment

Run the following command to create the environment from the provided `.yml` file:

```conda env create -f table_extraction/environment.yml```

The environment can be activated using the following command:
```conda activate rwi_uni_subjects_env```

## Data Enrichment Documentation 

<ins>
Master R-Script:
</ins>

“**master_script_dataset.R**”

<ins>
R-Studio-Project:
</ins>

“**data_enrichment.Rproj**” (Open the R-Project first, this sets the
working directory to the data enrichment folder and ensures the correct
execution of the code.)

### Required R-Packages:

- tidyverse 2.0.0 (including dplyr 1.1.4, forcats 1.0.0, ggplot2 3.5.1,
  lubridate 1.9.4, purrr 1.0.2, readr 2.1.5, stringr 1.5.1, tibble
  3.2.1, tidyr 1.3.1)
- readxl 1.4.3
- writexl 1.5.1
- reshape2 1.4.4
- conflicted 1.2.0
- data.table 1.16.4
- haven 2.5.4
- openxlsx 4.2.7.1
- mapproj 1.2.11
- geodata 0.6-2
- knitr 1.49
- kableExtra 1.4.0
- stargazer 5.2.3
- foreign 0.8-87
- terra 1.8-15
- spData 2.3.4
- tmap 4.0
- units 0.8-5
- sf 1.0-19
- sp 2.2-0
- raster 3.6-31
- maps 3.4.2.1

### R-File Description

*01_loop_uni.R*: Imports yearly data on study subjects at universities
from 1971 to 1996 by loop. Appends the years and exports a single
dataset.

*02_loop_fh.R*: Equivalent to 01_loop_uni.R but for technical colleges.

*03_loop_other.R*: Imports study subject data which does not follow the
same format as the previous data. This includes data on study subjects
in the East-German states from 1991 to 1996, data on army and church
(1991 to 1995) as well as on art and music (1991 to 1996) subjects and
data on teaching studies for 1996. Formats the data equivalently to the
previous data.

*04_combined.R*: Makes corrections on the previously exported datasets
and combines them into a single panel dataset.

*05_data_prep_spillover_dplyr.R*: Generates dataset with opening years
of universities and technical colleges and starting years of all study
subject on 3, 2, and 1 digit SF-levels.

*06_write_dataset.R*: Selects the relevant variables and renames them.
German terms for higher education facilities are translated to English.
Then, the panel dataset is exported and saved as
“HEI_and_subjects_1971-1996_v2.dta”.

*07_plausibility_check.R*: Graphically checks if everything worked.

*08_ags_sf_he_checks.R*: Manually corrects naming errors of higher
education facilities. Randomly generates sample to check the dataset one
last time. Then, the final dataset is exported and saved as
“HEI_and_subjects_1971-1996_v2_saved.dta”.

*09_descriptives.R*: Computes descriptives (figures, tables, maps).
Execution requires large geometry shapefile which is available upon
request.

### Folder Structure:

*data_final*: Folder for the final dataset. Empty at first, will be
filled with processed data upon first run of the script.

*data_input*: Contains data on the structure of German administrative
statistics on study subjects:

- *01_full_he_namen_harmonisiert.xlsx*: Matching higher education
  facility names from the original data to standardized names
- *01_full_sf_namen_harmonisiert.xlsx*: Matching study subject names
  from the original data to standardized names
- *01_full_stadt_namen_harmonisiert.xlsx*: Matching city names from the
  original data to standardized names
- *georef-germany-postleitzahl.csv*: Geometry shapefile for map
  generation in *09_descriptives.R* (available upon request)
- *he_namen_for_HS_Nummern.xlsx*: Manually matched higher education
  facility names from the “Destatis Schlüsselverzeichnis” to the names
  the original data
- *hochschul_liste_HS-Kompass.xlsx*: Postal data of all higher education
  facilities
- *HS_Nummern.xlsx*: Matching higher education facility number and name
- *Kopie von Kopie von 01_full_stadt_namen_harmonisiert_Alina.xlsx*:
  Manually checked correct matching of higher education facility names
  to harmonized names
- *Kopie von StadtOhneAGS.xlsx*: Manually collected AGS (German
  administrative reference numbers for municipalities) for observations
  where they were missing
- *kreis_namen_2013.xlsx*: Names of all German districts (as of 2013)
- *studenten-pruefungsstatistik.xlsx*: Matching study subject codes and
  names

*data_output*: Stores the temporary files exported in the scripts. Empty
at first, will be filled with processed data upon first run of the
script.

*fig*: Folder for the generated figures.

- *Kopie_Stadtnamen_missings_for_Standorte-Maps.xlsx*: Adjusting city
  names for display

*prog*: Contains the ten (sub-)scripts described above.

*tab*: Stores the generated decriptives tables.

*input_tables*: Contains all data on study subjects at universities,
technical colleges and other institutions (1971 to 1996).

- *ags.xlsx*: Matching administrative municipality code and name
- *FH*
  - *71-96*: Excel sheets with raw data from the scraping of the
    StudiBücher
- *Other*
  - *71-96*: Excel sheets with raw data from the scraping of the
    StudiBücher
- *Uni*
  - *71-96*: Excel sheets with raw data from the scraping of the
    StudiBücher

## Contact:

For further enquiry please contact: 
- [Boris Thome](https://dbs.cs.uni-duesseldorf.de/mitarbeiter.php?id=thome)
- [Serife Yasar](https://www.rwi-essen.de/rwi/team/person/serife-yasar) 
- [Research Data Center Ruhr (RWI FDZ Ruhr)](https://www.rwi-essen.de/forschung-beratung/weitere/forschungsdatenzentrum-ruhr) 
