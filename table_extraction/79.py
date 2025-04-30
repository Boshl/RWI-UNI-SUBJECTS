from table_extractor import *


def extract_fh(type="FH", year="79"):
    mappings = {
        "Vollstudium": {"keyword": "1", "threshold": 0.75},
        "Vollstudium_WS_vorgeschrieben": {"keyword": "11", "threshold": 0.78},
        "Vollstudium_WS_vorgeschrieben2": {"keyword": "11", "threshold": 0.78},
        "Vollstudium_WS_empfohlen": {"keyword": "12", "threshold": 0.78},
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

    p1 = 48
    page1 = fh.extract_page(
        base_path,
        f"Name_{type}_{year}_S.{p1}",
        f"Studiengänge_{type}_{year}_S.{p1}",
        f"Studiengänge_{type}_{year}_S.{p1+1}",
        f"{p1}_1",
        f"{p1+1}_1",
    )

    p2 = 50
    page2 = fh.extract_page(
        base_path,
        f"Name_{type}_{year}_S.{p2}",
        f"Studiengänge_{type}_{year}_S.{p2}",
        f"Studiengänge_{type}_{year}_S.{p2+1}",
        f"{p2}_1",
        f"{p2+1}_1",
    )
    p3 = 52
    page3 = fh.extract_page(
        base_path,
        f"Name_{type}_{year}_S.{p3}",
        f"Studiengänge_{type}_{year}_S.{p3}",
        f"Studiengänge_{type}_{year}_S.{p3}_2",
        f"{p3}_1",
        f"{p3}_2",
    )

    final_df = pd.concat([page1, page2, page3], axis=1)
    final_df = final_df.sort_index()
    print(final_df)
    fh.df_to_excel_formatting(final_df)


def extract_uni(type="Uni", year="79"):
    mappings = {
        "Vollstudium": {"keyword": "1", "threshold": 0.75},
        "Vollstudium_WS_vorgeschrieben": {"keyword": "11", "threshold": 0.78},
        "Vollstudium_WS_vorgeschrieben2": {"keyword": "11", "threshold": 0.78},
        "Vollstudium_WS_empfohlen": {"keyword": "12", "threshold": 0.78},
        "Schwerpunkt": {"keyword": "3", "threshold": 0.75},
        "Aufbaustudium": {"keyword": "5", "threshold": 0.72},
        "Teilstudium_bis": {"keyword": "7b", "threshold": 0.76},
    }

    fh = Table_Extractor(
        year,
        type,
        mappings,
        show_lines=False,
        min_dist=30,
        use_default_icons=False,
        gray_scale_matching=False,
        line_detection_threshold=40,
        confidence_based=True,
    )

    base_path = f"./table_extraction/tables/{type}/{year}/axis_labels"

    p1 = 40
    page1 = fh.extract_page(
        base_path,
        f"Name_{type}_{year}_S.{p1}",
        f"Studiengänge_{type}_{year}_S.{p1}",
        f"Studiengänge_{type}_{year}_S.{p1}_2",
        f"{p1}_1",
        f"{p1}_2",
    )

    p2 = 41
    page2 = fh.extract_page(
        base_path,
        f"Name_{type}_{year}_S.{p2}",
        f"Studiengänge_{type}_{year}_S.{p2}",
        f"Studiengänge_{type}_{year}_S.{p2}_2",
        f"{p2}_1",
        f"{p2}_2",
    )
    p3 = 42
    page3 = fh.extract_semi_page(
        base_path,
        f"Name_{type}_{year}_S.{p3}",
        f"Studiengänge_{type}_{year}_S.{p3}",
        f"{p3}_1",
    )

    final_df = pd.concat([page1, page2, page3], axis=0)
    print(final_df)
    fh.df_to_excel_formatting(final_df)


def extract_misc(type="Sonstiges", year="79"):
    mappings = {
        "vollstudium": {"keyword": "1", "threshold": 0.9},
        "vollstudium_ws_vg": {"keyword": "11", "threshold": 0.9},
        "vollstudium_ws_empf": {"keyword": "12", "threshold": 0.9},
        "aufbaustudium": {"keyword": "5", "threshold": 0.9},
        "aufbaustudium_ws_vg": {"keyword": "51", "threshold": 0.9},
        "teilstudium": {"keyword": "7", "threshold": 0.9},
    }
    tx = Table_Extractor(
        year,
        type,
        mappings,
        show_lines=True,
        min_dist=22,
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


extract_misc()
