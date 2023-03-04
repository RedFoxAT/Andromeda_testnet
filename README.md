<img src="https://github.com/RedFoxAT/Andromeda/blob/main/andromeda_logo.png" width="1150" alt="" />

### _MINIMUM REQUIREMENTS_
 ```OS``` _UBUNTU 20.04<br>
 ```CPU``` 4core<br>
 ```RAM``` 16GB<br>
 ```HDD``` 200GB_<br>

### _LINKS_
```WEBSITE``` - https://andromedaprotocol.io/ <br>
```TWITTER``` - https://twitter.com/AndromedaProt/ <br>
```DISCORD``` - https://discord.gg/GBd6buKYyZ <br>
```GITHUB``` - https://github.com/andromedaprotocol/ <br>
```TELEGRAM``` - https://t.me/andromedaprotocol/ <br>
## MANUAL INSTALL
### _PREPARING SERVER_
```
sudo apt update && sudo apt upgrade -y
sudo apt install curl tar wget clang pkg-config libssl-dev jq build-essential bsdmainutils git make ncdu gcc git jq chrony liblz4-tool -y
```
### _INSTALL GO_
```
ver="1.19" && \
wget "https://golang.org/dl/go$ver.linux-amd64.tar.gz" && \
sudo rm -rf /usr/local/go && \
sudo tar -C /usr/local -xzf "go$ver.linux-amd64.tar.gz" && \
rm "go$ver.linux-amd64.tar.gz" && \
echo "export PATH=$PATH:/usr/local/go/bin:$HOME/go/bin" >> $HOME/.bash_profile && \
source $HOME/.bash_profile && \
go version
```
### _LAST BUILD_
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

### _CREATE/RECOVERY WALLET_
```
andromedad keys add <walletname>
   OR
andromedad keys add <walletname> --recover
```
### _DOWNLOAD GENESIS_
```
wget -qO $HOME/.andromeda/config/genesis.json wget "https://snapshot.yeksin.net/andromeda/genesis.json"
```
### _DOWNLOAD ADDRBOOK_
```
wget -qO $HOME/.andromedad/config/addrbook.json wget "https://snapshot.yeksin.net/andromeda/addrbook.json"
```
### _ADD PEERS_
```
PEERS="06d4ab2369406136c00a839efc30ea5df9acaf11@10.128.0.44:26656,43d667323445c8f4d450d5d5352f499fa04839a8@192.168.0.237:26656,29a9c5bfb54343d25c89d7119fade8b18201c503@192.168.101.79:26656,6006190d5a3a9686bbcce26abc79c7f3f868f43a@37.252.184.230:26656"
sed -i -e "s/^seeds *=.*/seeds = \"$SEEDS\"/; s/^persistent_peers *=.*/persistent_peers = \"$PEERS\"/" $HOME/.andromedad/config/config.toml
```
### _SYNK NODE_
```
SNAP_RPC=http://andromedad.rpc.t.stavr.tech:4137
peers="247f3c2bed475978af238d97be68226c1f084180@andromedad.peer.stavr.tech:4376"
sed -i.bak -e "s/^persistent_peers *=.*/persistent_peers = \"$peers\"/" $HOME/.andromedad/config/config.toml
LATEST_HEIGHT=$(curl -s $SNAP_RPC/block | jq -r .result.block.header.height); \
BLOCK_HEIGHT=$((LATEST_HEIGHT - 100)); \
TRUST_HASH=$(curl -s "$SNAP_RPC/block?height=$BLOCK_HEIGHT" | jq -r .result.block_id.hash)

echo $LATEST_HEIGHT $BLOCK_HEIGHT $TRUST_HASH

sed -i.bak -E "s|^(enable[[:space:]]+=[[:space:]]+).*$|\1true| ; \
s|^(rpc_servers[[:space:]]+=[[:space:]]+).*$|\1\"$SNAP_RPC,$SNAP_RPC\"| ; \
s|^(trust_height[[:space:]]+=[[:space:]]+).*$|\1$BLOCK_HEIGHT| ; \
s|^(trust_hash[[:space:]]+=[[:space:]]+).*$|\1\"$TRUST_HASH\"| ; \
s|^(seeds[[:space:]]+=[[:space:]]+).*$|\1\"\"|" $HOME/.andromedad/config/config.toml
andromedad tendermint unsafe-reset-all --home $HOME/.andromedad
systemctl restart andromedad && journalctl -u andromedad -f -o cat
```
### _CHECK NODE SYNK_ (if results _FALSE_ – node is synchronized)
```
curl -s localhost:26657/status | jq .result.sync_info.catching_up
```

### _CHECK NODE LOGS_
```
journalctl -u andromedad -f -o cat
```
### _CHECK BALANCE_
```
andromedad q bank balances <wallet name>
```
### _CHANGE NODE PROPERTIES_
```
andromedad tx staking edit-validator 
—-new-moniker="Newmoniker" 
--identity="new" 
--website="new" 
--chain-id galileo-3 
--gas 350000 
--from <our wallet name> 
--details="new" -y
