from table_extractor import *


def extract_fh(year="86", type="FH"):
    mappings = {
        "Vollstudium": {"keyword": "1", "threshold": 0},
        "Vollstudium_WS_vorgeschrieben": {"keyword": "11", "threshold": 0},
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
        line_detection_threshold=35,
    )

    base_path = f"./table_extraction/tables/{type}/{year}/axis_labels"

    p1 = 82
    p2 = 83
    df1 = fh.extract_page_join_over_cities(
        base_path,
        f"Name_{type}_S.{p1}",
        f"Name_{type}_S.{p2}",
        f"Studiengänge_{type}_S.{p1}",
        f"{p1}",
        f"{p2}",
    )
    p1 = 84
    p2 = 85
    df2 = fh.extract_page_join_over_cities(
        base_path,
        f"Name_{type}_S.{p1}",
        f"Name_{type}_S.{p2}",
        f"Studiengänge_{type}_S.{p1}",
        f"{p1}",
        f"{p2}",
    )

    page1 = pd.concat([df1, df2], axis=0)

    p1 = 86
    p2 = 87
    df3 = fh.extract_page_join_over_cities(
        base_path,
        f"Name_{type}_S.{p1}",
        f"Name_{type}_S.{p2}",
        f"Studiengänge_{type}_S.{p1}",
        f"{p1}",
        f"{p2}",
    )

    p1 = 88
    p2 = 89
    df4 = fh.extract_page_join_over_cities(
        base_path,
        f"Name_{type}_S.{p1}",
        f"Name_{type}_S.{p2}",
        f"Studiengänge_{type}_S.{p1}",
        f"{p1}",
        f"{p2}",
    )

    page2 = pd.concat([df3, df4], axis=0)

    p1 = 90
    p2 = 91
    df5 = fh.extract_page_join_over_cities(
        base_path,
        f"Name_{type}_S.{p1}",
        f"Name_{type}_S.{p2}",
        f"Studiengänge_{type}_S.{p1}",
        f"{p1}",
        f"{p2}",
    )

    p1 = 92
    p2 = 93
    df6 = fh.extract_page_join_over_cities(
        base_path,
        f"Name_{type}_S.{p1}",
        f"Name_{type}_S.{p2}",
        f"Studiengänge_{type}_S.{p1}",
        f"{p1}",
        f"{p2}",
    )

    page3 = pd.concat([df5, df6], axis=0)

    final_df = pd.concat([page1, page2, page3], axis=1)
    print(final_df)
    fh.df_to_excel_formatting(final_df)


def extract_uni(year="86", type="Uni"):
    mappings = {
        "Vollstudium": {"keyword": "1", "threshold": 0},
        "Vollstudium_WS_vorgeschrieben": {"keyword": "11", "threshold": 0},
        "Vollstudium_WS_empfohlen": {"keyword": "12", "threshold": 0},
        "Schwerpunkt": {"keyword": "3", "threshold": 0},
        "Schwerpunkt_WS_vorgeschrieben": {"keyword": "31", "threshold": 0},
        "Teilstudium_ab": {"keyword": "7a", "threshold": 0},
        "Teilstudium_bis": {"keyword": "7b", "threshold": 0},
    }

    fh = Table_Extractor(
        year,
        type,
        mappings,
        show_lines=False,
        min_dist=25,
        use_default_icons=False,
        gray_scale_matching=False,
        line_detection_threshold=35,
    )

    base_path = f"./table_extraction/tables/{type}/{year}/axis_labels"

    p1 = 70
    p2 = 71
    df1 = fh.extract_page_join_over_cities(
        base_path,
        f"Name_{type}s_S.{p1}",
        f"Name_{type}s_S.{p2}",
        f"Studiengänge_{type}s_S.{p1}",
        f"{p1}",
        f"{p2}",
    )
    p1 = 72
    p2 = 73
    df2 = fh.extract_page_join_over_cities(
        base_path,
        f"Name_{type}s_S.{p1}",
        f"Name_{type}s_S.{p2}",
        f"Studiengänge_{type}s_S.{p1}",
        f"{p1}",
        f"{p2}",
    )

    page1 = pd.concat([df1, df2], axis=0)

    p1 = 74
    p2 = 75
    df3 = fh.extract_page_join_over_cities(
        base_path,
        f"Name_{type}s_S.{p1}",
        f"Name_{type}s_S.{p2}",
        f"Studiengänge_{type}s_S.{p1}",
        f"{p1}",
        f"{p2}",
    )

    p1 = 76
    p2 = 77
    df4 = fh.extract_page_join_over_cities(
        base_path,
        f"Name_{type}s_S.{p1}",
        f"Name_{type}s_S.{p2}",
        f"Studiengänge_{type}s_S.{p1}",
        f"{p1}",
        f"{p2}",
    )

    page2 = pd.concat([df3, df4], axis=0)

    final_df = pd.concat([page1, page2], axis=0)
    print(final_df)
    fh.df_to_excel_formatting(final_df)


def extract_misc(type="Sonstiges", year="86"):
    mappings = {
        "vollstudium": {"keyword": "1", "threshold": 0.8},
        "vollstudium_ws_vg": {"keyword": "11", "threshold": 0.65},
        "vollstudium_ws_empf": {"keyword": "12", "threshold": 0.95},
        # "aufbaustudium": {"keyword": "5", "threshold": 0.8},
        # "aufbaustudium_ws_vg": {"keyword": "51", "threshold": 0.8},
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
        min_dist=24,
        threshold=0.71,
    )
    base_path = f"./table_extraction/tables/{type}/{year}/axis_labels"
    p = 76
    page1 = tx.extract_semi_page(
        base_path, f"Name_{type}_S.{p}", f"Studiengänge_{type}_S.{p}", f"Sonstiges_1"
    )
    p = 77
    page2 = tx.extract_semi_page(
        base_path, f"Name_{type}_S.{p}", f"Studiengänge_{type}_S.{p-1}", f"Sonstiges_2"
    )
    df = pd.concat([page1, page2], axis=1)
    print(df)
    tx.df_to_excel_formatting(df)


extract_misc()
