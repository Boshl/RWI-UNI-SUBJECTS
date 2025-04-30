from table_extractor import *


def extract_fh(year="92", type="FH"):
    mappings = {
        "Vollstudium": {"keyword": "1", "threshold": 0},
        "Vollstudium_WS_vorgeschrieben": {"keyword": "11", "threshold": 0},
        "Vollstudium_WS_empfohlen": {"keyword": "12", "threshold": 0},
        "Vollstudium_SS_vorgeschrieben": {"keyword": "13", "threshold": 0},
        "Schwerpunkt": {"keyword": "3", "threshold": 0},
        "Schwerpunkt_WS_vorgeschrieben": {"keyword": "31", "threshold": 0},
        # "Schwerpunkt_WS_empfohlen": {"keyword": "32", "threshold": 0}
    }

    fh = Table_Extractor(
        year,
        type,
        mappings,
        show_lines=True,
        min_dist=25,
        use_default_icons=False,
        gray_scale_matching=False,
        line_detection_threshold=33,
    )

    base_path = f"./table_extraction/tables/{type}/{year}/axis_labels"
    ##############################################################################
    p1 = 80
    df1 = fh.extract_semi_page(
        base_path, f"Name_{type}_S.{p1}_1", f"Studiengänge_{type}_S.{p1}", f"{p1}_1"
    )
    df2 = fh.extract_semi_page(
        base_path, f"Name_{type}_S.{p1}_2", f"Studiengänge_{type}_S.{p1}", f"{p1}_2"
    )
    semi_page1 = pd.concat([df1, df2], axis=1)

    p1 += 1
    df1 = fh.extract_semi_page(
        base_path, f"Name_{type}_S.{p1}_1", f"Studiengänge_{type}_S.{p1}", f"{p1}_1"
    )
    df2 = fh.extract_semi_page(
        base_path, f"Name_{type}_S.{p1}_2", f"Studiengänge_{type}_S.{p1}", f"{p1}_2"
    )
    semi_page2 = pd.concat([df1, df2], axis=1)

    page1 = pd.concat([semi_page1, semi_page2], axis=0)
    ##############################################################################
    p1 += 1
    df1 = fh.extract_semi_page(
        base_path, f"Name_{type}_S.{p1}_1", f"Studiengänge_{type}_S.{p1}", f"{p1}_1"
    )
    df2 = fh.extract_semi_page(
        base_path, f"Name_{type}_S.{p1}_2", f"Studiengänge_{type}_S.{p1}", f"{p1}_2"
    )
    semi_page1 = pd.concat([df1, df2], axis=1)

    p1 += 1
    df1 = fh.extract_semi_page(
        base_path, f"Name_{type}_S.{p1}_1", f"Studiengänge_{type}_S.{p1}", f"{p1}_1"
    )
    df2 = fh.extract_semi_page(
        base_path, f"Name_{type}_S.{p1}_2", f"Studiengänge_{type}_S.{p1}", f"{p1}_2"
    )
    semi_page2 = pd.concat([df1, df2], axis=1)
    page2 = pd.concat([semi_page1, semi_page2], axis=0)
    ##############################################################################
    p1 += 1
    df1 = fh.extract_semi_page(
        base_path, f"Name_{type}_S.{p1}_1", f"Studiengänge_{type}_S.{p1}", f"{p1}_1"
    )
    df2 = fh.extract_semi_page(
        base_path, f"Name_{type}_S.{p1}_2", f"Studiengänge_{type}_S.{p1}", f"{p1}_2"
    )
    semi_page1 = pd.concat([df1, df2], axis=1)

    p1 += 1
    df1 = fh.extract_semi_page(
        base_path, f"Name_{type}_S.{p1}_1", f"Studiengänge_{type}_S.{p1}", f"{p1}_1"
    )
    df2 = fh.extract_semi_page(
        base_path, f"Name_{type}_S.{p1}_2", f"Studiengänge_{type}_S.{p1}", f"{p1}_2"
    )
    semi_page2 = pd.concat([df1, df2], axis=1)
    page3 = pd.concat([semi_page1, semi_page2], axis=0)
    ##############################################################################
    p1 += 1
    df1 = fh.extract_semi_page(
        base_path, f"Name_{type}_S.{p1}_1", f"Studiengänge_{type}_S.{p1}", f"{p1}_1"
    )
    df2 = fh.extract_semi_page(
        base_path, f"Name_{type}_S.{p1}_2", f"Studiengänge_{type}_S.{p1}", f"{p1}_2"
    )
    semi_page1 = pd.concat([df1, df2], axis=1)

    p1 += 1
    df1 = fh.extract_semi_page(
        base_path, f"Name_{type}_S.{p1}_1", f"Studiengänge_{type}_S.{p1}", f"{p1}_1"
    )
    df2 = fh.extract_semi_page(
        base_path, f"Name_{type}_S.{p1}_2", f"Studiengänge_{type}_S.{p1}", f"{p1}_2"
    )
    semi_page2 = pd.concat([df1, df2], axis=1)
    page4 = pd.concat([semi_page1, semi_page2], axis=0)
    ##############################################################################
    final_df = pd.concat([page1, page2, page3, page4], axis=1)
    print(final_df)
    fh.df_to_excel_formatting(final_df)


def extract_uni(year="92", type="Uni"):
    mappings = {
        "Vollstudium": {"keyword": "1", "threshold": 0},
        "Vollstudium_2": {"keyword": "1", "threshold": 0},
        "Vollstudium_WS_vorgeschrieben": {"keyword": "11", "threshold": 0},
        "Vollstudium_WS_vorgeschrieben_2": {"keyword": "11", "threshold": 0},
        # "Vollstudium_WS_vorgeschrieben_3": {"keyword": "11", "threshold": 0},
        "Vollstudium_WS_empfohlen": {"keyword": "12", "threshold": 0},
        "Vollstudium_WS_empfohlen_2": {"keyword": "12", "threshold": 0},
        "Vollstudium_SS_vorgeschrieben": {"keyword": "13", "threshold": 0},
        "Schwerpunkt": {"keyword": "3", "threshold": 0},
        "Schwerpunkt_2": {"keyword": "3", "threshold": 0},
        "Schwerpunkt_WS_vorgeschrieben": {"keyword": "31", "threshold": 0},
        "Schwerpunkt_WS_vorgeschrieben_2": {"keyword": "31", "threshold": 0},
        "Schwerpunkt_WS_vorgeschrieben_3": {"keyword": "31", "threshold": 0},
        "Teilstudium_ab": {"keyword": "7a", "threshold": 0},
        "Teilstudium_bis": {"keyword": "7b", "threshold": 0},
        "Nebenfach": {"keyword": "8", "threshold": 0},
        "Keine_Studienanfaenger": {"keyword": "X", "threshold": 0},
    }
    uni = Table_Extractor(
        year,
        type,
        mappings,
        show_lines=False,
        min_dist=25,
        use_default_icons=False,
        gray_scale_matching=False,
        line_detection_threshold=22,
    )

    base_path = f"./table_extraction/tables/{type}/{year}/axis_labels"
    ##############################################################################
    p1 = 70
    page1 = uni.extract_page_join_over_cities(
        base_path,
        f"Name_{type}s_1",
        f"Name_{type}s_2",
        f"Studiengänge_{type}s_S.{p1}",
        f"{p1}_1",
        f"{p1}_2",
    )

    p1 += 1
    page2 = uni.extract_page_join_over_cities(
        base_path,
        f"Name_{type}s_1",
        f"Name_{type}s_2",
        f"Studiengänge_{type}s_S.{p1}",
        f"{p1}_1",
        f"{p1}_2",
    )

    p1 += 1
    page3 = uni.extract_page_join_over_cities(
        base_path,
        f"Name_{type}s_1",
        f"Name_{type}s_2",
        f"Studiengänge_{type}s_S.{p1}",
        f"{p1}_1",
        f"{p1}_2",
    )

    p1 += 1
    page4 = uni.extract_page_join_over_cities(
        base_path,
        f"Name_{type}s_1",
        f"Name_{type}s_2",
        f"Studiengänge_{type}s_S.{p1}",
        f"{p1}_1",
        f"{p1}_2",
    )

    final_df = pd.concat([page1, page2, page3, page4], axis=0)
    ##############################################################################
    uni = Table_Extractor(
        year,
        type,
        mappings,
        show_lines=False,
        min_dist=25,
        use_default_icons=False,
        gray_scale_matching=False,
        line_detection_threshold=25,
    )
    p1 += 1
    page5 = uni.extract_page_join_over_cities(
        base_path,
        f"Name_{type}s_3",
        f"Name_{type}s_4",
        f"Studiengänge_{type}s_S.{p1}",
        f"{p1}_1",
        f"{p1}_2",
    )

    p1 += 1
    page6 = uni.extract_page_join_over_cities(
        base_path,
        f"Name_{type}s_3",
        f"Name_{type}s_4",
        f"Studiengänge_{type}s_S.{p1}",
        f"{p1}_1",
        f"{p1}_2",
    )

    p1 += 1
    page7 = uni.extract_page_join_over_cities(
        base_path,
        f"Name_{type}s_3",
        f"Name_{type}s_4",
        f"Studiengänge_{type}s_S.{p1}",
        f"{p1}_1",
        f"{p1}_2",
    )

    p1 += 1
    page8 = uni.extract_page_join_over_cities(
        base_path,
        f"Name_{type}s_3",
        f"Name_{type}s_4",
        f"Studiengänge_{type}s_S.{p1}",
        f"{p1}_1",
        f"{p1}_2",
    )

    temp_df = pd.concat([page5, page6, page7, page8], axis=0)
    ##############################################################################
    final_df = pd.concat([final_df, temp_df], axis=1)
    print(final_df)
    uni.df_to_excel_formatting(final_df)


def extract_misc(type="Sonstiges", year="92"):
    mappings = {
        "vollstudium": {"keyword": "1", "threshold": 0.8},
        "vollstudium_ws_vg": {"keyword": "11", "threshold": 0.65},
        "vollstudium_ws_empf": {"keyword": "12", "threshold": 0.95},
        # "aufbaustudium": {"keyword": "5", "threshold": 0.8},
        # "aufbaustudium_ws_vg": {"keyword": "51", "threshold": 0.8},
        # "aufbaustudium_ws_empf": {"keyword": "52", "threshold": 0.9},
        "schwerpunkt": {"keyword": "3", "threshold": 0.8},
        "teilstudium": {"keyword": "7", "threshold": 0.8},
        "teilstudium_2": {"keyword": "7", "threshold": 0.8},
        "teilstudium_3": {"keyword": "7", "threshold": 0.8},
        # "teilstudium_ws_vg": {"keyword": "71", "threshold": 0.9},
        # "teilstudium_ws_empf": {"keyword": "72", "threshold": 0.9}
    }
    tx = Table_Extractor(
        year,
        type,
        mappings,
        show_lines=True,
        min_dist=10,
        threshold=0.75,
    )
    base_path = f"./table_extraction/tables/{type}/{year}/axis_labels"
    p = 84
    page1 = tx.extract_semi_page(
        base_path, f"Name_{type}_S.{p}", f"Studiengänge_{type}_S.{p}", f"Sonstiges_1"
    )
    tx.df_to_excel_formatting(page1, custom_name="Sonstiges_Kirche")
    p = 85
    page1 = tx.extract_semi_page(
        base_path, f"Name_{type}_S.{p}", f"Studiengänge_{type}_S.{p}", f"Sonstiges_2"
    )
    tx.df_to_excel_formatting(page1, custom_name="Sonstiges_Kunst")
    p = 86
    page1 = tx.extract_semi_page(
        base_path, f"Name_{type}_S.{p}", f"Studiengänge_{type}_S.{p}", f"Sonstiges_3"
    )
    p = 86
    page2 = tx.extract_semi_page(
        base_path, f"Name_{type}_S.{p}_2", f"Studiengänge_{type}_S.{p}", f"Sonstiges_4"
    )
    df = pd.concat([page1, page2], axis=1)
    tx.df_to_excel_formatting(df, custom_name="Sonstiges_Musik")
    p = 87
    page1 = tx.extract_semi_page(
        base_path, f"Name_{type}_S.{p}", f"Studiengänge_{type}_S.{p}", f"Sonstiges_5"
    )
    tx.df_to_excel_formatting(page1, custom_name="Sonstiges_Bundeswehr")


extract_misc()
