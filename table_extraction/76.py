from table_extractor import *


def extract_fh(type="FH", year="76"):
    mappings = {
        "Vollstudium": {"keyword": "1", "threshold": 0.75},
        "Vollstudium_WS_vorgeschrieben": {"keyword": "11", "threshold": 0.86},
        "Vollstudium_WS_vorgeschrieben2": {"keyword": "11", "threshold": 0.86},
        "Vollstudium_WS_empfohlen": {"keyword": "12", "threshold": 0.9},
        "VollstudiumZB": {"keyword": "2", "threshold": 0.75},
        "VollstudiumZB_WS_vorgeschrieben": {"keyword": "21", "threshold": 0.9},
        "VollstudiumZB_WS_empfohlen": {"keyword": "22", "threshold": 0.9},
        "Schwerpunkt": {"keyword": "3", "threshold": 0.85},
        "SchwerpunktZB": {"keyword": "4", "threshold": 0.94},
        "Aufbaustudium": {"keyword": "5", "threshold": 0.85},
    }

    fh = Table_Extractor(
        year,
        type,
        mappings,
        show_lines=False,
        min_dist=20,
        confidence_based=False,
    )

    base_path = f"./table_extraction/tables/{type}/{year}/axis_labels"

    page1 = fh.extract_page(
        base_path,
        "Name_FH_76_S.50",
        "Studiengänge_FH_76_S.50",
        "Studiengänge_FH_76_S.50_2",
        "50_1",
        "50_2",
    )
    page2 = fh.extract_page(
        base_path,
        "Name_FH_76_S.51",
        "Studiengänge_FH_76_S.51",
        "Studiengänge_FH_76_S.51_2",
        "51_1",
        "51_2",
    )
    page3 = fh.extract_page(
        base_path,
        "Name_FH_76_S.52",
        "Studiengänge_FH_76_S.52",
        "Studiengänge_FH_76_S.52_2",
        "52_1",
        "52_2",
    )

    final_df = pd.concat([page1, page2, page3], axis=1)
    print(final_df)
    fh.df_to_excel_formatting(final_df)


def extract_uni(type="Uni", year="76"):
    mappings = {
        "Vollstudium": {"keyword": "1", "threshold": 0.85},
        "Vollstudium_WS_vorgeschrieben": {"keyword": "11", "threshold": 0.9},
        "Vollstudium_WS_empfohlen": {"keyword": "12", "threshold": 0.9},
        "VollstudiumZB": {"keyword": "2", "threshold": 0.85},
        "VollstudiumZB_2": {"keyword": "2", "threshold": 0.85},
        "VollstudiumZB_WS_vorgeschrieben": {"keyword": "21", "threshold": 0.9},
        "VollstudiumZB_WS_vorgeschrieben_2": {"keyword": "21", "threshold": 0.9},
        "VollstudiumZB_WS_vorgeschrieben_3": {"keyword": "21", "threshold": 0.9},
        "VollstudiumZB_WS_vorgeschrieben_4": {"keyword": "21", "threshold": 0.9},
        "VollstudiumZB_WS_empfohlen": {"keyword": "22", "threshold": 0.9},
        "VollstudiumZB_WS_empfohlen_2": {"keyword": "22", "threshold": 0.9},
        "Schwerpunkt": {"keyword": "3", "threshold": 0.85},
        "SchwerpunktZB": {"keyword": "4", "threshold": 0.94},
        "Aufbaustudium": {"keyword": "5", "threshold": 0.85},
    }

    fh = Table_Extractor(
        year,
        type,
        mappings,
        show_lines=False,
        min_dist=20,
        confidence_based=True,
        gray_scale_matching=True,
        threshold=0.78,
    )

    base_path = f"./table_extraction/tables/{type}/{year}/axis_labels"

    page1 = fh.extract_page(
        base_path,
        "Name_Uni_76_S.25",
        "Studiengänge_Uni_76_S.25",
        "Studiengänge_Uni_76_S.25_2",
        "25_1",
        "25_2",
    )
    page2 = fh.extract_page(
        base_path,
        "Name_Uni_76_S.26",
        "Studiengänge_Uni_76_S.26",
        "Studiengänge_Uni_76_S.26_2",
        "26_1",
        "26_2",
    )
    page3 = fh.extract_semi_page(
        base_path, "Name_Uni_76_S.27", "Studiengänge_Uni_76_S.27", "27_1"
    )

    final_df = pd.concat([page1, page2, page3], axis=0)
    print(final_df)
    fh.df_to_excel_formatting(final_df)


extract_uni()
