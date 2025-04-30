from table_extractor import *


def extract_fh():
    mappings = {
        "vollstudium": {"keyword": "1", "threshold": 0.75},
        "vollstudium_zb": {"keyword": "2", "threshold": 0.75},
    }

    fh = Table_Extractor(
        "72",
        "FH",
        mappings,
        show_lines=False,
        last_column=False,
        last_row=False,
        min_dist=30,
        line_detection_threshold=35,
        confidence_based=False,
    )

    base_path = "./table_extraction/tables/FH/72/axis_labels"
    cities = fh.get_values_from_txt(f"{base_path}/FH72_Name_S.46-47.txt")
    degrees1 = fh.get_values_from_txt(f"{base_path}/FH72_Studiengang_S.46.txt")
    degrees2 = fh.get_values_from_txt(f"{base_path}/FH72_Studiengang_S.47.txt")
    df1 = fh.extract_table(cities, degrees1, "47")
    df2 = fh.extract_table(cities, degrees2, "48")
    page1 = pd.concat([df1, df2], axis=0)
    fh.df_to_excel_formatting(page1, interim_result=True, custom_name="47-48")

    cities = fh.get_values_from_txt(f"{base_path}/FH72_Name_S.48-49.txt")
    df1 = fh.extract_table(cities, degrees1, "49")
    df2 = fh.extract_table(cities, degrees2, "50")
    page2 = pd.concat([df1, df2], axis=0)
    fh.df_to_excel_formatting(page2, interim_result=True, custom_name="49-50")

    cities = fh.get_values_from_txt(f"{base_path}/FH72_Name_S.50-51.txt")
    df1 = fh.extract_table(cities, degrees1, "51")
    df2 = fh.extract_table(cities, degrees2, "52")
    page3 = pd.concat([df1, df2], axis=0)
    fh.df_to_excel_formatting(page3, interim_result=True, custom_name="51-52")

    cities = fh.get_values_from_txt(f"{base_path}/FH72_Name_S.52-53.txt")
    df1 = fh.extract_table(cities, degrees1, "53")
    fh = Table_Extractor(
        "72",
        "FH",
        mappings,
        show_lines=False,
        first_row=False,
        last_column=False,
        last_row=False,
        min_dist=30,
        line_detection_threshold=35,
        confidence_based=False,
    )
    df2 = fh.extract_table(cities, degrees2, "54")
    page4 = pd.concat([df1, df2], axis=0)
    fh.df_to_excel_formatting(page4, interim_result=True, custom_name="53-54")

    fh = Table_Extractor(
        "72",
        "FH",
        mappings,
        show_lines=False,
        last_column=False,
        last_row=False,
        min_dist=30,
        line_detection_threshold=35,
        confidence_based=False,
    )
    cities = fh.get_values_from_txt(f"{base_path}/FH72_Name_S.54-55.txt")
    df1 = fh.extract_table(cities, degrees1, "55")
    fh = Table_Extractor(
        "72",
        "FH",
        mappings,
        show_lines=False,
        first_row=False,
        last_column=False,
        last_row=False,
        min_dist=30,
        line_detection_threshold=35,
        confidence_based=False,
    )
    df2 = fh.extract_table(cities, degrees2, "56")
    page5 = pd.concat([df1, df2], axis=0)
    fh.df_to_excel_formatting(page5, interim_result=True, custom_name="55-56")

    final_df = pd.concat([page1, page2], axis=1)
    final_df = pd.concat([final_df, page3], axis=1)
    final_df = pd.concat([final_df, page4], axis=1)
    final_df = pd.concat([final_df, page5], axis=1)

    fh.df_to_excel_formatting(final_df)


def extract_uni():
    mappings = {
        "nebenfach_ws": {"keyword": "81", "threshold": 0.9},
        "vollstudium": {"keyword": "1", "threshold": 0.75},
        "vollstudium2": {"keyword": "1", "threshold": 0.75},
        "vollstudium_ws": {"keyword": "11", "threshold": 0.8},
        "vollstudium_ws_empf": {"keyword": "12", "threshold": 0.9},
        "teilstudium": {"keyword": "7", "threshold": 0.65},
        "teilstudium_ws": {"keyword": "71", "threshold": 0.9},
        "teilstudium_ws_empf": {"keyword": "72", "threshold": 0.9},
        "nebenfach": {"keyword": "8", "threshold": 0.9},
        "nebenfach_ws_empf": {"keyword": "82", "threshold": 0.9},
    }
    uni = Table_Extractor(
        "72",
        "Uni",
        mappings,
        True,
        last_row=False,
        show_lines=True,
        line_detection_threshold=35,
        confidence_based=False,
    )

    cities = uni.get_values_from_txt(
        source="./table_extraction/tables/Uni/72/axis_labels/Uni72_Name_S.30.txt"
    )

    degrees1 = uni.get_values_from_txt(
        source="./table_extraction/tables/Uni/72/axis_labels/Uni72_Studiengang_S.30.txt"
    )
    degrees2 = uni.get_values_from_txt(
        source="./table_extraction/tables/Uni/72/axis_labels/Uni72_Studiengang_S.31.txt"
    )
    degrees3 = uni.get_values_from_txt(
        source="./table_extraction/tables/Uni/72/axis_labels/Uni72_Studiengang_S.32.txt"
    )
    degrees4 = uni.get_values_from_txt(
        source="./table_extraction/tables/Uni/72/axis_labels/Uni72_Studiengang_S.33.txt"
    )

    df1 = uni.extract_table(cities, degrees1, "31")
    uni.df_to_excel_formatting(df1, interim_result=True, custom_name="31")

    uni = Table_Extractor(
        "72",
        "Uni",
        mappings,
        True,
        first_row=False,
        last_row=False,
        show_lines=True,
        line_detection_threshold=35,
        confidence_based=False,
    )
    df2 = uni.extract_table(cities, degrees2, "32")
    uni.df_to_excel_formatting(df2, interim_result=True, custom_name="32")

    uni = Table_Extractor(
        "72",
        "Uni",
        mappings,
        True,
        last_row=False,
        show_lines=True,
        line_detection_threshold=35,
    )
    df3 = uni.extract_table(cities, degrees3, "33")
    uni.df_to_excel_formatting(df3, interim_result=True, custom_name="33")

    uni = Table_Extractor(
        "72",
        "Uni",
        mappings,
        True,
        first_row=False,
        last_row=False,
        show_lines=True,
        line_detection_threshold=35,
        confidence_based=False,
    )
    df4 = uni.extract_table(cities, degrees4, "34")
    uni.df_to_excel_formatting(df4, interim_result=True, custom_name="34")
    final_df = pd.concat([df1, df2], axis=0)
    final_df = pd.concat([final_df, df3], axis=0)
    final_df = pd.concat([final_df, df4], axis=0)

    uni.df_to_excel_formatting(final_df)


extract_uni()
