from table_extractor import *


def extract_fh(type="FH", year="78"):
    mappings = {
        "Vollstudium": {"keyword": "1", "threshold": 0.75},
        "Vollstudium_WS_vorgeschrieben": {"keyword": "11", "threshold": 0.78},
        "Vollstudium_WS_vorgeschrieben2": {"keyword": "11", "threshold": 0.78},
        "Vollstudium_WS_vorgeschrieben_3": {"keyword": "11", "threshold": 0.78},
        "Vollstudium_WS_vorgeschrieben_4": {"keyword": "11", "threshold": 0.78},
        "Vollstudium_WS_empfohlen": {"keyword": "12", "threshold": 0.78},
        "Vollstudium_WS_empfohlen_2": {"keyword": "12", "threshold": 0.78},
        "Vollstudium_WS_empfohlen_3": {"keyword": "12", "threshold": 0.78},
        "Schwerpunkt": {"keyword": "3", "threshold": 0.75},
        "Aufbaustudium": {"keyword": "5", "threshold": 0.72},
    }

    fh = Table_Extractor(
        year,
        type,
        mappings,
        show_lines=False,
        min_dist=20,
        use_default_icons=False,
        gray_scale_matching=False,
        confidence_based=True,
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


def extract_uni(type="Uni", year="78"):
    mappings = {
        "Vollstudium": {"keyword": "1", "threshold": 0.75},
        "Vollstudium_2": {"keyword": "1", "threshold": 0.75},
        "Vollstudium_WS_vorgeschrieben": {"keyword": "11", "threshold": 0.78},
        "Vollstudium_WS_vorgeschrieben2": {"keyword": "11", "threshold": 0.78},
        "Vollstudium_WS_vorgeschrieben_3": {"keyword": "11", "threshold": 0.78},
        "Vollstudium_WS_vorgeschrieben_4": {"keyword": "11", "threshold": 0.78},
        "Vollstudium_WS_empfohlen": {"keyword": "12", "threshold": 0.78},
        "Vollstudium_WS_empfohlen2": {"keyword": "12", "threshold": 0.78},
        "Vollstudium_WS_empfohlen_3": {"keyword": "12", "threshold": 0.78},
        "Schwerpunkt": {"keyword": "3", "threshold": 0.75},
        "Aufbaustudium": {"keyword": "5", "threshold": 0.72},
    }

    fh = Table_Extractor(
        year,
        type,
        mappings,
        show_lines=False,
        min_dist=20,
        gray_scale_matching=True,
        confidence_based=True,
    )

    base_path = f"./table_extraction/tables/{type}/{year}/axis_labels"

    p1 = 39
    page1 = fh.extract_page(
        base_path,
        f"Name_{type}s_{year}_S.{p1}",
        f"Studiengänge_{type}s_{year}_S.{p1}",
        f"Studiengänge_{type}s_{year}_S.{p1}_2",
        f"{p1}_1",
        f"{p1}_2",
    )
    p2 = 40
    page2 = fh.extract_page(
        base_path,
        f"Name_{type}s_{year}_S.{p2}",
        f"Studiengänge_{type}s_{year}_S.{p2}",
        f"Studiengänge_{type}s_{year}_S.{p2}_2",
        f"{p2}_1",
        f"{p2}_2",
    )
    p3 = 41
    page3 = fh.extract_semi_page(
        base_path,
        f"Name_{type}s_{year}_S.{p3}",
        f"Studiengänge_{type}s_{year}_S.{p3}",
        f"{p3}_1",
    )

    final_df = pd.concat([page1, page2, page3], axis=0)
    print(final_df)
    fh.df_to_excel_formatting(final_df)


def extract_misc(type="Sonstiges", year="78"):
    mappings = {
        "Vollstudium": {"keyword": "1", "threshold": 0.9},
        "Vollstudium_ws_vg": {"keyword": "11", "threshold": 0.9},
        "Vollstudium_ws_vg_2": {"keyword": "11", "threshold": 0.9},
        "Vollstudium_ws_empf": {"keyword": "12", "threshold": 0.9},
        "aufbaustudium_ws_vg": {"keyword": "51", "threshold": 0.9},
        "teilstudium": {"keyword": "7", "threshold": 0.9},
    }
    tx = Table_Extractor(
        year,
        type,
        mappings,
        show_lines=True,
        min_dist=20,
        threshold=0.75,
    )
    base_path = f"./table_extraction/tables/{type}/{year}/axis_labels"
    p1 = 44
    df = tx.extract_semi_page(
        base_path,
        f"Name_Sonstiges_S.{p1}",
        f"Studiengänge_Sonstiges_S.{p1}",
        f"Sonstiges",
        write_to_file=False,
    )
    tx.df_to_excel_formatting(df)


extract_uni()
