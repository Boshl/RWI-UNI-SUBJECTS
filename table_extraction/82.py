from table_extractor import *


def extract_fh(type="FH", year="82"):
    mappings = {
        "Vollstudium": {"keyword": "1", "threshold": 0.72},
        "Vollstudium_WS_vorgeschrieben": {"keyword": "11", "threshold": 0.72},
        "Vollstudium_WS_empfohlen": {"keyword": "12", "threshold": 0.78},
        "Schwerpunkt": {"keyword": "3", "threshold": 0.75},
        "Aufbaustudium": {"keyword": "5", "threshold": 0.72},
    }

    fh = Table_Extractor(
        year,
        type,
        mappings,
        show_lines=True,
        min_dist=25,
        use_default_icons=False,
        gray_scale_matching=False,
        line_detection_threshold=40,
        confidence_based=False,
    )

    base_path = f"./table_extraction/tables/{type}/{year}/axis_labels"

    p1 = 46
    page1 = fh.extract_page(
        base_path,
        f"Name_{type}_S.{p1}",
        f"Studiengänge_{type}_S.{p1}_1",
        f"Studiengänge_{type}_S.{p1}_2",
        f"{p1}_1",
        f"{p1}_2",
    )

    p2 = 47
    page2 = fh.extract_page(
        base_path,
        f"Name_{type}_S.{p2}",
        f"Studiengänge_{type}_S.{p2}_1",
        f"Studiengänge_{type}_S.{p2}_2",
        f"{p2}_1",
        f"{p2}_2",
    )
    p3 = 48
    page3 = fh.extract_page(
        base_path,
        f"Name_{type}_S.{p3}",
        f"Studiengänge_{type}_S.{p3}_1",
        f"Studiengänge_{type}_S.{p3}_2",
        f"{p3}_1",
        f"{p3}_2",
    )

    final_df = pd.concat([page1, page2, page3], axis=1)
    print(final_df)
    fh.df_to_excel_formatting(final_df)


def extract_uni(type="Uni", year="82"):
    mappings = {
        "Vollstudium": {"keyword": "1", "threshold": 0.67},
        "Vollstudium_WS_vorgeschrieben": {"keyword": "11", "threshold": 0.7},
        "Vollstudium_WS_vorgeschrieben2": {"keyword": "11", "threshold": 0.7},
        "Vollstudium_WS_empfohlen": {"keyword": "12", "threshold": 0.78},
        "Vollstudium_WS_empfohlen_2": {"keyword": "12", "threshold": 0.78},
        "Schwerpunkt": {"keyword": "3", "threshold": 0.75},
        "Aufbaustudium": {"keyword": "5", "threshold": 0.72},
        "Teilstudium_bis": {"keyword": "7b", "threshold": 0.74},
        "Teilstudium_ab": {"keyword": "7a", "threshold": 0.74},
    }

    uni = Table_Extractor(
        year,
        type,
        mappings,
        show_lines=False,
        min_dist=25,
        use_default_icons=False,
        gray_scale_matching=True,
        line_detection_threshold=28,
        confidence_based=True,
    )

    base_path = f"./table_extraction/tables/{type}/{year}/axis_labels"

    p1 = 38
    page1 = uni.extract_semi_page(
        base_path, f"Name_{type}s_S.{p1}", f"Studiengänge_{type}s_S.{p1}", f"{p1}_1"
    )

    p2 = 39
    page2 = uni.extract_page(
        base_path,
        f"Name_{type}s_S.{p2}",
        f"Studiengänge_{type}s_S.{p2}_1",
        f"Studiengänge_{type}s_S.{p2}_2",
        f"{p2}_1",
        f"{p2}_2",
    )

    p3 = 40
    page3 = uni.extract_page(
        base_path,
        f"Name_{type}s_S.{p3}",
        f"Studiengänge_{type}s_S.{p3}_1",
        f"Studiengänge_{type}s_S.{p3}_2",
        f"{p3}_1",
        f"{p3}_2",
    )

    final_df = pd.concat([page1, page2, page3], axis=0)
    print(final_df)
    uni.df_to_excel_formatting(final_df)


def extract_misc(type="Sonstiges", year="82"):
    mappings = {
        "vollstudium": {"keyword": "1", "threshold": 0.7},
        "vollstudium_ws_vg": {"keyword": "11", "threshold": 0.78},
        "vollstudium_ws_empf": {"keyword": "12", "threshold": 0.95},
        "aufbaustudium": {"keyword": "5", "threshold": 0.8},
        "aufbaustudium_ws_vg": {"keyword": "51", "threshold": 0.8},
        # "aufbaustudium_ws_empf": {"keyword": "52", "threshold": 0.9},
        "schwerpunkt": {"keyword": "3", "threshold": 0.93},
        "schwerpunkt_ws_vg": {"keyword": "31", "threshold": 0.93},
        "teilstudium": {"keyword": "7", "threshold": 0.93},
        # "teilstudium_ws_vg": {"keyword": "71", "threshold": 0.9},
        # "teilstudium_ws_empf": {"keyword": "72", "threshold": 0.9}
    }
    tx = Table_Extractor(year, type, mappings, show_lines=True, min_dist=22)
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


extract_misc()
