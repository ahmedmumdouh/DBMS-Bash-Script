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
    echo "Invalid input"
#if their exists a directory with the same name
#will output that the database already exists
elif [[ -d ./DB/$1 ]]
then
    echo "The database: $1 already exists"
#if the name passes the above conditions will create
#a directory with the name passed in $1
else
    mkdir ./DB/$1
    echo "Database $1 was created successfully"
fi

