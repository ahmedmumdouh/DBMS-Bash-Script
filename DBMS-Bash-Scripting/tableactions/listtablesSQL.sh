#!/bin/bash

db_name=$1


declare -a table_names

readarray -d '' table_names < <(find ./DB/$db_name/* -maxdepth 1 -type f -print0 2> error.log)
let length=${#table_names[*]}

if [ $length -eq 0 ]
then
    echo "No tables exist in database: $db_name"
else
    let count=0
    echo "+++++++++++++++++++++++++++"
    echo "| tables                  |"
    echo "+++++++++++++++++++++++++++"

    while [ $count -lt $length ]
    do
        echo -n "| "
        echo -n ${table_names[$count]} | cut -f4 -d/ 
        echo "---------------------------"
        ((count++))
    done
fi

echo ""
