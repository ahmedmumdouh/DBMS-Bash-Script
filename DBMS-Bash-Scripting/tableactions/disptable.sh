#!/bin/bash

read -p "Enter TB(Display) Name : " dispt && location=DB/$1/$dispt && if ! [[ $dispt =~ ^[A-Za-z_][A-Za-z0-9_]*$ ]] ;
	then
		read -p "InValid Input ... `echo $'\n> 'Press any key to Refresh ... `" ; exit 	
	fi

if [[ -f "$location" ]]; then
	#cat "$location" ;
	echo "----------------------------------------------------------------------------------------------------------------------------------------"
	head -1 "$location" | awk 'BEGIN{ RS = ","; FS = "+" } {print $1 }' | awk 'BEGIN{ORS="\t"} {print $0 "|"}'
	echo $'\n'	
	echo '----------------------------------------------------------------------------------------------------------------------------------------'
	sed '1d' "$location" | awk -F, 'BEGIN{OFS=" \t"} {for(n = 1; n <= NF; n++){ $n=$n }}1'
	echo $'\n'
	read -p "> Press any key to Refresh ... "
else
	read -p "Not Existed TB : $dispt ... `echo $'\n> '`Press any key to Refresh ... "
fi
