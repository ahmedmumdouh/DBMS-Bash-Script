#!/bin/bash

read -p "Enter TB(Display) Name : " dispt && location=DB/$1/$dispt && if ! [[ $dispt =~ ^[A-Za-z_][A-Za-z0-9_]*$ ]] ;
	then
		read -p "InValid Input ... `echo $'\n> 'Press any key to Refresh ... `" ; exit 	
	fi

if [[ -f "$location" ]]; then
	let length=$( sed '1,2d' "$location" | wc -l | cut -f 1 )
	#let fields=$(head -1 "$location" | sed -e 's/,/ /g' | wc -w)
	let count=0
	echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
   	echo -n "+ " && head -1 "$location" | awk 'BEGIN{ RS = ","; FS = "+" } {print $1 }' | awk 'BEGIN{ORS="\t|"} {print $0 }'
   	echo $'\n'"+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
	echo "+"
	    while [ $count -lt $length ]
	    do
		echo -n "+ "
		sed -n "$((count+3))p" "$location" | awk 'BEGIN{ RS = "," } {print $1 }' | awk 'BEGIN{ORS="\t|"} {print $0 }' #sed -e 's/,/\t|/g' 
		if (( count == length-1 ))
		then
		    echo $'\n'"+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
		else
		    echo $'\n'"+----------------------------------------------------------------------------------------------------------------------------------------"
		fi
		
		((count++))
	    done
	echo $'\n'
	read -p "> Press any key to Refresh ... "
else
	read -p "Not Existed TB : $dispt ... `echo $'\n> '`Press any key to Refresh ... "
fi
