#!/bin/bash

shopt -s nocasematch

#array that holds the sql query input from the user
declare -a inputLine

#checks if the DB directory doesn't exist 
#then will create it
if ! [[ -d ./DB ]]
then
    mkdir -p DB
fi

#if the database name doesn't start with a letter or
#underscore will output invalid input
if ! [[ $1 =~ ^[A-Za-z_][A-Za-z0-9_]*$ ]]
then   
    echo "invalid database name"

#if the directory exists will ask the user
#if they are sure they want to deletethe db
#the input has to be either yY or nN
elif [[ -d ./DB/$1 ]]
then
    while [ true ]
    do
        echo "Using database $1"
        echo "To go back to databases press [B/b]"
        echo ""
        read -p ">($1) " -ra inputLine
        if [[ ${inputLine[0]} =~ ^[Bb]$ ]]
        then
            break
        elif [[ ${inputLine[0]} =~ ^create$ && ${inputLine[1]} =~ ^table$ ]]
        then
            tbl_name=${inputLine[2]}
            let length=${#inputLine[*]}
            let last_element=length-1

            if [[ ${inputLine[3]} =~ ^[\(] && ${inputLine[last_element]} =~ ");"$ ]]
            then
                let count=3
                parameters=""

                while [ $count -lt $length ] 
                do
                    element=${inputLine[$count]}
                    if [[ $element =~ ^[\,]$ ]]
                    then
                        let check=count+1
                        if ! [[ ${inputLine[$check]} =~ ^[A-Za-z_][A-Za-z0-9_]*$ ]]
                        then
                            echo "invalid command"
                            continue 2
                        fi
                        parameters+=""
                    elif [[ $element =~ [\,]$ ]]
                    then
                        parameters+=${element%?}
                        parameters+="+"
                    elif [[ $element =~ ^[\,] ]]
                    then
                        parameters+=${element: 1}
                        parameters+="+"
                    elif [[ $element =~ ^[\(] ]]
                    then
                        parameters+=${element: 1}
                        parameters+="+"
                    elif [[ $element =~ [\)\;]$ ]]
                    then
                        element=${element%?}
                        parameters+=${element%?}
                    else
                        parameters+=$element
                        parameters+="+"
                    fi
                    ((count++))
                done
                #echo $parameters
                if [[ ${parameters: 0:1} == "+" ]]
                then
                    parameters=${parameters: 1}
                fi
                if [[ ${parameters: -1} == "+" ]]
                then
                    parameters=${parameters%?}
                fi
  
                bash ./tableactions/createtableSQL.sh $tbl_name $parameters $1

            else
                echo "invalid command"
                echo ""
            fi
        elif [[ ${inputLine[0]} =~ ^drop$ && ${inputLine[1]} =~ ^table$ ]]
        then
            tbl_name=${inputLine[2]}
            if [[ ${tbl_name: -1} == ";" ]]
            then
                tbl_name=${tbl_name%?}
                bash ./tableactions/droptableSQL.sh $1 $tbl_name
            elif [[ ${inputLine[3]} == ";" ]]
            then
                bash ./tableactions/droptableSQL.sh $1 $tbl_name
            else
                echo "invalid command"
            fi
        elif [[ ${inputLine[0]} =~ ^show$ ]]
        then
            if [[ ${inputLine[1]} =~ ^tables$ && ${inputLine[2]} = ";" ]]
            then
                bash ./tableactions/listtablesSQL.sh $1
            elif [[ ${inputLine[1]} =~ ^tables\;$ ]]
            then
                bash ./tableactions/listtablesSQL.sh $1
            else
                echo "invalid command"
            fi
        elif [[ ${inputLine[0]} =~ ^desc$ ]]
        then
            if [[ ${inputLine[2]} =~ ";" ]]
            then
                tbl_name=${inputLine[1]} 
                bash ./tableactions/disptableSQL.sh $1 $tbl_name
            elif [[ ${inputLine[1]} =~ [\;]$ ]]
            then
                tbl_name=${inputLine[1]%?}
                bash ./tableactions/disptableSQL.sh $1 $tbl_name
            else
                echo "invalid command"
                echo ""
            fi           
        else
            echo "invalid command"
        fi
    done
else
    echo "Database $1 doesn't exist"
fi

shopt -u nocasematch
