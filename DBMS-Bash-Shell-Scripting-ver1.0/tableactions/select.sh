#!/bin/bash
read -p "Enter TB(Select) Name : " seltb && location=DB/$1/$seltb && if ! [[ $seltb =~ ^[A-Za-z_][A-Za-z0-9_]*$ ]] ;
	then
		read -p "InValid Input ... `echo $'\n> 'Press any key to Refresh ... `" ; exit 	
	fi
if [[ -f $location ]]; then
	select choice in "Select Row" "Select Column" "Select Cell"; do
		case $choice in
			"Select Row" )	
				read -p "Enter Primary Key Value (Name: $(head -1 "$location" | cut -d',' -f1 |cut -d'+' -f1) ,Type: $(head -1 "$location" | cut -d',' -f1 |cut -d'+' -f2) ,Size: $(head -1 "$location" | cut -d',' -f1 |cut -d'+' -f3)) : " pk_val
				linenum=''
				linenum=$(cut -d ',' -f1 "$location" | awk '{if(NR != 1) print $0}' | grep -x -n -e "$pk_val" | cut -d':' -f1)
				
				if [[ "$pk_val" == '' ]]; then
					echo "InValid-NULL-Entry ... "
				elif [[ "$linenum" = '' ]]; then
					echo "Not-Accepted PK-($pk_val) ... "
				else
					let linenum=$linenum+1
	echo "----------------------------------------------------------------------------------------------------------------------------------------"
	head -1 "$location" | awk 'BEGIN{ RS = ","; FS = "+" } {print $1 }' | awk 'BEGIN{ORS="\t"} {print $0 "|"}'
	echo $'\n'	
	echo '----------------------------------------------------------------------------------------------------------------------------------------'
	sed -n "${linenum}p" "$location" | awk -F, 'BEGIN{OFS=" \t"} {for(n = 1; n <= NF; n++){ $n=$n }}1'| awk -F, 'BEGIN{OFS=" \t"} {for(n = 1; n <= NF; n++){ $n=$n }}1'
	echo '----------------------------------------------------------------------------------------------------------------------------------------'	
	echo $'\n'
				fi
				read -p "> Press any key to Refresh ... " ; exit
				;;

			"Select Column" )
				
				echo " > Select one of Column-Name : "
				fields=$(head -1 $location | awk 'BEGIN{ RS = ","; FS = "+" } {print $1}')
				echo "| $(echo "$fields" | awk 'BEGIN{ORS=" | "} {print $0}')"
				echo "---------------------------------------------------------------------------------------------------------------"
				read -p "->  "
				if [[ "$REPLY" = '' ]]; then
					echo "InValid-NULL-Entry ... "
				elif [[ $(echo "$fields" | grep -x "$REPLY") = "" ]]; then
					echo "Not-Accepted Col-Name($REPLY) ... "
				else
		
					let fieldnum=$(echo "$fields" | grep -x -n "$REPLY" | cut -d':' -f1)
	echo "----------------------------------------------------------------------------------------------------------------------------------------"
	head -1 "$location" | awk -v fieldnum="$fieldnum" 'BEGIN{ RS = ","; FS = "+" } {if(NR == fieldnum){ print $1 } }' | awk 'BEGIN{ORS="\t"} {print $0 "|"}'
	echo $'\n'	
	echo '----------------------------------------------------------------------------------------------------------------------------------------'
	cut -d',' -f "$fieldnum" "$location" | awk '{if(NR != 1) print $0}'
	echo '----------------------------------------------------------------------------------------------------------------------------------------'	
	echo $'\n'
					
		
				fi
				read -p "> Press any key to Refresh ... " ; exit
				;;

			"Select Cell" ) 
				read -p "Enter Primary Key Value (Name: $(head -1 "$location" | cut -d',' -f1 |cut -d'+' -f1) ,Type: $(head -1 "$location" | cut -d',' -f1 |cut -d'+' -f2) ,Size: $(head -1 "$location" | cut -d',' -f1 |cut -d'+' -f3)) : " pk_val
				linenum=''
				linenum=$(cut -d ',' -f1 "$location" | awk '{if(NR != 1) print $0}' | grep -x -n -e "$pk_val" | cut -d':' -f1)
				
				if [[ "$pk_val" == '' ]]; then
					echo "InValid-NULL-Entry ... "
				elif [[ "$linenum" = '' ]]; then
					echo "Not-Accepted PK-($pk_val) ... "
				else
					let linenum=$linenum+1
					echo "Selected Row-PK($pk_val) Successfully ... "
					echo " > Select one of Column-Name : "
					fields=$(head -1 $location | awk 'BEGIN{ RS = ","; FS = "+" } {print $1}')
					echo "| $(echo "$fields" | awk 'BEGIN{ORS=" | "} {print $0}')"
				echo "---------------------------------------------------------------------------------------------------------------"
					read -p "->  "
					if [[ "$REPLY" = '' ]]; then
						echo "InValid-NULL-Entry ... "
					elif [[ $(echo "$fields" | grep -x "$REPLY") = "" ]]; then
						echo "Not-Accepted Col-Name($REPLY) ... "
					else
						let fieldnum=$(echo "$fields" | grep -x -n "$REPLY" | cut -d':' -f1)
						echo "Cell of Row-PK($pk_val) and Col-Field($REPLY) is | $(sed -n "${linenum}p" "$location"  | cut -d',' -f "$fieldnum") |"
						
					fi
				fi
				read -p "> Press any key to Refresh ... " ; exit	
				;;

			* ) read -p "InValid Input ... `echo $'\n> 'Press any key to Refresh ... `" ; exit 
				;;
		esac

	done

else
	read -p "Not Existed TB : $seltb ... `echo $'\n> '`Press any key to Refresh ... "
fi

#########################################################################3

