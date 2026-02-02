---
title: State Sync Configuration
description: Guide to configuring state sync on ZIGChain nodes for rapid bootstrap without downloading full block history, including RPC configuration and snapshot setup.
keywords:
  [
    ZIGChain state sync,
    ZIGChain node setup,
    ZIGChain full-node sync,
    ZIGChain node bootstrap,
    ZIGChain node configuration,
    ZIGChain RPC node,
    run ZIGChain node,
    ZIGChain node setup guide,
  ]
sidebar_position: 6
---

import Tabs from '@theme/Tabs';
import TabItem from '@theme/TabItem';

# State Sync Configuration

State sync is the recommended method for bringing a fresh node to near-current height without downloading every historical block. Instead of replaying the consensus log from genesis, your node trusts a recent state proof from a well-known RPC node and downloads the state directly.

State sync is built into the Cosmos SDK and allows validators or sentry nodes to join the network rapidly by trusting a snapshot-enabled RPC endpoint from a recent block height. This dramatically reduces the time it takes to reach the tip of the chain, but it also means the node only stores the most recent state that the RPC service exposes.

Before running state sync, finish the steps in [Set Up a Node](setup-node)

:::info
For nodes that serve explorers, dApps, or other RPC clients that require the full historical transaction log, state sync is not appropriate—these workloads still need a fully synced node with the entire block history.
:::

## RPC and Seed References

Define the variables that match your target network before continuing:

<Tabs groupId="network">
  <TabItem value="Mainnet" label="Mainnet" default>

    ```bash
    SNAP_RPC="https://public-zigchain-rpc.numia.xyz:443"
    SEED_NODES="https://raw.githubusercontent.com/ZIGChain/networks/main/zigchain-1/seed-nodes.txt"
    ```

  </TabItem>
  <TabItem value="Testnet" label="Testnet">

    ```bash
    SNAP_RPC="https://public-zigchain-testnet-rpc.numia.xyz:443"
    SEED_NODES="https://raw.githubusercontent.com/ZIGChain/networks/main/zig-test-2/seed-nodes.txt"
    ```

  </TabItem>
</Tabs>

## Enable State Sync

1. **Calculate trust parameters.**

   The node must trust a block that is slightly behind the head so that the block is available from the RPC endpoint.

   ```bash
   LATEST_HEIGHT=$(curl -s $SNAP_RPC/block | jq -r .result.block.header.height)
   BLOCK_HEIGHT=$((LATEST_HEIGHT - 5000))
   TRUST_HASH=$(curl -s "$SNAP_RPC/block?height=$BLOCK_HEIGHT" | jq -r .result.block_id.hash)
   ```

2. **Update `config.toml`.**

   Enable the service and inject the RPC servers, trust height, and trust hash. The commands differ slightly per platform:

<Tabs groupId="platform">
  <TabItem value="Linux" label="Linux" default>

    ```bash
    sed -i.bak -E \
        "s|^(enable[[:space:]]*=[[:space:]]*).*$|\1true| ; \
         s|^(rpc_servers[[:space:]]*=[[:space:]]*).*$|\1\"$SNAP_RPC,$SNAP_RPC\"| ; \
         s|^(trust_height[[:space:]]*=[[:space:]]*).*$|\1$BLOCK_HEIGHT| ; \
         s|^(trust_hash[[:space:]]*=[[:space:]]*).*$|\1\"$TRUST_HASH\"|" \
        "$HOME/.zigchain/config/config.toml"
    ```

  </TabItem>
  <TabItem value="Mac ARM" label="Mac ARM">

    ```bash
    sed -i '' -E \
        "s|^(enable[[:space:]]*=[[:space:]]*).*$|\1true| ; \
         s|^(rpc_servers[[:space:]]*=[[:space:]]*).*$|\1\"$SNAP_RPC,$SNAP_RPC\"| ; \
         s|^(trust_height[[:space:]]*=[[:space:]]*).*$|\1$BLOCK_HEIGHT| ; \
         s|^(trust_hash[[:space:]]*=[[:space:]]*).*$|\1\"$TRUST_HASH\"|" \
        "$HOME/.zigchain/config/config.toml"
    ```

  </TabItem>
  <TabItem value="Mac AMD" label="Mac AMD">

    ```bash
    sed -i '' -E \
        "s|^(enable[[:space:]]*=[[:space:]]*).*$|\1true| ; \
         s|^(rpc_servers[[:space:]]*=[[:space:]]*).*$|\1\"$SNAP_RPC,$SNAP_RPC\"| ; \
         s|^(trust_height[[:space:]]*=[[:space:]]*).*$|\1$BLOCK_HEIGHT| ; \
         s|^(trust_hash[[:space:]]*=[[:space:]]*).*$|\1\"$TRUST_HASH\"|" \
        "$HOME/.zigchain/config/config.toml"
    ```

  </TabItem>
</Tabs>

3. **Refresh the seed list.**

   Download the current seed nodes and write them into `config.toml`.

   ```bash
   SEED_FILE="$HOME/.zigchain/config/seeds.txt"
   wget "$SEED_NODES" -O "$SEED_FILE"
   SEEDS=$(paste -sd, "$SEED_FILE")
   sed -i.bak -E "s|^(persistent_peers[[:space:]]*=[[:space:]]*).*|\1\"$SEEDS\"|" "$HOME/.zigchain/config/config.toml"
   ```

4. **Restart the node.**

   Once the configuration is updated, restart `zigchaind`. Use your service manager (`systemctl`, `launchctl`, etc.) or run `zigchaind start` in the foreground. The log should show state sync progress (e.g., `service state-sync` logs).

## Verify Synchronization

Confirm that the node is no longer catching up and that state sync completed:

```bash
curl -s localhost:26657/status | jq '.result.sync_info'
```

Look for `catching_up: false` and ensure the `latest_block_height` increases over time without the node replaying every block.

## References

- [Set Up a Node](setup-node)
