#!/bin/bash
read -p "Enter TB(Delete) Name : " dtb && location=DB/$1/$dtb && if ! [[ $dtb =~ ^[A-Za-z_][A-Za-z0-9_]*$ ]] ;
	then
		read -p "InValid Input ... `echo $'\n> 'Press any key to Refresh ... `" ; exit 	
	fi
if [[ -f $location ]]; then
	select choice in "Delete Row" "Delete Column" "Truncate Table"; do
		case $choice in
			"Delete Row" )	
				read -p "Enter Primary Key Value (Name: $(head -1 "$location" | cut -d',' -f1 |cut -d'+' -f1) ,Type: $(head -1 "$location" | cut -d',' -f1 |cut -d'+' -f2) ,Size: $(head -1 "$location" | cut -d',' -f1 |cut -d'+' -f3)) : " pk_val
				linenum=''
				linenum=$(cut -d ',' -f1 "$location" | awk '{if(NR != 1) print $0}' | grep -x -n -e "$pk_val" | cut -d':' -f1)
				
				if [[ "$pk_val" == '' ]]; then
					echo "InValid-NULL-Entry ... "
				elif [[ "$linenum" = '' ]]; then
					echo "Not-Accepted PK-($pk_val) ... "
				else
					read -p "Are you Sure You Want To del-Row-PK-($pk_val) of TB : $dtb ? [y/n]  " ch
					case $ch in
						 [Yy]* ) 
							let linenum=$linenum+1
							sed -i "${linenum}d" "$location" && echo "Row of PK-($pk_val) is Deleted Successfully ... "
							;;
						 [Nn]* ) 
							echo "Canceled ... "
							;;
						* ) 
							echo "Invalid Input ... "
							;;
					esac
					
				fi
				read -p "> Press any key to Refresh ... " ; exit
				;;

			"Delete Column" )
				
				echo " > Select one of Column-Name : "
				fields=$(head -1 $location | awk 'BEGIN{ RS = ","; FS = "+" } {if(NR != 1){print $1}}')
				echo "| $(echo "$fields" | awk 'BEGIN{ORS=" | "} {print $0}')"
				echo "---------------------------------------------------------------------------------------------------------------"
				read -p "->  "
				if [[ "$REPLY" = '' ]]; then
					echo "InValid-NULL-Entry ... "
				elif [[ $(echo "$fields" | grep -x "$REPLY") = "" ]]; then
					echo "Not-Accepted Col-Name($REPLY) ... "
				else
					read -p "Are you Sure You Want To del-Col($REPLY) of TB : $dtb ? [y/n]  " ch
						case $ch in
							 [Yy]* ) 
								let fieldnum=$(echo "$fields" | grep -x -n "$REPLY" | cut -d':' -f1)+1
								cut -d',' -f"$fieldnum" --complement "$location" >"$location".new && rm "$location" && mv "$location".new "$location" && echo "Column of Field-($REPLY) is Deleted Successfully ... "
								;;
							 [Nn]* ) 
								echo "Canceled ... "
								;;
							* ) 
								echo "Invalid Input ... "
								;;
						esac
					
				fi
				read -p "> Press any key to Refresh ... " ; exit
				;;

			"Truncate Table" ) 
				read -p "Are you Sure You Want To Truncate TB : $dtb ? [y/n]  " ch
						case $ch in
							 [Yy]* ) 
								head -1 "$location" >"$location".new && rm "$location" && mv "$location".new "$location" && echo "Table is Truncated Successfully ... " ; exit 
								;;
							 [Nn]* ) 
								echo "Canceled ... "
								;;
							* ) 
								echo "Invalid Input ... "
								;;
						esac
				read -p "> Press any key to Refresh ... " ; exit	
				;;

			* ) read -p "InValid Input ... `echo $'\n> 'Press any key to Refresh ... `" ; exit 
				;;
		esac

	done

else
	read -p "Not Existed TB : $dtb ... `echo $'\n> '`Press any key to Refresh ... "
fi

#########################################################################3

