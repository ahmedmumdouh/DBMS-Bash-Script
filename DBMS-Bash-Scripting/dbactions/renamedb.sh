#!/bin/bash

select varuse in "Rename DataBase" "Cancel" 
do
	case $varuse in
		"Rename DataBase" )	
			read -p "Select DataBase: " dbname && if ! [[ -d ./DB/$dbname && $dbname =~ ^[a-zA-Z_][a-zA-Z0-9_]*$ ]] ; 
				then 
					read -p "InValid-Entry OR Not Exited DB : $dbname 😱 ... `echo $'\n> '`Press any Key to Refresh " ; 
					exit 
				fi

			read -p "Enter New Name to $dbname : " dbnew && if [[ -d ./DB/$dbnew &&  $dbnew =~ ^[a-zA-Z_][a-zA-Z0-9_]*$  ]] 
				then 
					read -p "Another DB Existed with Same name : $dbnew  😱 ... `echo $'\n> '`Press any Key to Refresh " ; 
					exit 
				else
					mv ./DB/$dbname ./DB/$dbnew 2>error.log && read -p "Renamed DB: $dbname to $dbnew ... 😀`echo $'\n> '`Press any Key to Refresh " || read -p "error `echo $'\n> '`Press any Key to Refresh "
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

