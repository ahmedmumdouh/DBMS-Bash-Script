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
col_name=$3
col_value=$4
col_cond_name=$5
col_cond_value=$6

if ! [[ $tbl_name =~ ^[A-Za-z_][A-Za-z0-9_]*$ ]]
then
    echo "Invalid Input, please check table name"
    echo ""
elif [[ -f ./DB/$db_name/$tbl_name ]]
then
    location=./DB/$db_name/$tbl_name
    let col_num=0
    let col_cond_num=0
    let col_exist=0
    declare -a col_names_list

    #gets the column names from the table
    col_names=$(head -1 ./DB/$db_name/$tbl_name | awk 'BEGIN{RS=","; FS="+"}{print $1}')
    #reads the column names into an array
    readarray col_names_list<<<"$col_names"

    #check that the column name given exists in the table
    #and get the column number for the column to be changed
    for name in ${col_names_list[*]}
    do
        ((col_num++))
        if [[ $col_name == $name ]]
        then
            ((col_exist=1))
            break
        fi
    done

    #if the column name doesn't exists, quit
    if [ $col_exist -eq 0 ]
    then
        echo "Invalid, column: $col_name doesn't exist"
        exit
    fi

    #check that the column name given exists in the table
    #and get the column number for the column to be checked
    ((col_exist=0))
    for name in ${col_names_list[*]}
    do
        ((col_cond_num++))
        if [[ $col_cond_name == $name ]]
        then
            ((col_exist=1))
            break
        fi
    done

    #if the column name doesn't exists, quit
    if [ $col_exist -eq 0 ]
    then
        echo "Invalid, column: $col_cond_name doesn't exist"
        exit
    fi

    #check the datatype of the value of the column to be changed
    let checkdata=$(check_datatype $col_num $col_value $location)
    if [ $checkdata -eq 0 ]
    then
        echo "Invalid input: Check syntax or the datatypes"
        exit
    fi
    
    #check the datatype of the value of the column of the condition
    let checkdata=$(check_datatype $col_cond_num $col_cond_value $location)
    if [ $checkdata -eq 0 ]
    then
        echo "Invalid input: Check syntax or the datatypes"
        exit
    fi

    #check the size of the value of the column to be changed
    let checksize=$(check_size $col_num $col_value $location)
    if [ $checksize -eq 0 ]
    then
        echo "Invalid input: Check syntax or the data sizes"
        exit
    fi

    #check the size of the value of the column of the condition
    let checksize=$(check_size $col_cond_num $col_cond_value $location)
    if [ $checksize -eq 0 ]
    then
        echo "Invalid input: Check syntax or the data sizes"
        exit
    fi

    #if the value to be changed is in aprimary key column
    #checks that the value doesn't already exist
    if [ $col_num -eq 1 ]
    then
        let checkpk=$(check_pk $col_num $col_value $location)
        if [ $checkpk -eq 0 ]
        then
            echo "Invalid input: primary key value already exists"
            exit
        fi
    fi

    #tempfile used for saving the updates done on the table file
    #then moving it tk be the table file
    temploc=./DB/$db_name/tmpfile

    #copies the metadata to the tmpfile
    #then loops on the records and if the field (column) number in the where condition is found
    #updates the value in the column to be changed and appends the new data to tmpfile
    #then mv the tmpfile to be the table file
    sed -n '1p' $location > $temploc 2> error.log && tail -n+2 $location | awk -v col_index="$col_cond_num" -v col_val="$col_cond_value" -v new_val_num="$col_num" -v new_val="$col_value" 'BEGIN{FS=",";OFS=","}{if($col_index==col_val){$new_val_num=new_val}{print}}' >> $temploc 2> error.log && mv $temploc $location 2> error.log
    
    echo ""
    echo "Done"
    echo ""
#if the table doesn't exist then
#will tell the user
else
    echo "The table name: $tbl_name doesn't exist"
fi