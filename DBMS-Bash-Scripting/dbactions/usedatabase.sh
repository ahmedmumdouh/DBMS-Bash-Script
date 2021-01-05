#!/bin/bash


select varuse in "Use DataBase" "Cancel" 
do
	case $varuse in
		"Use DataBase" )	
			read -p "Enter DataBase Name: " db && if ! [[ $db =~ ^[a-zA-Z_][A-Za-z0-9_]*$ ]] ;
				then
					read -p "InValid Input ... 😱`echo $'\n> 'Press any key to Refresh ... `" && exit 	
				fi

			while true 
			do
				
				if [[ -d DB/$db ]]; then
					clear
					echo Tables of Database [ $db ] :$'\n '$(find ./DB/$db/* -type f 2>>error.log | cut -d'/' -f4 2>>error.log )
					echo ------------------------------------------------------------------------------
					select varuse in "Create Table" "Drop Table" "Update Table" "Insert into table" "Delete from table" "Select from table" "Display Table" "Back"
					do
						case $varuse in
							"Create Table" )	
								bash tableactions/createtable.sh $db
								;;
							"Drop Table" )
								bash tableactions/droptable.sh $db
								;;
							"Update Table" )  
								bash tableactions/updatetable.sh $db
								;;
							"Insert into table")
								bash tableactions/insert.sh $db
								;;
							"Delete from table" )  
								bash tableactions/delete.sh $db
								;;
							"Select from table" )
								bash tableactions/select.sh $db
								;;
							"Display Table" ) 
								bash tableactions/disptable.sh $db
								;;
							"Back" )  clear && exit
								;;
							* ) read -p "InValid Input ... 😱`echo $'\n> 'Press any key to Refresh ... `" && clear && break 
								;;
						esac
						clear && break 

					done
				else
					read -p "Not Existed DB : $db ... 😱`echo $'\n> '`Press any key to Refresh ... " && clear && exit
				fi

			done
			;;
		"Cancel" )	
			read -p "Canceled ... 😉 `echo $'\n> 'Press any key to Refresh ... `"
			;;
		
		* ) read -p "InValid Input ... 😱`echo $'\n> 'Press any key to Refresh ... `" 
			;;
	esac
	clear && break 
done

