import pandas as pd
import os
import json

# load csv file
input_path = "./data_enrichment/data_final/RWI-UNI-SUBJECTS_translated.csv"  # Replace with your actual file path
df = pd.read_csv(input_path, encoding="utf-8")


# type conversions
df["Year"] = df["Year"].astype("Int64")
df["HE_number"] = df["HE_number"].astype("Int64").astype(str)
df["Subject_code"] = df["Subject_code"].astype("Int64").astype(str)
df["Subject_area_code"] = df["Subject_area_code"].astype("Int64").astype(str)
df["Subject_group_code"] = df["Subject_group_code"].astype("Int64").astype(str)

# sort by 'Year'
df = df.sort_values(by="Year")

# read json with book data that contains information such as year, author, title for the study guides
with open("./data_enrichment/data_input/book_data.json", "r", encoding="utf-8") as f:
    book_data = json.load(f)
books_metadata = pd.DataFrame(book_data)

# add book data to the dataframe
text_columns = ["Author", "Institution", "Title", "Publisher"]
for col in text_columns:
    if col in books_metadata.columns:
        books_metadata[col] = books_metadata[col]

df = df.merge(books_metadata, on="Year", how="left")


# Spalten neu anordnen: immer [German, English, German, English, ...]
new_column_order = [
    "Year",
    "Type",
    "HE_name_orig",
    "Subject_orig",
    "Study_Type",
    "HE_number",
    "HE_name_destat",
    "HE_name_destat_last",
    "HE_change",
    "Subject",
    "Subject_area",
    "Subject_group",
    "Subject_code",
    "Subject_area_code",
    "Subject_group_code",
    "AGS",
    "Location_name",
    "Detailed_field",
    "Narrow_field",
    "Broad_field",
    "Detailed_field_code",
    "Narrow_field_code",
    "Broad_field_code",
    "Subject_orig_EN",
    "Subject_EN",
    "Subject_area_EN",
    "Subject_group_EN",
    "Author",
    "Institution",
    "Title",
    "Publisher",
]
# list of remaining columns not in desired_order
remaining = [col for col in df.columns if col not in new_column_order]

# reorder DataFrame
df = df[new_column_order + remaining]
df = df.replace("<NA>", "")
df = df.fillna("")

# save csv file
df.to_csv(
    "./data_enrichment/data_final/RWI-UNI-SUBJECTS.csv",
    index=False,
    encoding="utf-8",
)
