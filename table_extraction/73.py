from table_extractor import *


def extract_fh(type="FH", year="73"):
    mappings = {
        "vollstudium_1": {"keyword": "1", "threshold": 0.75},
        "11": {"keyword": "11", "threshold": 0.79},
        "12": {"keyword": "12", "threshold": 0.79},
        "vollstudium_zb_2": {"keyword": "2", "threshold": 0.75},
        "21": {"keyword": "21", "threshold": 0.92},
        "22": {"keyword": "22", "threshold": 0.92},
        "3": {"keyword": "3", "threshold": 0.75},
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

    cities = fh.get_values_from_txt(f"{base_path}/Name_FH_73_S.46.txt")
    degrees1 = fh.get_values_from_txt(f"{base_path}/Studiengänge_FH_73_S.46.txt")
    degrees2 = fh.get_values_from_txt(f"{base_path}/Studiengänge_FH_73_S.46_2.txt")
    df1 = fh.extract_table(cities, degrees1, "46_1")
    df2 = fh.extract_table(cities, degrees2, "46_2")
    page1 = pd.concat([df1, df2], axis=0)
    fh.df_to_excel_formatting(page1, interim_result=True, custom_name="46")

    cities = fh.get_values_from_txt(f"{base_path}/Name_FH_73_S.47.txt")
    degrees1 = fh.get_values_from_txt(f"{base_path}/Studiengänge_FH_73_S.47.txt")
    degrees2 = fh.get_values_from_txt(f"{base_path}/Studiengänge_FH_73_S.47_2.txt")
    df1 = fh.extract_table(cities, degrees1, "47_1")
    df2 = fh.extract_table(cities, degrees2, "47_2")
    page2 = pd.concat([df1, df2], axis=0)
    fh.df_to_excel_formatting(page2, interim_result=True, custom_name="47")

    fh = Table_Extractor(
        year,
        type,
        mappings,
        show_lines=False,
        last_column=False,
        min_dist=20,
        confidence_based=False,
    )
    cities = fh.get_values_from_txt(f"{base_path}/Name_FH_73_S.48.txt")
    degrees1 = fh.get_values_from_txt(f"{base_path}/Studiengänge_FH_73_S.48.txt")
    degrees2 = fh.get_values_from_txt(f"{base_path}/Studiengänge_FH_73_S.48_2.txt")
    df1 = fh.extract_table(cities, degrees1, "48_1")
    df2 = fh.extract_table(cities, degrees2, "48_2")
    page3 = pd.concat([df1, df2], axis=0)
    fh.df_to_excel_formatting(page3, interim_result=True, custom_name="48")

    final_df = pd.concat([page1, page2], axis=1)
    final_df = pd.concat([final_df, page3], axis=1)

    fh.df_to_excel_formatting(final_df)


def extract_uni(type="Uni", year="73"):
    mappings = {
        "Vollstudium": {"keyword": "1", "threshold": 0.7},
        "Vollstudium2": {"keyword": "1", "threshold": 0.7},
        "Vollstudium_WS_vorgeschrieben": {"keyword": "11", "threshold": 0.79},
        "Vollstudium_WS_vorgeschrieben2": {"keyword": "11", "threshold": 0.79},
        "Vollstudium_WS_empfohlen": {"keyword": "12", "threshold": 0.82},
        "VollstudiumZB": {"keyword": "2", "threshold": 0.75},
        "VollstudiumZB_WS_vorgeschrieben": {"keyword": "21", "threshold": 0.87},
        "VollstudiumZB_WS_empfohlen": {"keyword": "22", "threshold": 0.88},
        "Schwerpunkt": {"keyword": "3", "threshold": 0.8},
        "Aufbaustudium": {"keyword": "5", "threshold": 0.8},
        "teilstudium_ab": {"keyword": "7a", "threshold": 0.85},
        "teilstudium_bis": {"keyword": "7b", "threshold": 0.85},
    }

    uni = Table_Extractor(
        year,
        type,
        mappings,
        show_lines=False,
        min_dist=30,
        line_detection_threshold=35,
        confidence_based=False,
    )

    base_path = f"./table_extraction/tables/{type}/{year}/axis_labels"
    cities = uni.get_values_from_txt(f"{base_path}/Name_Unis_73_s.35.txt")

    degrees1 = uni.get_values_from_txt(f"{base_path}/Studiengänge_Unis_73_S.35.txt")
    df1 = uni.extract_table(cities, degrees1, "35_1")
    uni.df_to_excel_formatting(df1, interim_result=True, custom_name="35_1")

    degrees2 = uni.get_values_from_txt(f"{base_path}/Studiengänge_Unis_73_S.35_2.txt")
    df2 = uni.extract_table(cities, degrees2, "35_2")
    uni.df_to_excel_formatting(df2, interim_result=True, custom_name="35_2")

    degrees3 = uni.get_values_from_txt(f"{base_path}/Studiengänge_Unis_73_S.36.txt")
    df3 = uni.extract_table(cities, degrees3, "36_1")
    uni.df_to_excel_formatting(df3, interim_result=True, custom_name="36_1")

    degrees4 = uni.get_values_from_txt(f"{base_path}/Studiengänge_Unis_73_S.36_2.txt")
    df4 = uni.extract_table(cities, degrees4, "36_2")
    uni.df_to_excel_formatting(df4, interim_result=True, custom_name="36_2")

    degrees5 = uni.get_values_from_txt(f"{base_path}/Studiengänge_Unis_73_S.37.txt")
    df5 = uni.extract_table(cities, degrees5, "37_1")
    uni.df_to_excel_formatting(df5, interim_result=True, custom_name="37_1")

    final_df = pd.concat([df1, df2], axis=0)
    final_df = pd.concat([final_df, df3], axis=0)
    final_df = pd.concat([final_df, df4], axis=0)
    final_df = pd.concat([final_df, df5], axis=0)
    uni.df_to_excel_formatting(final_df)


extract_uni()
