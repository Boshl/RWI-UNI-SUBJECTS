from table_extractor import *


def extract_fh(year="75", type="FH"):
    mappings = {
        "vollstudium_zb_ws": {"keyword": "21", "threshold": 0.9},
        "vollstudium_zb_ws_2": {"keyword": "21", "threshold": 0.9},
        "vollstudium_zb_ws_empf": {"keyword": "22", "threshold": 0.92},
        "schwerpunkt": {"keyword": "3", "threshold": 0.92},
        "schwerpunkt_zb": {"keyword": "4", "threshold": 0.92},
        "aufbau": {"keyword": "5", "threshold": 0.85},
        "aufbau_zb": {"keyword": "6", "threshold": 0.85},
        "vollstudium_ws": {"keyword": "11", "threshold": 0.75},
        "vollstudium_ws_2": {"keyword": "11", "threshold": 0.75},
        "vollstudium_ws_empf": {"keyword": "12", "threshold": 0.75},
        "vollstudium": {"keyword": "1", "threshold": 0.75},
        "vollstudium2": {"keyword": "1", "threshold": 0.75},
        "vollstudium_zb": {"keyword": "2", "threshold": 0.75},
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
        confidence_based=False,
    )

    base_path = f"./table_extraction/tables/{type}/{year}/axis_labels"

    p1 = 47
    page1 = fh.extract_page(
        base_path,
        f"{type}_Name_{p1}",
        f"{type}_Studiengang_1",
        f"{type}_Studiengang_2",
        f"{p1}_1",
        f"{p1}_2",
    )
    p2 = 48
    page2 = fh.extract_page(
        base_path,
        f"{type}_Name_{p2}",
        f"{type}_Studiengang_1",
        f"{type}_Studiengang_2",
        f"{p2}_1",
        f"{p2}_2",
    )

    p3 = 49
    page3 = fh.extract_page(
        base_path,
        f"{type}_Name_{p3}",
        f"{type}_Studiengang_1",
        f"{type}_Studiengang_2",
        f"{p3}_1",
        f"{p3}_2",
    )

    final_df = pd.concat([page1, page2, page3], axis=1)
    print(final_df)
    fh.df_to_excel_formatting(final_df)


def extract_uni(year="75", type="Uni"):
    mappings = {
        "vollstudium": {"keyword": "1", "threshold": 0.73},
        "vollstudium_ws": {"keyword": "11", "threshold": 0.75},
        "vollstudium_ws_2": {"keyword": "11", "threshold": 0.75},
        "vollstudium_ws_empf": {"keyword": "12", "threshold": 0.75},
        "vollstudium_ws_empf_2": {"keyword": "12", "threshold": 0.75},
        "vollstudium_ws_empf_3": {"keyword": "12", "threshold": 0.75},
        "vollstudium_zb": {"keyword": "2", "threshold": 0.73},
        "vollstudium_zb_ws": {"keyword": "21", "threshold": 0.92},
        "vollstudium_zb_ws_2": {"keyword": "21", "threshold": 0.92},
        "vollstudium_zb_ws_3": {"keyword": "21", "threshold": 0.92},
        "vollstudium_zb_ws_4": {"keyword": "21", "threshold": 0.92},
        "vollstudium_zb_ws_5": {"keyword": "21", "threshold": 0.92},
        "vollstudium_zb_ws_empf": {"keyword": "22", "threshold": 0.92},
        "vollstudium_zb_ws_empf_2": {"keyword": "22", "threshold": 0.92},
        "schwerpunkt": {"keyword": "3", "threshold": 0.91},
        "schwerpunkt_zb": {"keyword": "4", "threshold": 0.92},
        "aufbau": {"keyword": "5", "threshold": 0.85},
        "aufbau_zb": {"keyword": "6", "threshold": 0.85},
    }

    uni = Table_Extractor(
        year,
        type,
        mappings,
        show_lines=False,
        min_dist=25,
        use_default_icons=False,
        gray_scale_matching=True,
        line_detection_threshold=35,
        confidence_based=True,
        threshold=0.77,
    )

    base_path = f"./table_extraction/tables/{type}/{year}/axis_labels"

    p1 = 25
    page1 = uni.extract_page(
        base_path,
        f"Unis",
        f"Studiengang_{p1}_1",
        f"Studiengang_{p1}_2",
        f"{p1}_1",
        f"{p1}_2",
    )
    p2 = 26
    page2 = uni.extract_page(
        base_path,
        f"Unis",
        f"Studiengang_{p2}_1",
        f"Studiengang_{p2}_2",
        f"{p2}_1",
        f"{p2}_2",
    )

    p3 = 27
    page3 = uni.extract_semi_page(base_path, f"Unis", f"Studiengang_{p3}_1", f"{p3}_1")

    final_df = pd.concat([page1, page2, page3], axis=0)
    print(final_df)
    uni.df_to_excel_formatting(final_df)


extract_uni()
