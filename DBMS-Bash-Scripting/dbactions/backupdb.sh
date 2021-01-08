#!/bin/bash


if ! [[ -d ./Backup ]]; then
	mkdir -p Backup 
fi

if ! [[ -d ./DB ]]; then
	mkdir -p DB 
fi

select varuse in "Backup DataBase" "Cancel" 
do
	case $varuse in
		"Backup DataBase" )	
			read -p "Enter DB Name: " dbname && if ! [[ $dbname =~ ^[A-Za-z_][A-Za-z0-9_]*$ ]] ;
			then
				read -p "InValid Input ... 😱`echo $'\n> 'Press any key to Refresh ... `" ; exit 	
			fi
			if [[ -d DB/$dbname ]]; then
				if ! [[ -d Backup/$dbname ]]; then
					mkdir -p Backup/$dbname ;
				fi
				dateS="`date +"%d-%m-%Y|%H:%M:%S"`" ;
				for path in `find ./DB/$dbname -type d 2>>error.log` 
				do
					dirname=`echo $path |rev|cut -d/ -f1 |rev  2>>error.log`
					tar -cvf ./Backup/$dbname/"${dirname}-${dateS}.tar"  $path 2>>error.log ; 
				done
				read -p  "The DB : $dbname BackedUp Successfully ... 😀`echo $'\n> '` Press Any Key to Refresh";						
			else
				read -p "Not Existed DB : $dbname ... 😱`echo $'\n> '`Press any key to Refresh ... " && clear && exit
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






