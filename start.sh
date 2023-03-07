#!/bin/bash
echo "Install Andromeda Node"
#Install ufw firewall and configure the firewall
#apt-get update
#apt-get install ufw
#ufw default deny incoming
#ufw default allow outgoing
#ufw allow 22
#ufw allow 26656
#ufw enable

echo -e "\e[1m\e[32m	Enter your Validator_Name:\e[0m"
echo "------------"
read Validator_Name

echo export Validator_Name=${Validator1_Name} >> $HOME/.bash_profile
echo export CHAIN_ID1="galileo-3" >> $HOME/.bash_profile
source ~/.bash_profile
echo "Install OK!"
#instal
#sudo apt update
#sudo apt install make pkg-config build-essential libssl-dev curl jq git chrony libleveldb-dev -y
#sudo apt-get install manpages-dev -y

# Increase the default open files limit (This is to make sure that the nodes won't crash once the #network grows larger and larger.)
#sudo su -c "echo 'fs.file-max = 65536' >> /etc/sysctl.conf"
#sudo sysctl -p

# Install go
#curl https://dl.google.com/go/go1.18.3.linux-amd64.tar.gz | sudo tar -C/usr/local -zxvf -
