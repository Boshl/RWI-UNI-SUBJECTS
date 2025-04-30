from table_extractor import *


def extract_fh(mappings):
    year = "85"
    type = "FH"
    fh = Table_Extractor(
        year,
        type,
        mappings,
        show_lines=True,
        line_detection_threshold=20,
        confidence_based=False,
    )
    text_path = f"./table_extraction/tables/{type}/{year}/axis_labels"
    page1 = fh.extract_page(
        text_path,
        city_file="FH85_Name_S.48.txt",
        degrees1_file="FH85_Studiengang_S.48.txt",
        degrees2_file="FH85_Studiengang_S.49.txt",
        image1="50_1",
        image2="50_2",
    )
    page2 = fh.extract_page(
        text_path,
        city_file="FH85_Name_S.50.txt",
        degrees1_file="FH85_Studiengang_S.48.txt",
        degrees2_file="FH85_Studiengang_S.49.txt",
        image1="51_1",
        image2="51_2",
    )
    page3 = fh.extract_page(
        text_path,
        city_file="FH85_Name_S.52.txt",
        degrees1_file="FH85_Studiengang_S.48.txt",
        degrees2_file="FH85_Studiengang_S.49.txt",
        image1="52_1",
        image2="52_2",
    )

    final_df = pd.concat([page1, page2], axis=1)
    final_df = pd.concat([final_df, page3], axis=1)
    fh.df_to_excel_formatting(final_df)


def extract_uni(mappings):
    year = "85"
    type = "Uni"
    uni = Table_Extractor(
        year,
        type,
        mappings,
        show_lines=True,
        line_detection_threshold=30,
        confidence_based=True,
        threshold=0.75,
    )
    text_path = f"./table_extraction/tables/{type}/{year}/axis_labels"
    page1 = uni.extract_semi_page(
        text_path,
        cities_txt="Uni85_Name_S.37",
        degrees_txt="Uni85_Studiengang_S.37",
        screenshot="42_1",
    )
    page2 = uni.extract_page(
        text_path,
        cities_txt="Uni85_Name_S.37",
        degrees1_txt="Uni85_Studiengang_S.38",
        degrees2_txt="Uni85_Studiengang_S.39",
        screenshot1="43_1",
        screenshot2="43_2",
    )
    page3 = uni.extract_page(
        text_path,
        cities_txt="Uni85_Name_S.37",
        degrees1_txt="Uni85_Studiengang_S.40",
        degrees2_txt="Uni85_Studiengang_S.41",
        screenshot1="44_1",
        screenshot2="44_2",
    )
    """
    page4 = uni.extract_page(text_path,
                             city_file="Uni85_Name_S.37.txt",
                             degrees1_file="Uni85_Studiengang_S.42",
                             degrees2_file="Uni85_Studiengang_S.43",
                             image1="45_1",
                             image2="45_2")
    """

    final_df = pd.concat([page1, page2, page3], axis=0)
    # final_df = pd.concat([final_df, page4], axis=1)
    uni.df_to_excel_formatting(final_df)


def extract_uni_misc(mappings):
    year = "85"
    type = "Uni"
    uni = Table_Extractor(
        year,
        type,
        mappings,
        show_lines=True,
        line_detection_threshold=30,
        confidence_based=False,
    )
    text_path = f"./table_extraction/tables/{type}/{year}/axis_labels"

    page1 = uni.extract_page(
        text_path,
        cities_txt="Weitere_Name_85-86.txt",
        degrees1_file="Weitere_Studiengang_85-86.txt",
        degrees2_file="",
        image1="45_1",
        image2="",
        multi_table=False,
    )
    page2 = uni.extract_page(
        text_path,
        cities_txt="Weitere_Name_85-86_2.txt",
        degrees1_file="Weitere_Studiengang_85-86_2.txt",
        degrees2_file="Weitere_Studiengang_85-86_2.txt",
        image1="45_2",
        image2="45_2",
        multi_table=False,
    )
    uni.df_to_excel_formatting(page1, interim_result=True, custom_name="weitere1")
    uni.df_to_excel_formatting(page2, interim_result=True, custom_name="weitere2")


mappings = {
    "Vollstudium": {"keyword": "1", "threshold": 0.75},
    "Vollstudium_WS_vorgeschrieben": {"keyword": "11", "threshold": 0.85},
    "Vollstudium_WS_empfohlen": {"keyword": "12", "threshold": 0.85},
    "Schwerpunkt": {"keyword": "3", "threshold": 0.8},
    "Schwerpunkt_WS_vorgeschrieben": {"keyword": "31", "threshold": 0.9},
    "Aufbaustudium": {"keyword": "5", "threshold": 0.8},
    "aufbaustudium_ws_erforderlich": {"keyword": "51", "threshold": 0.85},
    "aufbaustudium_ws_empfohlen": {"keyword": "52", "threshold": 0.85},
    "teilstudium_ab": {"keyword": "7a", "threshold": 0.85},
    "teilstudium_bis": {"keyword": "7b", "threshold": 0.85},
}


def extract_misc(type="Sonstiges", year="85"):
    mappings = {
        "vollstudium": {"keyword": "1", "threshold": 0.8},
        "vollstudium_ws_vg": {"keyword": "11", "threshold": 0.65},
        "vollstudium_ws_empf": {"keyword": "12", "threshold": 0.95},
        "aufbaustudium": {"keyword": "5", "threshold": 0.8},
        "aufbaustudium_ws_vg": {"keyword": "51", "threshold": 0.8},
        # "aufbaustudium_ws_empf": {"keyword": "52", "threshold": 0.9},
        "schwerpunkt": {"keyword": "3", "threshold": 0.8},
        "schwerpunkt_ws_vg": {"keyword": "31", "threshold": 0.8},
        "teilstudium": {"keyword": "7", "threshold": 0.8},
        # "teilstudium_ws_vg": {"keyword": "71", "threshold": 0.9},
        # "teilstudium_ws_empf": {"keyword": "72", "threshold": 0.9}
    }
    tx = Table_Extractor(
        year,
        type,
        mappings,
        show_lines=True,
        min_dist=22,
        threshold=0.79,
    )
    base_path = f"./table_extraction/tables/{type}/{year}/axis_labels"
    p = 42
    df = tx.extract_semi_page(
        base_path,
        f"Name_{type}_S.{p}",
        f"Studiengänge_{type}_S.{p}",
        f"Sonstiges",
        write_to_file=False,
    )
    tx.df_to_excel_formatting(df)


extract_uni(mappings)
