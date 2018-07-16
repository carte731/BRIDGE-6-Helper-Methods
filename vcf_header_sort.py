#!/usr/bin/env python3

import os
import sys
import pandas as pd

file_path = str(sys.argv[1]) # Imports parameters arguments
excel_file = str(sys.argv[2])
out = str(sys.argv[3])

comment_header_data='' # Top .VCF header info, the "##" sections
column_headers='' # The column data that needs to be changed
VCF_body=bytearray() # A bytearray for saving the VCF column data
gate=True # controls if it's going to save the top portion of the VCF file, header or the VCF body
for x in open(file_path, encoding="ISO-8859-1"): ## This opens, reads and loops through a .VCF file. It allows advanced encoding to avoid extended decoding issues  
    if((x[:2] != "##") and (x[:6] == "#CHROM")): # checks if it's the column header row
        column_headers+=x
        gate=False
    elif(gate==True): # Saves the top half of the file
        comment_header_data+=x
    else:
        VCF_body.extend(x.encode('ISO-8859-1')) # Saves the .VCF body to a byte-array to save space

column_headers = column_headers.strip("\n") # These three lines convert the column headers into a list 
column_headers = list(column_headers.split("\t"))
column_headers_final = column_headers ## Copies the listing of column header

plate_one = pd.read_excel(excel_file, 'Plate_1') # reads the excel file into a dataframe
plate_two = pd.read_excel(excel_file, 'Plate_2')

plateListOne = plate_one["NamesInVCF"].tolist() # saves a column into a Python list
plateListTwo = plate_two["NamesInVCF"].tolist()

final_list = []
idx = 0
rejectItems = 'NO MATCH COLUMN HEADERS\n' + '-------------------------------\n'

for u in column_headers: # Goes thorugh list
    if(u in plateListOne): # Checks if the element from the list is in the xcel file 
        rep_indx = column_headers_final.index(u) # grabs element from that list, to check if xcel list
        idx = plate_one[plate_one["NamesInVCF"] == u].index.item() # Grabs index of the input element from xcel dataframe
        element = plate_one.iloc[idx]["NAM Parents"] # grabs element (accession #) based off of the index position
        column_headers_final[rep_indx] = element # Saves to final output listing
    elif(u in plateListTwo): # Same as above but for "Plate-2"
        rep_indx = column_headers_final.index(u)
        idx = plate_two[plate_two["NamesInVCF"] == u].index.item()
        element = plate_two.iloc[idx]["NAM Parents"]
        column_headers_final[rep_indx] = element
    else:
        rejectItems+=u + "\n" ## All rejected headers are placed here.

final_output = '\t'.join(column_headers_final) # converts list back into string
final_output+="\n"

with open(out + "adjusted_VCF.vcf", "w") as vcfSave: # Saves ".VCF" comment headers and column headers
    vcfSave.write(comment_header_data)
    vcfSave.write(final_output)
    
with open(out + "adjusted_VCF.vcf", "ab") as vcfSave_body: # Saves byte-array body to ".VCF" file created in the lines above.
    vcfSave_body.write(VCF_body)

with open(out + "MISMATCHED_COLUMN_HEADERS.txt", "w") as mismatch: # Creates a text file from the non-matched files.
    mismatch.write(rejectItems)
