#!/bin/bash

sudo apt update
sudo apt install apache2

# Uncomment below 2 lines if you are running script for first time
#sudo -- sh -c -e "echo {Your_IP_Address} omegabank.local >> /etc/hosts"
#sudo -- sh -c -e "echo {Your_IP_Address} www.omegabank.local >> /etc/hosts"
sudo a2enmod proxy
sudo a2enmod proxy_http
sudo a2enmod proxy_balancer
sudo a2enmod lbmethod_byrequests
sudo service apache2 restart
sudo cp main/omegabank.local.conf /etc/apache2/sites-available/omegabank.local.conf
sudo a2ensite omegabank.local.conf
sudo service apache2 restart


