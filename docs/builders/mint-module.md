---
title: Mint Module
description: Technical documentation for ZIGChain Mint Module including inflation parameters, token issuance, blocks per year, goal bonded ratio, and inflation rate calculations.
keywords:
  [
    ZIGChain minting module,
    ZIGChain modules,
    Cosmos SDK modules,
    ZIG token distribution,
    ZIGChain tokenomics,
    ZIGChain tokenomics & utilities,
    ZIG token issuance,
    ZIGChain monetary policy,
  ]
sidebar_position: 3
---

import Tabs from '@theme/Tabs';
import TabItem from '@theme/TabItem';

# Mint Module

The ZIGChain Mint Module is based on the [Cosmos SDK - Mint Module](https://docs.cosmos.network/main/build/modules/mint) but with the specific parameters that you can find in the [Mint Parameters](#mint-parameters) section.

## Mint Parameters

The Mint module in ZIGChain has set up the following parameters:

> ⚠️ _These values may change via governance proposals. Always confirm using the CLI or API._

| Parameters            | Testnet Value | Mainnet Value |
| :-------------------- | :------------ | :------------ |
| blocks_per_year       | 12,614,400    | 10,512,000    |
| goal_bonded           | 0.15 (15%)    | 0.15 (15%)    |
| inflation_max         | 0.02 (2%)     | 0.02 (2%)     |
| inflation_min         | 0.009 (0.9%)  | 0.01 (1%)     |
| inflation_rate_change | 0.02 (2%)     | 0.01 (1%)     |
| mint_denom            | uzig          | uzig          |

## Parameters Overview

`blocks_per_year`

**Description:** Number of blocks estimated per year. As inflation is an annual parameter, the `blocks_per_year` helps to calculate the inflation per block.

**Default:** 10,512,000 (one block every 3 seconds approximately)

---

`goal_bonded`

**Description:** Rate of bonded tokens that will be the goal.

- If the total bonded ZIG tokens are **below** `goal_bonded`, inflation will **increase** to incentivize staking.
- Conversely, if the total bonded ZIG tokens are **above** `goal_bonded`, inflation will **decrease** to reduce incentives.

**Default:** 15% or 150,000,000,000,000,000 (expressed in 18 decimal format)

`inflation_max`

**Description:** Specifies the maximum inflation rate that can be reached.

**Default:** 2% or 20,000,000,000,000,000 (expressed in 18 decimal format)

---

`inflation_min`

**Description:** Specifies the minimum allowable inflation rate.

**Default:** 1% or 10,000,000,000,000,000 (expressed in 18 decimal format)

---

`inflation_rate_change`

**Description:** The maximum change in the inflation rate that can occur annually

**Default:** 1% or 10,000,000,000,000,000 (expressed in 18 decimal format)

---

`mint_denom`

**Description:** The denomination (token name) of the currency that is minted as rewards.

**Default:** uzig

---

## Mint CLI Quick Sheet

Get the current minting parameters:
<Tabs groupId="network">
<TabItem value="Mainnet" label="Mainnet" default>

```bash
zigchaind query mint params \
--chain-id zigchain-1 --node https://public-zigchain-rpc.numia.xyz
```

</TabItem>
<TabItem value="Testnet" label="Testnet">

```bash
zigchaind query mint params \
--chain-id zig-test-2 --node https://public-zigchain-testnet-rpc.numia.xyz
```

</TabItem>
<TabItem value="Local" label="Local">

```bash
zigchaind query mint params \
--chain-id zigchain-1 --node http://localhost:26657
```

</TabItem>
</Tabs>

Get the current inflation:
<Tabs groupId="network">
<TabItem value="Mainnet" label="Mainnet" default>

```bash
zigchaind query mint inflation \
--chain-id zigchain-1 --node https://public-zigchain-rpc.numia.xyz
```

</TabItem>
<TabItem value="Testnet" label="Testnet">

```bash
zigchaind query mint inflation \
--chain-id zig-test-2 --node https://public-zigchain-testnet-rpc.numia.xyz
```

</TabItem>
<TabItem value="Local" label="Local">

```bash
zigchaind query mint inflation \
--chain-id zigchain-1 --node http://localhost:26657
```

</TabItem>
</Tabs>

Get the current annual provisions based on the current inflation:
<Tabs groupId="network">
<TabItem value="Mainnet" label="Mainnet" default>

```bash
zigchaind query mint annual-provisions \
--chain-id zigchain-1 --node https://public-zigchain-rpc.numia.xyz
```

</TabItem>
<TabItem value="Testnet" label="Testnet">

```bash
zigchaind query mint annual-provisions \
--chain-id zig-test-2 --node https://public-zigchain-testnet-rpc.numia.xyz
```

</TabItem>
<TabItem value="Local" label="Local">

```bash
zigchaind query mint annual-provisions \
--chain-id zigchain-1 --node http://localhost:26657
```

</TabItem>
</Tabs>

## References

- [Cosmos SDK - Mint Module](https://docs.cosmos.network/main/build/modules/mint)

- [ZIG Coin](../about-zigchain/zig)
