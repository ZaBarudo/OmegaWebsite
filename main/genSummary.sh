#!/bin/bash

#branch="~"
#cd $branch

inputFile=$1
if [ -z $inputFile ]
then  # If the manager wants to add custom users, put the txt file in the files directory before passign as arg
    echo "Using Branch_Transaction_History.txt..."
    inputFile="Branch_Transaction_History.txt"
    branch_path=$(pwd)
    branch_name=(${branch_path//// })  
    summaryFile="../../files/summary_${branch_name[-1]}.txt"
else
    if [ -f "../../files/$inputFile" ]
    then
        echo "$inputFile is present in the Files Directory"
        summaryFile="../../files/summary_${inputFile}"
        inputFile="../../files/$inputFile"
    else
        echo "$inputFile is not present in the Files Directory"
        exit 1
    fi
fi
sort -o $inputFile -k 3,3 $inputFile

if [ -s $inputFile ]
then
    true
else
    echo "Branch_Transaction_History.txt has no transactions"
    exit 1
fi

touch $summaryFile

balance=0
first_user=$(ls . | head -n 1)
first_trans=$(cat ${inputFile} | head -n 2 | tail -n 1)

first_line=($first_trans)
first_date=${first_line[2]}
first_month=${first_date:5:2}
temp_month=${first_month}
expen_max=() # Each index stores the most increased money in respective month
user_max=() # Each index stores the user with most increased money in respective month
expen_min=()
user_min=()


for user in $(ls . | head -n -3)
do 
    #user_balance=$(cat ${user}/Current_Balance.txt | head -n 1)
    change=0
    temp=0

    while IFS="" read -r trans || [ -n "$trans" ]
    do
        line=($trans)
        if [ ${line[0]} == $user ]
        then
            
            
            change_money=${line[1]}
            #add_sub=${change_money:0:1}
            date=${line[2]}
            month=${date:5:2}
            if (( ${line[1]} < 0 ))
            then
                echo ${line[1]#-} >> "../../files/Expenditure${month}.txt"
            fi

            if [ $month == $temp_month ]
            then
                change=$(($change + $change_money))
            else
                # For max change
                if [ -z ${expen_max[$temp]} ]
                
                then
                    expen_max[$temp]=$change
                    user_max[$temp]=$user
                    
                else
                    if (( ${expen_max[$temp]} < ${change} ))
                    
                    then
                        expen_max[$temp]=$change
                        user_max[$temp]=$user
                        
                    fi
                fi
                # For minimum change
                if [ -z ${expen_min[$temp]} ]
                
                then
                    expen_min[$temp]=$change
                    user_min[$temp]=$user
                    
                else
                    if (( ${expen_min[$temp]} > ${change} ))
                    
                    then
                        expen_min[$temp]=$change
                        user_min[$temp]=$user
                        
                    fi
                fi
                change=$change_money
                temp=$(($temp + 1))
                
                temp_month=$month
            fi
        fi
    done < $inputFile
    if [ -z ${expen_max[$temp]} ]
    
    then
        expen_max[$temp]=$change
        user_max[$temp]=$user
    else
        if (( ${expen_max[$temp]} < ${change} ))
        
        then
            expen_max[$temp]=$change
            user_max[$temp]=$user
            
        fi
    fi
    if [ -z ${expen_min[$temp]} ]
                
        then
            expen_min[$temp]=$change
            user_min[$temp]=$user
            
        else
            if (( ${expen_min[$temp]} > ${change} ))
            
            then
                expen_min[$temp]=$change
                user_min[$temp]=$user
                
            fi
        fi
    temp_month=$first_month
    
    
done

echo "The balance which increased the most in each month: " | tee                                                                                                                                                                $summaryFile
echo "Month  Change  User" | tee -a $summaryFile
for (( c=0; c<=$temp; c++ ))
do
    echo "  $(($c + $first_month))     ${expen_max[c]}  ${user_max[c]}" | tee -a $summaryFile
done
echo "The balance which decreased the most in each month: " | tee                                                                                                                                                                $summaryFile
echo "Month  Change  User" | tee -a $summaryFile
for (( c=0; c<=$temp; c++ ))
do
    echo "  $(($c + $first_month))     ${expen_min[c]}  ${user_min[c]}" | tee -a $summaryFile
done
sudo apt install datamash &> /dev/null

for (( c=0; c<=$temp; c++ ))
do
    echo "Month  $(($c + $first_month)) " | tee -a $summaryFile
    echo "Mean           Median    Mode" | tee -a $summaryFile
    if (( $(($c + $first_month))  > 9 ))
    then
        datamash mean 1 median 1 mode 1 < "../../files/Expenditure$(($c + $first_month)).txt" | tee -a $summaryFile
        rm "../../files/Expenditure$(($c + $first_month)).txt"
    else
        datamash mean 1 median 1 mode 1 < "../../files/Expenditure0$(($c + $first_month)).txt" | tee -a $summaryFile
        rm "../../files/Expenditure0$(($c + $first_month)).txt"
    fi

done




