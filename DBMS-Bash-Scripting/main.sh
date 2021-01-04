#!/bin/bash
while true 
do 
	clear
	echo DataBase List :$'\n '$(find ./DB/ -maxdepth 1 -type d 2>>error.log | cut -d'/' -f3 2>>error.log )
	echo ------------------------------------------------------------------------------
	select choice in createDB renameDB dropDB  useExistDB SQLMode Exit
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
			SQLMode )  #welcome Statement 
clear && echo "  Welcome to Our SQLMode ... " && echo ------------------------------------------------------------------------------ && bash mainSQL.sh
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
