<img src="https://github.com/RedFoxAT/Andromeda/blob/main/andromeda_logo.png" width="1150" alt="" />

### _MINIMUM REQUIREMENTS / МИНИМАЛЬНЫЕ ТРЕБОВАНИЯ_
 ```OS``` _UBUNTU 20.04<br>
 ```CPU``` 4core<br>
 ```RAM``` 16GB<br>
 ```HDD``` 200GB_<br>

### _LINKS / ССЫЛКИ_
```WEBSITE``` - https://andromedaprotocol.io/ <br>
```TWITTER``` - https://twitter.com/AndromedaProt/ <br>
```DISCORD``` - https://discord.gg/GBd6buKYyZ <br>
```GITHUB``` - https://github.com/andromedaprotocol/ <br>
```TELEGRAM``` - https://t.me/andromedaprotocol/ <br>

## AUTO INSTALL / УСТАНОВКА СКРИПТОМ
```
wget -O install_node https://raw.githubusercontent.com/RedFoxAT/Andromeda_testnet/main/start.sh && chmod +x install_node && ./install_node
```
## MANUAL INSTALL / РУЧНАЯ УСТАНОВКА
### _PREPARING SERVER / ОБНОВЛЕНИЕ ПРОГРАММ_
```
sudo apt update && sudo apt upgrade -y
sudo apt install curl tar wget clang pkg-config libssl-dev jq build-essential bsdmainutils git make ncdu gcc git jq chrony liblz4-tool -y
```
### _INSTALL GO / УСТАНОВКА GO_
```
ver="1.20.1" && \
wget https://go.dev/dl/go1.20.1.linux-amd64.tar.gz && \
sudo rm -rf /usr/local/go && \
sudo tar -C /usr/local -xzf go1.20.1.linux-amd64.tar.gz && \
rm go1.20.1.linux-amd64.tar.gz && \
echo "export PATH=$PATH:/usr/local/go/bin:$HOME/go/bin" >> $HOME/.bash_profile && \
source $HOME/.bash_profile && \
go version
```
### _LAST BUILD / УСТАНОВКА_
```
cd $HOME
git clone https://github.com/andromedaprotocol/andromedad.git
cd andromedad
git checkout galileo-3-v1.1.0-beta1 
make install
```
```python
andromedad init <node name> --chain-id galileo-3
andromedad config chain-id galileo-3
```    
### _CREATE/RECOVERY WALLET / СОЗДАНИЕ (ВОССТАНОВЛЕНИЕ КОШЕЛЬКА)_
```
andromedad keys add <walletname>
   OR
andromedad keys add <walletname> --recover
```
### _DOWNLOAD GENESIS / ЗАГРУЗКА GENESIS_
```
curl -Ls https://raw.githubusercontent.com/andromedaprotocol/testnets/galileo-3/genesis.json > $HOME/.andromedad/config/genesis.json
```
### _DOWNLOAD ADDRBOOK / ЗАГРУЗКА АДРЕСНОЙ КНИГИ_
```
wget -qO $HOME/.andromedad/config/addrbook.json wget "https://raw.githubusercontent.com/RedFoxAT/Andromeda_testnet/main/addrbook.json"
```
### _ADD PEERS / ДОБАВЛЕНИЕ ПИРОВ_
```
PEERS="06d4ab2369406136c00a839efc30ea5df9acaf11@10.128.0.44:26656,43d667323445c8f4d450d5d5352f499fa04839a8@192.168.0.237:26656,29a9c5bfb54343d25c89d7119fade8b18201c503@192.168.101.79:26656,6006190d5a3a9686bbcce26abc79c7f3f868f43a@37.252.184.230:26656"
sed -i -e "s/^seeds *=.*/seeds = \"$SEEDS\"/; s/^persistent_peers *=.*/persistent_peers = \"$PEERS\"/" $HOME/.andromedad/config/config.toml
```
### _SYNK NODE / СИНХРОНИЗАЦИЯ НОДЫ_
```
sudo systemctl stop andromedad
andromedad tendermint unsafe-reset-all --home $HOME/.andromedad --keep-addr-book 

STATE_SYNC_RPC="http://161.97.148.146:60657"

LATEST_HEIGHT=$(curl -s $STATE_SYNC_RPC/block | jq -r .result.block.header.height)
SYNC_BLOCK_HEIGHT=$(($LATEST_HEIGHT - 1000))
SYNC_BLOCK_HASH=$(curl -s "$STATE_SYNC_RPC/block?height=$SYNC_BLOCK_HEIGHT" | jq -r .result.block_id.hash)

sed -i \
  -e "s|^enable *=.*|enable = true|" \
  -e "s|^rpc_servers *=.*|rpc_servers = \"$STATE_SYNC_RPC,$STATE_SYNC_RPC\"|" \
  -e "s|^trust_height *=.*|trust_height = $SYNC_BLOCK_HEIGHT|" \
  -e "s|^trust_hash *=.*|trust_hash = \"$SYNC_BLOCK_HASH\"|" \
  -e "s|^persistent_peers *=.*|persistent_peers = \"$STATE_SYNC_PEER\"|" \
  $HOME/.andromedad/config/config.toml
  
 #Restart node
sudo systemctl restart andromedad && sudo journalctl -u andromedad -f
```
### _CREATE VALIDATOR / СОЗДАНИЕ ВАЛИДАТОРА_
```
andromedad tx staking create-validator \
--commission-rate 0.1 \
--commission-max-rate 1 \
--commission-max-change-rate 1 \
--min-self-delegation "1" \
--amount 1000000uandr \
--pubkey $(andromedad tendermint show-validator) \
--from <wallet> \
--moniker="NEW NAME" \
--chain-id galileo-3 \
--gas 350000 \
--identity="" \
--website="" \
--details="" -y
```
### _YUOR VALOPER ADDRESS /ВАШ АДРЕС ВАЛИДАТОРА_
```
andromedad keys show wallet --bech val -a
```
## 
### _CHECK NODE SYNK / ПРОВЕРКА СИНХРОНИЗАЦИИ_ (if results _FALSE_ – node is synchronized)(если результат _FALSE_ - нода синхронизирована)
```
curl -s localhost:26657/status | jq .result.sync_info.catching_up
```
### _CHECK NODE LOGS / ПРОВЕРКА ЛОГОВ_
```
journalctl -u andromedad -f -o cat
```
### _CHECK BALANCE / ПРОВЕРКА БАЛАНСА КОШЕЛЬКА_
```
andromedad q bank balances <wallet name>
