#!/bin/bash

db_name=$1
tbl_name=$2
required_col=$3

if ! [[ $tbl_name =~ ^[A-Za-z_][A-Za-z0-9_]*$ ]]
then
    echo "Invalid Input, please check table name"
    echo ""
elif [[ -f ./DB/$db_name/$tbl_name ]]
then

    if [ $required_col ]
    then
        #col_list an array that will hold the values of required_col without "+"
        declare -a col_list

        declare -a col_names_list
        declare -a records_list
        #will split the string according the delimiter "+"
        readarray -td+ col_list <<<"$required_col+"
        #the last index in the array will hold a " " so we unset that index
        unset 'col_list[-1]'

        #gets the column names from the table
        col_names=$(head -1 ./DB/$db_name/$tbl_name | awk 'BEGIN{RS=","; FS="+"}{print $1}')
        #reads the column names into an array
        readarray col_names_list<<<"$col_names" 

        # #gets the record fields from the table
        # records=$(tail -n+2 ./DB/$db_name/$tbl_name | awk 'BEGIN{FS=","}{i=1; while(i<=NF){print $i; i++}}')
        # #reads them into an array
        # readarray records_list<<<"$records"

        let no_of_col=${#col_list[*]}
        #number of columns
        let col_count=${#col_names_list[*]}
        let count1=0
        let i=0
        let flag=0
        declare -a field_no

        while [ $count1 -lt $no_of_col ]
        do
            let count2=0
            flag=0
            while [ $count2 -lt $col_count ]
            do
                if [ ${col_list[$count1]} = ${col_names_list[$count2]} ]
                then
                    field_no[i]=$count2
                    ((i++))
                    flag=1
                    break
                fi
                ((count2++))
            done
            if [ $flag -eq 0 ]
            then
                echo "Invalid column name"
                exit 
            fi
            ((count1++))
        done

        #gets the record fields from the table
        records=$(tail -n+2 ./DB/$db_name/$tbl_name | awk 'BEGIN{FS=","}{i=1; while(i<=NF){print $i; i++}}')
        #reads them into an array
        readarray records_list<<<"$records"

        #calculates the number of records
        let record_count=${#records_list[*]}/${#col_names_list[*]}

        #counter to loop on the records_list array
        let fields_count=0;
        let count=0
        let field_count=${#field_no[*]}

        echo -n "  "

        #display the column names to the user
        for column in ${col_names_list[*]}
        do
            for req_col in ${col_list[*]}
            do
                if [[ $column == $req_col ]]
                then
                    echo -n $column
                    echo -n "              "
                    break
                fi
            done

        done

        echo ""
        ((count=0))

        #displays the records to the user
        while [ $count -lt $record_count ]
        do
            #use to display the record number to the user
            let disp_count=$count+1
            echo -n "$disp_count: "

            let col_no=0
            
            #loops on the number of columns to display
            #the fields of the record fro each column
            while [ $col_no -lt $col_count ]
            do
                let col_check=0
                let f_no=0
                while [ $col_check -lt $field_count ]
                do
                    if [[ $col_no == ${field_no[$f_no]} ]]
                    then
                        echo -n ${records_list[$fields_count]}
                        echo -n "              "
                        ((f_no++))
                        break
                    fi
                    ((f_no++))
                    ((col_check++))
                done               
                ((fields_count++))
                ((col_no++))
            done  
            echo ""
            ((count++))  
        done

    else       
        #col_names_list holds the column names of the table
        #records_ list will hold all the records, each field is in
        #an index in the array
        declare -a col_names_list
        declare -a records_list

        #gets the column names from the table
        col_names=$(head -1 ./DB/$db_name/$tbl_name | awk 'BEGIN{RS=","; FS="+"}{print $1}')
        #reads the column names into an array
        readarray col_names_list<<<"$col_names"    

        #gets the record fields from the table
        records=$(tail -n+2 ./DB/$db_name/$tbl_name | awk 'BEGIN{FS=","}{i=1; while(i<=NF){print $i; i++}}')
        #reads them into an array
        readarray records_list<<<"$records"

        #calculates the number of records
        let record_count=${#records_list[*]}/${#col_names_list[*]}

        #number of columns
        let col_count=${#col_names_list[*]}
        #counter to loop on the records_list array
        let fields_count=0;
        let count=0

        echo -n "  "

        #display the column names to the user
        while [ $count -lt $col_count ]
        do
            echo -n ${col_names_list[$count]}
            echo -n "              "
            ((count++))
        done

        echo ""
        ((count=0))

        #displays the records to the user
        while [ $count -lt $record_count ]
        do
            #use to display the record number to the user
            let disp_count=$count+1
            echo -n "$disp_count: "

            let col_no=0
            #loops on the number of columns to display
            #the fields of the record fro each column
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
    fi  
#if the table doesn't exist then
#will tell the user
else
    echo "The table name: $tbl_name doesn't exist"
fi