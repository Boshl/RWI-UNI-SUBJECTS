from table_extractor import *


def extract_fh(type="FH", year="74"):
    mappings = {
        "Vollstudium": {"keyword": "1", "threshold": 0.72},
        "VollstudiumZB": {"keyword": "2", "threshold": 0.72},
        "Vollstudium_WS_vorgeschrieben": {"keyword": "11", "threshold": 0.74},
        "Vollstudium_WS_vorgeschrieben2": {"keyword": "11", "threshold": 0.74},
        "VollstudiumZB_WS_vorgeschrieben": {"keyword": "21", "threshold": 0.92},
        "Vollstudium_WS_empfohlen": {"keyword": "12", "threshold": 0.78},
        "Vollstudium_WS_empfohlen2": {"keyword": "12", "threshold": 0.78},
        "VollstudiumZB_WS_empfohlen": {"keyword": "22", "threshold": 0.9},
        "Schwerpunkt": {"keyword": "3", "threshold": 0.87},
        "Aufbaustudium": {"keyword": "5", "threshold": 0.87},
    }

    fh = Table_Extractor(
        year,
        type,
        mappings,
        show_lines=False,
        min_dist=20,
        use_default_icons=False,
        gray_scale_matching=False,
        line_detection_threshold=25,
        confidence_based=False,
    )

    base_path = f"./table_extraction/tables/{type}/{year}/axis_labels"

    p1 = 47
    page1 = fh.extract_page(
        base_path,
        f"Name_{type}_{year}_S.{p1}",
        f"Studiengänge_{type}_{year}_S.{p1}",
        f"Studiengänge_{type}_{year}_S.{p1}_2",
        f"{p1}_1",
        f"{p1}_2",
    )

    p2 = 48
    page2 = fh.extract_page(
        base_path,
        f"Name_{type}_{year}_S.{p2}",
        f"Studiengänge_{type}_{year}_S.{p2}",
        f"Studiengänge_{type}_{year}_S.{p2}_2",
        f"{p2}_1",
        f"{p2}_2",
    )

    fh = Table_Extractor(
        year,
        type,
        mappings,
        show_lines=False,
        min_dist=20,
        use_default_icons=False,
        gray_scale_matching=False,
        line_detection_threshold=30,
        confidence_based=False,
    )

    p3 = 49
    page3 = fh.extract_page(
        base_path,
        f"Name_{type}_{year}_S.{p3}",
        f"Studiengänge_{type}_{year}_S.{p3}",
        f"Studiengänge_{type}_{year}_S.{p3}_2",
        f"{p3}_1",
        f"{p3}_2",
    )

    final_df = pd.concat([page1, page2, page3], axis=1)
    print(final_df)
    fh.df_to_excel_formatting(final_df)


def extract_uni(type="Uni", year="74"):
    mappings = {
        "Vollstudium": {"keyword": "1", "threshold": 0.72},
        "Vollstudium_WS_vorgeschrieben": {"keyword": "11", "threshold": 0.74},
        "Vollstudium_WS_vorgeschrieben2": {"keyword": "11", "threshold": 0.74},
        "Vollstudium_WS_empfohlen": {"keyword": "12", "threshold": 0.74},
        "Vollstudium_WS_empfohlen2": {"keyword": "12", "threshold": 0.74},
        "VollstudiumZB": {"keyword": "2", "threshold": 0.72},
        "VollstudiumZB_WS_vorgeschrieben": {"keyword": "21", "threshold": 0.85},
        "VollstudiumZB_WS_vorgeschrieben_2": {"keyword": "21", "threshold": 0.85},
        "VollstudiumZB_WS_empfohlen": {"keyword": "22", "threshold": 0.89},
        "VollstudiumZB_WS_empfohlen_2": {"keyword": "22", "threshold": 0.89},
        "Schwerpunkt": {"keyword": "3", "threshold": 0.8},
        "Aufbaustudium": {"keyword": "5", "threshold": 0.8},
        "Teilstudium_bis": {"keyword": "7b", "threshold": 0.8},
        "Teilstudium_ab": {"keyword": "7a", "threshold": 0.8},
        "TeilstudiumZB": {"keyword": "7", "threshold": 0.85},
    }

    uni = Table_Extractor(
        year,
        type,
        mappings,
        show_lines=False,
        min_dist=30,
        use_default_icons=False,
        gray_scale_matching=False,
        line_detection_threshold=30,
        confidence_based=True,
        threshold=0.76,
    )

    base_path = f"./table_extraction/tables/{type}/{year}/axis_labels"

    p1 = 25
    page1 = uni.extract_page(
        base_path,
        f"Name_{type}s_{year}_S.{p1}",
        f"Studiengänge_{type}s_{year}_S.{p1}",
        f"Studiengänge_{type}s_{year}_S.{p1}_2",
        f"{p1}_1",
        f"{p1}_2",
    )

    uni = Table_Extractor(
        year,
        type,
        mappings,
        show_lines=False,
        min_dist=30,
        use_default_icons=False,
        gray_scale_matching=False,
        line_detection_threshold=30,
        confidence_based=True,
        threshold=0.76,
    )

    p2 = 26
    page2 = uni.extract_page(
        base_path,
        f"Name_{type}s_{year}_S.{p2}",
        f"Studiengänge_{type}s_{year}_S.{p2}",
        f"Studiengänge_{type}s_{year}_S.{p2}_2",
        f"{p2}_1",
        f"{p2}_2",
    )
    p3 = 27
    page3 = uni.extract_semi_page(
        base_path,
        f"Name_{type}s_{year}_S.{p3}",
        f"Studiengänge_{type}s_{year}_S.{p3}",
        f"{p3}_1",
    )

    final_df = pd.concat([page1, page2, page3], axis=0)
    print(final_df)
    uni.df_to_excel_formatting(final_df)


extract_uni()
