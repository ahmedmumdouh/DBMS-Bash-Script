#!/bin/bash
while true 
do 
	clear
	echo DataBase List :$'\n '$(find ./DB/ -maxdepth 1 -type d 2>>error.log | cut -d'/' -f3 2>>error.log )
	echo ------------------------------------------------------------------------------
	select choice in "Create DataBase" "Rename DataBase" "Drop DataBase"  "Use DataBase" "Use SQLMode" "Exit"
	do
		case $choice in
			"Create DataBase" )  bash dbactions/createdb.sh 
				;;
			"Rename DataBase" )  bash dbactions/renamedb.sh
				;;
			"Drop DataBase" )  bash dbactions/dropdb.sh
				;;

			"Use DataBase" )  bash dbactions/usedatabase.sh
				;;
			"Use SQLMode" )  #welcome Statement 
				select varuse in "Use SQL Mode" "Cancel" 
				do
					case $varuse in
						"Use SQL Mode" )	
				clear && echo "  Welcome to Our SQLMode ... 😀" && echo ------------------------------------------------------------------------------ && bash mainSQL.sh
							;;
						"Cancel" )	
							read -p "Canceled ... 😉 `echo $'\n> 'Press any key to Refresh ... `"
							;;
						
						* ) read -p "InValid Input ... 😱`echo $'\n> 'Press any key to Refresh ... `" 
							;;
					esac
					clear && break 
				done
				;;
			"Exit" ) clear && exit
				;;
			* ) read -p "InValid Input ... 😱`echo $'\n> 'Press any key to Refresh ... `" && break
				
				;;
		esac
		clear && break ; 

	done
done



