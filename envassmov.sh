#!/bin/bash

declare -a sub #creates a BASH list, used for saving lists of files held in directory
# module load python3_ML/3.6.4 # Loads Python-3 module for use
# module load md5deep_ML/2.0

python_Dataframe(){
    
    # Activates Python and exports BASH variables into the new Python environment
    inputExcel="${inputExcel}" subExcels="${subExcels##*/}" temploc="${temploc}" dirName="${dirName}" python3 - <<END_OF_PYTHON

import os
import sys
import pandas as pd

def takeIt(dirName, temploc, inputExcel, subExcels):
    excelFile = pd.read_excel(inputExcel + "/" + subExcels, 'SRA_data')
    fileListing = excelFile["filename"].tolist()
    with open(temploc + "/masterMove.txt", "a+") as masterList:
        for file in fileListing:
            masterList.write(dirName + "/" + file + "\n")


def bashImports():
    inputExcel=str(os.environ['inputExcel'])
    subExcels=str(os.environ['subExcels'])
    temploc=str(os.environ['temploc'])
    dirName=str(os.environ['dirName'])
    return(dirName, temploc, inputExcel, subExcels)

def main():
    dirName, temploc, inputExcel, subExcels=bashImports()
    takeIt(dirName, temploc, inputExcel, subExcels)

main()

END_OF_PYTHON
}

dir_maker(){ # Creates file structure for data output

    loc=${2}
    temploc="${loc}"/SORTED_BRIDG6_FASTQ/
    if [[ ! -d "${temploc}" ]]; then # Checks if it directory's are already there
        mkdir "${temploc}"
        mkdir "${temploc}"excel_files
        mkdir "${temploc}"fastq_files
    fi

}

master_list(){ # Creates listings from directory structures 

    inputExcel=${3}

    cd $inputExcel
    declare -a excelListing=$(find -type f)
    
    for subExcels in ${excelListing[@]}; do
        tradeCraft=${subExcels%.*}
        tradeCraft=${tradeCraft##*/}
        dirName="${temploc}"fastq_files/"${tradeCraft}"
        mkdir "${dirName}"
        python_Dataframe
    done

    echo -e "OPERATIONS COMPLETE...\n"
}

copier(){ # Reads the "found fastq" text file line-by-line and copies them to the output scratch directory

    local fastqFiles=${1}

    counter=1
    misses=0
    declare -a errorList=()
    while read -r line; do
        if [[ -f ${fastqFiles}/"${line##*/}" ]]; then
            cp ${fastqFiles}/"${line##*/}" "${line}"
            ((counter+=1))
        else
            ((misses+=1))
            errorList+=("${line}")
        fi
    done < "${temploc}"/masterMove.txt

    if [[ ${misses} > 0 ]] || [[ ${counter} < 6582 ]]; then
        echo -e "ERROR: Missing "${misses} "files"
        echo -e "Counter is: " ${counter} "\n"
        for missingFile in errorList; do   
            echo -e $missingFile
        done
    fi
}

checkSummer(){

    cd "${temploc}"fastq_files
    declare -a dirListing=$(ls -d *)
    for dir in ${dirListing[@]}; do
        md5deep -r "${dir}" >>  "${dir}"/"${dir##*/}_CheckSums.txt"
    done
}

main(){ # Main function for BASH

    dir_maker "$@" 
    master_list "$@"
    copier "$@"
    checkSummer

}

main "$@" # runs main function and imports parameters arguments.