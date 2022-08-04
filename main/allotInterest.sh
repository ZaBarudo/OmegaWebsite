#!/bin/bash

# Generate a cronjob for this script
crontab -l > cron_bkp
echo "0 0 * * * ../allotInterest.sh >/dev/null 2>&1" > cron_bkp
crontab cron_bkp
rm cron_bkp

# only CEO can run this script

bank="~"
for branch in *
do 
    i=0
    declare -a category_name=() 
    declare -a category_value=()

    while read -a line 
    do
    category_name[${i}]=${line[0]}  # Get all categories in branch
    category_value[${i}]=${line[1]:0:-1}  # Get interest rates for categories in branch
    i=$((${i}+1))
    done <<< $(cat "${branch}/Daily_Interest_Rates.txt")

    echo ${category_name[@]}

    for user in $(ls "${branch}" | head -n -3)  # Go through each user
    do
        echo ${user}
        balance=$(cat ${branch}/${user}/Current_Balance.txt | head -n 1)  # Get Current balance
        for category in $(cat "${branch}/${user}/User_Details.txt")  # Go through user's categories
        do
            if ! [ -z ${category} ]
            then
                for j in {0..5}
                do
                    echo ${category_name[j]} ${category}
                    if [ ${category} == ${category_name[j]} ]
                    then
                        balance=$(echo "${balance}+${category_value[j]}" | awk -F "+" '{print ($1+$1*$2/100)}')
                        echo ${balance} > "${branch}/${user}/Current_Balance.txt"
                    fi
                done
            fi
        done
    done
done