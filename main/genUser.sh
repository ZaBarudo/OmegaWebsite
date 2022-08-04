#!/bin/bash

mkdir OmegaBank
cd OmegaBank
echo $(pwd)

inputFile=$1
if [ -z $inputFile ]
then  # If the manager wants to add custom users, put the txt file in the files directory before passign as arg
    echo "Using User_Accounts.txt to create users..."
    inputFile="../files/User_Accounts.txt"
else
    if [ -f "../files/$inputFile" ]
    then
        echo "$inputFile is present in the Files Directory"
    else
        echo "$inputFile is not present in the Files Directory"
        exit 1
    fi
fi

for branch in Branch1 Branch2 Branch3 Branch4
do
    mkdir $branch
    useradd -d $(pwd)/$branch "${branch}MGR"
    passwd -d "${branch}MGR"  # Remove -d later

    cd ..
    setfacl -m g:${branch}MGR:r-x "updateBranch.sh" 
    echo -e "#!/bin/bash\nalias updateBranch='$(pwd)/updateBranch.sh'" >> "OmegaBank/${branch}/.bash_profile"
    . "OmegaBank/${branch}/.bash_profile"
    cd OmegaBank

    touch "${branch}/Branch_Current_Balance.txt" "${branch}/Branch_Transaction_History.txt"
    cp "../files/Daily_Interest_Rates.txt" "${branch}/Daily_Interest_Rates.txt"

done

while read -a line;  # Converting each line to array
do

    username=${line[0]}
    branch=${line[1]}
    type=${line[2]}
    age=${line[3]}
    legacy=${line[4]}

    mkdir "${branch}/${username}"  # Makes a directory for the user
    echo "500">"${branch}/${username}/Current_Balance.txt"  # Adding 500 to Current Balance
    touch "${branch}/${username}/Transaction_History.txt"  # Creating transaction history
    
    useradd -d $(pwd)/${branch}/$username "${username}"
    passwd -d "${username}"  # Remove -d later

    cd ..
    setfacl -m g:${username}:r-x "makeTransaction.sh" 
    
    echo -e "#!/bin/bash\nalias makeTransaction='$(pwd)/makeTransaction.sh'" >> "OmegaBank/${branch}/${username}/.bash_profile"
    . "OmegaBank/${branch}/${username}/.bash_profile"
    cd OmegaBank

    if [ ${type} != "-" ]
    then
        echo -e "${type}" >> "${branch}/${username}/User_Details.txt"
    fi
    if [ ${age} != "-" ]
    then
        echo -e "${age}" >> "${branch}/${username}/User_Details.txt"
    fi
    if [ ${legacy} != "-" ]
    then
        echo -e "${legacy}" >> "${branch}/${username}/User_Details.txt"
    fi
    
done <<< $(cat $inputFile)

mkdir CEO
useradd -d $(pwd) "CEO"
passwd -d "CEO"  # Remove -d later

cd ..
setfacl -m g:CEO:r-x "allotInterest.sh" 
echo -e '#!/bin/bash\nalias allotInterest="$(pwd)/allotInterest.sh"' >> "OmegaBank/CEO/.bash_profile"
. "OmegaBank/CEO/.bash_profile"