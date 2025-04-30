from table_extractor import *


def extract_fh(type="FH", year="81"):
    mappings = {
        "Vollstudium": {"keyword": "1", "threshold": 0.72},
        "Vollstudium_WS_vorgeschrieben": {"keyword": "11", "threshold": 0.72},
        "Vollstudium_WS_vorgeschrieben2": {"keyword": "11", "threshold": 0.72},
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

    p1 = 49
    page1 = fh.extract_page(
        base_path,
        f"Name_{type}_S.{p1}",
        f"Studiengänge_{type}_S.{p1}_1",
        f"Studiengänge_{type}_S.{p1}_2",
        f"{p1}_1",
        f"{p1}_2",
    )

    p2 = 50
    page2 = fh.extract_page(
        base_path,
        f"Name_{type}_S.{p2}",
        f"Studiengänge_{type}_S.{p2}_1",
        f"Studiengänge_{type}_S.{p2}_2",
        f"{p2}_1",
        f"{p2}_2",
    )
    p3 = 51
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


def extract_uni(type="Uni", year="81"):
    mappings = {
        "Vollstudium": {"keyword": "1", "threshold": 0.67},
        "Vollstudium2": {"keyword": "1", "threshold": 0.67},
        "Vollstudium3": {"keyword": "1", "threshold": 0.67},
        "Vollstudium_WS_vorgeschrieben": {"keyword": "11", "threshold": 0.72},
        "Vollstudium_WS_vorgeschrieben2": {"keyword": "11", "threshold": 0.72},
        "Vollstudium_WS_vorgeschrieben_3": {"keyword": "11", "threshold": 0.72},
        "Vollstudium_WS_vorgeschrieben_4": {"keyword": "11", "threshold": 0.72},
        "Vollstudium_WS_vorgeschrieben_5": {"keyword": "11", "threshold": 0.72},
        "Vollstudium_WS_vorgeschrieben_6": {"keyword": "11", "threshold": 0.72},
        "Vollstudium_WS_empfohlen": {"keyword": "12", "threshold": 0.78},
        "Vollstudium_WS_empfohlen2": {"keyword": "12", "threshold": 0.78},
        "Vollstudium_WS_empfohlen_3": {"keyword": "12", "threshold": 0.78},
        "Schwerpunkt": {"keyword": "3", "threshold": 0.75},
        "Schwerpunkt2": {"keyword": "3", "threshold": 0.75},
        "Schwerpunkt_3": {"keyword": "3", "threshold": 0.75},
        "Schwerpunkt_4": {"keyword": "3", "threshold": 0.75},
        "Aufbaustudium": {"keyword": "5", "threshold": 0.72},
        "Aufbaustudium2": {"keyword": "5", "threshold": 0.72},
        "Teilstudium_bis": {"keyword": "7b", "threshold": 0.74},
        "Teilstudium_ab": {"keyword": "7a", "threshold": 0.74},
    }

    fh = Table_Extractor(
        year,
        type,
        mappings,
        show_lines=False,
        min_dist=25,
        use_default_icons=False,
        gray_scale_matching=False,
        line_detection_threshold=28,
        confidence_based=True,
    )

    base_path = f"./table_extraction/tables/{type}/{year}/axis_labels"

    p1 = 41
    page1 = fh.extract_semi_page(
        base_path, f"Name_{type}s_S.{p1}", f"Studiengänge_{type}s_S.{p1}", f"{p1}_1"
    )

    p2 = 42
    page2 = fh.extract_page(
        base_path,
        f"Name_{type}s_S.{p2}",
        f"Studiengänge_{type}s_S.{p2}_1",
        f"Studiengänge_{type}s_S.{p2}_2",
        f"{p2}_1",
        f"{p2}_2",
    )

    p3 = 43
    page3 = fh.extract_page(
        base_path,
        f"Name_{type}s_S.{p3}",
        f"Studiengänge_{type}s_S.{p3}_1",
        f"Studiengänge_{type}s_S.{p3}_2",
        f"{p3}_1",
        f"{p3}_2",
    )

    final_df = pd.concat([page1, page2, page3], axis=0)
    print(final_df)
    fh.df_to_excel_formatting(final_df)


def extract_misc(type="Sonstiges", year="81"):
    mappings = {
        "vollstudium": {"keyword": "1", "threshold": 0.7},
        "vollstudium_2": {"keyword": "1", "threshold": 0.8},
        "vollstudium_ws_vg": {"keyword": "11", "threshold": 0.78},
        "vollstudium_ws_vg_2": {"keyword": "11", "threshold": 0.78},
        "vollstudium_ws_vg_3": {"keyword": "11", "threshold": 0.78},
        "vollstudium_ws_empf": {"keyword": "12", "threshold": 0.95},
        "vollstudium_ws_empf_2": {"keyword": "12", "threshold": 0.88},
        "aufbaustudium": {"keyword": "5", "threshold": 0.8},
        "aufbaustudium_ws_vg": {"keyword": "51", "threshold": 0.8},
        # "aufbaustudium_ws_empf": {"keyword": "52", "threshold": 0.9},
        "teilstudium": {"keyword": "7", "threshold": 0.93},
        # "teilstudium_ws_vg": {"keyword": "71", "threshold": 0.9},
        # "teilstudium_ws_empf": {"keyword": "72", "threshold": 0.9}
    }
    tx = Table_Extractor(
        year,
        type,
        mappings,
        show_lines=True,
        min_dist=22,
        confidence_based=False,
    )
    base_path = f"./table_extraction/tables/{type}/{year}/axis_labels"
    p = 46
    df = tx.extract_semi_page(
        base_path,
        f"Name_{type}_S.{p}",
        f"Studiengänge_{type}_S.{p}",
        f"Sonstiges",
        write_to_file=False,
    )
    tx.df_to_excel_formatting(df)


extract_misc()
