#!/bin/bash

declare -a sub
module load python3_ML/3.6.4

python_Dataframe(){
    
    sub="${sub[@]}" xcel="${xcel}" localD="${localDir}" output="${temploc}" fileType="${fileType}" python3 - <<END_OF_PYTHON
    
import os
import pandas as pd

def fileIso(sub, localDir, fileType):
    reverse=-1
    inputList={}
    word=""
    for index, i in enumerate(sub):
            while(i[reverse] != "_"):
                word+=i[reverse]
                reverse-=1
            word="".join(reversed(word))
            inputList[word]=[i + fileType, localDir + i + fileType]
            word=""
            reverse=-1
    return(inputList)

def dataFrame_handler(output, path):
    if(os.path.isfile(output + "excel_files/output.xlsx")):
        accession = pd.read_excel(output + "excel_files/output.xlsx")
        accession.set_index("library_ID", inplace=True)
    else:
        accession = pd.read_excel(path)
        accession.set_index("library_ID", inplace=True)

    if(os.path.isfile(output + "excel_files/not_found_output.xlsx")):
        NotFoundDF = pd.read_excel(output + "excel_files/not_found_output.xlsx")
        NotFoundDF.set_index("library_ID", inplace=True)
    else:
        NotFoundDF = pd.DataFrame(columns = ["library_ID", 
        "title",
        "library_strategy", 
        "library_source", 
        "library_selection", 
        "library_layout", 
        "platform", 
        "instrument_model", 
        "design_description",
        "filetype",
        "filename",
        "filename2",
        "filename3",
        "filename4",])
        NotFoundDF.set_index("library_ID", inplace=True)

    return(accession, NotFoundDF)


def dataFraming(inputList, sub, path, output, fileType):

    accession, NotFoundDF = dataFrame_handler(output, path)

    fastqFound = ''

    for key in inputList:
        dataFrameKey=''
        if(key in accession.index):
            dataFrameKey=accession
            fastqFound += inputList[key][1] + "\n"
        else:           
            dataFrameKey=NotFoundDF

        dataFrameKey.loc[key, "title"] = "Exome capture of Hordeum vulgare: leaf tissue"
        dataFrameKey.loc[key, "library_strategy"] = "OTHER"
        dataFrameKey.loc[key, "library_source"] = "GENOMIC"
        dataFrameKey.loc[key, "library_selection"] = "Hybrid Selection"
        dataFrameKey.loc[key, "library_layout"] = "paired"
        dataFrameKey.loc[key, "platform"] = "ILLUMINA"
        dataFrameKey.loc[key, "instrument_model"] = "Illumina HiSeq 2500"
        dataFrameKey.loc[key, "design_description"] = "Genomic libraries constructed with Roche NimbleGen SeqCap EZ Developer probe pool"
        dataFrameKey.loc[key, "filetype"] = "fastq"
        if(pd.isnull(dataFrameKey.loc[key, "filename"])):
            dataFrameKey.loc[key, "filename"] = inputList[key][0]
        elif(pd.isnull(dataFrameKey.loc[key, "filename2"])):
            dataFrameKey.loc[key, "filename2"] = inputList[key][0]
        elif(pd.isnull(dataFrameKey.loc[key, "filename3"])):
            dataFrameKey.loc[key, "filename3"] = inputList[key][0]
        elif(pd.isnull(dataFrameKey.loc[key, "filename4"])):
            dataFrameKey.loc[key, "filename4"] = inputList[key][0]

    writer_notFound = pd.ExcelWriter(output + "excel_files/not_found_output.xlsx")
    NotFoundDF.to_excel(writer_notFound)
    writer_notFound.save()

    writer = pd.ExcelWriter(output + "excel_files/output.xlsx")
    accession.to_excel(writer)
    writer.save()

    if(fastqFound):
        with open(output + "found_list.txt", "a+") as foundFiles:
            foundFiles.write(fastqFound)

def bashImports():
    sub=list(os.environ['sub'].split(" "))
    path=str(os.environ['xcel'])
    output=str(os.environ['output'])
    localDir=str(os.environ['localD'])
    fileType=str(os.environ['fileType'])
    return(sub, path, output, localDir, fileType)

def main():
    sub, path, output, localDir, fileType=bashImports()
    inputList=fileIso(sub, localDir, fileType)
    dataFraming(inputList, sub, path, output, fileType)

main()

END_OF_PYTHON

}

dir_maker(){
    # if [ -d output ]; then
    #     output=${4}
    # else
    #     output=$HOME
    temp=$(mktemp -d)
    temploc="${temp}"/BRIDG6_FASTQ/
    if [ ! -d "${temploc}" ]; then
        # mkdir "${temploc}"BRIDG6_FASTQ
        mkdir "${temploc}"
        mkdir "${temploc}"/excel_files
        mkdir "${temploc}"/fastq_files    
    fi

}


master_list(){

    local path=${1}
    fileType=${2}
    xcel=${3}

    declare -a dir_list=$(ls -d */)

    for subdirs in ${dir_list[@]}; do
        declare -a sub=()
        localDir="$path""$subdirs"
        local dirFiles=$(find "$path""$subdirs" -type f -name "*${fileType}*")
        for i in ${dirFiles[@]}; do
            local filename=${i##*/}
            filename=${filename%.*}
            sub+=("$filename")
        done
        python_Dataframe
    done

}

copier(){
    while read -r line; do
        cp "${line}" "${temploc}"/fastq_files
    done < "${temploc}"found_list.txt

    s3cmd mb s3://BRIDG6_FASTQ  > /dev/null
    # if (( s3cmd put --recursive "${temploc}" s3://BRIDG6_FASTQ )); then
    s3cmd put --recursive "${temploc}" s3://BRIDG6_FASTQ
        # echo -e "Transfer complete...\n"
    # fi
    # echo -e "Transfer failed...\n"

}

main(){

    dir_maker    
    master_list "$@"
    copier

}

main "$@"