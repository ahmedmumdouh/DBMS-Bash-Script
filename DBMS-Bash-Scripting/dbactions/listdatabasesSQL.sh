#!/bin/bash

#checks if the DB directory doesn't exist 
#then will create it
if ! [[ -d ./DB ]]
then
    mkdir -p DB
else
    declare -a database_names
    #find cmd will get the directory names inside /DB 
    #and the name will be saved inside the array database_names
    readarray -d '' database_names < <(find ./DB/* -maxdepth 1 -type d -print0 2> error.log)

    let length=${#database_names[*]}
    let count=0
    echo "+++++++++++++++++++++++++++"
    echo "| Databases               |"
    echo "+++++++++++++++++++++++++++"
    #loops on the database_names and only printthe third field
    #which holds the database name
    while [ $count -lt $length ]
    do
        echo -n "| "
        echo -n ${database_names[$count]} | cut -f3 -d/ 
        echo "---------------------------"
        ((count++))
    done
fi