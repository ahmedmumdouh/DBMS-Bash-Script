#!/bin/bash
# mkdir with the name sent to you mkdir $1
# first check if the directory exits or not

if ! [[ -d ./DB ]]; then
	mkdir -p DB 
fi

read -p "Enter DB Name: " dbname && if ! [[ $dbname =~ ^[A-Za-z_][A-Za-z0-9_]*$ ]] ;
then
	read -p "InValid Input ... `echo $'\n> 'Press any key to Refresh ... `" ; exit 	
fi

if [[ -d DB/$dbname ]]; then
	read -p  "The DB : $1 Already Exists ... `echo $'\n> '` Press Any Key to Refresh";
 
else
	mkdir -p DB/$dbname ;
	read -p  "The DB : $1 Created Successfully in ./DB/$1 ... `echo $'\n> '` Press Any Key to Refresh";

fi
