#!/bin/bash

# Make .bashrc for each user
#user="~"
balance=$(cat Current_Balance.txt)
balance=${balance[0]}
read -p "Withdrawal[W] or Deposit[D]: " choice
read -p "Enter Amount: " amount
if [[ ${choice} = "W" || ${choice} = "w" ]]
then
    if [ $((${balance}-${amount})) -lt 0 ]
    then
        echo "Balance less than 0 after transaction"
        exit 1
    else
        balance=$((${balance}-${amount}))
        echo "$(whoami) -${amount} $(date '+%Y-%m-%d %H:%M:%S')" >> Transaction_History.txt 
        echo -e "\nWithdrawal of ${amount} confirmed\nCurrent Balance: ${balance}"
    fi
else
    balance=$((${balance}+${amount}))
    echo "$(whoami) +${amount} $(date '+%Y-%m-%d %H:%M:%S')" >> Transaction_History.txt
    echo -e "\nDeposition of ${amount} confirmed\nCurrent Balance: ${balance}"
fi
echo ${balance} > Current_Balance.txt