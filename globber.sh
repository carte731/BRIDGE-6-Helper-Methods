#!/bin/bash

declare -a sub
#module load python3_ML/3.6.4

python_Dataframe(){
    
    # sub="${sub[@]}" xcel="${xcel}" python3 - <<END_OF_PYTHON
    xcel="${xcel}" python3 - <<END_OF_PYTHON
    
import os
import pandas as pd

def fileIso(sub):
    reverse=-1
    inputList={}
    word=""
    inputR12=""
    gate=False
    for i in sub:
            while(i[reverse] != "_"):
                word+=i[reverse]
                reverse-=1
            word="".join(reversed(word))
            if((word.lower() != "rasmusson") and(word.lower() != "unmatched")):
                for u in word:
                    if((ord(u) >= 48) and (ord(u) <= 57) and (gate == False)):
                            inputR12+="_"
                            inputR12+=u
                            gate = True
                    else:
                            inputR12+=u
                inputList[word]=inputR12
            gate = False
            inputR12="" 
            word=""
            reverse=-1
    return(inputList)

def dataFraming(inputList, sub, path):
    # accession = pd.read_excel("/home/corey/alexStuff/Exome_SRA_metadata_Ana.xlsx")
    accession = pd.read_excel(path)
    accession.set_index("library_ID", inplace=True)
    # print(accession)
    # print(inputList)

    for key in inputList:
        print(key + ' ' + inputList[key])
        accession.loc[key, "title"] = "Exome capture of Hordeum vulgare: leaf tissue"
        accession.loc[key, "library_strategy"] = "OTHER"
        accession.loc[key, "library_source"] = "GENOMIC"
        accession.loc[key, "library_selection"] = "Hybrid Selection"
        accession.loc[key, "library_layout"] = "paired"
        accession.loc[key, "platform"] = "ILLUMINA"
        accession.loc[key, "instrument_model"] = "Illumina HiSeq 2500"
        accession.loc[key, "design_description"] = "Genomic libraries constructed with Roche NimbleGen SeqCap EZ Developer probe pool"
        accession.loc[key, "filetype"] = "fastq"
        accession.loc[key, "filename"] = inputList[key] + "_R1.fastq.gz"
        accession.loc[key, "filename2"] = inputList[key] + "_R2.fastq.gz"
    
    writer = pd.ExcelWriter("/home/corey/alexStuff/output.xlsx")
    # writer = pd.ExcelWriter("~/output.xlsx")
    accession.to_excel(writer)
    writer.save()

def bashImports():
    # sub=list(os.environ['sub'].split(" "))
    path=str(os.environ['xcel'])
    with open("/home/corey/alexStuff/test.txt", "r" ) as sublist:
        subq = sublist.read().replace('\n','') 
    # print(subq)
    sub=list(subq.split(" "))
    return(sub, path)

def main():
    sub, path=bashImports()
    inputList=fileIso(sub)
    # print(fileListing)
    dataFraming(inputList, sub, path)

main()

END_OF_PYTHON

}

master_list(){
    # args=("$@")
    # local path="/panfs/roc/scratch/agonzale/NAM_GBS_2_6row/Barcode_Splitter_Output/NAM_GBS_6row/"
    # local path="/home/corey/alexStuff/"
    # local path=${args[0]}
    local path=${1}
    # local fileType=".fastq"
    # local fileType=${args[1]}
    local fileType=${2}
    # local xcel="/home/corey/alexStuff/Exome_SRA_metadata_Ana_2.xlsx"
    # local xcel=${args[2]}
    xcel=${3}
    # output=${4}

    # local dirFiles=$(find "$PWD" -type f -name '*.fastq*')
    local dirFiles=$(find "$path" -type f -name "*${fileType}*")
    
    for i in ${dirFiles[@]}; do
        local filename=${i##*/}
        filename=${filename%.*}
        sub+=("$filename")
    done
    echo "${sub[@]}" >> /home/corey/alexStuff/test.txt

}

main(){
    master_list "$@"
    python_Dataframe
}

main "$@"