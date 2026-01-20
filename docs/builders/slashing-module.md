---
title: Slashing Module
description: Technical reference for ZIGChain Slashing Module including slashing parameters, downtime penalties, double-sign penalties, and validator misconduct handling.
keywords:
  [
    ZIGChain slashing module,
    ZIGChain modules,
    Cosmos SDK modules,
    ZIGChain slashing risk,
    ZIGChain validator penalties,
    ZIGChain network security,
    ZIGChain validator uptime,
    ZIGChain consensus reliability,
  ]
sidebar_position: 3
---

import Tabs from '@theme/Tabs';
import TabItem from '@theme/TabItem';

# Slashing Module

The ZIGChain Slashing Module is based on the [Cosmos SDK - Slashing Module](https://docs.cosmos.network/main/build/modules/slashing) but with the specific parameters that you can find in the [Slashing Parameters](#slashing-parameters) section.

If you want to understand more about the Consensus and Slashing in ZIGChain, check out the [Validators FAQ](../nodes-and-validators/validators-faq).

If you are just looking for the most commonly used commands, see the [Validator Quick Sheet](../nodes-and-validators/validators-quick-sheet).

## Slashing Parameters

The slashing module in ZIGChain has set up the following parameters:

> ⚠️ _These values may change via governance proposals. Always confirm using the CLI or API._

| Parameters                 | Testnet Value  | Mainnet Value  |
| :------------------------- | :------------- | :------------- |
| downtime_jail_duration     | 10m0s          | 10m0s          |
| min_signed_per_window      | 0.05 (5%)      | 0.05 (5%)      |
| signed_blocks_window       | 35000          | 35000          |
| slash_fraction_double_sign | 0.05 (5%)      | 0.0005 (0.05%) |
| slash_fraction_downtime    | 0.0001 (0.01%) | 0.0001 (0.01%) |

## Parameters Overview

`downtime_jail_duration`

**Description:** Specifies the amount of time a validator must remain jailed after being slashed for downtime before they can submit an unjail request.

- If a validator fails to meet the minimum block signing requirement (`min_signed_per_window`), they are jailed for the specified duration.
- Once the jail time is served, the validator must manually submit an **unjail transaction** to re-enter the active validator set.

**Default:** 10m0s (600 seconds)

**Note:** The `downtime_jail_duration` aims to provide a sufficient penalty without overly disrupting the validator's operations. This encourages validators to maintain high availability while allowing them to quickly recover from temporary issues.

---

`min_signed_per_window`

**Description:** Defines the minimum fraction of blocks a validator is required to sign within a given window to avoid slashing.

- If a validator signs less than `min_signed_per_window` of the blocks in the current `signed_blocks_window`, they are jailed and may face slashing penalties depending on `slash_fraction_downtime`.

**Example**: For a `signed_blocks_window` of 100 blocks and `min_signed_per_window` of 0.05 (5%), if a validator signs fewer than 5 blocks, they will be penalized.

**Default:** 5% or 50,000,000,000,000,000 (expressed in 18 decimal format)

---

`signed_blocks_window`

**Description:** Defines the number of recent blocks used to assess a validator's performance. If a validator fails to meet the `min_signed_per_window` requirement within this window, they are penalized.

- This is a **rolling window**, meaning it continuously updates as new blocks are added.
- A shorter window makes slashing penalties more responsive to validator behavior, while a longer window provides more tolerance for occasional missed blocks.

**Default:** 35000 blocks

---

`slash_fraction_double_sign`

**Description:** The percentage of a validator's stake (including delegator's stake) that is slashed if they are found guilty of double-signing (i.e., signing two conflicting blocks at the same height).

**Example**: If a validator has 10,000 ZIG tokens bonded, a double-signing event would result in the loss of 5 tokens (0.05% of their stake) if `slash_fraction_double_sign` = 0.0005 (0.05%).

**Default:** 0.05% or 500,000,000,000,000 (expressed in 18 decimal format)

---

`slash_fraction_downtime`

**Description:** The fraction of a validator's stake that is slashed for failing to sign blocks due to downtime.

- Downtime is considered less severe than double-signing; hence, the penalty is lower. However, consistent downtime can still degrade network performance.

Example: A validator with 10,000 ZIG tokens bonded would lose 1 token (0.01% of their stake) if penalized for downtime.

**Default:** 0.01% or 100,000,000,000,000 (expressed in 18 decimal format)

---

## Slashing CLI Quick Sheet

Get slashing params:
<Tabs groupId="network">
<TabItem value="Mainnet" label="Mainnet" default>

```bash
zigchaind query slashing params \
--chain-id zigchain-1 --node https://public-zigchain-rpc.numia.xyz
```

</TabItem>
<TabItem value="Testnet" label="Testnet">

```bash
zigchaind query slashing params \
--chain-id zig-test-2 --node https://public-zigchain-testnet-rpc.numia.xyz
```

</TabItem>
<TabItem value="Local" label="Local">

```bash
zigchaind query slashing params \
--chain-id zigchain-1 --node http://localhost:26657
```

</TabItem>
</Tabs>

Check when your validator will be unjailed:

<Tabs groupId="network">
<TabItem value="Mainnet" label="Mainnet" default>

```bash
zigchaind query slashing signing-info \
$(zigchaind tendermint show-validator) \
--chain-id zigchain-1 --node https://public-zigchain-rpc.numia.xyz
```

</TabItem>
<TabItem value="Testnet" label="Testnet">

```bash
zigchaind query slashing signing-info \
$(zigchaind tendermint show-validator) \
--chain-id zig-test-2 --node https://public-zigchain-testnet-rpc.numia.xyz
```

</TabItem>
<TabItem value="Local" label="Local">

```bash
zigchaind query slashing signing-info \
$(zigchaind tendermint show-validator) \
--chain-id zigchain-1 --node http://localhost:26657
```

</TabItem>
</Tabs>

Unjail your validator:
<Tabs groupId="network">
<TabItem value="Mainnet" label="Mainnet" default>

```bash
zigchaind tx slashing unjail \
--gas "auto" \
--gas-prices "0.0025uzig" \
--from $ACCOUNT \
--gas-adjustment=1.5 \
--chain-id zigchain-1 --node https://public-zigchain-rpc.numia.xyz
```

</TabItem>
<TabItem value="Testnet" label="Testnet">

```bash
zigchaind tx slashing unjail \
--gas "auto" \
--gas-prices "0.0025uzig" \
--from $ACCOUNT \
--gas-adjustment=1.5 \
--chain-id zig-test-2 --node https://public-zigchain-testnet-rpc.numia.xyz
```

</TabItem>
<TabItem value="Local" label="Local">

```bash
zigchaind tx slashing unjail \
--gas "auto" \
--gas-prices "0.0025uzig" \
--from zuser1 \
--gas-adjustment 1.5 \
--chain-id zigchain-1 --node http://localhost:26657
```

</TabItem>
</Tabs>

Get your slashing info and unjail period end for all validators:
<Tabs groupId="network">
<TabItem value="Mainnet" label="Mainnet" default>

```bash
zigchaind query slashing signing-infos \
--chain-id zigchain-1 --node https://public-zigchain-rpc.numia.xyz
```

</TabItem>
<TabItem value="Testnet" label="Testnet">

```bash
zigchaind query slashing signing-infos \
--chain-id zig-test-2 --node https://public-zigchain-testnet-rpc.numia.xyz
```

</TabItem>
<TabItem value="Local" label="Local">

```bash
zigchaind query slashing signing-infos \
--chain-id zigchain-1 --node http://localhost:26657
```

</TabItem>
</Tabs>

## References

- [Cosmos SDK - Slashing Module](https://docs.cosmos.network/main/build/modules/slashing)
- [Validators FAQ](../nodes-and-validators/validators-faq)

- [Validator Quick Sheet](../nodes-and-validators/validators-quick-sheet)
