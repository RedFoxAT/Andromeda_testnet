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
