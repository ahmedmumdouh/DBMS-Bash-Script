#!/bin/bash
read -p "Enter DataBase Name: " dropname && if ! [[ $dropname =~ ^[A-Za-z_][A-Za-z0-9_]*$ ]];
then
	read -p "InValid Input ... `echo $'\n> 'Press any key to Refresh ... `" ; exit 	
fi
if [[ -d DB/$dropname ]]; then
	read -p "Are you Sure You Want To Drop DB : $dropname ? [y/n]  " choice;
	case $choice in
		 [Yy]* ) 
			rm -r DB/$dropname && read -p "Deleted DB : $dropname `echo $'\n> 'Press any key to Refresh ... `" 
			;;
		 [Nn]* ) 
			read -p "Canceled ... `echo $'\n> 'Press any key to Refresh ... `"
			;;
		* ) 
			read -p "InValid Input ... `echo $'\n> 'Press any key to Refresh ... `"
			;;
	esac
else
	read -p "Not Existed DB : $dropname `echo $'\n> 'Press any key to Refresh ... `"
fi




