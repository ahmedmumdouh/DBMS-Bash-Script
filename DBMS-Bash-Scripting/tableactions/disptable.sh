#!/bin/bash

read -p "Enter TB(Display) Name : " dispt && location=DB/$1/$dispt && if ! [[ $dispt =~ ^[A-Za-z_][A-Za-z0-9_]*$ ]] ;
	then
		read -p "InValid Input ... `echo $'\n> 'Press any key to Refresh ... `" ; exit 	
	fi

if [[ -f "$location" ]]; then
	    db_name=$1
	    tbl_name=$dispt
	    let rlength=$( sed '1d' "$location" | wc -l | cut -f 1 )
	    let clength=$( head -1 "$location" | sed -e 's/,/ /g' | wc -w | cut -f 1 )
	    declare -a fields_list
	    fields=$(head -1 ./DB/$db_name/$tbl_name | awk 'BEGIN{ RS = ","; FS = "+" } {i=1; while(i<=NF){print $i; i++}}')
	    readarray fields_list <<<"$fields"
	    let length=${#fields_list[*]}
	    let count=0
	    let col_no=1
	    echo " - Database : $1		- Table : $tbl_name		- Number of Colunms : $clength		- Number of Records : $rlength "
	    echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
	    echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"   
	    while [ $count -lt $length ]
	    do
		if [ $count == 0 ]
		then
		    echo -n "++ 	Column ($col_no) Name : ${fields_list[${count}]}" | tr '\n' ' ' ; echo "  (Primary Key)"  ; 
		else
		    echo -n "++ 	Column ($col_no) Name : ${fields_list[$count]}";
		fi
		echo -n "++ 	Column ($col_no) Datatype : ${fields_list[$count+1]}";
		echo -n "++ 	Column ($col_no) Size : ${fields_list[$count+2]}";
		echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++" 
		((count+=3))
		((col_no++))
	    done
	    echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++" 
	echo $'\n'
	read -p "> Press any key to Refresh ... "
else
	read -p "Not Existed TB : $dispt ... `echo $'\n> '`Press any key to Refresh ... "
fi
