#!/usr/bin/env python3

import os
import sys
import pandas as pd
import numpy as np

inputMaster = sys.argv[1]

mainMid = pd.read_excel(inputMaster, 'SRA_data')
frontPage = pd.read_excel(inputMaster, 'Contact Info and Instructions')
backPage = pd.read_excel(inputMaster, 'Library and Platform Terms')
df1 = mainMid.iloc[:732]
df1.set_index("bioproject_accession", inplace=True)
df2 = mainMid.iloc[732:1464]
df2.set_index("bioproject_accession", inplace=True)
df3 = mainMid.iloc[1464:2196]
df3.set_index("bioproject_accession", inplace=True)
df4 = mainMid.iloc[2196:2928]
df4.set_index("bioproject_accession", inplace=True)
df5 = mainMid.iloc[2928:3660]
df5.set_index("bioproject_accession", inplace=True)
df6 = mainMid.iloc[3660:4392]
df6.set_index("bioproject_accession", inplace=True)
df7 = mainMid.iloc[4392:5124]
df7.set_index("bioproject_accession", inplace=True)
df8 = mainMid.iloc[5124:5856]
df8.set_index("bioproject_accession", inplace=True)
df9 = mainMid.iloc[5856:]
df9.set_index("bioproject_accession", inplace=True)

df1.to_csv("/home/corey/Downloads/SRA_metadata/new_excels/CSVs/SRA_metadata_bridge_6_group_1.csv", sep='\t', encoding='utf-8')
df2.to_csv("/home/corey/Downloads/SRA_metadata/new_excels/CSVs/SRA_metadata_bridge_6_group_2.csv", sep='\t', encoding='utf-8')
df3.to_csv("/home/corey/Downloads/SRA_metadata/new_excels/CSVs/SRA_metadata_bridge_6_group_3.csv", sep='\t', encoding='utf-8')
df4.to_csv("/home/corey/Downloads/SRA_metadata/new_excels/CSVs/SRA_metadata_bridge_6_group_4.csv", sep='\t', encoding='utf-8')
df5.to_csv("/home/corey/Downloads/SRA_metadata/new_excels/CSVs/SRA_metadata_bridge_6_group_5.csv", sep='\t', encoding='utf-8')
df6.to_csv("/home/corey/Downloads/SRA_metadata/new_excels/CSVs/SRA_metadata_bridge_6_group_6.csv", sep='\t', encoding='utf-8')
df7.to_csv("/home/corey/Downloads/SRA_metadata/new_excels/CSVs/SRA_metadata_bridge_6_group_7.csv", sep='\t', encoding='utf-8')
df8.to_csv("/home/corey/Downloads/SRA_metadata/new_excels/CSVs/SRA_metadata_bridge_6_group_8.csv", sep='\t', encoding='utf-8')
df9.to_csv("/home/corey/Downloads/SRA_metadata/new_excels/CSVs/SRA_metadata_bridge_6_group_9.csv", sep='\t', encoding='utf-8')

   
writer = pd.ExcelWriter('/home/corey/Downloads/SRA_metadata/new_excels/SRA_metadata_bridge_6_group_1.xlsx', index=True)
frontPage.to_excel(writer, sheet_name="Contact Info and Instructions")
df1.to_excel(writer, sheet_name="SRA_data")
backPage.to_excel(writer, sheet_name="Library and Platform Terms")
writer.save()

writer = pd.ExcelWriter('/home/corey/Downloads/SRA_metadata/new_excels/SRA_metadata_bridge_6_group_2.xlsx', index=True)
frontPage.to_excel(writer, sheet_name="Contact Info and Instructions")
df2.to_excel(writer, sheet_name="SRA_data")
backPage.to_excel(writer, sheet_name="Library and Platform Terms")
writer.save()

writer = pd.ExcelWriter('/home/corey/Downloads/SRA_metadata/new_excels/SRA_metadata_bridge_6_group_3.xlsx', index=True)
frontPage.to_excel(writer, sheet_name="Contact Info and Instructions")
df3.to_excel(writer, sheet_name="SRA_data")
backPage.to_excel(writer, sheet_name="Library and Platform Terms")
writer.save()

writer = pd.ExcelWriter('/home/corey/Downloads/SRA_metadata/new_excels/SRA_metadata_bridge_6_group_4.xlsx', index=True)
frontPage.to_excel(writer, sheet_name="Contact Info and Instructions")
df4.to_excel(writer, sheet_name="SRA_data")
backPage.to_excel(writer, sheet_name="Library and Platform Terms")
writer.save()

writer = pd.ExcelWriter('/home/corey/Downloads/SRA_metadata/new_excels/SRA_metadata_bridge_6_group_5.xlsx', index=True)
frontPage.to_excel(writer, sheet_name="Contact Info and Instructions")
df5.to_excel(writer, sheet_name="SRA_data")
backPage.to_excel(writer, sheet_name="Library and Platform Terms")
writer.save()

writer = pd.ExcelWriter('/home/corey/Downloads/SRA_metadata/new_excels/SRA_metadata_bridge_6_group_6.xlsx', index=True)
frontPage.to_excel(writer, sheet_name="Contact Info and Instructions")
df6.to_excel(writer, sheet_name="SRA_data")
backPage.to_excel(writer, sheet_name="Library and Platform Terms")
writer.save()

writer = pd.ExcelWriter('/home/corey/Downloads/SRA_metadata/new_excels/SRA_metadata_bridge_6_group_7.xlsx', index=True)
frontPage.to_excel(writer, sheet_name="Contact Info and Instructions")
df7.to_excel(writer, sheet_name="SRA_data")
backPage.to_excel(writer, sheet_name="Library and Platform Terms")
writer.save()

writer = pd.ExcelWriter('/home/corey/Downloads/SRA_metadata/new_excels/SRA_metadata_bridge_6_group_8.xlsx', index=True)
frontPage.to_excel(writer, sheet_name="Contact Info and Instructions")
df8.to_excel(writer, sheet_name="SRA_data")
backPage.to_excel(writer, sheet_name="Library and Platform Terms")
writer.save()

writer = pd.ExcelWriter('/home/corey/Downloads/SRA_metadata/new_excels/SRA_metadata_bridge_6_group_9.xlsx', index=True)
frontPage.to_excel(writer, sheet_name="Contact Info and Instructions")
df9.to_excel(writer, sheet_name="SRA_data")
backPage.to_excel(writer, sheet_name="Library and Platform Terms")
writer.save()