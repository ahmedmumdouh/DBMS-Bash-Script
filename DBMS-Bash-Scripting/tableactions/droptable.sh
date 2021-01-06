#!/bin/bash




select varuse in "Drop Table" "Cancel" 
do
	case $varuse in
		"Drop Table" )	
			read -p "Enter TB(Drop) Name : " dropt && location=DB/$1/$dropt && if ! [[ $dropt =~ ^[A-Za-z_][A-Za-z0-9_]*$ ]] ;
				then
					read -p "InValid Input ... 😱`echo $'\n> 'Press any key to Refresh ... `" ; exit 	
				fi

			if [[ -f "$location" ]]; then
				read -p "Are you Sure You Want To drop TB : $dropt ? [y/n]  " choice
				case $choice in
					 [Yy]* ) 
						rm $location
						echo "Deleted TB : $dropt ... 😀"
						;;
					 [Nn]* ) 
						echo "Canceled ... 😉"
						;;
					* ) 
						echo "Invalid Input ... 😱"
						;;
				esac
				read -p "> Press any key to Refresh ... "
			else
				read -p "Not Existed TB : $dropt ... 😱`echo $'\n> '`Press any key to Refresh ... "
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
