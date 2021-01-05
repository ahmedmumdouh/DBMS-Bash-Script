#!/bin/bash
# mkdir with the name sent to you mkdir $1
# first check if the directory exits or not

if ! [[ -d ./DB ]]; then
	mkdir -p DB 
fi

select varuse in "Create DataBase" "Cancel" 
do
	case $varuse in
		"Create DataBase" )	
			read -p "Enter DB Name: " dbname && if ! [[ $dbname =~ ^[A-Za-z_][A-Za-z0-9_]*$ ]] ;
			then
				read -p "InValid Input ... 😱`echo $'\n> 'Press any key to Refresh ... `" ; exit 	
			fi

			if [[ -d DB/$dbname ]]; then
				read -p  "The DB : $1 Already Exists ... 😱`echo $'\n> '` Press Any Key to Refresh";
			 
			else
				mkdir -p DB/$dbname ;
				read -p  "The DB : $1 Created Successfully ... 😀`echo $'\n> '` Press Any Key to Refresh";

			fi
			;;
		"Cancel" )	
			read -p "Canceled ... 😉 `echo $'\n> 'Press any key to Refresh ... `"
			;;
		
		* ) read -p "InValid Input ... 😱`echo $'\n> 'Press any key to Refresh ... `" 
			;;
	esac
	clear && break 
done
