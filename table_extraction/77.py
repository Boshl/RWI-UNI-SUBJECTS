from table_extractor import *


def extract_fh(type="FH", year="77"):
    mappings = {
        "Vollstudium": {"keyword": "1", "threshold": 0.75},
        "Vollstudium_WS_vorgeschrieben": {"keyword": "11", "threshold": 0.8},
        "Vollstudium_WS_vorgeschrieben2": {"keyword": "11", "threshold": 0.8},
        "Vollstudium_WS_empfohlen": {"keyword": "12", "threshold": 0.83},
        "VollstudiumZB": {"keyword": "2", "threshold": 0.75},
        "VollstudiumZB_WS_vorgeschrieben": {"keyword": "21", "threshold": 0.86},
        "VollstudiumZB_WS_empfohlen": {"keyword": "22", "threshold": 0.85},
        "Schwerpunkt": {"keyword": "3", "threshold": 0.85},
        "SchwerpunktZB": {"keyword": "4", "threshold": 0.93},
        "Aufbaustudium": {"keyword": "5", "threshold": 0.81},
        "AufbaustudiumZB": {"keyword": "6", "threshold": 0.81},
    }

    fh = Table_Extractor(
        year,
        type,
        mappings,
        show_lines=False,
        min_dist=20,
        use_default_icons=False,
        gray_scale_matching=True,
        confidence_based=True,
        threshold=0.75,
    )

    base_path = f"./table_extraction/tables/{type}/{year}/axis_labels"

    p1 = 48
    page1 = fh.extract_page(
        base_path,
        f"Name_FH_77_S.{p1}",
        f"Studiengänge_FH_77_S.{p1}",
        f"Studiengänge_FH_77_S.{p1}_2",
        f"{p1}_1",
        f"{p1}_2",
    )
    p2 = 49
    page2 = fh.extract_page(
        base_path,
        f"Name_FH_77_S.{p2}",
        f"Studiengänge_FH_77_S.{p2}",
        f"Studiengänge_FH_77_S.{p2}_2",
        f"{p2}_1",
        f"{p2}_2",
    )
    p3 = 50
    page3 = fh.extract_page(
        base_path,
        f"Name_FH_77_S.{p3}",
        f"Studiengänge_FH_77_S.{p3}",
        f"Studiengänge_FH_77_S.{p3}_2",
        f"{p3}_1",
        f"{p3}_2",
    )

    final_df = pd.concat([page1, page2, page3], axis=1)
    print(final_df)
    fh.df_to_excel_formatting(final_df)


def extract_uni(type="Uni", year="77"):
    mappings = {
        "Vollstudium": {"keyword": "1", "threshold": 0.75},
        "Vollstudium_2": {"keyword": "1", "threshold": 0.75},
        "Vollstudium_WS_vorgeschrieben": {"keyword": "11", "threshold": 0.8},
        "Vollstudium_WS_vorgeschrieben2": {"keyword": "11", "threshold": 0.8},
        "Vollstudium_WS_vorgeschrieben_2": {"keyword": "11", "threshold": 0.8},
        "Vollstudium_WS_vorgeschrieben_3": {"keyword": "11", "threshold": 0.8},
        "Vollstudium_WS_empfohlen": {"keyword": "12", "threshold": 0.83},
        "Vollstudium_WS_empfohlen_2": {"keyword": "12", "threshold": 0.83},
        "VollstudiumZB": {"keyword": "2", "threshold": 0.75},
        "VollstudiumZB_WS_vorgeschrieben": {"keyword": "21", "threshold": 0.91},
        "VollstudiumZB_WS_empfohlen": {"keyword": "22", "threshold": 0.88},
        "Schwerpunkt": {"keyword": "3", "threshold": 0.8},
        "Schwerpunkt_2": {"keyword": "3", "threshold": 0.8},
        "SchwerpunktZB": {"keyword": "4", "threshold": 0.93},
        "Aufbaustudium": {"keyword": "5", "threshold": 0.81},
        "AufbaustudiumZB": {"keyword": "6", "threshold": 0.81},
    }

    uni = Table_Extractor(
        year,
        type,
        mappings,
        show_lines=False,
        min_dist=20,
        use_default_icons=False,
        gray_scale_matching=True,
        confidence_based=True,
    )

    base_path = f"./table_extraction/tables/{type}/{year}/axis_labels"

    p1 = 40
    page1 = uni.extract_page(
        base_path,
        f"Name_{type}_{year}_S.{p1}",
        f"Studiengänge_{type}_{year}_S.{p1}",
        f"Studiengänge_{type}_{year}_S.{p1}_2",
        f"{p1}_1",
        f"{p1}_2",
    )
    p2 = 41
    page2 = uni.extract_page(
        base_path,
        f"Name_{type}_{year}_S.{p2}",
        f"Studiengänge_{type}_{year}_S.{p2}",
        f"Studiengänge_{type}_{year}_S.{p2}_2",
        f"{p2}_1",
        f"{p2}_2",
    )
    p3 = 42
    page3 = uni.extract_semi_page(
        base_path,
        f"Name_{type}_{year}_S.{p3}",
        f"Studiengänge_{type}_{year}_S.{p3}",
        f"{p3}_1",
    )

    final_df = pd.concat([page1, page2, page3], axis=0)
    print(final_df)
    uni.df_to_excel_formatting(final_df)


extract_fh()
