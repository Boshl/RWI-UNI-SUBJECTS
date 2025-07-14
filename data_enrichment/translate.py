import pandas as pd
from transformers import MarianMTModel, MarianTokenizer
from tqdm import tqdm

"""
This script does the following:
1.) merges the Destatis translations to translate subjects, subject group and subject area values
2.) translates the Subject_orig column with help of the fine-tuned large language model
"""


# translates entries with fine-tuned model
def translate(text: str) -> str:
    if pd.isna(text) or not isinstance(text, str) or text.strip() == "":
        return ""
    inputs = tokenizer(text, return_tensors="pt", truncation=True, padding=True)
    outputs = model.generate(**inputs)
    return tokenizer.decode(outputs[0], skip_special_tokens=True)


# fixing some typos to avoid mismatching with the Destatis dataset
def fix_typos(df, translations_df):
    df["Subject_area"] = df["Subject_area"].replace(
        "Allgemeine und vergleichende Literatur\x02und Sprachwissenschaft",
        "Allgemeine und vergleichende Literatur- und Sprachwissenschaft",
    )

    df["Subject_area"] = df["Subject_area"].replace(
        "Germanistik (Deutsch, germanische Sprachen ohne Anglistik",
        "Germanistik (Deutsch, germanische Sprachen ohne Anglistik)",
    )

    df["Subject_area"] = df["Subject_area"].replace(
        "Vermessungswesen", "Vermessungswesen (Geodäsie)"
    )

    df["Subject_group"] = df["Subject_group"].replace(
        "Humanmedizin/ Gesundheitswissenschaften",
        "Humanmedizin/Gesundheitswissenschaften",
    )

    mask = (df["Subject_area"] == "Vermessungswesen (Geodäsie)") & df[
        "Subject_area_EN"
    ].isnull()
    df.loc[mask, "Subject_area_EN"] = "Surveying (Geodesy)"

    translations_df["Subject_area_Ger"] = translations_df["Subject_area_Ger"].replace(
        "Bergbau, Hüttenwesen ", "Bergbau, Hüttenwesen"
    )
    return df, translations_df


# this function was used to find entries that did not have a string match with Destatis
def check_missing(df):
    columns = [
        "Subject",
        "Subject_EN",
        "Subject_group",
        "Subject_group_EN",
        "Subject_area",
        "Subject_area_EN",
    ]
    # count missing values
    missing_values = df[columns].isnull().sum()
    print(missing_values)

    # find entries with missing translations
    untranslated_mask = df["Subject_area"].notnull() & df["Subject_area_EN"].isnull()

    # get untranslated values
    untranslated_values = df.loc[untranslated_mask, "Subject_area"].dropna().unique()

    print("Missing translations for subject_area:")
    print(untranslated_values)

    missing_subject_area_en = df[
        df["Subject_area"].notnull() & df["Subject_area_EN"].isnull()
    ]
    print(missing_subject_area_en[["Subject_area", "Subject_area_EN"]])


"""
1.) translate subject, subject_group and subject_area by using Destatis translations
"""
# loads csv file that needs to be translated
input_path = "./data_enrichment/data_final/RWI-UNI-SUBJECTS_prefinal.csv"
df = pd.read_csv(input_path, encoding="utf-8")

# read csv file with Destatis translations
translations_df = pd.read_csv(
    "./data_enrichment/data_input/translations_grouped.csv", encoding="utf-8"
)  # filter for relevant columns
translations_df_filtered = translations_df[
    ["Subject_code", "Subject_EN", "Subject_group_EN", "Subject_area_EN"]
]

# join the dataframes on subject_code
df = pd.merge(
    df,
    translations_df_filtered,
    left_on="Subject_code",
    right_on="Subject_code",
    how="left",
)

df, translations_df = fix_typos(df, translations_df)
base_columns = ["Subject", "Subject_area", "Subject_group"]

# in case of missing subject code: translate by matching the strings
for col in base_columns:
    col_en = f"{col}_EN"
    col_ger = f"{col}_Ger"

    # checks if English translations are missing
    mask = df[col].notnull() & df[col_en].isnull()

    translation_map = (
        translations_df[[col_ger, col_en]]
        .dropna()
        .drop_duplicates()
        .set_index(col_ger)[col_en]
    )

    # missing English translations are added here
    df.loc[mask, col_en] = df.loc[mask, col].map(translation_map)

"""
2.) fine-tuned large language model is used to add Subject_orig translations
"""

# directory of fine-tuned model
model_dir = "./data_enrichment/model/marianmt-de-en-finetuned"
tokenizer = MarianTokenizer.from_pretrained(model_dir)
model = MarianMTModel.from_pretrained(model_dir)  # loads fine-tuned model

# only unique values will be translated for efficiency. results will be merged later
unique_vals = df["Subject_orig"].dropna().unique()
translation_map = {}

for val in tqdm(
    unique_vals, desc=f"translate column Subject_orig with fine-tuned model"
):
    translated = translate(val)
    translation_map[val] = translated
    print(f"{val} → {translated}")

df[f"Subject_orig_EN"] = df["Subject_orig"].map(translation_map)

output_path = "./data_enrichment/data_final/RWI-UNI-SUBJECTS_translated.csv"

check_missing(df)
df.to_csv(output_path, index=False, encoding="utf-8")
