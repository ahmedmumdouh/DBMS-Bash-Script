#!/bin/bash
while true 
do 
	clear
	echo Databases:$'\n '$(find ./DB/ -maxdepth 1 -type d | cut -d'/' -f3 )
	echo ------------------------------------------------------------------------------
	select choice in createDB renameDB dropDB  useExistDB Exit
	do
		case $choice in
			createDB )  bash dbactions/createdb.sh 
				;;
			renameDB )  bash dbactions/renamedb.sh
				;;
			dropDB )  bash dbactions/dropdb.sh
				;;

			useExistDB )  bash dbactions/usedatabase.sh
				;;
			Exit ) clear && exit
				;;
			* ) read -p "InValid Input : `echo $'\n> '`Press Any Key To Restart ..." 
				clear && break
				;;
		esac
		clear && break ; 

	done
done
