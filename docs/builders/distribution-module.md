---
title: Distribution Module
description: Technical reference for ZIGChain Distribution Module including parameters for reward distribution, community tax, proposer rewards, and withdrawal address configuration.
keywords:
  [
    ZIGChain distribution module,
    ZIGChain modules,
    Cosmos SDK modules,
    staking rewards ZIGChain,
    delegation rewards ZIGChain,
    ZIGChain validator rewards,
    ZIGChain delegator rewards,
    ZIG staking rewards,
    ZIGChain staking yield,
  ]
sidebar_position: 3
---

import Tabs from '@theme/Tabs';
import TabItem from '@theme/TabItem';

# Distribution Module

The ZIGChain Distribution Module is based on the [Cosmos SDK - Distribution Module](https://docs.cosmos.network/main/build/modules/distribution) but with the specific parameters that you can find in the [Distribution Parameters](#distribution-parameters) section.

## Distribution Parameters

The Distribution module in ZIGChain is configured with the following parameters:

> ⚠️ _These values may change via governance proposals. Always confirm using the CLI or API._

| Parameters            | Testnet Values            | Mainnet Values            |
| :-------------------- | :------------------------ | :------------------------ |
| base_proposer_reward  | 0.000000000000000000 (0%) | 0.000000000000000000 (0%) |
| bonus_proposer_reward | 0.000000000000000000 (0%) | 0.000000000000000000 (0%) |
| community_tax         | 0.02 (2%)                 | 0.02 (2%)                 |
| withdraw_addr_enabled | True                      | True                      |

## Parameters Overview

`base_proposer_reward`

**Description:** This parameter defines the fixed portion of block rewards allocated to the proposer of a block, regardless of how many precommits (votes) the block includes. It's expressed as a fraction of the total fees collected in that block.

**Default:** 0.000000000000000000

**Note:** A value of zero means no fixed proposer reward is distributed for proposing a block.

---

`bonus_proposer_reward`

**Description:** This parameter defines an additional reward given to the block proposer based on the percentage of validators that precommitted (voted) on the proposed block. It incentivizes proposers to include valid and well-formed blocks to maximize participation.

**Default:** 0.000000000000000000

**Note:** A value of zero means no additional bonus is given, even if many validators precommit to the block.

---

`community_tax`

**Description:** This parameter defines the portion of block rewards and transaction fees allocated to the blockchain's community pool. This pool is a shared fund managed through governance and used to support ecosystem development and community-driven initiatives.

**Example:** If block rewards total 1,000 ZIG, 20 ZIG (2%) are allocated to the community pool, while the remaining 980 ZIG are distributed among validators and delegators.

[//]: # "_For a detailed breakdown of validator rewards, see the Validators FAQ_ [❌ ADD LINK]_._"

**Default:** 2% or 20,000,000,000,000,000 (expressed in 18 decimal format)

**Note**: The community pool is managed through governance proposals. For more information, refer to the [Governance Documentation](./governance-module.md).

---

`withdraw_addr_enabled`

**Description:** This parameter allows delegators to receive the rewards in a different address than the one used for staking.

**Default:** True

**Note:** This feature is particularly useful for users who wish to separate their staking operations from reward management.

[//]: # "To set or update the withdrawal address, refer to the Delegators Quick Sheet [❌ ADD LINK]"

---

## Distribution CLI Quick Sheet

Check distribution module parameters:
<Tabs groupId="network">
<TabItem value="Mainnet" label="Mainnet" default>

```bash
zigchaind query distribution params \
--chain-id zigchain-1 --node https://public-zigchain-rpc.numia.xyz
```

</TabItem>
<TabItem value="Testnet" label="Testnet">

```bash
zigchaind query distribution params \
--chain-id zig-test-2 --node https://public-zigchain-testnet-rpc.numia.xyz
```

</TabItem>
<TabItem value="Local" label="Local">
```bash
zigchaind query distribution params \
--chain-id zigchain-1 --node http://localhost:26657
```

</TabItem>
</Tabs>

Check community pool balance:
<Tabs groupId="network">
<TabItem value="Mainnet" label="Mainnet" default>

```bash
zigchaind query distribution community-pool \
--chain-id zigchain-1 --node https://public-zigchain-rpc.numia.xyz
```

</TabItem>
<TabItem value="Testnet" label="Testnet">

```bash
zigchaind query distribution community-pool \
--chain-id zig-test-2 --node https://public-zigchain-testnet-rpc.numia.xyz
```

</TabItem>
<TabItem value="Local" label="Local">

```bash
zigchaind query distribution community-pool \
--chain-id zigchain-1 --node http://localhost:26657
```

</TabItem>
</Tabs>

Fund the community pool:
<Tabs groupId="network">
<TabItem value="Mainnet" label="Mainnet" default>

```bash
zigchaind tx distribution fund-community-pool 100uzig \
--from $ACCOUNT --gas-adjustment 1.5 \
--gas auto --gas-prices="0.0025uzig" \
--chain-id zigchain-1 --node https://public-zigchain-rpc.numia.xyz
```

</TabItem>
<TabItem value="Testnet" label="Testnet">

```bash
zigchaind tx distribution fund-community-pool 100uzig \
--from $ACCOUNT --gas-adjustment 1.5 \
--gas auto --gas-prices="0.0025uzig" \
--chain-id zig-test-2 --node https://public-zigchain-testnet-rpc.numia.xyz
```

</TabItem>
<TabItem value="Local" label="Local">

```bash
zigchaind tx distribution fund-community-pool 100uzig \
--from zuser1 --gas-adjustment 1.5 \
--gas auto --gas-prices="0.0025uzig" \
--chain-id zigchain-1 --node http://localhost:26657
```

</TabItem>
</Tabs>

Query Validator's Commission Rewards:

<Tabs groupId="network">
<TabItem value="Mainnet" label="Mainnet" default>

```bash
zigchaind query distribution commission $VALIDATOR_ADDRESS \
--chain-id zigchain-1 --node https://public-zigchain-rpc.numia.xyz
```

</TabItem>
<TabItem value="Testnet" label="Testnet">

```bash
zigchaind query distribution commission $VALIDATOR_ADDRESS \
--chain-id zig-test-2 --node https://public-zigchain-testnet-rpc.numia.xyz
```

</TabItem>
<TabItem value="Local" label="Local">

```bash
zigchaind query distribution commission $VALIDATOR_ADDRESS \
--chain-id zigchain-1 --node http://localhost:26657
```

</TabItem>
</Tabs>

Query Validator's Outstanding Rewards:

<Tabs groupId="network">
<TabItem value="Mainnet" label="Mainnet" default>

```bash
zigchaind query distribution validator-outstanding-rewards $VALIDATOR_ADDRESS \
--chain-id zigchain-1 --node https://public-zigchain-rpc.numia.xyz
```

</TabItem>
<TabItem value="Testnet" label="Testnet">

```bash
zigchaind query distribution validator-outstanding-rewards $VALIDATOR_ADDRESS \
--chain-id zig-test-2 --node https://public-zigchain-testnet-rpc.numia.xyz
```

</TabItem>
<TabItem value="Local" label="Local">

```bash
zigchaind query distribution validator-outstanding-rewards $VALIDATOR_ADDRESS \
--chain-id zigchain-1 --node http://localhost:26657
```

</TabItem>
</Tabs>

Query Validator Slashes by Block Range:

<Tabs groupId="network">
<TabItem value="Mainnet" label="Mainnet" default>

```bash
zigchaind query distribution slashes $VALIDATOR_ADDRESS [start-height] [end-height] \
--chain-id zigchain-1 --node https://public-zigchain-rpc.numia.xyz
```

</TabItem>
<TabItem value="Testnet" label="Testnet">

```bash
zigchaind query distribution slashes $VALIDATOR_ADDRESS [start-height] [end-height] \
--chain-id zig-test-2 --node https://public-zigchain-testnet-rpc.numia.xyz
```

</TabItem>
<TabItem value="Local" label="Local">

```bash
zigchaind query distribution slashes $VALIDATOR_ADDRESS [start-height] [end-height] \
--chain-id zigchain-1 --node http://localhost:26657
```

</TabItem>
</Tabs>

Query All Rewards Earned by a Delegator:

<Tabs groupId="network">
<TabItem value="Mainnet" label="Mainnet" default>

```bash
zigchaind query distribution rewards $VALIDATOR_ADDRESS \
--chain-id zigchain-1 --node https://public-zigchain-rpc.numia.xyz
```

</TabItem>
<TabItem value="Testnet" label="Testnet">

```bash
zigchaind query distribution rewards $VALIDATOR_ADDRESS \
--chain-id zig-test-2 --node https://public-zigchain-testnet-rpc.numia.xyz
```

</TabItem>
<TabItem value="Local" label="Local">

```bash
zigchaind query distribution rewards $VALIDATOR_ADDRESS \
--chain-id zigchain-1 --node http://localhost:26657
```

</TabItem>
</Tabs>

Query Validator Distribution Info:

<Tabs groupId="network">
<TabItem value="Mainnet" label="Mainnet" default>

```bash
zigchaind query distribution validator-distribution-info $VALIDATOR_ADDRESS \
--chain-id zigchain-1 --node https://public-zigchain-rpc.numia.xyz
```

</TabItem>
<TabItem value="Testnet" label="Testnet">

```bash
zigchaind query distribution validator-distribution-info $VALIDATOR_ADDRESS \
--chain-id zig-test-2 --node https://public-zigchain-testnet-rpc.numia.xyz
```

</TabItem>
<TabItem value="Local" label="Local">

```bash
zigchaind query distribution validator-distribution-info $VALIDATOR_ADDRESS \
--chain-id zigchain-1 --node http://localhost:26657
```

</TabItem>
</Tabs>

## References

- [Cosmos SDK - Distribution Module](https://docs.cosmos.network/main/build/modules/distribution)
