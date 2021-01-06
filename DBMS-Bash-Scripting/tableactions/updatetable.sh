#!/bin/bash
# -------------------------------functions section--------------------------------------
# 				$1			$2			$3
# match-data	$input		$file 		$column
function match_data {
	datatype=$(head -1 $2 | cut -d ',' -f$3 | cut -d '+' -f2)
	if [[ -z "$1"  ]]; then
		echo 0  #Accept NULL Entry
	elif [[ "$1" = -?(0) || $1 =~ [,]+ ]]; then
		echo 1 # error! "-0"
	elif [[ "$1" = ?(-)+([0-9])?(.)*([0-9]) ]]; then
		if [[ $datatype == integer ]]; then
			# datatype integer and the input is integer or float 
			echo 0
		else
			# datatype string and input is number accepted number as string in Real DB
			echo 0                  
		fi
	else
		if [[ $datatype == integer ]]; then
			# datatype integer and input is not
			echo 1 # error!
		else
			# datatype string and input is string
			echo 0
		fi
	fi
}
function match_size {
	datasize=$(head -1 $2 | cut -d ',' -f$3 | cut -d '+' -f3)
	if [[ "${#1}" -le $datasize ]]; then
		echo 0
	else
		echo 1 # error
	fi
}
#################################################################### Code ###############


#########################################################################3



select varuse in "Update Table" "Cancel" 
do
	case $varuse in
		"Update Table" )	
			read -p "Enter TB(Update) Name : " uptb && location=DB/$1/$uptb && if ! [[ $uptb =~ ^[A-Za-z_][A-Za-z0-9_]*$ ]] ;
				then
					read -p "InValid Input ... `echo $'\n> 'Press any key to Refresh ... `" ; exit 	
				fi

			if [[ -f "$location" ]]; then
				select cho in "Update Cell" "Update Row Values" "Cancel"; do
					case $cho in
						"Update Cell" ) 
							read -p "Enter Primary Key Value (Name: $(head -1 "$location" | cut -d',' -f1 |cut -d'+' -f1) ,Type: $(head -1 "$location" | cut -d',' -f1 |cut -d'+' -f2) ,Size: $(head -1 "$location" | cut -d',' -f1 |cut -d'+' -f3)) : " pk_val
							linenum=''
							linenum=$(cut -d ',' -f1 "$location" | awk '{if(NR != 1) print $0}' | grep -x -n -e "$pk_val" | cut -d':' -f1)
							
							if [[ "$pk_val" == '' ]]; then
								echo "InValid-NULL-Entry ... 😱 "
							elif [[ "$linenum" = '' ]]; then
								echo "Not-Accepted PK-($pk_val) ... 😱 "
							else
								let linenum=$linenum+1
								echo "Selected Row-PK($pk_val) Successfully ... ✔️ "
								echo " > Select one of Column-Name : "
								fields=$(head -1 $location | awk 'BEGIN{ RS = ","; FS = "+" } {print $1}')
								echo "| $(echo "$fields" | awk 'BEGIN{ORS=" | "} {print $0}')"
							echo "---------------------------------------------------------------------------------------------------------------"
								read -p "->  "
								if [[ "$REPLY" = '' ]]; then
									echo "InValid-NULL-Entry ... "
								elif [[ $(echo "$fields" | grep -x "$REPLY") = "" ]]; then
									echo "Not-Accepted Col-Name($REPLY) ... 😱 "
								else
									let fieldnum=$(echo "$fields" | grep -x -n "$REPLY" | cut -d':' -f1)
									echo "Update old-Value of Row-PK($pk_val) and Col-Field($REPLY) is | `sed -n "${linenum}p" "$location"  | cut -d',' -f "$fieldnum"` |"
									read -p "Enter New Value (Name: $(head -1 "$location" | cut -d',' -f"$fieldnum" |cut -d'+' -f1) ,Type: $(head -1 "$location" | cut -d',' -f"$fieldnum" |cut -d'+' -f2) ,Size: $(head -1 "$location" | cut -d',' -f"$fieldnum" |cut -d'+' -f3) ) : " new_val
									
									dflag=$(match_data "$new_val" "$location" "$fieldnum")
									sflag=$(match_size "$new_val" "$location" "$fieldnum")
									pk_uflag=$(cut -d ',' -f1 "$location" | awk '{if(NR != 1) print $0}' | grep -x -e "$new_val")
									if [[ "$dflag" == 1 ]]; then 
										echo "InValid-Type-Entry ... 😱 "
									elif [[ "$sflag" == 1 ]]; then
										echo "InValid-Size-Entry ... 😱 "
									else # Data is valid
										if [[ fieldnum -eq 1 ]]; then
											if [[ -n "$pk_uflag" ]]; then
												echo "This PK-($new_val) is Already Existed ... 😱 "
											elif [[ -z "$new_val" ]];then	
									echo "Col-PK-(`head -1 "$location" | cut -d',' -f1 |cut -d'+' -f1`) InValid-NULL-Entry ... 😱 "	
											else
					awk -v fn="$fieldnum" -v rn="$linenum" -v nv="$new_val" 'BEGIN { FS = OFS = "," } { if(NR == rn) $fn = nv } 1' "$location" > "$location".new && rm "$location" && mv "$location".new "$location" && echo "Entry PK-($new_val) Updated Successfully ... 😀 "
											fi
											 
										else 
											awk -v fn="$fieldnum" -v rn="$linenum" -v nv="$new_val" 'BEGIN { FS = OFS = "," } { if(NR == rn) $fn = nv } 1' "$location" > "$location".new && rm "$location" && mv "$location".new "$location" && echo "Entry D-($new_val) Updated Successfully ... 😀 "
										fi
										#break 
									fi						
								fi
							fi
							read -p "> Press any key to Refresh ... " ; exit	
							;;

						"Update Row Values" ) 
							read -p "Enter Primary Key Value (Name: $(head -1 "$location" | cut -d',' -f1 |cut -d'+' -f1) ,Type: $(head -1 "$location" | cut -d',' -f1 |cut -d'+' -f2) ,Size: $(head -1 "$location" | cut -d',' -f1 |cut -d'+' -f3)) : " pk_val
							linenum=''
							linenum=$(cut -d ',' -f1 "$location" | awk '{if(NR != 1) print $0}' | grep -x -n -e "$pk_val" | cut -d':' -f1)
							
							if [[ "$pk_val" == '' ]]; then
								echo "InValid-NULL-Entry ... 😱 "
							elif [[ "$linenum" = '' ]]; then
								echo "Not-Accepted PK-($pk_val) ... 😱 "
							else
								let linenum=$linenum+1
								echo "Selected Row-PK($pk_val) Successfully ... ✔️ "
								typeset -i nf=`awk -F, '{if(NR==1){print NF}}' $location ;`	
								for (( i = 1; i <= $nf; i++ )); do
									echo "Update old-Value of Row-PK($pk_val) and Col-Field($(head -1 "$location" | cut -d',' -f"$i" |cut -d'+' -f1)) is | `sed -n "${linenum}p" "$location"  | cut -d',' -f "$i"` |"
									read -p "Enter New Value (Name: $(head -1 "$location" | cut -d',' -f"$i" |cut -d'+' -f1) ,Type: $(head -1 "$location" | cut -d',' -f"$i" |cut -d'+' -f2) ,Size: $(head -1 "$location" | cut -d',' -f"$i" |cut -d'+' -f3) ) : " new_val
									
									dflag=$(match_data "$new_val" "$location" "$i")
									sflag=$(match_size "$new_val" "$location" "$i")
									pk_uflag=$(cut -d ',' -f1 "$location" | awk '{if(NR != 1) print $0}' | grep -x -e "$new_val")
									if [[ "$dflag" == 1 ]]; then 
										echo "InValid-Type-Entry ... 😱 "
									elif [[ "$sflag" == 1 ]]; then
										echo "InValid-Size-Entry ... 😱 "
									else # Data is valid
										if [[ "$i" == 1 ]]; then
											if [[ -n "$pk_uflag" ]]; then
												echo "This PK-($new_val) is Already Existed ... 😱 "
											elif [[ -z "$new_val" ]];then	
									echo "Col-PK-(`head -1 "$location" | cut -d',' -f1 |cut -d'+' -f1`) InValid-NULL-Entry ... 😱 "	
											else
					awk -v fn="$i" -v rn="$linenum" -v nv="$new_val" 'BEGIN { FS = OFS = "," } { if(NR == rn) $fn = nv } 1' "$location" > "$location".new && rm "$location" && mv "$location".new "$location" && echo "Entry PK-($new_val) Updated Successfully ... 😀 "
											fi
											 
										else 
											awk -v fn="$i" -v rn="$linenum" -v nv="$new_val" 'BEGIN { FS = OFS = "," } { if(NR == rn) $fn = nv } 1' "$location" > "$location".new && rm "$location" && mv "$location".new "$location" && echo "Entry D-($new_val) Updated Successfully ... 😀 "
										fi
									fi	
								done
								read -p "> Press any key to Refresh ... " ; exit
							fi
							;;
						"Cancel" ) read -p "Canceled ... 😉 `echo $'\n> 'Press any key to Refresh ... `" ; exit ;;
						* ) read -p "InValid Input ... 😱 `echo $'\n> 'Press any key to Refresh ... `" ; exit 
							;;
					esac

				done

			else
				read -p "Not Existed TB : $uptb ... 😱 `echo $'\n> '`Press any key to Refresh ... "
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






