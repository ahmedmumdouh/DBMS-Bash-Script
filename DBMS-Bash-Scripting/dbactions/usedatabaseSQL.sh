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

elif [[ -d ./DB/$1 ]]
then
    while [ true ]
    do
        # echo "Using database $1"
        # echo "To go back to databases press [B/b]"
        # echo ""
        read -p ">($1) " -ra inputLine

        # let len=${#inputLine[*]}
        # if ! [[ ${inputLine[$len-1]} =~ [\;]$ ]]
        # then
        #     echo "invalid command"
        #     continue
        # fi

        #if input is [B/b] will go back to database operations
        if [[ ${inputLine[0]} =~ ^[Bb]$ ]]
        then
            break
        #the condition is truue if the input starts with
        #create table
        elif [[ ${inputLine[0]} =~ ^create$ && ${inputLine[1]} =~ ^table$ ]]
        then
            #table name has to be the 3rd argument
            tbl_name=${inputLine[2]}
            #get the length of the input
            let length=${#inputLine[*]}
            #get the last string/word written
            let last_element=length-1

            #after table name the string has to start with "("
            #and the command has to end with ");"
            if [[ ${inputLine[3]} =~ ^[\(] && ${inputLine[last_element]} =~ ");"$ ]]
            then
                #start looping from the 4th arg => column names
                let count=3
                #parameters string which will hold the
                #column nam, datatypes and size
                parameters=""

                while [ $count -lt $length ] 
                do
                    element=${inputLine[$count]}
                    #checks true if the element consists of "," only
                    if [[ $element =~ ^[\,]$ ]]
                    then
                        #checks if the "," has something written after it
                        #if not will break from this loop and contines
                        #in the main while loop of accepting commands from the user
                        #ex: CREATE TABLE tbl1 (col1 INTEGER 2, col2 STRING 10 , );
                        let check=count+1
                        if ! [[ ${inputLine[$check]} =~ ^[A-Za-z_][A-Za-z0-9_]*$ ]]
                        then
                            echo "invalid command"
                            continue 2
                        fi
                        parameters+=""
                    #true if the word ends with a ","
                    #trims the "," at the end of the word
                    #ex: col1 INTEGER 2, 
                    elif [[ $element =~ [\,]$ ]]
                    then
                        parameters+=${element%?}
                        parameters+="+"
                    #true if the word starts with a ","
                    #trims the "," at the beignning
                    #ex: ,col2 STRING 10
                    elif [[ $element =~ ^[\,] ]]
                    then
                        parameters+=${element: 1}
                        parameters+="+"
                    #true if the word starts with "("
                    #trims the "("
                    #ex: (col1 
                    elif [[ $element =~ ^[\(] ]]
                    then
                        parameters+=${element: 1}
                        parameters+="+"
                    #true if the word ends with ");"
                    #trims the ");"
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
                #if the string of parameters starts with "+"
                #or ends with "+" will trim both
                #parameters in the end holds: col1+integer+2+col2+string+10
                if [[ ${parameters: 0:1} == "+" ]]
                then
                    parameters=${parameters: 1}
                fi
                if [[ ${parameters: -1} == "+" ]]
                then
                    parameters=${parameters%?}
                fi

                #pass the table name, the parameters string and the database name
                #to the create tables file
                bash ./tableactions/createtableSQL.sh $tbl_name $parameters $1

            else
                echo "invalid command"
                echo ""
            fi
        #true if the string starts with drop table
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
        elif [[ ${inputLine[0]} =~ ^select$ ]]
        then
            let length=${#inputLine[*]}
            #echo $length
            if [[ ${inputLine[1]} =~ ^[\*]$ && ${inputLine[2]} =~ ^from$ ]]
            then
                tbl_name=${inputLine[3]}
                if [[ $tbl_name =~ [\;]$ ]]
                then
                    tbl_name=${tbl_name%?}                    
                    bash ./tableactions/selectSQL.sh $1 $tbl_name
                elif [[ ${inputLine[$length-4]} =~ ^where$ ]]
                then
                    col_name=${inputLine[$length-3]}
                    operator=${inputLine[$length-2]}
                    col_value=${inputLine[$length-1]}
                    if ! [[ $operator == "=" ]]
                    then
                        echo "Invalid operator used"
                    elif [[ $col_value =~ [\;]$ ]]
                    then
                        col_value=${col_value%?}
                        bash ./tableactions/selectrecordSQL.sh $1 $tbl_name $col_name $col_value
                    else
                        echo "Invalid command"
                    fi
                else
                    echo "invalid command"
                fi
            elif [[ ${inputLine[$length-2]} =~ ^from$ ]]
            then
                tbl_name=${inputLine[$length-1]}
                if [[ $tbl_name =~ [\;]$ ]]
                then
                    tbl_name=${tbl_name%?}

                    let col_count=1
                    let loop=$length-2
                    col_names=""

                    while [ $col_count -lt $loop ]
                    do
                        element=${inputLine[$col_count]}

                        if [[ $element =~ ^[\,]$ ]]
                        then
                            #checks if the "," has something written after it
                            #if not will break from this loop and contines
                            #in the main while loop of accepting commands from the user
                            #ex: SELECT id, name , FROM tbl1;
                            let check=col_count+1
                            if ! [[ ${inputLine[$check]} =~ ^[A-Za-z_][A-Za-z0-9_]*$ ]]
                            then
                                echo "invalid command"
                                continue 2
                            elif [[ ${inputLine[$check]} =~ ^from$ ]]
                            then
                                echo "invalid command"
                                continue 2
                            fi
                            col_names+=""
                        elif [[ $element =~ ^[\,] ]]
                        then
                            col_names+=${element: 1}
                            col_names+="+"
                        elif [[ $element =~ [\,]$ ]]
                        then
                            let check=col_count+1
                            if [[ ${inputLine[$check]} =~ ^from$ ]]
                            then
                                echo "invalid command"
                                continue 2
                            fi
                            col_names+=${element%?}  
                            col_names+="+"                      
                        else
                            col_names+=$element
                            col_names+="+"
                        fi
                        ((col_count++))                       
                    done
                    
                    if [[ ${col_names: -1} == "+" ]]
                    then
                        col_names=${col_names%?}
                    fi
                    
                    bash ./tableactions/selectSQL.sh $1 $tbl_name $col_names
                else
                    echo "invalid command"
                fi
            else
                echo "invalid command"
            fi
        elif [[ ${inputLine[0]} =~ ^delete$ && ${inputLine[1]} =~ ^from$ && ${inputLine[3]} =~ ^where$ ]]
        then
            let length=${#inputLine[*]}
            tbl_name=${inputLine[2]}
            col_name=${inputLine[$length-3]}
            operator=${inputLine[$length-2]}
            col_value=${inputLine[$length-1]}
            if ! [[ $operator == "=" ]]
            then
                echo "Invalid operator used"
            elif [[ $col_value =~ [\;]$ ]]
            then
                col_value=${col_value%?}
                #echo "$tbl_name, $col_name, $col_value"
                bash ./tableactions/deleteSQL.sh $1 $tbl_name $col_name $col_value
            else
                echo "Invalid command"
            fi
        else
            echo "invalid command"
        fi
    done
else
    echo "Database $1 doesn't exist"
fi

shopt -u nocasematch