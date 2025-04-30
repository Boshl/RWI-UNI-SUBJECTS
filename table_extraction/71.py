from table_extractor import *

"""
The following functions are categorized as `extract` and `extract_pages` functions. 
For example, the `extract_fh` function calls the `extract_fh_pages` function for each pair of pages 
and aggregates the results at the end. 

The `extract_fh_pages` is used to extract a pair of subsequent pages that have the same axis labels.
"""


def extract_fh(year="71", type="FH"):
    """pipeline for the extraction of universities of applied sciences (UAs) tables"""
    base_path = f"./table_extraction/tables/{type}/{year}/axis_labels"
    """
    the mappings dictionary contains information about the icon templates. It translates each icon into a keyword that will be inserted in the dataframe. 
    The threshold element is the minimal required similarity score.
    """
    mappings = {"vollstudium": {"keyword": "1", "threshold": 0.82}}

    fh = Table_Extractor(
        year,
        type,
        mappings,
        show_lines=True,
        last_column=False,
        confidence_based=False,
    )
    # pages 31 and 32 use the same axis labels and are extracted in the same extract_fh_pages() function
    pages31_32 = extract_fh_pages("31", "32", year, type, mappings, base_path)
    pages33_34 = extract_fh_pages("33", "34", year, type, mappings, base_path)
    pages35_36 = extract_fh_pages("35", "36", year, type, mappings, base_path)
    # concatenation of the pages into a final dataframe
    final_df = pd.concat([pages31_32, pages33_34], axis=1)
    final_df = pd.concat([final_df, pages35_36], axis=1)
    fh.df_to_excel_formatting(final_df)


def extract_fh_pages(page1, page2, year, type, mappings, base_path):
    """extracts a pair of pages with identical labels"""
    fh = Table_Extractor(
        year,
        type,
        mappings,
        show_lines=True,
        last_column=False,
        confidence_based=False,
    )
    cities = fh.get_values_from_txt(f"{base_path}/Name_FHs_71_S.{page1}.txt")
    degrees = fh.get_values_from_txt(f"{base_path}/Studiengänge_FH_71_S.{page1}.txt")

    df1 = fh.extract_table(cities, degrees, f"{page1}")

    fh = Table_Extractor(year, type, mappings, show_lines=True, first_column=False)
    cities = fh.get_values_from_txt(f"{base_path}/Name_FHs_71_S.{page2}.txt")
    df2 = fh.extract_table(cities, degrees, f"{page2}")
    # concatenation of page pairs with identical labels
    pages = pd.concat([df1, df2], axis=1)
    fh.df_to_excel_formatting(
        pages, interim_result=True, custom_name=f"{page1}-{page2}"
    )
    return pages


def extract_uni(year="71", type="Uni"):
    """pipeline for the extraction of university tables"""
    base_path = f"./table_extraction/tables/{type}/{year}/axis_labels"
    """
    the mappings dictionary contains information about the icon templates. It translates each icon into a keyword that will be inserted in the dataframe. 
    The threshold element is the minimal required similarity score.
    """
    mappings = {
        "1_simple": {"keyword": "1", "threshold": 0.99},
        "1_simple_2": {"keyword": "1", "threshold": 0.99},
        "1_simple_3": {"keyword": "1", "threshold": 0.99},
        "1_a": {"keyword": "1", "threshold": 0.92},
        "1_b": {"keyword": "1", "threshold": 0.92},
        "1_b_2": {"keyword": "1", "threshold": 0.92},
        "1_27_2": {"keyword": "1", "threshold": 0.92},
        "2": {"keyword": "2", "threshold": 0.8},
        "2_simple": {"keyword": "2", "threshold": 0.8},
        "2_a": {"keyword": "2", "threshold": 0.85},
        "2_b": {"keyword": "2", "threshold": 0.85},
        "3": {"keyword": "3", "threshold": 0.8},
        "3_simple": {"keyword": "3", "threshold": 0.8},
        "4": {"keyword": "4", "threshold": 0.8},
        "4_simple": {"keyword": "4", "threshold": 0.8},
        "5": {"keyword": "5", "threshold": 0.8},
        "5_simple": {"keyword": "5", "threshold": 0.8},
    }
    uni = Table_Extractor(
        year,
        type,
        mappings,
        show_lines=False,
        last_column=False,
        gray_scale_matching=True,
        confidence_based=False,
        min_dist=30,
    )
    page27 = extract_uni_pages("27", "27", year, type, mappings, base_path)
    page28 = extract_uni_pages("28", "28", year, type, mappings, base_path)
    final_df = pd.concat([page27, page28], axis=0)
    uni.df_to_excel_formatting(final_df)


def extract_uni_pages(page1, page2, year, type, mappings, base_path):
    """extracts a pair of pages with identical labels"""
    uni = Table_Extractor(
        year,
        type,
        mappings,
        show_lines=False,
        last_row=False,
        confidence_based=True,
        min_dist=70,
        threshold=0.82,
        line_detection_threshold=30,
    )
    cities = uni.get_values_from_txt(f"{base_path}/Name_Unis_71_S.{page1}.txt")
    degrees1 = uni.get_values_from_txt(
        f"{base_path}/Studiengänge_Unis_71_S.{page1}_1.txt"
    )

    df1 = uni.extract_table(cities, degrees1, f"{page1}_1")

    uni = Table_Extractor(
        year,
        type,
        mappings,
        show_lines=False,
        first_row=False,
        confidence_based=True,
        min_dist=70,
        threshold=0.82,
        line_detection_threshold=30,
    )
    cities = uni.get_values_from_txt(f"{base_path}/Name_Unis_71_S.{page2}.txt")
    degrees2 = uni.get_values_from_txt(
        f"{base_path}/Studiengänge_Unis_71_S.{page1}_2.txt"
    )
    df2 = uni.extract_table(cities, degrees2, f"{page2}_2")
    pages = pd.concat([df1, df2], axis=0)
    uni.df_to_excel_formatting(
        pages, interim_result=True, custom_name=f"{page1}-{page2}"
    )
    return pages


# NOTE: remove the following comments to execute the extraction scripts
# extract_uni()
# extract_fh()
