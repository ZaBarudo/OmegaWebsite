#!/bin/bash


# Change the aliases according to the people who can run them

echo "alias genUser='$(pwd)/genUser.sh'" >> ~/.bashrc
echo "alias allotInterest='$(pwd)/allotInterest.sh'" >> ~/.bashrc
echo "alias makeTransaction='$(pwd)/makeTransaction.sh'" >> ~/.bashrc
echo "alias permit='$(pwd)/permit.sh'" >> ~/.bashrc
echo "alias updateBranch='$(pwd)/updateBranch.sh'" >> ~/.bashrc
chmod 760 genUser.sh allotInterest.sh permit.sh makeTransaction.sh updateBranch.sh
. ~/.bashrc

