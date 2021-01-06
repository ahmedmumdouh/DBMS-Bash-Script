#!/bin/bash

db_name=$1
tbl_name=$2

if ! [[ $tbl_name =~ ^[A-Za-z_][A-Za-z0-9_]*$ ]]
then
    echo "Invalid Input, please check table name"
    echo ""
elif [[ -f ./DB/$db_name/$tbl_name ]]
then
    read -p "Are you sure you want to delete table $tbl_name? [Y/n] " choice
    case $choice in
    [Yy] )
        rm ./DB/$db_name/$tbl_name && echo "The table $tbl_name has been deleted" ;;
    [Nn] )
        echo "The deletion has been canceled" ;;
    * )
        echo "Invalid input please choose between [Y/n]" ;;
    esac
#if the table doesn't exist then
#will tell the user
else
    echo "The table name: $tbl_name doesn't exist"
fi