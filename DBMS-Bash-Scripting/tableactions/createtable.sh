#!/bin/bash




select varuse in "Create Table" "Cancel" 
do
	case $varuse in
		"Create Table" )	
			read -p "Enter TB(Create) Name: " tbname && if ! [[ $tbname =~ ^[A-Za-z_][A-Za-z0-9_]*$ ]] ;
				then
					read -p "InValid Input ... 😱`echo $'\n> 'Press any key to Refresh ... `" ; exit 	
				fi

			if [[ -f DB/$1/$tbname ]]; then
				read -p  "Existed TB : $tbname 😱`echo $'\n> 'Press any key to Refresh ... `" ; exit 	
			else
				touch DB/$1/$tbname && location=DB/$1/$tbname ;
				while true; do
					read -p "Enter No.Cols [1-99] :  " num_col
					if [[ "$num_col" = +([1-9])*([0-9]) ]]; then
						break
					else
						echo InValid Input Try Again ... 😱
					fi
					done
					#
					for (( i = 1; i <= num_col; i++ )); do
						
						if [[ "$i" = "1" ]]; then
							while true; do
							read -p "Enter Column-(1) Primary Key Name :  " pk_name
							if  [[ $pk_name =~ ^[A-Za-z_][A-Za-z0-9_]*$ ]]; then
								echo -n "$pk_name" >> "$location"
								echo -n "+" >> "$location"
								break
							else
								echo InValid Input Try Again ... 😱
							fi
							done
						else 
							fields=$(head -1 $location | awk 'BEGIN{ RS = ","; FS = "+" } {print $1}')
							while true ; do
								read -p "Enter Column-($[i]) Name :  " pk_name
								if  [[ -n "`echo "$fields" | grep -x "$pk_name"`" ]] ; then
									echo "Column-Name-($pk_name) is Already Exist ... " && continue  
								elif  [[ $pk_name =~ ^[A-Za-z_][A-Za-z0-9_]*$ ]]; then
									echo -n "$pk_name" >> "$location"
									echo -n "+" >> "$location"
									break
								else
									echo InValid Input Try Again ... 😱
								fi
							done
						fi
					
						while true; do
							echo "Enter Column-($[i]) DataType : "
							select choice in "integer" "string"; do
								if [[ "$REPLY" = "1" || "$REPLY" = "2" ]]; then
									echo -n "$choice" >> "$location"
									echo -n "+" >> "$location"
									break
								else
									echo InValid Input Try Again ... 😱 
								fi
							done
							break
						done

						while true; do
							read -p "Enter Column-($[i]) size [1-99] : " size
					
							if [[ "$size" = +([1-9])*([0-9]) ]]; then
								echo -n "$size" >> "$location"
								if [[ i -eq $num_col ]]; then
									echo -n $'\n' >> "$location"
									read -p "TB ($tbname) created successfully ... 😀`echo $'\n> 'Press any key to Refresh ... `"
								
								else 
									echo -n "," >> "$location"
								fi
								break
							
							else
								echo InValid Input Try Again ... 😱
							fi
						done
					done

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
					
