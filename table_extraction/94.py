from table_extractor import *


def extract_fh(year="94", type="FH"):
    mappings = {
        "Vollstudium": {"keyword": "1", "threshold": 0},
        "Vollstudium_WS_vorgeschrieben": {"keyword": "11", "threshold": 0},
        # "Vollstudium_WS_empfohlen": {"keyword": "12", "threshold": 0},
        "Vollstudium_SS_vorgeschrieben": {"keyword": "13", "threshold": 0},
        "Schwerpunkt": {"keyword": "3", "threshold": 0},
        "Schwerpunkt_WS_vorgeschrieben": {"keyword": "31", "threshold": 0},
    }

    fh = Table_Extractor(
        year,
        type,
        mappings,
        show_lines=True,
        min_dist=30,
        use_default_icons=False,
        gray_scale_matching=False,
        line_detection_threshold=40,
    )

    base_path = f"./table_extraction/tables/{type}/{year}/axis_labels"

    page_number = 90
    t1 = extract_page_helper_fh(fh, base_path, page_number)
    page_number += 2
    t2 = extract_page_helper_fh(fh, base_path, page_number)
    df1 = pd.concat([t1, t2], axis=0)
    ##############################################################################

    page_number += 2
    t1 = extract_page_helper_fh(fh, base_path, page_number)
    page_number += 2
    t2 = extract_page_helper_fh(fh, base_path, page_number)
    df2 = pd.concat([t1, t2], axis=0)

    ##############################################################################

    page_number += 2
    t1 = extract_page_helper_fh(fh, base_path, page_number)
    page_number += 2
    t2 = extract_page_helper_fh(fh, base_path, page_number)
    df3 = pd.concat([t1, t2], axis=0)

    ##############################################################################

    page_number += 2
    t1 = extract_page_helper_fh(fh, base_path, page_number)
    page_number += 2
    t2 = extract_page_helper_fh(fh, base_path, page_number)
    df4 = pd.concat([t1, t2], axis=0)

    ##############################################################################

    final_df = pd.concat([df1, df2, df3, df4], axis=1)
    print(final_df)
    fh.df_to_excel_formatting(final_df)


def extract_page_helper(extractor, base_path, p):
    page1 = extractor.extract_semi_page(
        base_path,
        f"Name_{extractor.type}s_S.{p}",
        f"Studiengänge_{extractor.type}s_S.{p}",
        f"{p}",
    )
    page2 = extractor.extract_semi_page(
        base_path,
        f"Name_{extractor.type}s_S.{p+1}",
        f"Studiengänge_{extractor.type}s_S.{p}",
        f"{p+1}",
    )
    return pd.concat([page1, page2], axis=1)


def extract_page_helper_fh(extractor, base_path, p):
    page1 = extractor.extract_semi_page(
        base_path,
        f"Name_{extractor.type}_S.{p}",
        f"Studiengänge_{extractor.type}_S.{p}",
        f"{p}",
    )
    page2 = extractor.extract_semi_page(
        base_path,
        f"Name_{extractor.type}_S.{p+1}",
        f"Studiengänge_{extractor.type}_S.{p}",
        f"{p+1}",
    )
    return pd.concat([page1, page2], axis=1)


def extract_uni(year="94", type="Uni"):
    mappings = {
        "Vollstudium": {"keyword": "1", "threshold": 0},
        "Vollstudium_WS_vorgeschrieben": {"keyword": "11", "threshold": 0},
        "Vollstudium_WS_empfohlen": {"keyword": "12", "threshold": 0},
        "Vollstudium_WS_empfohlen_2": {"keyword": "12", "threshold": 0},
        "Schwerpunkt": {"keyword": "3", "threshold": 0},
        "Schwerpunkt_WS_vorgeschrieben": {"keyword": "31", "threshold": 0},
        "Teilstudium_ab": {"keyword": "7a", "threshold": 0},
        # "Teilstudium_bis": {"keyword": "7b", "threshold": 0},
        "Nebenfach": {"keyword": "8", "threshold": 0},
    }

    uni = Table_Extractor(
        year,
        type,
        mappings,
        show_lines=False,
        min_dist=25,
        use_default_icons=False,
        gray_scale_matching=True,
        line_detection_threshold=40,
    )
    base_path = f"./table_extraction/tables/{type}/{year}/axis_labels"

    ##############################################################################

    page = 70
    p1 = extract_page_helper(uni, base_path, page)
    page += 2
    p2 = extract_page_helper(uni, base_path, page)
    page += 2
    p3 = extract_page_helper(uni, base_path, page)
    page += 2
    p4 = extract_page_helper(uni, base_path, page)

    ##############################################################################

    page += 2
    p5 = extract_page_helper(uni, base_path, page)
    page += 2
    p6 = extract_page_helper(uni, base_path, page)
    page += 2
    p7 = extract_page_helper(uni, base_path, page)
    page += 2
    p8 = extract_page_helper(uni, base_path, page)

    ##############################################################################
    df1 = pd.concat([p1, p2, p3, p4], axis=0)
    df2 = pd.concat([p5, p6, p7, p8], axis=0)
    final_df = pd.concat([df1, df2], axis=1)
    print(final_df)
    uni.df_to_excel_formatting(final_df)


def extract_misc(type="Sonstiges", year="94"):
    mappings = {
        "vollstudium": {"keyword": "1", "threshold": 0.8},
        "vollstudium_2": {"keyword": "1", "threshold": 0.8},
        "vollstudium_3": {"keyword": "1", "threshold": 0.8},
        "vollstudium_4": {"keyword": "1", "threshold": 0.8},
        "vollstudium_ws_vg": {"keyword": "11", "threshold": 0.65},
        "vollstudium_ws_vg_2": {"keyword": "11", "threshold": 0.65},
        "vollstudium_ws_vg_3": {"keyword": "11", "threshold": 0.65},
        "schwerpunkt": {"keyword": "3", "threshold": 0.8},
        "schwerpunkt_2": {"keyword": "3", "threshold": 0.8},
        "teilstudium": {"keyword": "7", "threshold": 0.8},
        "teilstudium_2": {"keyword": "7", "threshold": 0.8},
        "teilstudium_3": {"keyword": "7", "threshold": 0.8},
        "teilstudium_4": {"keyword": "7", "threshold": 0.8},
    }
    tx = Table_Extractor(
        year,
        type,
        mappings,
        show_lines=False,
        min_dist=32,
        threshold=0.75,
    )
    base_path = f"./table_extraction/tables/{type}/{year}/axis_labels"
    # Kirche
    p = 84
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
    p = 85
    page1 = tx.extract_semi_page(
        base_path,
        f"Name_{type}_S.{p}",
        f"Studiengänge_{type}_S.{p}",
        f"Sonstiges_Kunst",
    )
    tx.df_to_excel_formatting(page1, custom_name="Sonstiges_Kunst")
    # Musik
    p = 86
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
    p = 87
    page1 = tx.extract_semi_page(
        base_path,
        f"Name_{type}_S.{p}",
        f"Studiengänge_{type}_S.{p}",
        f"Sonstiges_Bundeswehr",
    )
    tx.df_to_excel_formatting(page1, custom_name="Sonstiges_Bundeswehr")


extract_misc()
