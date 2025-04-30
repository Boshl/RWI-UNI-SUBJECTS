from table_extractor import *


def extract_fh(year="95", type="FH"):
    mappings = {
        "Vollstudium": {"keyword": "1", "threshold": 0},
        "Vollstudium_WS_vorgeschrieben": {"keyword": "11", "threshold": 0},
        # "Vollstudium_WS_empfohlen": {"keyword": "12", "threshold": 0},
        "Vollstudium_SS_vorgeschrieben": {"keyword": "13", "threshold": 0},
        "Schwerpunkt": {"keyword": "3", "threshold": 0},
        "Schwerpunkt_WS_vorgeschrieben": {"keyword": "31", "threshold": 0},
        "Nebenfach": {"keyword": "8", "threshold": 0},
    }

    fh = Table_Extractor(
        year,
        type,
        mappings,
        show_lines=False,
        min_dist=25,
        use_default_icons=False,
        gray_scale_matching=False,
        line_detection_threshold=45,
        threshold=0.75,
    )

    base_path = f"./table_extraction/tables/{type}/{year}/axis_labels"

    ##############################################################################

    number = 80
    t1 = fh.extract_page_join_over_cities(
        base_path,
        f"Name_{type}_S.{number}_1",
        f"Name_{type}_S.{number}_2",
        f"Studiengänge_{type}_S.{number}",
        f"{number}_1",
        f"{number}_2",
    )
    number += 1
    t2 = fh.extract_page_join_over_cities(
        base_path,
        f"Name_{type}_S.{number-1}_1",
        f"Name_{type}_S.{number-1}_2",
        f"Studiengänge_{type}_S.{number}",
        f"{number}_1",
        f"{number}_2",
    )
    df1 = pd.concat([t1, t2], axis=0)

    ##############################################################################

    number += 1
    t1 = fh.extract_page_join_over_cities(
        base_path,
        f"Name_{type}_S.{number}_1",
        f"Name_{type}_S.{number}_2",
        f"Studiengänge_{type}_S.{number}",
        f"{number}_1",
        f"{number}_2",
    )
    number += 1
    t2 = fh.extract_page_join_over_cities(
        base_path,
        f"Name_{type}_S.{number-1}_1",
        f"Name_{type}_S.{number-1}_2",
        f"Studiengänge_{type}_S.{number}",
        f"{number}_1",
        f"{number}_2",
    )
    df2 = pd.concat([t1, t2], axis=0)

    ##############################################################################

    number += 1
    t1 = fh.extract_page_join_over_cities(
        base_path,
        f"Name_{type}_S.{number}_1",
        f"Name_{type}_S.{number}_2",
        f"Studiengänge_{type}_S.{number}",
        f"{number}_1",
        f"{number}_2",
    )
    number += 1
    t2 = fh.extract_page_join_over_cities(
        base_path,
        f"Name_{type}_S.{number-1}_1",
        f"Name_{type}_S.{number-1}_2",
        f"Studiengänge_{type}_S.{number}",
        f"{number}_1",
        f"{number}_2",
    )
    df3 = pd.concat([t1, t2], axis=0)

    ##############################################################################

    number += 1
    t1 = fh.extract_page_join_over_cities(
        base_path,
        f"Name_{type}_S.{number}_1",
        f"Name_{type}_S.{number}_2",
        f"Studiengänge_{type}_S.{number}",
        f"{number}_1",
        f"{number}_2",
    )
    number += 1
    t2 = fh.extract_page_join_over_cities(
        base_path,
        f"Name_{type}_S.{number-1}_1",
        f"Name_{type}_S.{number-1}_2",
        f"Studiengänge_{type}_S.{number}",
        f"{number}_1",
        f"{number}_2",
    )
    df4 = pd.concat([t1, t2], axis=0)

    ##############################################################################

    final_df = pd.concat([df1, df2, df3, df4], axis=1)
    print(final_df)
    fh.df_to_excel_formatting(final_df)


def extract_uni(year="95", type="Uni"):
    mappings = {
        "Vollstudium": {"keyword": "1", "threshold": 0},
        "Vollstudium_WS_vorgeschrieben": {"keyword": "11", "threshold": 0},
        "Vollstudium_WS_empfohlen": {"keyword": "12", "threshold": 0},
        "Schwerpunkt": {"keyword": "3", "threshold": 0},
        "Schwerpunkt_WS_vorgeschrieben": {"keyword": "31", "threshold": 0},
        "Teilstudium_ab": {"keyword": "7a", "threshold": 0},
        "Teilstudium_bis": {"keyword": "7b", "threshold": 0},
        "Nebenfach": {"keyword": "8", "threshold": 0},
    }

    uni = Table_Extractor(
        year,
        type,
        mappings,
        show_lines=False,
        min_dist=30,
        use_default_icons=False,
        gray_scale_matching=False,
        line_detection_threshold=45,
    )

    base_path = f"./table_extraction/tables/{type}/{year}/axis_labels"

    ##############################################################################

    number = 70
    t1 = uni.extract_page_join_over_cities(
        base_path,
        f"Name_{type}s_1",
        f"Name_{type}s_2",
        f"Studiengänge_{type}s_S.{number}",
        f"{number}_1",
        f"{number}_2",
    )
    number += 1
    t2 = uni.extract_page_join_over_cities(
        base_path,
        f"Name_{type}s_1",
        f"Name_{type}s_2",
        f"Studiengänge_{type}s_S.{number}",
        f"{number}_1",
        f"{number}_2",
    )
    number += 1
    t3 = uni.extract_page_join_over_cities(
        base_path,
        f"Name_{type}s_1",
        f"Name_{type}s_2",
        f"Studiengänge_{type}s_S.{number}",
        f"{number}_1",
        f"{number}_2",
    )
    number += 1
    t4 = uni.extract_page_join_over_cities(
        base_path,
        f"Name_{type}s_1",
        f"Name_{type}s_2",
        f"Studiengänge_{type}s_S.{number}",
        f"{number}_1",
        f"{number}_2",
    )

    df1 = pd.concat([t1, t2, t3, t4], axis=0)

    ##############################################################################
    number += 1
    t1 = uni.extract_page_join_over_cities(
        base_path,
        f"Name_{type}s_3",
        f"Name_{type}s_4",
        f"Studiengänge_{type}s_S.{number}",
        f"{number}_1",
        f"{number}_2",
    )
    number += 1
    t2 = uni.extract_page_join_over_cities(
        base_path,
        f"Name_{type}s_3",
        f"Name_{type}s_4",
        f"Studiengänge_{type}s_S.{number}",
        f"{number}_1",
        f"{number}_2",
    )
    number += 1
    t3 = uni.extract_page_join_over_cities(
        base_path,
        f"Name_{type}s_3",
        f"Name_{type}s_4",
        f"Studiengänge_{type}s_S.{number}",
        f"{number}_1",
        f"{number}_2",
    )
    number += 1
    t4 = uni.extract_page_join_over_cities(
        base_path,
        f"Name_{type}s_3",
        f"Name_{type}s_4",
        f"Studiengänge_{type}s_S.{number}",
        f"{number}_1",
        f"{number}_2",
    )

    df2 = pd.concat([t1, t2, t3, t4], axis=0)

    ##############################################################################

    final_df = pd.concat([df1, df2], axis=1)
    print(final_df)
    uni.df_to_excel_formatting(final_df)


def extract_misc(type="Sonstiges", year="95"):
    mappings = {
        "vollstudium": {"keyword": "1", "threshold": 0.8},
        "vollstudium_2": {"keyword": "1", "threshold": 0.8},
        "vollstudium_3": {"keyword": "1", "threshold": 0.8},
        "vollstudium_4": {"keyword": "1", "threshold": 0.8},
        "vollstudium_ws_vg": {"keyword": "11", "threshold": 0.65},
        "vollstudium_ws_vg_2": {"keyword": "11", "threshold": 0.65},
        "vollstudium_ws_vg_3": {"keyword": "11", "threshold": 0.65},
        "schwerpunkt": {"keyword": "3", "threshold": 0.8},
        "schwerpunkt_ws_vg": {"keyword": "31", "threshold": 0.8},
        "schwerpunkt_2": {"keyword": "3", "threshold": 0.8},
        "teilstudium": {"keyword": "7", "threshold": 0.8},
        "teilstudium_2": {"keyword": "7", "threshold": 0.8},
        "teilstudium_3": {"keyword": "7", "threshold": 0.8},
        "teilstudium_4": {"keyword": "7", "threshold": 0.8},
        "nebenfach": {"keyword": "8", "threshold": 0.8},
    }
    tx = Table_Extractor(
        year,
        type,
        mappings,
        show_lines=False,
        min_dist=25,
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
