from table_extractor import *


def extract_fh(year="93", type="FH"):
    mappings = {
        "Vollstudium": {"keyword": "1", "threshold": 0},
        "Vollstudium_WS_vorgeschrieben": {"keyword": "11", "threshold": 0},
        "Vollstudium_WS_empfohlen": {"keyword": "12", "threshold": 0},
        "Vollstudium_SS_vorgeschrieben": {"keyword": "13", "threshold": 0},
        "Schwerpunkt": {"keyword": "3", "threshold": 0},
        "Schwerpunkt_WS_vorgeschrieben": {"keyword": "31", "threshold": 0},
    }

    fh = Table_Extractor(
        year,
        type,
        mappings,
        show_lines=False,
        min_dist=30,
        use_default_icons=False,
        gray_scale_matching=False,
        line_detection_threshold=35,
    )

    base_path = f"./table_extraction/tables/{type}/{year}/axis_labels"

    ##############################################################################
    p1 = 84
    page1 = fh.extract_page_join_over_cities(
        base_path,
        f"Name_{type}_1",
        f"Name_{type}_2",
        f"Studiengänge_{type}_S.{p1}",
        f"{p1}_1",
        f"{p1}_2",
    )

    p1 = 85
    page2 = fh.extract_page_join_over_cities(
        base_path,
        f"Name_{type}_1",
        f"Name_{type}_2",
        f"Studiengänge_{type}_S.{p1}",
        f"{p1}_1",
        f"{p1}_2",
    )
    page1_2 = pd.concat([page1, page2], axis=0)
    ##############################################################################

    p1 = 86
    page3 = fh.extract_page_join_over_cities(
        base_path,
        f"Name_{type}_3",
        f"Name_{type}_4",
        f"Studiengänge_{type}_S.{p1}",
        f"{p1}_1",
        f"{p1}_2",
    )

    p1 = 87
    page4 = fh.extract_page_join_over_cities(
        base_path,
        f"Name_{type}_3",
        f"Name_{type}_4",
        f"Studiengänge_{type}_S.{p1}",
        f"{p1}_1",
        f"{p1+1}_2",
    )
    page3_4 = pd.concat([page3, page4], axis=0)

    fh = Table_Extractor(
        year,
        type,
        mappings,
        show_lines=False,
        min_dist=30,
        use_default_icons=False,
        gray_scale_matching=False,
        line_detection_threshold=30,
    )
    ##############################################################################
    p1 = 89
    page5 = fh.extract_page_join_over_cities(
        base_path,
        f"Name_{type}_5",
        f"Name_{type}_6",
        f"Studiengänge_{type}_S.{p1}",
        f"{p1}_1",
        f"{p1}_2",
    )

    p1 = 90
    page6 = fh.extract_page_join_over_cities(
        base_path,
        f"Name_{type}_5",
        f"Name_{type}_6",
        f"Studiengänge_{type}_S.{p1}",
        f"{p1}_1",
        f"{p1}_2",
    )
    page5_6 = pd.concat([page5, page6], axis=0)

    ##############################################################################
    p1 = 91
    page7 = fh.extract_page_join_over_cities(
        base_path,
        f"Name_{type}_7",
        f"Name_{type}_8",
        f"Studiengänge_{type}_S.{p1}",
        f"{p1}_1",
        f"{p1}_2",
    )

    p1 = 92
    page8 = fh.extract_page_join_over_cities(
        base_path,
        f"Name_{type}_7",
        f"Name_{type}_8",
        f"Studiengänge_{type}_S.{p1}",
        f"{p1}_1",
        f"{p1+1}_2",
    )
    page7_8 = pd.concat([page7, page8], axis=0)

    ##############################################################################
    final_df = pd.concat([page1_2, page3_4, page5_6, page7_8], axis=1)
    print(final_df)
    fh.df_to_excel_formatting(final_df)


def extract_uni(year="93", type="Uni"):
    mappings = {
        "Vollstudium": {"keyword": "1", "threshold": 0},
        "Vollstudium_WS_vorgeschrieben": {"keyword": "11", "threshold": 0},
        "Vollstudium_WS_empfohlen": {"keyword": "12", "threshold": 0},
        "Schwerpunkt": {"keyword": "3", "threshold": 0},
        "Schwerpunkt_WS_vorgeschrieben": {"keyword": "31", "threshold": 0},
        "Teilstudium_ab": {"keyword": "7a", "threshold": 0},
        # "Teilstudium_bis": {"keyword": "7b", "threshold": 0},
        "Nebenfach": {"keyword": "8", "threshold": 0},
    }

    fh = Table_Extractor(
        year,
        type,
        mappings,
        show_lines=False,
        min_dist=25,
        use_default_icons=False,
        gray_scale_matching=True,
        line_detection_threshold=45,
        threshold=0.75,
    )

    base_path = f"./table_extraction/tables/{type}/{year}/axis_labels"

    ##############################################################################

    p1 = 72
    page1 = fh.extract_page_join_over_cities(
        base_path,
        f"Name_{type}s_1",
        f"Name_{type}s_2",
        f"Studiengänge_{type}s_1",
        f"{p1}_1",
        f"{p1}_2",
    )

    p1 = 73
    page2 = fh.extract_page_join_over_cities(
        base_path,
        f"Name_{type}s_1",
        f"Name_{type}s_2",
        f"Studiengänge_{type}s_2",
        f"{p1}_1",
        f"{p1}_2",
    )

    p1 = 74
    page3 = fh.extract_page_join_over_cities(
        base_path,
        f"Name_{type}s_1",
        f"Name_{type}s_2",
        f"Studiengänge_{type}s_3",
        f"{p1}_1",
        f"{p1}_2",
    )

    p1 = 75
    page4 = fh.extract_page_join_over_cities(
        base_path,
        f"Name_{type}s_1",
        f"Name_{type}s_2",
        f"Studiengänge_{type}s_4",
        f"{p1}_1",
        f"{p1}_2",
    )

    page1_4 = pd.concat([page1, page2, page3, page4], axis=0)

    ##############################################################################
    p1 = 76
    page5 = fh.extract_page_join_over_cities(
        base_path,
        f"Name_{type}s_3",
        f"Name_{type}s_4",
        f"Studiengänge_{type}s_1",
        f"{p1}_1",
        f"{p1}_2",
    )

    p1 = 77
    page6 = fh.extract_page_join_over_cities(
        base_path,
        f"Name_{type}s_3",
        f"Name_{type}s_4",
        f"Studiengänge_{type}s_2",
        f"{p1}_1",
        f"{p1+1}_2",
    )

    p1 = 79
    page7 = fh.extract_page_join_over_cities(
        base_path,
        f"Name_{type}s_3",
        f"Name_{type}s_4",
        f"Studiengänge_{type}s_3",
        f"{p1}_1",
        f"{p1}_2_new_2",
    )

    p1 = 80
    page8 = fh.extract_page_join_over_cities(
        base_path,
        f"Name_{type}s_3",
        f"Name_{type}s_4",
        f"Studiengänge_{type}s_4",
        f"{p1}_1_new",
        f"{p1}_2",
    )

    page5_8 = pd.concat([page5, page6, page7, page8], axis=0)

    ##############################################################################
    final_df = pd.concat([page1_4, page5_8], axis=1)
    print(final_df)
    fh.df_to_excel_formatting(final_df)


def extract_misc(type="Sonstiges", year="93"):
    mappings = {
        "vollstudium": {"keyword": "1", "threshold": 0.8},
        "vollstudium_ws_vg": {"keyword": "11", "threshold": 0.65},
        "schwerpunkt": {"keyword": "3", "threshold": 0.8},
        "teilstudium": {"keyword": "7", "threshold": 0.8},
    }
    tx = Table_Extractor(
        year,
        type,
        mappings,
        show_lines=False,
        min_dist=20,
        threshold=0.75,
    )
    base_path = f"./table_extraction/tables/{type}/{year}/axis_labels"
    # Kirche
    p = 86
    print(f"Name_{type}_S.{p}")
    print(f"Studiengänge_{type}_S.{p}")
    page1 = tx.extract_semi_page(
        base_path,
        f"Name_{type}_S.{p}",
        f"Studiengänge_{type}_S.{p}",
        f"Sonstiges_Kirche",
    )
    tx.df_to_excel_formatting(page1, custom_name="Sonstiges_Kirche")
    # Kunst
    p = 87
    page1 = tx.extract_semi_page(
        base_path,
        f"Name_{type}_S.{p}",
        f"Studiengänge_{type}_S.{p}",
        f"Sonstiges_Kunst",
    )
    tx.df_to_excel_formatting(page1, custom_name="Sonstiges_Kunst")
    # Musik
    p = 88
    page1 = tx.extract_semi_page(
        base_path,
        f"Name_{type}_S.{p}",
        f"Studiengänge_{type}_S.{p}",
        f"Sonstiges_Musik_1",
    )

    page2 = tx.extract_semi_page(
        base_path,
        f"Name_{type}_S.{p}_2",
        f"Studiengänge_{type}_S.{p}",
        f"Sonstiges_Musik_2",
    )
    df = pd.concat([page1, page2], axis=1)
    tx.df_to_excel_formatting(df, custom_name="Sonstiges_Musik")
    # Bundeswehr
    p = 89
    page1 = tx.extract_semi_page(
        base_path,
        f"Name_{type}_S.{p}",
        f"Studiengänge_{type}_S.{p}",
        f"Sonstiges_Bundeswehr",
    )
    tx.df_to_excel_formatting(page1, custom_name="Sonstiges_Bundeswehr")


extract_misc()
