import shutil

"""
this script was used to collect all extracted tables and interim results and put them into the results folder
"""


# collects data for universities of applied science (UAs) and universities
def collect_data(from_year, to_year):
    try:
        shutil.rmtree(f"./table_extraction/results/FH/")
        shutil.rmtree(f"./table_extraction/results/Uni/")
    except:
        print("No folders existed.")
    years = range(from_year, to_year + 1)
    for year in years:
        type = "FH"
        shutil.copytree(
            f"./table_extraction/tables/{type}/{year}/results",
            f"./table_extraction/results/{type}/{year}",
        )
        type = "Uni"
        shutil.copytree(
            f"./table_extraction/tables/{type}/{year}/results",
            f"./table_extraction/results/{type}/{year}",
        )


# some tables contain additional institutions that just offer arts or similar subjects. the results are collected here:
def collect_data_other(from_year, to_year):
    try:
        shutil.rmtree(f"./table_extraction/results/Sonstiges/")
    except:
        print("No folders existed.")
    years = range(from_year, to_year + 1)
    for year in years:
        type = "Sonstiges"
        shutil.copytree(
            f"./table_extraction/tables/{type}/{year}/results",
            f"./table_extraction/results/{type}/{year}",
        )


# NOTE: remove the comment to execute the script
# collect_data(71, 96)
# collect_data_other(78, 96)
