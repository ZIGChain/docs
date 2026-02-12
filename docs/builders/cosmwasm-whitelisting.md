---
title: CosmWasm Whitelisting
description: Guide to requesting CosmWasm contract upload whitelisting on ZIGChain testnet and mainnet, including verification steps and whitelist status checks.
keywords:
  [
    CosmWasm whitelisting,
    ZIGChain CosmWasm,
    ZIGChain smart contracts,
    deploy CosmWasm contract ZIGChain,
    ZIGChain wasm module,
    ZIGChain contract verification,
    ZIGChain testnet,
    ZIGChain mainnet,
    ZIGChain contract deployment,
  ]
sidebar_position: 7
---

# CosmWasm Whitelisting

import Tabs from '@theme/Tabs';
import TabItem from '@theme/TabItem';

This guide explains how builders can request upload whitelisting for CosmWasm contracts on ZIGChain testnet and mainnet, and how to verify whitelist status once approved.

## How to Whitelist Your Address

Contract uploads are restricted to whitelisted addresses. The process differs between testnet and mainnet.

### Testnet Whitelisting

For testnet, contact ZIGChain support via Discord or Telegram and submit the details below.

- **Required**:

  - Contact address (email or Discord/Telegram handle)
  - Description of the project
  - Wallet address to whitelist (bech32 `zig1...`)
  - Network (Testnet)

- **Optional (recommended for faster review)**:

  - Repository link and license

- **Where to request**:
  - Discord: [Join ZIGChain Discord](https://discord.com/channels/486954374845956097/)
  - Telegram: [Zignaly / ZIGChain Telegram](https://t.me/ZignalyHQ)
  - See also: [Community & Support](../about-zigchain/community-support)

Once approved, your address will be added to the upload whitelist for testnet.

### Mainnet Whitelisting

For mainnet, teams should create governance proposals that the community can vote on. This ensures transparency and community involvement in the whitelisting process.

- **Process**:

  1. Create a governance proposal for address whitelisting
  2. Include project details, contract specifications, and the address to whitelist
  3. Community members vote on the proposal
  4. If approved, the address is added to the mainnet upload whitelist

- **Where to submit proposals**:
  - Follow the governance process outlined in [Governance](../users/governance)

#### Generate `proposal.json`

To make creating the governance proposal easier, you can use the whitelisting proposal generator scripts below. They will:

- Fetch the **current whitelist** and gov deposit params from chain
- Ask for your **team name**, **project description**, and **wallet address(es)** to whitelist
- Generate a `proposal.json` in your current directory
- Print the `zigchaind tx gov submit-proposal ...` command you can run next

> **Note:** These scripts use `zigchain-1` and the public RPC (`https://public-zigchain-rpc.numia.xyz`).

<Tabs groupId="os">
<TabItem value="linux" label="Linux" default>

```bash
cd /tmp/
curl -O https://raw.githubusercontent.com/ZIGChain/docs/main/scripts/generate-proposal-linux.sh
chmod +x generate-proposal-linux.sh
./generate-proposal-linux.sh
```

</TabItem>
<TabItem value="macos-amd" label="macOS AMD">

```bash
cd /tmp/
curl -O https://raw.githubusercontent.com/ZIGChain/docs/main/scripts/generate-proposal-mac.sh
chmod +x generate-proposal-mac.sh
./generate-proposal-mac.sh
```

</TabItem>
<TabItem value="macos-arm" label="macOS ARM">

```bash
cd /tmp/
curl -O https://raw.githubusercontent.com/ZIGChain/docs/main/scripts/generate-proposal-mac.sh
chmod +x generate-proposal-mac.sh
./generate-proposal-mac.sh
```

</TabItem>
</Tabs>

## Verify Whitelist

After your request is approved and you receive confirmation that your address is whitelisted, verify that your wallet address appears in the upload permissions:

<Tabs groupId="network">
<TabItem value="Mainnet" label="Mainnet" default>

```bash
zigchaind query wasm params \
--chain-id zigchain-1 \
--node https://public-zigchain-rpc.numia.xyz
```

</TabItem>
<TabItem value="Testnet" label="Testnet">

```bash
zigchaind query wasm params \
--chain-id zig-test-2 \
--node https://public-zigchain-testnet-rpc.numia.xyz
```

</TabItem>
<TabItem value="Local" label="Local">

```bash
zigchaind query wasm params \
--chain-id zigchain-1 \
--node http://localhost:26657
```

</TabItem>
</Tabs>
