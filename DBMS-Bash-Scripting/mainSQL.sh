#!/bin/bash


#used to make regex case insensitive
shopt -s nocasematch

PS1=">"

#checks the database name whether it ends with ";"
#either like this: dbname; or dbname ;
#if either of the above returns 1
#else, there is no ";" returns 0
function check_db_name() {
    dbname=$1

    if [[ ${dbname: -1} == ";" ]]
    then
        echo ${dbname%?}
    elif [[ $2 == ";" ]]
    then
        echo 1
    else
        echo 0
    fi
}

#array that holds the sql query input from the user
declare -a inputLine

#loop that waits for the user input until they press
#q or Q
while [ true ]
do
    #the sql query is read into the array and the separator is " " space
    read -p "> " -ra inputLine
    
    #true if the query starts with: create database, case insensitive
    #input should be: create database dbname; OR create database dbname ;
    if [[ ${inputLine[0]} =~ ^create$ && ${inputLine[1]} =~ ^database$ ]]
    then
        #send the 3rd arg (database name) and 4th arg (check if it has ";")
        dbName=${inputLine[2]}
        result="$(check_db_name $dbName ${inputLine[3]})"

        #if the query is correct will call the createdb file
        if [ $result = 1 ]
        then
            bash dbactions/createdbSQL.sh $dbName
        elif [ $result = 0 ]
        then
            echo "Invalid command"
        else
            bash dbactions/createdbSQL.sh $result
        fi

    #true if the query starts with: drop database, case insensitive
    #input should be: drop database dbname; OR drop database dbname ;
    elif [[ ${inputLine[0]} =~ ^drop$ && ${inputLine[1]} =~ ^database$ ]]
    then
        dbName=${inputLine[2]}
        result="$(check_db_name $dbName ${inputLine[3]})"

        if [ $result = 1 ]
        then
            bash dbactions/dropdbSQL.sh $dbName
        elif [ $result = 0 ]
        then
            echo "Invalid command"
        else
            bash dbactions/dropdbSQL.sh $result
        fi

    #true if the query starts with: use, case insensitive
    #input should be: use dbname; OR use dbname ;
    elif [[ ${inputLine[0]} =~ ^use$ ]]
    then
        dbName=${inputLine[1]}
        result="$(check_db_name $dbName ${inputLine[2]})"

        if [ $result = 1 ]
        then
            bash dbactions/usedatabaseSQL.sh $dbName
        elif [ $result = 0 ]
        then
            echo "Invalid command"
        else
            bash dbactions/usedatabaseSQL.sh $result
        fi

    #true if the query starts with: show case insensitive
    #input should be: show databases; OR show databases ;
    elif [[ ${inputLine[0]} =~ ^show$ ]]
    then
        #true if the 2nd arg is databases and 3rd arg is ";"
        if [[ ${inputLine[1]} =~ ^databases$ && ${inputLine[2]} =~ ";" ]]
        then
            bash dbactions/listdatabasesSQL.sh
        #true if 2nd arg is databases;
        elif [[ ${inputLine[1]: -1} == ";" && ${inputLine[1]%?} =~ ^databases$ ]]
        then
            bash dbactions/listdatabasesSQL.sh
        else
            echo "Invalid command"
        fi
    #if the user inputs q or Q will break from the loop
    #and exit the program
    elif [[ ${inputLine[0]} =~ ^[qQ]$ ]]
    then
        break

    else
        echo "Invalid command"
    fi
done

shopt -u nocasematch
