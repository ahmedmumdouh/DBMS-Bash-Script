#!/bin/bash

echo "inside create file $1"

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
    read -p "InValid Input ... `echo $'\n> 'Press any key to Refresh ... `" ; exit
#if their exists a directory with the same name
#will output that the database already exists
elif [[ -d ./DB/$1 ]]
then
    read -p  "The DB : $1 Already Exists ... `echo $'\n> '` Press Any Key to Refresh";
#if the name passes the above conditions will create
#a directory with the name passed in $1
else
    mkdir ./DB/$1
    read -p  "The DB : $1 Created Successfully in ./DB/$1 ... `echo $'\n> '` Press Any Key to Refresh";
fi

