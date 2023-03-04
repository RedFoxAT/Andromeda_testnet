<img src="https://github.com/RedFoxAT/Andromeda/blob/main/andromeda_logo.png" width="1150" alt="" />

### LINKS
```WEBSITE``` - https://andromedaprotocol.io/ <br>
```TWITTER``` - https://twitter.com/AndromedaProt/ <br>
```DISCORD``` - https://discord.gg/GBd6buKYyZ <br>
```GITHUB``` - https://github.com/andromedaprotocol/ <br>
```TELEGRAM``` - https://t.me/andromedaprotocol/ <br>

### DOWNLOAD GENESIS
```
wget -qO $HOME/.andromeda/config/genesis.json wget "https://snapshot.yeksin.net/andromeda/genesis.json"
```
### DOWNLOAD ADDRBOOK
```
wget -qO $HOME/.andromedad/config/addrbook.json wget "https://snapshot.yeksin.net/andromeda/addrbook.json"
```
### ADD PEERS
```
PEERS="06d4ab2369406136c00a839efc30ea5df9acaf11@10.128.0.44:26656,43d667323445c8f4d450d5d5352f499fa04839a8@192.168.0.237:26656,29a9c5bfb54343d25c89d7119fade8b18201c503@192.168.101.79:26656,6006190d5a3a9686bbcce26abc79c7f3f868f43a@37.252.184.230:26656"
sed -i -e "s/^seeds *=.*/seeds = \"$SEEDS\"/; s/^persistent_peers *=.*/persistent_peers = \"$PEERS\"/" $HOME/.andromedad/config/config.toml
```
