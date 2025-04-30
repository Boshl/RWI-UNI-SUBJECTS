import math
import os
import re

import cv2
import matplotlib.pyplot as plt
import numpy as np
import pandas as pd
import xlsxwriter
import warnings


class Table_Extractor:

    def __init__(
        self,
        year,
        type,
        mappings,
        line_detection=False,
        first_column=True,
        first_row=True,
        last_column=True,
        last_row=True,
        show_lines=False,
        line_detection_threshold=25,
        min_dist=15,
        use_default_icons=False,
        gray_scale_matching=False,
        confidence_based=True,
        threshold=0.7,
    ):
        self.year = year  # year number as double digit
        self.type = (
            type  # Uni / FH (english: university / university of applied sciences)
        )
        self.mappings = mappings  # mappings that contain template name, keyword and minimal threshold
        self.base_path = f"./table_extraction/tables/{type}/{year}"
        self.first_column = first_column  # if tables do not have framelines, set this to True. It inserts a line coordinate at position 0
        self.last_column = last_column  # if tables do not have framelines, set this to True. It inserts a line coordinate at the last position
        self.first_row = first_row  # if tables do not have framelines, set this to True. It inserts a line coordinate at position 0
        self.last_row = last_row  # if tables do not have framelines, set this to True. It inserts a line coordinate at the last position
        self.show_lines = show_lines  # if set to True, this visualizes detected lines
        self.line_detection_threshold = (
            line_detection_threshold  # sets a minimal line width
        )
        self.min_dist = min_dist  # minimal distance between two lines
        self.use_default_icons = use_default_icons  # if set to True, uses example images of the icons from another book
        self.gray_scale_matching = gray_scale_matching  # if set to True, uses a gray scale image for table extraction
        self.confidence_based = confidence_based  # if set to True, the icon with the highest confidence (similarity value) wins and gets written into a cell. alternatively, manually inserted threshold can be inserted via mappings
        self.threshold = (
            threshold  # sets a minimal threshold for similarity for all icons
        )
        with warnings.catch_warnings():
            warnings.simplefilter(action="ignore", category=FutureWarning)

    def sort_coords(self, columns, rows):
        """sort line coordinates ascending"""
        columns = list(set(columns))
        columns = sorted(columns)
        rows = list(set(rows))
        rows = sorted(rows)
        return columns, rows

    def apply_grayscale(self, img):
        """converts image to grayscale"""
        gray = cv2.cvtColor(img, cv2.COLOR_BGR2GRAY)
        return gray

    def find_template(self, icon, source, keyword, threshold):
        img_rgb = cv2.imread(source)
        img_rgb = cv2.resize(img_rgb, (0, 0), fx=2.14, fy=2.14)
        if self.gray_scale_matching:
            img_rgb = self.apply_grayscale(img_rgb)

        template = cv2.imread(icon)
        w, h = template.shape[:-1]
        if self.gray_scale_matching:
            template = self.apply_grayscale(template)
        res = cv2.matchTemplate(img_rgb, template, cv2.TM_CCOEFF_NORMED)
        loc = np.where(res >= threshold)
        locations = []
        for pt in zip(*loc[::-1]):
            confidence = res[pt[1]][pt[0]]
            locations.append((pt[0] + w / 2, pt[1] + h / 2, confidence))
            cv2.rectangle(img_rgb, pt, (pt[0] + h, pt[1] + w), (0, 0, 255), 1)
        # plt.imshow(im)
        return locations

    def write_positions_and_values_to_df_tuples(
        self, icon, source, keyword, df, threshold, columns, rows
    ):
        """writes keyword and confidence score into the dataframe position based on row and column positions"""
        icon_locations = self.find_template(icon, source, keyword, self.threshold)
        for icon in icon_locations:
            icon_column = icon[0]
            icon_row = icon[1]
            confidence = icon[2]
            row_position = (-1, -1)
            column_position = (-1, -1)

            for r in rows:
                if r[0] < icon_row < r[1]:
                    row_position = r

            for c in columns:
                if c[0] < icon_column < c[1]:
                    column_position = c

            if row_position[0] >= 0 and column_position[0] >= 0:
                cell = df.at[row_position, column_position]
                if confidence > 0.69:
                    if pd.isna(cell):
                        df.at[row_position, column_position] = (keyword, confidence)
                    elif confidence > float(cell[1]):
                        df.at[row_position, column_position] = (keyword, confidence)
        return df

    def reduce_dataframe(self, cell):
        """removes confidence to clean up the dataframe"""
        if not pd.isna(cell):
            cell = cell[0]
        return cell

    def detect_icons(self, source, df, columns, rows):
        """iterates over all templates in mappings and takes the keyword to extract the tables"""
        for name, value in self.mappings.items():
            threshold = value["threshold"]
            keyword = value["keyword"]
            if self.use_default_icons:
                icon_path = f"./table_extraction/Template_Icons/{name}.png"
            else:
                icon_path = f"{self.base_path}/icons/{name}.png"
            if not self.confidence_based:
                df = self.write_positions_and_values_to_df_tuples(
                    icon=icon_path,
                    source=source,
                    keyword=keyword,
                    df=df,
                    threshold=threshold,
                    columns=columns,
                    rows=rows,
                )
            else:
                df = self.write_positions_and_values_to_df_tuples(
                    icon=icon_path,
                    source=source,
                    keyword=keyword,
                    df=df,
                    threshold=threshold,
                    columns=columns,
                    rows=rows,
                )
        df = df.T.reset_index(drop=True).T
        df = df.apply(lambda col: col.map(self.reduce_dataframe))
        return df

    def reduce_lines(self, columns, rows):
        """reduces lines with help of the min_dist parameter"""
        columns, rows = self.sort_coords(columns, rows)
        columns_reduced = []
        previous = -1000
        for c in columns:
            if c - previous > self.min_dist:
                columns_reduced.append(c)
            previous = c

        rows_reduced = []
        previous = -1000
        for r in rows:
            if r - previous > self.min_dist:
                rows_reduced.append(r)
            previous = r

        return columns_reduced, rows_reduced

    def get_line_tuples(self, columns, rows):
        """makes tuples based on the detected line coordinates, e.g. conversion of [0,10,20] to (0, 10), (10, 20)"""
        column_tuples = []
        first = True
        previous = 0
        for c in columns:
            if not first:
                column_tuple = (previous, c)
                column_tuples.append(column_tuple)
            previous = c
            first = False

        row_tuples = []
        first = True
        previous = 0
        for r in rows:
            if not first:
                row_tuple = (previous, r)
                row_tuples.append(row_tuple)
            previous = r
            first = False
        return column_tuples, row_tuples

    def draw_lines(self, file, columns, rows):
        """draw detected lines for visuzalization of interim results"""
        image = cv2.imread(f"{self.base_path}/screenshots_cutout/{file}.png")
        image = cv2.resize(image, (0, 0), fx=2.14, fy=2.14)
        height = image.shape[0]
        width = image.shape[1]
        line_thickness = 8
        for c in columns:
            cv2.line(
                image,
                (c[0], 0),
                (c[0], height),
                (200, 0, 200),
                thickness=line_thickness,
            )
            cv2.line(
                image,
                (c[1], 0),
                (c[1], height),
                (200, 0, 200),
                thickness=line_thickness,
            )
        for r in rows:
            cv2.line(
                image, (0, r[0]), (width, r[0]), (200, 0, 0), thickness=line_thickness
            )
            cv2.line(
                image, (0, r[1]), (width, r[1]), (200, 0, 0), thickness=line_thickness
            )

        image_small = cv2.resize(image, (0, 0), fx=0.5, fy=0.5)
        cv2.imshow(f"{file}.png - Detected Lines", image_small)
        # cv2.waitKey()
        cv2.waitKey(2000)  # waits 2000 ms = 2 seconds
        cv2.destroyWindow(f"{file}.png - Detected Lines")

    def detect_lines(self, file):
        """line detection using kernels"""
        image = cv2.imread(f"{self.base_path}/screenshots_cutout/{file}.png")
        image = cv2.resize(image, (0, 0), fx=2.14, fy=2.14)
        # processing of the image to improve line detection
        alpha = 0.1
        beta = 0.5
        image = cv2.convertScaleAbs(image, alpha=alpha, beta=beta)
        contrast = 0.5  # contrast control (0 to 127)
        brightness = 0  # brightness control (0-100)
        image = cv2.addWeighted(image, contrast, image, 0, brightness)
        gray = cv2.cvtColor(image, cv2.COLOR_BGR2GRAY)
        thresh = cv2.threshold(gray, 127, 255, cv2.THRESH_BINARY_INV + cv2.THRESH_OTSU)[
            1
        ]
        height = image.shape[0]
        width = image.shape[1]

        # kernels represent the line structure:
        horizontal_kernel = cv2.getStructuringElement(
            cv2.MORPH_RECT, (self.line_detection_threshold, 1)
        )

        horizontal_mask = cv2.morphologyEx(
            thresh, cv2.MORPH_OPEN, horizontal_kernel, iterations=3
        )

        vertical_kernel = cv2.getStructuringElement(
            cv2.MORPH_RECT, (1, self.line_detection_threshold)
        )
        vertical_mask = cv2.morphologyEx(
            thresh, cv2.MORPH_OPEN, vertical_kernel, iterations=3
        )

        table_mask = cv2.bitwise_or(horizontal_mask, vertical_mask)
        image[np.where(table_mask == 255)] = [255, 255, 255]

        vertical_contours, hierarchy = cv2.findContours(
            vertical_mask, cv2.RETR_EXTERNAL, cv2.CHAIN_APPROX_SIMPLE
        )
        columns = []
        for vertical in vertical_contours:
            columns.append(vertical[0][0][0])

        horizontal_contours, hierarchy = cv2.findContours(
            horizontal_mask, cv2.RETR_EXTERNAL, cv2.CHAIN_APPROX_SIMPLE
        )
        rows = []
        for horizontal in horizontal_contours:
            rows.append(horizontal[0][0][1])
        columns, rows = self.reduce_lines(columns, rows)

        if not self.first_column:
            columns.append(0)
        if not self.first_row:
            rows.append(0)
        if not self.last_row:
            rows.append(height)
        if not self.last_column:
            columns.append(width)

        columns, rows = self.sort_coords(columns, rows)
        columns, rows = self.get_line_tuples(
            columns, rows
        )  # converts detected line lists to tuples
        if self.show_lines:
            self.draw_lines(file, columns, rows)  # visuzalizes the detected lines
        return columns, rows

    def get_filenames_in_directory(self, dir):
        filenames = []
        filenames = os.listdir(dir)
        return filenames

    def get_values_from_txt(self, source):
        with open(source, "r", encoding="utf-8") as f:
            values = f.read().splitlines()
        values = list(filter(None, values))
        return values

    def extract_table(self, cities, degrees, file, rename_axis=True):
        """extracts a single table"""
        source = f"{self.base_path}/screenshots_cutout/{file}.png"
        columns, rows = self.detect_lines(file)
        print("")
        print(f"File {file}")
        print(f"Detected columns:  {len(columns)}/{len(cities)}")
        print(f"Detected rows:  {len(rows)}/{len(degrees)}")
        print("")

        rows = rows[0 : len(degrees)]
        columns = columns[0 : len(cities)]
        df = pd.DataFrame(index=rows, columns=columns)
        if rename_axis:
            df = self.detect_icons(source, df, columns=columns, rows=rows)
            df = df.set_axis(cities, axis=1, copy=False)
            df = df.rename(index=dict(zip(rows, degrees)))
            df = df.replace(np.nan, "", regex=True)
            df = df.drop(
                df.filter(regex="#").columns, axis=1
            )  # remove empty columns; some tables contained empty rows and columns without axis labels by design.
            df = df.drop(
                df.filter(regex="#").columns, axis=0
            )  # remove empty rows; some tables contained empty rows and columns without axis labels by design.
        return df

    def extract_page(
        self,
        base_path,
        cities_txt,
        degrees1_txt,
        degrees2_txt,
        screenshot1,
        screenshot2,
        join_rows=True,
    ):
        """extracts a table that spans over two pages"""
        cities = self.get_values_from_txt(f"{base_path}/{cities_txt}.txt")
        degrees1 = self.get_values_from_txt(f"{base_path}/{degrees1_txt}.txt")
        degrees2 = self.get_values_from_txt(f"{base_path}/{degrees2_txt}.txt")
        df1 = self.extract_table(cities, degrees1, screenshot1)
        df2 = self.extract_table(cities, degrees2, screenshot2)
        if join_rows:
            page = pd.concat([df1, df2], axis=0)
        else:
            page = pd.concat([df1, df2], axis=1)
        self.df_to_excel_formatting(
            page, interim_result=True, custom_name=f"{screenshot1}_bis_{screenshot2}"
        )
        return page

    def extract_page_join_over_cities(
        self,
        base_path,
        cities1_txt,
        cities2_txt,
        degrees_txt,
        screenshot1,
        screenshot2,
        join_rows=False,
    ):
        """extracts a table that spans over two pages that have the same institution location labels (cities labels)"""
        cities1 = self.get_values_from_txt(f"{base_path}/{cities1_txt}.txt")
        cities2 = self.get_values_from_txt(f"{base_path}/{cities2_txt}.txt")
        degrees = self.get_values_from_txt(f"{base_path}/{degrees_txt}.txt")
        df1 = self.extract_table(cities1, degrees, screenshot1)
        df2 = self.extract_table(cities2, degrees, screenshot2)
        if join_rows:
            page = pd.concat([df1, df2], axis=0)
        else:
            page = pd.concat([df1, df2], axis=1)
        self.df_to_excel_formatting(
            page, interim_result=True, custom_name=f"{screenshot1}_bis_{screenshot2}"
        )
        return page

    def extract_semi_page(
        self, base_path, cities_txt, degrees_txt, screenshot, write_to_file=True
    ):
        """extracts a semi page; required in case of tables spanning over multiple pages that are ending on an uneven page"""
        cities = self.get_values_from_txt(f"{base_path}/{cities_txt}.txt")
        degrees = self.get_values_from_txt(f"{base_path}/{degrees_txt}.txt")
        page = self.extract_table(cities, degrees, screenshot)
        if write_to_file:
            self.df_to_excel_formatting(
                page, interim_result=True, custom_name=f"{screenshot}"
            )
        return page

    def df_to_excel_formatting(self, df, interim_result=False, custom_name=False):
        """converts the dataframe into the excel .xlsx format and saves the result"""
        df = df.drop(
            df.filter(regex="#").columns, axis=1
        )  # remove empty columns; some tables contained empty rows and columns without axis labels by design.
        df = df[~df.index.to_series().str.startswith("#")]
        sheetname = "Tabelle1"
        if interim_result or custom_name:
            writer = pd.ExcelWriter(
                f"{self.base_path}/results/{self.type}_{self.year}_{custom_name}.xlsx",
                engine="xlsxwriter",
            )
        else:
            writer = pd.ExcelWriter(
                f"{self.base_path}/results/{self.type}_{self.year}.xlsx",
                engine="xlsxwriter",
            )
        header_list = list(df.columns.values)
        df.to_excel(writer, index=True, header=True, startrow=1, sheet_name=sheetname)
        workbook = writer.book
        format = workbook.add_format({})
        format.set_rotation(90)
        # print(df)
        for i in range(0, len(header_list)):
            writer.sheets[sheetname].write(1, i + 1, header_list[i], format)
        worksheet = workbook.get_worksheet_by_name(sheetname)
        worksheet.set_column(0, 0, 40)
        worksheet.set_column(1, 300, 3)
        workbook.close()
