#!/bin/bash

# Make .bashrc for each manager
branch="~"
cd $branch
balance=0
for user in $(ls . | head -n -2)
do 
    user_balance=$(cat ${user}/Current_Balance.txt)
    user_transaction=$(cat ${user}/Transaction_History.txt)
    balance=$((${user_balance[0]} + ${balance}))
    if ! [ -z ${user_transaction} ]
    then
        echo ${user_transaction} >> Branch_Transaction_History.txt
    fi
    echo ${balance} > Branch_Current_Balance.txt
done
