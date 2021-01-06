#!/bin/bash

function check_datatype() {
    col_num=$1
    value=$2
    location=$3

    #gets the datatypes names from the table
    #using the column number = field number
    datatype=$(head -1 $location | awk -v col_num=$col_num 'BEGIN{RS=","; FS="+"}{if(NR == col_num){print $2}}')
    
    #if the value to be entered is integer it should consist
    #of numbers only and could have a negative sign (-)
    #if datatype is string they shouldn't enter ","
    #as it is a delimiter
    if [[ $datatype == "integer" ]]
    then
        if ! [[ "$value" = ?(-)+([0-9])*([0-9]) ]]
        then
            echo 0 #false
        else
            echo 1 #true
        fi
    elif [[ $datatype == "string" ]]
    then
        if [[ $value =~ [\,] ]]
        then
            echo 0
        else
            echo 1 #true
        fi
    fi
}

function check_size() {
    col_num=$1
    value=$2
    location=$3

    #gets the size of that column using the column number
    size=$(head -1 $location | awk -v col_num=$col_num 'BEGIN{RS=","; FS="+"}{if(NR == col_num){print $3}}')
    
    #checks if the value is a number if it has a negative sign(-)
    #removes it so it doesn't affect the count of the size
    if [[ "$value" = ?(-)+([0-9])*([0-9]) ]]
    then
        temp_val=${value: 1}
    else
        temp_val=$value
    fi

    #checks the count of the characters in the string
    #is not bigger than the size written
    if [[ "${#temp_val}" -le $size ]]
    then
        echo 1 #true
    else
        echo 0 #false
    fi
}

function check_pk() {
    col_num=$1
    value=$2
    location=$3

    #gets a value in the column that matches the value entered by the user
    #if there is something then will be returned in pk_exist
    pk_exist=$(tail -n+2 $location | awk -v col_num=$col_num -v value=$value 'BEGIN{FS=","}{if($col_num == value){print $col_num}}')

    if [[ $pk_exist == "" ]]
    then
        echo 1 #true
    else
        echo 0 #false
    fi
}

db_name=$1
tbl_name=$2
parameters=$3

if ! [[ $tbl_name =~ ^[A-Za-z_][A-Za-z0-9_]*$ ]]
then
    echo "Invalid Input, please check table name"
    echo ""
elif [[ -f ./DB/$db_name/$tbl_name ]]
then
    location=./DB/$db_name/$tbl_name

    #split the parameters string with the delimiter "+"
    #and save the value in the array param_list
    declare -a param_list
    readarray -td+ param_list <<<"$parameters+"
    unset 'param_list[-1]' #unset last value as it holds an empty string

    #get the number of columns in the table
    col_numbers=$(head -1 $location | awk 'BEGIN{FS=","}{print NF}')

    let param_length=${#param_list[*]}

    #checks that the values entered matches the number of columns in the table
    if [ $param_length -ne $col_numbers ]
    then
        echo "The values entered is not equal to the number of columns in table: $tbl_name"
        exit
    fi

    #we loop sequentail so the first value should be for the first column, etc.
    let col_num=1

    #loops on the values entered by the user
    for value in ${param_list[*]}
    do
        #checks the datatypes matches the one in the table for that column
        let checkdata=$(check_datatype $col_num $value $location)
        
        if [ $checkdata -eq 0 ]
        then
            echo "Invalid input: Check syntax or the datatypes"
            exit
        fi

        #checks the size matches the one in the table for that column
        let checksize=$(check_size $col_num $value $location)
        if [ $checksize -eq 0 ]
        then
            echo "Invalid input: Check syntax or the data sizes"
            exit
        fi

        #if the column is the primary key one then checks
        #that the value doesn't already exists in that column
        if [ $col_num -eq 1 ]
        then
            let checkpk=$(check_pk $col_num $value $location)
            if [ $checkpk -eq 0 ]
            then
                echo "Invalid input: primary key value already exists"
                exit
            fi
        fi

        ((col_num++))
    done

    ((col_num=1))
    
    #loops on the values entered by the user 
    #to insert them in the table
    for value in ${param_list[*]}
    do
        ((col_num++))

        echo -n $value >> $location
        
        if [ $col_num -gt $col_numbers ]
        then
            echo -n $'\n' >> $location
            echo ""
        else
            echo -n "," >> $location
        fi
    done
    
#if the table doesn't exist then
#will tell the user
else
    echo "The table name: $tbl_name doesn't exist"
fi