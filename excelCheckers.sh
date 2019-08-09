python_Dataframe(){
    
    # Activates Python and exports BASH variables into the new Python environment
    checkExcels="${checkExcels}" sub="${sub[@]}" subdirs="${subdirs}" file= python3 - <<END_OF_PYTHON

import os
import sys
import pandas as pd

def excelChecker(sub, checkExcels, filename):
    excelFile = pd.read_excel(checkExcels + "/" + filename, 'SRA_data')
    fileListing = excelFile["filename"].tolist()
    misses=1
    hits=0
    finalOut=''
    for file in fileListing:
        if(file not in sub):
            misses+=1
            finalOut+=file + "\n"
        else:
            hits+=1
    if(misses > 0):
        with open("/home/corey/excelMissList.txt", "a+") as missList:
            missList.write(finalOut)

def bashImports(): # Imports variables from BASH environment
    sub=list(os.environ['sub'].split(" "))
    checkExcels=str(os.environ['checkExcels'])
    filename=str(os.environ['subdirs']).strip("/")
    filename+=".xlsx"
    return(sub, checkExcels, filename)

def main(): # Main function
    sub, checkExcels, filename=bashImports()
    excelChecker(sub, checkExcels, filename)

main()

END_OF_PYTHON

}

master_list(){ # Creates listings from directory structures 

    local inputPath=${1}
    # fileType=${2}
    checkExcels=${2}

    cd $inputPath
    declare -a dir_list=$(ls -d */)
    counter=1
    for subdirs in ${dir_list[@]}; do
        declare -a sub=()
        localDir="$inputPath""$subdirs"
        local dirFiles=$(find "$inputPath"/"$subdirs" -type f -name "*.fastq*")
        for i in ${dirFiles[@]}; do
            local filename=${i##*/}
            sub+=("$filename")
        done
        python_Dataframe
        echo -e "ROUND $subdirs complete...\n"
    done

    echo -e "OPERATIONS COMPLETE...\n"
    
    # for i in ${sub[@]}; do
    #     echo -e $i
    # done
}

main(){ # Main function for BASH

    master_list "$@"

}

main "$@" # runs main function and imports parameters arguments.