---
sidebar_position: 4
---

# Set Up a Node

This guide provides step-by-step instructions for setting up a ZIGChain testnet node, including configuration, system management, examples, and the reasoning behind each action.

<div class="spacer"></div>

## Prerequisites

**Recommended Hardware Requirements**

- **Core Processor**: 8-core (4 physical core), x86_64 architecture
- **Memory:** 32 GB RAM
- **Storage:** 1 TB SSD
- **Network:** Stable internet connection

**Open Network Ports**

Ensure the following ports are open:

- `26656`
- `26657`

**Install zigchaind**

Ensure that `zigchain CLI` or `zigchaind` is installed on your system. If not, follow this [installation guide](../build/quick-start.md).

<div class="spacer"></div>

## Initialize the Node

To set up the local configuration files needed for the node to run, initialize the ZIGChain node.

This process creates essential files and directories inside `$HOME/.zigchain`.

To create the **necessary configuration files**, run:

```bash
zigchaind init <node_name> --chain-id <chain_id>
```

import Tabs from '@theme/Tabs';
import TabItem from '@theme/TabItem';

<Tabs>
  <TabItem value="Testnet" label="Testnet" default>
    ```bash
    zigchaind init mynode --chain-id zig-test-2
    ```
  </TabItem>
  <TabItem value="Local" label="Local">
    ```bash
    zigchaind init mynode --chain-id zigchain-1
    ```
  </TabItem>
</Tabs>

<div class="spacer"></div>

If you get the error: `genesis.json file already exists.`
You can remove the zigchain data `rm -rf $HOME/.zigchain` and run it again.

After initialization, the following directory structure is created:

```
~/.zigchain
├── config
│   ├── app.toml
│   ├── client.toml
│   ├── config.toml
│   ├── genesis.json
│   ├── node_key.json
│   └── priv_validator_key.json
└── data
    └── priv_validator_state.json
```

## Download the Genesis File

ZIGChain maintains a public repository containing the genesis file, seed nodes, and RPC nodes.

Download the latest [genesis file](https://github.com/ZIGChain/networks/blob/main/zig-test-2/genesis.json), with the following command:

```bash
wget https://raw.githubusercontent.com/ZIGChain/networks/refs/heads/main/zig-test-2/genesis.json -O ~/.zigchain/config/genesis.json
```

## Configure the Node

Modify `config.toml` for network connectivity.

```bash
vim ~/.zigchain/config/config.toml
```

Key configuration parameters:

| Setting     | Value                              |
| ----------- | ---------------------------------- |
| `moniker`   | Your node's name, (e.g., `mynode`) |
| `log_level` | `info`                             |
| `seeds`     | See next section                   |

You can adjust multiple settings as needed. For more details, refer to the [CometBFT Configuration](https://docs.cometbft.com/v1.0/references/config/config.toml#base-configuration).

### Set Up State Sync

To sync up your node with the network, enable the State Sync service in the `config.toml`.

<Tabs>
  <TabItem value="Linux" label="Linux" default>

    ```bash
    SNAP_RPC="https://testnet-rpc.zigchain.com:443"
    LATEST_HEIGHT=$(curl -s $SNAP_RPC/block | jq -r .result.block.header.height)
    BLOCK_HEIGHT=$((LATEST_HEIGHT - 5000))
    TRUST_HASH=$(curl -s "$SNAP_RPC/block?height=$BLOCK_HEIGHT" | jq -r .result.block_id.hash)

    sed -i.bak -E \
        "s|^(enable[[:space:]]*=[[:space:]]*).*$|\1true| ; \
         s|^(rpc_servers[[:space:]]*=[[:space:]]*).*$|\1\"$SNAP_RPC,$SNAP_RPC\"| ; \
         s|^(trust_height[[:space:]]*=[[:space:]]*).*$|\1$BLOCK_HEIGHT| ; \
         s|^(trust_hash[[:space:]]*=[[:space:]]*).*$|\1\"$TRUST_HASH\"|" \
        "$HOME/.zigchain/config/config.toml"
    ```


  </TabItem>
  <TabItem value="Mac" label="Mac">

    ```bash
    SNAP_RPC="https://testnet-rpc.zigchain.com:443"
    LATEST_HEIGHT=$(curl -s $SNAP_RPC/block | jq -r .result.block.header.height); \
    BLOCK_HEIGHT=$((LATEST_HEIGHT - 5000)); \
    TRUST_HASH=$(curl -s "$SNAP_RPC/block?height=$BLOCK_HEIGHT" | jq -r .result.block_id.hash)
    
    sed -i.bak -E "s|^(enable[[:space:]]+=[[:space:]]+).*$|\1true| ; \
    s|^(rpc_servers[[:space:]]+=[[:space:]]+).*$|\1\"$SNAP_RPC,$SNAP_RPC\"| ; \
    s|^(trust_height[[:space:]]+=[[:space:]]+).*$|\1$BLOCK_HEIGHT| ; \
    s|^(trust_hash[[:space:]]+=[[:space:]]+).*$|\1\"$TRUST_HASH\"|" "$HOME/.zigchain/config/config.toml"
    ```

  </TabItem>
</Tabs>

### Set Up Peers

To connect your node to others in the network, update persistent peers in the `config.toml`.

```toml
persistent_peers = "<peer_id>@<peer_address>:26656"
```

**Example:**

```toml
persistent_peers = "dc9725eac15e7887a4b8deb4eddfbf4cf641778f@testnet-seed0.zigchain.com:26656"
```

Get the full list of peers from [ZIGChain Networks](https://github.com/ZIGChain/networks/tree/main/zig-test-2) and add them to the configuration file directly:

<Tabs>
  <TabItem value="Linux" label="Linux" default>

    ```bash
    SEED_FILE=REPLACE-ME-WITH-SEED-FILE-PATH

    wget https://raw.githubusercontent.com/ZIGChain/networks/main/zig-test-2/seed-nodes.txt -O $SEED_FILE

    SEEDS=$(paste -sd, "$SEED_FILE")

    sed -i -E "s|^(persistent_peers[[:space:]]*=[[:space:]]*).*|\1\"$SEEDS\"|" "$HOME/.zigchain/config/config.toml"
    ```

  </TabItem>
  <TabItem value="Mac" label="Mac">

    ```bash
    SEED_FILE=REPLACE-ME-WITH-SEED-FILE-PATH

    wget https://raw.githubusercontent.com/ZIGChain/networks/main/zig-test-2/seed-nodes.txt -O $SEED_FILE

    SEEDS=$(paste -sd, "$SEED_FILE")

    sed -i '' -E "s|^(persistent_peers[[:space:]]*=[[:space:]]*).*|\1\"$SEEDS\"|" "$HOME/.zigchain/config/config.toml"
    ```

  </TabItem>
</Tabs>

<div class="spacer"></div>

## Set Up Minimum Gas Price

Modify `app.toml` to set minimum gas price to 0.0025uzig.

```sh
vim ~/.zigchain/config/app.toml
```

Find the line containing `minimum-gas-prices` and update it:

```toml
minimum-gas-prices = "0.0025uzig"
```

## Start the Node

Starting the ZIGChain node initiates synchronization with the testnet, allowing it to connect to the network and participate in consensus.

To start the node, run the following command:

```bash
zigchaind start
```

**Example Output:**

```
5:11PM INF service start impl=Node module=server msg="Starting Node service"
5:11PM INF serve module=rpc-server msg="Starting RPC HTTP server on 127.0.0.1:26657"
```

<div class="spacer"></div>

## Verify Node Status

Check if the node is running and syncing correctly:

```bash
curl -s localhost:26657/status | grep -o '"sync_info":{[^}]*}' | sed 's/"sync_info"://' | json_pp
```

**Example Output:**

```json
{
  "catching_up": false,
  "earliest_app_hash": "E3B0C44298FC1C149AFBF4C8996FB92427AE41E4649B934CA495991B7852B855",
  "earliest_block_hash": "BBAEC1030E0F1E5CC84E7AD90DBBF833092C21E5A7877ED5D0AC53333544AE86",
  "earliest_block_height": "1",
  "earliest_block_time": "2025-01-29T10:00:24.662688409Z",
  "latest_app_hash": "4C5CABFC67074A26CFEDAEFAE8C2CAEAF1FBD360868A00F2F5A844333ADA646C",
  "latest_block_hash": "4DE43846C6CD75C962B7A962DEC81D475F68F524DCA80E076497E1DBC1D51F69",
  "latest_block_height": "115789",
  "latest_block_time": "2025-02-09T16:26:42.581094257Z"
}
```

**Key fields:**

- `latest_block_height`: Shows the current block height.
- `catching_up`: Should be `false` when the node is fully synchronized.

<div class="spacer"></div>

## Setting Up System Service and Logs

Replace `ZUSER` with the username of the account running the blockchain node.

<Tabs>
  <TabItem value="Linux" label="Linux" default>

### Create Log files for zigchaind

Create log files and service file for the blockchain node.

```bash
ZUSER="zigchain"
sudo mkdir -p /var/log/zigchaind
sudo touch /var/log/zigchaind/main.log
sudo touch /var/log/zigchaind/error.log
sudo chown -R $ZUSER:$ZUSER /var/log/zigchaind
sudo touch /etc/systemd/system/zigchaind.service
```

### Create a systemd file

Create a configuration file for the blockchain node.

```bash
ZUSER="zigchain"
sudo bash -c "cat > /etc/systemd/system/zigchaind.service" << EOM
[Unit]
Description=zigchaind daemon
After=network-online.target

[Service]
User=$ZUSER
ExecStart=/home/$ZUSER/go/bin/zigchaind start --home=/home/$ZUSER/.zigchain
WorkingDirectory=/home/$ZUSER/go/bin
StandardOutput=file:/var/log/zigchaind/main.log
StandardError=file:/var/log/zigchaind/error.log
Restart=always
RestartSec=3
LimitNOFILE=4096

[Install]
WantedBy=multi-user.target
EOM
```

### Starting a daemon

Start the blockchain node as a daemon:

```bash
sudo systemctl enable zigchaind.service
sudo systemctl start zigchaind.service
```

### Other useful commands

```bash
sudo systemctl status zigchaind.service
sudo systemctl stop zigchaind.service
sudo systemctl restart zigchaind.service
sudo systemctl disable zigchaind.service
```

View the service logs:

```bash
tail -f /var/log/zigchaind/main.log
```

### Activate log rotate for the logs

Install logrotate:

```bash
sudo apt install logrotate -y
```

Set up the logrotate configuration:

```bash
LOGROTATE_CONF="/etc/logrotate.d/zigchaind"
ZUSER="zigchain"

sudo bash -c "cat > $LOGROTATE_CONF" <<EOL
/var/log/zigchaind/*.log {
  daily
  rotate 7
  compress
  missingok
  notifempty
  create 0640 $ZUSER $ZUSER
  sharedscripts
  postrotate
  systemctl restart zigchaind.service > /dev/null 2>&1 || true
  endscript
}
EOL
```

Test the logrotate configuration:

```bash
sudo logrotate -d $LOGROTATE_CONF
```

Force log rotation to ensure it works:

```bash
sudo logrotate -f $LOGROTATE_CONF
echo "Logrotate configuration for /var/log/zigchaind/ has been created and activated."
```

  </TabItem>
  <TabItem value="Mac" label="Mac">

### Create Log directories for zigchaind

Create log directories for the blockchain node.

```bash
ZUSER="zigchain"
sudo mkdir -p /usr/local/var/log/zigchaind
sudo touch /usr/local/var/log/zigchaind/main.log
sudo touch /usr/local/var/log/zigchaind/error.log
sudo chown -R ${ZUSER}:staff /usr/local/var/log/zigchaind
```

### Create a LaunchDaemon plist file

Create a Launch Daemon configuration file for the blockchain node.

```bash
ZUSER="zigchain"
sudo bash -c "cat > /Library/LaunchDaemons/com.zigchain.zigchaind.plist" << EOM
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>Label</key>
    <string>com.zigchain.zigchaind</string>
    <key>ProgramArguments</key>
    <array>
        <string>/Users/$ZUSER/go/bin/zigchaind</string>
        <string>start</string>
        <string>--home=/Users/$ZUSER/.zigchain</string>
    </array>
    <key>WorkingDirectory</key>
    <string>/Users/$ZUSER/go/bin</string>
    <key>StandardOutPath</key>
    <string>/usr/local/var/log/zigchaind/main.log</string>
    <key>StandardErrorPath</key>
    <string>/usr/local/var/log/zigchaind/error.log</string>
    <key>KeepAlive</key>
    <true/>
    <key>RunAtLoad</key>
    <true/>
    <key>UserName</key>
    <string>$ZUSER</string>
</dict>
</plist>
EOM
```

### Starting the daemon

Load and start the blockchain node as a daemon:

```bash
sudo launchctl load /Library/LaunchDaemons/com.zigchain.zigchaind.plist
sudo launchctl start com.zigchain.zigchaind
```

### Other useful commands

List all current jobs that contains "zigchain"

```bash
sudo launchctl list | grep zigchain
```

Stops the running job with the label

```bash
sudo launchctl stop com.zigchain.zigchaind
```

Disables the job

```bash
sudo launchctl unload /Library/LaunchDaemons/com.zigchain.zigchaind.plist
```

View the service logs

```bash
tail -f /usr/local/var/log/zigchaind/main.log
```

### Set up log rotation

Install newsyslog configuration for log rotation

```bash
ZUSER="ZUSER"

sudo tee -a /etc/newsyslog.conf > /dev/null <<EOL
/usr/local/var/log/zigchaind/main.log   ${ZUSER}:staff   644  7     1000  *     G
/usr/local/var/log/zigchaind/error.log  ${ZUSER}:staff   644  7     1000  *     G
EOL

```

Test the newsyslog configuration

```bash
sudo newsyslog -v
echo "Log rotation for /usr/local/var/log/zigchaind/ has been configured."
```

  </TabItem>
</Tabs>

In production environments, it is recommended to implement a monitoring system to track logs and monitor the health of the blockchain node.
