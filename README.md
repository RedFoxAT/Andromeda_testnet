# Andromeda testnet<br>
<img src="https://github.com/RedFoxAT/Andromeda/blob/main/andromeda_logo.png" width="1050" alt="" />
<h2><a href=https://andromedaprotocol.io> WEB SITE </a><br>
<h2><a href=https://discord.gg/GBd6buKYyZ> DISCORD </a><br>  
<h2><a href=https://testnet-ping.wildsage.io/andromeda/staking> EXPLORER </a></h2><br>
 Minimum hardware requirements:
CPU - 4, RAM - 8Gb, HDD 200Gb<br> 
<h3> Instalation guide </h3>
<br>
Server preparation: <br>
sudo apt update && sudo apt upgrade -y<br>
sudo apt install curl tar wget clang pkg-config libssl-dev jq build-essential bsdmainutils git make ncdu gcc git jq chrony liblz4-tool -y<br><br>
Installing GO 1.19:<br>
ver="1.19" && \
wget "https://golang.org/dl/go$ver.linux-amd64.tar.gz" && \
sudo rm -rf /usr/local/go && \
sudo tar -C /usr/local -xzf "go$ver.linux-amd64.tar.gz" && \
rm "go$ver.linux-amd64.tar.gz" && \
echo "export PATH=$PATH:/usr/local/go/bin:$HOME/go/bin" >> $HOME/.bash_profile && \
source $HOME/.bash_profile && \
go version
