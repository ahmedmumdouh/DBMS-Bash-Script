#!/bin/bash

shopt -s nocasematch

#$1 => table name
#$2 => parameters list (col_name, datatype, size)
#$3 => database name

tbl_name=$1
db_name=$3
parameters=$2

if ! [[ $tbl_name =~ ^[A-Za-z_][A-Za-z0-9_]*$ ]]
then
    echo "Invalid Input, please check table name"
    echo ""
elif [[ -f ./DB/$db_name/$tbl_name ]]
then
    echo "Table: $tbl_name already exists"
    echo ""
else 
    touch DB/$db_name/$tbl_name && location=DB/$db_name/$tbl_name
    declare -a param_list
    readarray -td+ param_list <<<"$parameters+"
    unset 'param_list[-1]'
    let length=${#param_list[*]}
    let count=0
    
    while [ $count -lt $length ]
    do
        col_name=${param_list[$count]}
        data_type=${param_list[count+1]}
        size=${param_list[count+2]}

        col_names=$(head -1 $location | awk 'BEGIN{ RS = ","; FS = "+" } {print $1}')

        if ! [[ $col_name =~ ^[A-Za-z_][A-Za-z0-9_]*$ ]]
        then
            echo "Invalid input, check column names"
            echo ""
            rm $location
            break
        elif [[ `echo $col_names | grep -i $col_name` ]]
        then
            echo "Invalid input, duplicate column $col_name"
            echo ""
            rm $location
        elif ! [[ $data_type =~ ^integer$ || $data_type =~ ^string$ ]]
        then
            echo "Invalid input, check datatypes"
            echo ""
            rm $location
            break
        elif ! [[ "$size" = +([1-9])*([0-9]) ]]
        then
            echo "Invalid input, check data sizes"
            echo ""
            rm $location
            break
        else
            echo -n $col_name >> $location
            echo -n "+" >> $location
            echo -n $data_type >> $location
            echo -n "+" >> $location
            echo -n $size >> $location

            let check_end=$count+3
            if [ $check_end -eq $length ]
            then
                echo -n $'\n' >> $location
                echo "Table: $tbl_name was created successfully"
                echo ""
            else
                echo -n "," >> $location
            fi
        fi
        ((count+=3))
    done
fi