#!/bin/bash

db_name=$1
tbl_name=$2
echo $tbl
if ! [[ $tbl_name =~ ^[A-Za-z_][A-Za-z0-9_]*$ ]]
then
    echo "Invalid Input, please check table name"
    echo ""
elif [[ -f ./DB/$db_name/$tbl_name ]]
then
    declare -a fields_list
    #readarray -d '' fields < <(head -1 ./DB/$db_name/$tbl_name | awk 'BEGIN{ RS = ","; FS = "+" } {i=1; while(i<=NF){print $i; i++}}')
    fields=$(head -1 ./DB/$db_name/$tbl_name | awk 'BEGIN{ RS = ","; FS = "+" } {i=1; while(i<=NF){print $i; i++}}')
    readarray fields_list <<<"$fields"

    let length=${#fields_list[*]}
    let count=0
    let col_no=1
    pk="no"

    # echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
    # echo "column_name   |  datatype   |  Primary key   |   size   |"
    while [ $count -lt $length ]
    do
        if [ $count == 0 ]
        then
            pk="yes"
        else
            pk="no"
        fi
        echo "Column ($col_no) name: ${fields_list[$count]}"
        echo "Column ($col_no) datatype: ${fields_list[$count+1]}"
        echo "Column ($col_no) size: ${fields_list[$count+2]}"
        echo "Column ($col_no) primary key: $pk"
        echo "++++++++++++++++++++++++++++++++++++++++++++++++++"
        ((count+=3))
        ((col_no++))
    done
#if the table doesn't exist then
#will tell the user
else
    echo "The table name: $tbl_name doesn't exist"
fi