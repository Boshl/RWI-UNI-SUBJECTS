from table_extractor import *


def extract_fh(year="96", type="FH"):
    mappings = {
        "Vollstudium": {"keyword": "1", "threshold": 0},
        "Vollstudium_WS_vorgeschrieben": {"keyword": "11", "threshold": 0},
        "Vollstudium_SS_vorgeschrieben": {"keyword": "13", "threshold": 0},
        "Schwerpunkt": {"keyword": "3", "threshold": 0},
        "Schwerpunkt_WS_vorgeschrieben": {"keyword": "31", "threshold": 0},
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
    )

    base_path = f"./table_extraction/tables/{type}/{year}/axis_labels"

    ##############################################################################

    number = 54
    t1 = fh.extract_page_join_over_cities(
        base_path,
        f"Name_{type}_S.{number}",
        f"Name_{type}_S.{number+1}",
        f"Studiengänge_{type}_S.{number}",
        f"{number}_1",
        f"{number}_2",
    )
    number += 1
    t2 = fh.extract_page_join_over_cities(
        base_path,
        f"Name_{type}_S.{number-1}",
        f"Name_{type}_S.{number}",
        f"Studiengänge_{type}_S.{number}",
        f"{number}_1",
        f"{number}_2",
    )
    df1 = pd.concat([t1, t2], axis=0)

    ##############################################################################

    number += 1
    t1 = fh.extract_page_join_over_cities(
        base_path,
        f"Name_{type}_S.{number}",
        f"Name_{type}_S.{number+1}",
        f"Studiengänge_{type}_S.{number}",
        f"{number}_1",
        f"{number}_2",
    )
    number += 1
    t2 = fh.extract_page_join_over_cities(
        base_path,
        f"Name_{type}_S.{number-1}",
        f"Name_{type}_S.{number}",
        f"Studiengänge_{type}_S.{number}",
        f"{number}_1",
        f"{number}_2",
    )
    df2 = pd.concat([t1, t2], axis=0)

    ##############################################################################

    number += 1
    t1 = fh.extract_page_join_over_cities(
        base_path,
        f"Name_{type}_S.{number}",
        f"Name_{type}_S.{number+1}",
        f"Studiengänge_{type}_S.{number}",
        f"{number}_1",
        f"{number}_2",
    )
    number += 1
    t2 = fh.extract_page_join_over_cities(
        base_path,
        f"Name_{type}_S.{number-1}",
        f"Name_{type}_S.{number}",
        f"Studiengänge_{type}_S.{number}",
        f"{number}_1",
        f"{number}_2",
    )
    df3 = pd.concat([t1, t2], axis=0)

    ##############################################################################

    number += 1
    t1 = fh.extract_page_join_over_cities(
        base_path,
        f"Name_{type}_S.{number}",
        f"Name_{type}_S.{number+1}",
        f"Studiengänge_{type}_S.{number}",
        f"{number}_1",
        f"{number}_2",
    )
    number += 1
    t2 = fh.extract_page_join_over_cities(
        base_path,
        f"Name_{type}_S.{number-1}",
        f"Name_{type}_S.{number}",
        f"Studiengänge_{type}_S.{number}",
        f"{number}_1",
        f"{number}_2",
    )
    df4 = pd.concat([t1, t2], axis=0)

    ##############################################################################

    final_df = pd.concat([df1, df2, df3, df4], axis=1)
    print(final_df)
    fh.df_to_excel_formatting(final_df)


def extract_uni(year="96", type="Uni"):
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
        line_detection_threshold=40,
        threshold=0.75,
    )

    base_path = f"./table_extraction/tables/{type}/{year}/axis_labels"

    ##############################################################################

    number = 40
    t1 = uni.extract_page_join_over_cities(
        base_path,
        f"Name_{type}s_1",
        f"Name_{type}s_2",
        f"Studiengänge_{type}s_S.{number}",
        f"{number}_1_rotated",
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


def extract_misc(type="Sonstiges", year="96"):
    mappings = {
        "vollstudium": {"keyword": "1", "threshold": 0.8},
        "vollstudium_2": {"keyword": "1", "threshold": 0.8},
        "vollstudium_ws_vg": {"keyword": "11", "threshold": 0.65},
        "vollstudium_ws_vg_2": {"keyword": "11", "threshold": 0.65},
        "vollstudium_ws_vg_3": {"keyword": "11", "threshold": 0.65},
        "vollstudium_ws_empf": {"keyword": "12", "threshold": 0.65},
        "schwerpunkt": {"keyword": "3", "threshold": 0.8},
        "schwerpunkt_2": {"keyword": "3", "threshold": 0.8},
        "schwerpunkt_ws_vg": {"keyword": "31", "threshold": 0.8},
        "teilstudium": {"keyword": "7", "threshold": 0.8},
        "zusatzfach": {"keyword": "8", "threshold": 0.8},
    }
    tx = Table_Extractor(
        year,
        type,
        mappings,
        show_lines=False,
        min_dist=25,
        threshold=0.75,
        line_detection_threshold=55,
    )
    base_path = f"./table_extraction/tables/{type}/{year}/axis_labels"

    # Musik
    p = 56
    page1 = tx.extract_semi_page(
        base_path,
        f"Name_{type}_S.{p}",
        f"Studiengänge_{type}_S.{p}",
        f"Sonstiges_Musik_1",
    )
    p = 57
    page2 = tx.extract_semi_page(
        base_path,
        f"Name_{type}_S.{p}",
        f"Studiengänge_{type}_S.{p-1}",
        f"Sonstiges_Musik_2",
    )
    df = pd.concat([page1, page2], axis=1)
    tx.df_to_excel_formatting(df, custom_name="Sonstiges_Musik_joined")

    # Kunst
    p = 58
    page1 = tx.extract_semi_page(
        base_path,
        f"Name_{type}_S.{p}",
        f"Studiengänge_{type}_S.{p}",
        f"Sonstiges_Kunst",
    )
    tx.df_to_excel_formatting(page1, custom_name="Sonstiges_Kunst_joined")

    tx = Table_Extractor(
        year,
        type,
        mappings,
        show_lines=False,
        min_dist=15,
        threshold=0.75,
        line_detection_threshold=80,
    )
    # Lehramt
    p = 252
    page1 = tx.extract_semi_page(
        base_path,
        f"Name_{type}_S.{p}",
        f"Studiengänge_{type}_S.{p}",
        f"Sonstiges_Lehramt_1",
    )
    p = 253
    page2 = tx.extract_semi_page(
        base_path,
        f"Name_{type}_S.{p}",
        f"Studiengänge_{type}_S.{p-1}",
        f"Sonstiges_Lehramt_2",
    )
    lehramt_1 = pd.concat([page1, page2], axis=1)
    tx.df_to_excel_formatting(lehramt_1, custom_name="Sonstiges_Lehramt_1_2_joined")

    p = 254
    page1 = tx.extract_semi_page(
        base_path,
        f"Name_{type}_S.{p}",
        f"Studiengänge_{type}_S.{p}",
        f"Sonstiges_Lehramt_3",
    )

    p = 255
    tx = Table_Extractor(
        year,
        type,
        mappings,
        line_detection=False,
        show_lines=True,
        min_dist=20,
        threshold=0.6,
        line_detection_threshold=90,
        last_row=False,
    )
    page2 = tx.extract_semi_page(
        base_path,
        f"Name_{type}_S.{p}",
        f"Studiengänge_{type}_S.{p-1}",
        f"Sonstiges_Lehramt_4_new",
    )
    lehramt_2 = pd.concat([page1, page2], axis=1)
    tx.df_to_excel_formatting(lehramt_2, custom_name="Sonstiges_Lehramt_3_4_joined")
    tx = Table_Extractor(
        year,
        type,
        mappings,
        show_lines=False,
        min_dist=20,
        threshold=0.75,
        line_detection_threshold=90,
    )
    p = 256
    page1 = tx.extract_semi_page(
        base_path,
        f"Name_{type}_S.{p}",
        f"Studiengänge_{type}_S.{p}",
        f"Sonstiges_Lehramt_5",
    )
    p = 257
    page2 = tx.extract_semi_page(
        base_path,
        f"Name_{type}_S.{p}",
        f"Studiengänge_{type}_S.{p-1}",
        f"Sonstiges_Lehramt_6",
    )
    lehramt_3 = pd.concat([page1, page2], axis=1)
    tx.df_to_excel_formatting(lehramt_3, custom_name="Sonstiges_Lehramt_5_6_joined")

    p = 258
    page1 = tx.extract_semi_page(
        base_path,
        f"Name_{type}_S.{p}",
        f"Studiengänge_{type}_S.{p}",
        f"Sonstiges_Lehramt_7",
    )
    p = 259
    page2 = tx.extract_semi_page(
        base_path,
        f"Name_{type}_S.{p}",
        f"Studiengänge_{type}_S.{p-1}",
        f"Sonstiges_Lehramt_8",
    )
    lehramt_4 = pd.concat([page1, page2], axis=1)
    tx.df_to_excel_formatting(lehramt_4, custom_name="Sonstiges_Lehramt_7_8_joined")

    # lehramt_final = pd.concat([lehramt_3, lehramt_4], axis=1)
    # tx.df_to_excel_formatting(lehramt_final, custom_name="Sonstiges_Lehramt_3")


extract_misc()
