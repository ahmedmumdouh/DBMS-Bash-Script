#!/bin/bash

db_name=$1
tbl_name=$2
col_name=$3
col_value=$4

echo ""

if ! [[ $tbl_name =~ ^[A-Za-z_][A-Za-z0-9_]*$ ]]
then
    echo "Invalid Input, please check table name"
    echo ""
elif [[ -f ./DB/$db_name/$tbl_name ]]
then
    declare -a col_names_list
    #gets the column names from the table
    col_names=$(head -1 ./DB/$db_name/$tbl_name | awk 'BEGIN{RS=","; FS="+"}{print $1}')
    #reads the column names into an array
    readarray col_names_list<<<"$col_names" 
    let flag_exist=0;
    let col_index=0;

    for column in ${col_names_list[*]}
    do
        if [[ $col_name == $column ]]
        then
            flag_exist=1;
            break
        fi
        ((col_index++))
    done

    if [ $flag_exist -eq 0 ]
    then
        echo "Column name: $col_name doesn't exist"
        exit
    fi
    ((col_index++))
    
    sed -n '1p' ./DB/$db_name/$tbl_name > ./DB/$db_name/tmpfile 2> error.log && tail -n+2 ./DB/$db_name/$tbl_name | awk -v col_index="$col_index" -v col_val="$col_value" 'BEGIN{FS=",";OFS=","}{if($col_index==col_val){next}{print}}' >> ./DB/$db_name/tmpfile 2> error.log && mv ./DB/$db_name/tmpfile ./DB/$db_name/$tbl_name 2> error.log
    echo "Done"
    echo ""
#if the table doesn't exist then
#will tell the user
else
    echo "The table name: $tbl_name doesn't exist"
fi