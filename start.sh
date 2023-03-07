#!/bin/bash
echo -e "\e[1m\e[35m		Установка Andromeda Node (RUS)/Alternetive\e[0m"
#Install ufw firewall and configure the firewall
apt-get update
apt-get install ufw
ufw default deny incoming
ufw default allow outgoing
ufw allow 22
ufw allow 26656
ufw enable
#Validator name
echo -e "\e[1m\e[32m	Введите наименование Валидатора (ноды):\e[0m"
echo "------------"
read Validator_Name

echo export Validator_Name=${Validator_Name} >> $HOME/.bash_profile
echo export CHAIN_ID="galileo-3" >> $HOME/.bash_profile
source ~/.bash_profile

#UPDATE
sudo apt update && sudo apt upgrade -y
sudo apt install curl tar wget clang pkg-config libssl-dev jq build-essential bsdmainutils git make ncdu gcc git jq chrony liblz4-tool -y


# Increase the default open files limit (This is to make sure that the nodes won't crash once the #network grows larger and larger.)
#sudo su -c "echo 'fs.file-max = 65536' >> /etc/sysctl.conf"
#sudo sysctl -p

# Install go
wget https://go.dev/dl/go1.20.1.linux-amd64.tar.gz
sudo tar -C /usr/local -xzf go1.20.1.linux-amd64.tar.gz

#Одной командой
cat <<EOF >> ~/.profile
export GOROOT=/usr/local/go
export GOPATH=$HOME/go
export GO111MODULE=on
export PATH=$PATH:/usr/local/go/bin:$HOME/go/bin
EOF
source ~/.profile

#Проверяем
go version

#Установка ноды
cd $HOME
git clone https://github.com/andromedaprotocol/andromedad.git
cd andromedad
git checkout galileo-3-v1.1.0-beta1
make install

#Проверяем 
andromedad version

#Инициализация ноды
andromedad init $Validator_Name --chain-id $CHAIN_ID

#Genesis

wget -qO $HOME/.andromedad/config/genesis.json "https://raw.githubusercontent.com/andromedaprotocol/testnets/galileo-3/genesis.json"
sed -i -e "s/^minimum-gas-prices *=.*/minimum-gas-prices = \"0.0001uandr\"/" $HOME/.andromedad/config/app.toml
wget -O $HOME/.andromedad/config/addrbook.json "https://raw.githubusercontent.com/obajay/nodes-Guides/main/AndromedaProtocol/addrbook.json"

#PEERS

PEERS="cd529600bb3aa20795a18c384c0edae2eb2da614@161.97.148.146:60656,dff203d0633c98eea4a228c5e913f22236043d89@23.88.69.101:16656,3f9594221efe3e9cd4d0de31f71993fc0f12bf01@65.21.245.252:26656,95e8225c5b8a21c1fecd411f37c75f5515de1891@185.197.251.203:26656,5e5186020063f7f8a3f3c6c23feca32830a18f33@65.109.174.30:56656,d30a56dd61de5b3e8d36bf40cb0a15add3915c91@195.3.223.33:37656,7ff2aaa5c49a0907e52689cc90fa416ec70e06a4@185.245.182.152:30656,704e605f9bd65912d8c65a58f955601c31188548@65.21.203.204:19656,433cc64756cb7f00b5fb4b26de97dc0db72b27ca@65.108.216.219:6656,b594f01b5b49a11b6d2e97c3b6358dc1388a1039@65.108.108.52:26656,29a9c5bfb54343d25c89d7119fade8b18201c503@209.34.206.32:26656"
sed -i 's|^persistent_peers *=.*|persistent_peers = "'$PEERS'"|' $HOME/.andromedad/config/config.toml

#service

tee /etc/systemd/system/andromedad.service > /dev/null <<EOF
[Unit]
Description=andromedad
After=network.target
[Service]
Type=simple
User=$USER
ExecStart=$(which andromedad) start
Restart=on-failure
RestartSec=10
LimitNOFILE=65535
[Install]
WantedBy=multi-user.target
EOF

#synk

sudo systemctl stop andromedad
andromedad tendermint unsafe-reset-all --home $HOME/.andromedad --keep-addr-book 

STATE_SYNC_RPC="http://161.97.148.146:60657"

LATEST_HEIGHT=$(curl -s $STATE_SYNC_RPC/block | jq -r .result.block.header.height)
SYNC_BLOCK_HEIGHT=$(($LATEST_HEIGHT - 2000))
SYNC_BLOCK_HASH=$(curl -s "$STATE_SYNC_RPC/block?height=$SYNC_BLOCK_HEIGHT" | jq -r .result.block_id.hash)

sed -i \
  -e "s|^enable *=.*|enable = true|" \
  -e "s|^rpc_servers *=.*|rpc_servers = \"$STATE_SYNC_RPC,$STATE_SYNC_RPC\"|" \
  -e "s|^trust_height *=.*|trust_height = $SYNC_BLOCK_HEIGHT|" \
  -e "s|^trust_hash *=.*|trust_hash = \"$SYNC_BLOCK_HASH\"|" \
  -e "s|^persistent_peers *=.*|persistent_peers = \"$STATE_SYNC_PEER\"|" \
  $HOME/.andromedad/config/config.toml
  
#активируем сервис и делаем reboot
sudo systemctl daemon-reload
sudo systemctl enable andromedad 
sudo systemctl restart andromedad
echo '=============== УСТАНОВКА ЗАВЕРШЕНА! ==================='
echo -e 'Для проверки логов:        \e[1m\e[33mjournalctl -u andromedad -f -o cat\e[0m'
echo -e 'Для проверки синхронизации (если FALSE - OK!):        \e[1m\e[33mcurl -s localhost:26657/status | jq .result.sync_info.catching_up\e[0m'
