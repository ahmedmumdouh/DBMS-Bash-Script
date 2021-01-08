#!/bin/bash

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
    rm -r ./DB/$1 && echo "The database $1 has been deleted"
#if the directory doesn't exist then
#will tell the user
else
    echo "The database name: $1 doesn't exist"
fi

