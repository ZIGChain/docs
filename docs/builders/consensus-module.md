---
title: Consensus Module
description: Technical documentation for ZIGChain Consensus Module including block parameters, evidence parameters, validator settings, and consensus configuration for testnet and mainnet.
keywords:
  [
    ZIGChain consensus module,
    ZIGChain modules,
    Cosmos SDK modules,
    ZIGChain Tendermint BFT,
    ZIGChain consensus reliability,
    ZIGChain validator configuration,
    ZIGChain block parameters,
    ZIGChain network security,
  ]
sidebar_position: 3
---

import Tabs from '@theme/Tabs';
import TabItem from '@theme/TabItem';

# Consensus Module

The ZIGChain Consensus Module is based on the [Cosmos SDK - Consensus Module](https://docs.cosmos.network/sdk/v0.53/learn/intro/blockchain-basics#consensus) but with the specific parameters that you can find in the [Consensus Parameters](#consensus-parameters) section.

## Consensus Parameters

The Consensus module in ZIGChain is configured with the following parameters:

> ⚠️ _These values may change via governance proposals. Always confirm using the CLI or API._

| Parameters                  | Testnet Value    | Mainnet Value      |
| :-------------------------- | :--------------- | :----------------- |
| abci                        |                  |                    |
| block.max_bytes             | 5,000,000        | 5,000,000          |
| block.max_gas               | 100,000,000      | 100,000,000        |
| evidence.max_age_duration   | 48h0m0s (2 days) | 504h0m0s (21 days) |
| evidence.max_age_num_blocks | 100,000          | 604,800            |
| evidence.max_bytes          | 1,048,576        | 1,048,576          |
| validator.pub_key_types     | ed25519          | ed25519            |
| version                     |                  |                    |

## Parameters Overview

`abci`

**Description:** Specifies the Application Blockchain Interface (ABCI) configuration, which handles communication between the blockchain's application and consensus layers.

**Default:** \{\}

---

`block.max_bytes`

**Description:** Maximum block size in bytes. This defines how much data (transactions, evidence, etc.) can be included in a single block.

**Default:** 5,000,000

**Note:** Increasing this value allows more transactions per block but can slow down block propagation and potentially impact consensus efficiency.

---

`block.max_gas`

**Description:** Maximum gas allowed per block.

**Example:** If the max_gas is 200,000 and the average transaction consumes 1,000 gas, a block can include up to 200 transactions.

**Default:** 100,000,000

**Note:** Setting a lower gas limit can prevent resource overload but might reduce throughput during high activity.

---

`evidence.max_age_duration`

**Description:** Maximum age of evidence duration in time. Should correspond with the unbonding period or similar to avoid [Nothing-At-Stake attacks](https://ethereum.org/en/developers/docs/consensus-mechanisms/pos/faqs/#what-is-nothing-at-stake-problem).

**Default:** 504h

---

`evidence.max_age_num_blocks`

**Description:** Maximum age of evidence in blocks. Calculated as MaxAgeDuration / \{average block time\}.

**Default:** 604,800

---

`evidence.max_bytes`

**Description:** Maximum number of evidence committed in a single block.

**Default:** 1,048,576

---

`validator.pub_key_types`

**Description:** Defines the cryptographic key types allowed for validators' public keys.

**Default:** ed25519

---

`version`

**Description:** Indicates the version of the consensus module or protocol in use.

**Default:** \{\}

---

## Consensus CLI Quick Sheet

Get the consensus parameters:
<Tabs groupId="network">
<TabItem value="Mainnet" label="Mainnet" default>

```
zigchaind query consensus params \
--chain-id zigchain-1 --node https://public-zigchain-rpc.numia.xyz
```

</TabItem>
<TabItem value="Testnet" label="Testnet">

```
zigchaind query consensus params \
--chain-id zig-test-2 --node https://public-zigchain-testnet-rpc.numia.xyz
```

</TabItem>
<TabItem value="Local" label="Local">
```
zigchaind query consensus params \
--chain-id zigchain-1 --node http://localhost:26657
```

</TabItem>
</Tabs>

## References

- [Cosmos SDK - Consensus Module](https://docs.cosmos.network/sdk/v0.53/learn/intro/blockchain-basics#consensus)

- [Tendermint - Genesis](https://docs.tendermint.com/master/spec/core/genesis.html#genesis)

- [CometBFT - Consensus Parameters](https://docs.cometbft.com/v0.37/spec/abci/abci++_app_requirements#consensus-connection-requirements)
