#!/bin/bash


# -------------------------------functions section--------------------------------------
# 				$1			$2			$3
# match-data	$input		$file 		$column
function match_data {
	datatype=$(head -1 $2 | cut -d ',' -f$3 | cut -d '+' -f2)
	if [[ -z "$1"  ]]; then
		echo 0  #Accept NULL Entry
	elif [[ "$1" = -?(0) || $1 =~ [,]+ ]]; then
		echo 1 # error! "-0" or ','
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
read -p "Enter TB(Insert) Name: " insertb && if ! [[ $insertb =~ ^[A-Za-z_][A-Za-z0-9_]*$ ]] ;
	then
		read -p "InValid Input ... `echo $'\n> 'Press any key to Refresh ... `" ; exit 	
	fi

if [[ -f DB/$1/$insertb ]]; then
	location=DB/$1/$insertb ;
	

	select sel in "Insert New Record Values" "Insert New Column(s)"
	do
		case $sel in
			"Insert New Record Values" )
			typeset -i nf=`awk -F, '{if(NR==1){print NF}}' $location ;`	
			for (( i = 1; i <= $nf; i++ )); do
			if [[ "$i" = "1" ]]; then
			    while true; do
				read -p "Enter Column-(1) Primary Key Value (Name: $(head -1 "$location" | cut -d',' -f1 |cut -d'+' -f1) ,Type: $(head -1 "$location" | cut -d',' -f1 |cut -d'+' -f2) ,Size: $(head -1 "$location" | cut -d',' -f1 |cut -d'+' -f3)) : " pk_val
				dflag=$(match_data "$pk_val" "$location" 1)
				sflag=$(match_size "$pk_val" "$location" 1)
				pk_uflag=$(cut -d ',' -f1 "$location" | awk '{if(NR != 1) print $0}' | grep -x -e "$pk_val")
				if [[ -z "$pk_val" ]]; then
					echo "InValid-NULL-Entry ... "					
				elif [[ "$dflag" == 1 ]]; then 
					echo "InValid-Type-Entry ... "
				elif [[ "$sflag" == 1 ]]; then
					echo "InValid-Size-Entry ... "
				elif [[ -n "$pk_uflag" ]]; then
					echo "This PK-($pk_val) is Already Existed ... "
				else # primary key is valid
					if [[ i -eq $nf ]]; then
						echo "$pk_val" >> "$location"
						echo "This Col($[i])-Val-($pk_val) is Inserted Successfully ... "
						read -p "Data-Insertion is Successfully ... `echo $'\n> 'Press any key to Refresh ... `"
						 
					else 
						echo -n "$pk_val" >> "$location"
						echo -n ',' >> "$location"
						echo "This PK-($pk_val) is Inserted Successfully ... "
					fi
					break 
				fi
			    done
			else 
				while true ; do
					read -p "Enter Column-($[i]) Value (Name: $(head -1 "$location" | cut -d',' -f$i |cut -d'+' -f1) ,Type: $(head -1 "$location" | cut -d',' -f$i |cut -d'+' -f2) ,Size: $(head -1 "$location" | cut -d',' -f$i |cut -d'+' -f3)) : " pk_val
					dflag=$(match_data "$pk_val" "$location" "$i")
					sflag=$(match_size "$pk_val" "$location" "$i")
					if [[ "$dflag" == 1 ]]; then 
						echo "InValid-Type-Entry ... "
					elif [[ "$sflag" == 1 ]]; then
						echo "InValid-Size-Entry ... "
					else # Data is valid
						if [[ i -eq $nf ]]; then
							echo "$pk_val" >> "$location"
							echo "This Col($[i])-Val-($pk_val) is Inserted Successfully ... "
							read -p "Data-Insertion is Successfully ... `echo $'\n> 'Press any key to Refresh ... `" 
							 
						else 
							echo -n "$pk_val" >> "$location"
							echo -n ',' >> "$location"
							echo "This Col($[i])-Val-($pk_val) is Inserted Successfully ... "
						fi
						break 
					fi
			   	 done
			fi
		
		done
 				exit #end record insertion
				;;

			"Insert New Column(s)" )
				while true; do	
					read -p "Enter No.Cols [1-99] :  " num_col
					if [[ "$num_col" = +([1-9])*([0-9]) ]]; then
						break
					else
						read -p  "InValid Input Try Again ... `echo $'\n> 'Press any key to Refresh ... `" ; exit
					fi
				done
		
		
		typeset -i nf=`awk -F, '{if(NR==1){print NF}}' $location ;`
		
		for (( i = 1; i <= num_col ; i++ )); do
			fields=$(head -1 $location | awk 'BEGIN{ RS = ","; FS = "+" } {print $1}')
			let fieldnum=$nf+$i ;
			col_field='' ;
			while true ; do
				#
				read -p "Enter Column-($[fieldnum]) Name :  " col_name
				if ! [[ $col_name =~ ^[A-Za-z_][A-Za-z0-9_]*$ ]]; then
					echo "InValid-Entry ... "
				elif [[ -n "`echo "$fields" | grep -x "$col_name"`" ]]; then
					echo "Already Existed Col-Name($col_name) ... "
				else
					col_field="$col_name+" ; echo "Accepted" && break 
						
				fi	
				#
				
			done
			
		
			while true; do
				echo "Enter Column-($[fieldnum]) DataType : "
				select dtype in "integer" "string"; do
					if [[ "$REPLY" = "1" || "$REPLY" = "2" ]]; then
						col_field="$col_field$dtype+" ; echo "Accepted" && break 
					else
						echo InValid Input Try Again ... 
					fi
				done
				break
			done

			while true; do
				read -p "Enter Column-($[fieldnum]) size [1-99] : " size
		
				if [[ "$size" = +([1-9])*([0-9]) ]]; then
					col_field="$col_field$size" ; 
					if [[ i -eq $num_col ]]; then
						awk -v fn="$fieldnum" -v fname="$col_field" 'BEGIN{FS=OFS=","}{if( NR == 1 ){ $fn=fname}else{ $fn=""} }1' "$location" >"$location".new && rm "$location" && mv "$location".new "$location" && echo "Column-($fieldnum) Name-($col_name) is Inserted Successfully ... " 
						read -p "TB ($insertb) modified successfully ... `echo $'\n> 'Press any key to Refresh ... `" && exit
					
					else 
						awk -v fn="$fieldnum" -v fname="$col_field" 'BEGIN{FS=OFS=","}{if( NR == 1 ){ $fn=fname}else{ $fn=""} }1' "$location" >"$location".new && rm "$location" && mv "$location".new "$location" && echo "Column-($fieldnum) Name-($col_name) is Inserted Successfully ... " 
					fi
					break
				
				else
					echo InValid Input Try Again ... 
				fi
			done
		done
				;;
			* ) read -p "InValid Input ... `echo $'\n> 'Press any key to Refresh ... `" ; exit 
				;;
		esac

	done
	#
	
else
	read -p  "Not-Existed TB : $insertb `echo $'\n> 'Press any key to Refresh ... `" ; exit
fi

#x=`awk -F: '{if(NR==1){print $1}}' data/shreef/lollll;`
# awk -F: -v"i=$i" '{if(NR==1){print $i}}' data/shreef/lollll  && $value = +(0-9)

# insert into table
######################################################
		
		

#######################################














