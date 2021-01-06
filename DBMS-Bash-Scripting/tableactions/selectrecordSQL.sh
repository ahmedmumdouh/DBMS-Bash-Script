#!/bin/bash

db_name=$1
tbl_name=$2
col_name=$3
col_value=$4

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
    
    # tail -n+2 ./DB/$db_name/$tbl_name | awk -v col_index="$col_index" -v col_val="$col_value" 'BEGIN{FS=","}{if($col_index==col_val){i=1; while(i<=NF){print $i; i++}}}'

    declare -a records_list
    record=$(tail -n+2 ./DB/$db_name/$tbl_name | awk -v col_index="$col_index" -v col_val="$col_value" 'BEGIN{FS=","}{if($col_index==col_val){i=1; while(i<=NF){print $i; i++}}}')
    readarray records_list<<<"$record"

    echo -n "  "

    for column in ${col_names_list[*]}
    do
        echo -n $column
        echo -n "              "
    done 
    echo "" 

    #calculates the number of records
    let record_count=${#records_list[*]}/${#col_names_list[*]} 
    #number of columns
    let col_count=${#col_names_list[*]}
    #counter to loop on the records_list array
    let fields_count=0;
    let count=0

    #displays the records to the user
        while [ $count -lt $record_count ]
        do
            #use to display the record number to the user
            let disp_count=$count+1
            echo -n "$disp_count: "

            let col_no=0
            #loops on the number of columns to display
            #the fields of the record for each column
            while [ $col_no -lt $col_count ]
            do
                echo -n ${records_list[$fields_count]}
                echo -n "              "
                ((fields_count++))
                ((col_no++))
            done  
            echo ""
            ((count++))  
        done 
#if the table doesn't exist then
#will tell the user
else
    echo "The table name: $tbl_name doesn't exist"
fi