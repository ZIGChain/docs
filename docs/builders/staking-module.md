---
title: Staking Module
description: Complete technical reference for ZIGChain Staking Module including staking parameters, validator limits, unbonding periods, commission rates, and CLI commands.
keywords:
  [
    ZIGChain staking module,
    ZIGChain staking,
    stake ZIG token,
    delegate ZIG to validator,
    ZIGChain unbonding period,
    ZIGChain staking rewards,
    ZIGChain validator delegation,
    ZIGChain validator commission,
    ZIGChain validator,
    ZIGChain active validators,
    ZIGChain validator requirements,
    ZIGChain staking validator,
    ZIGChain delegator,
    staking delegation ZIGChain,
    ZIGChain stake ZIG tokens,
    unbond ZIGChain,
    delegation rewards ZIGChain,
    zigchaind CLI,
    ZIGChain validator parameters,
  ]
sidebar_position: 3
---

import Tabs from '@theme/Tabs';
import TabItem from '@theme/TabItem';

# Staking Module

The ZIGChain Staking Module is based on the [Cosmos SDK - Staking Module](https://docs.cosmos.network/main/build/modules/staking) but with the specific parameters that you can find in the [Staking Parameters](#staking-parameters) section.

If you want to understand more about the Consensus, Slashing and Validators Selection, please check our [Validators FAQ](../nodes-and-validators/validators-faq).

If you are looking for the quick commands, refer to the [Validator Quick Sheet](../nodes-and-validators/validators-quick-sheet).

## Staking Parameters

The Staking module in ZIGChain has set up the following parameters:

> ⚠️ _These values may change via governance proposals. Always confirm using the CLI or API._

| Parameters          | Testnet Value     | Mainnet Value      |
| :------------------ | :---------------- | :----------------- |
| bond_denom          | uzig              | uzig               |
| historical_entries  | 10,000            | 10,000             |
| max_entries         | 7                 | 7                  |
| max_validators      | 4                 | 4                  |
| min_commission_rate | 0.0 (0%)          | 0.0 (0%)           |
| unbonding_time      | 168h0m0s (7 days) | 504h0m0s (21 days) |

## Parameters Overview

`bond_denom`

**Description:** The denomination (token name) of the currency that can be staked

- Validators and delegators must bond tokens in this denomination to participate in network activities.

**Default:** uzig

---

`historical_entries`

**Description:** This means the last 10,000 validator set states are stored.

- Historical entries are used to track changes in validator sets, rewards, and slashing events over time.
- This parameter is crucial for maintaining an accurate record of past state changes, especially during redelegations and reward distributions.

**Default:** 10,000

---

`max_entries`

**Description:** The maximum number of entries allowed for both unbonding delegations and redelegations per delegator.

- This parameter limits the number of concurrent unbonding or redelegation operations a delegator can have at any given time
- Ensuring a cap on these entries helps maintain the efficiency of the staking module and reduces the risk of abuse.

**Default:** 7

---

`max_validators`

**Description:** Defines the number of validators that can be part of the active validator set.

- Only the top `max_validators` ranked by stake will participate in consensus and receive block rewards.
- This parameter affects the network's decentralization, security, and performance.

**Default:** 4

---

`min_commission_rate`

**Description:** The minimum commission rate that validators are required to charge on delegator rewards.

**Default:** 0

---

`unbonding_time`

**Description:** The period delegators must wait to unfreeze their staked tokens after initiating an unbonding request.

- During this unbonding period, delegators cannot transfer or redelegate their tokens, and they do not earn staking rewards.
- This cooldown period is crucial for maintaining network security by preventing rapid withdrawal of staked assets in response to potential network attacks.

**Default:** 504h (21 days)

## Staking CLI Quick Sheet

#### If you’re interested in running your own validator, check out our [Set up a Validator](../nodes-and-validators/setup-validator) Guide.

Fetch Staking Params:

<Tabs groupId="network">
<TabItem value="Mainnet" label="Mainnet" default>

```bash
zigchaind query staking params \
--chain-id zigchain-1 --node https://public-zigchain-rpc.numia.xyz
```

</TabItem>
<TabItem value="Testnet" label="Testnet">

```bash
zigchaind query staking params \
--chain-id zig-test-2 --node https://public-zigchain-testnet-rpc.numia.xyz
```

</TabItem>
<TabItem value="Local" label="Local">

```bash
zigchaind query staking params \
--chain-id zigchain-1 --node http://localhost:26657
```

</TabItem>
</Tabs>

Get list of validators:

<Tabs groupId="network">
<TabItem value="Mainnet" label="Mainnet" default>

```bash
zigchaind query staking validators \
--chain-id zigchain-1 --node https://public-zigchain-rpc.numia.xyz
```

</TabItem>
<TabItem value="Testnet" label="Testnet">

```bash
zigchaind query staking validators \
--chain-id zig-test-2 --node https://public-zigchain-testnet-rpc.numia.xyz
```

</TabItem>
<TabItem value="Local" label="Local">

```bash
zigchaind query staking validators \
--chain-id zigchain-1 --node http://localhost:26657
```

</TabItem>
</Tabs>

Create a file with your validator info:

```bash
PUBKEY=$(zigchaind tendermint show-validator)
bash -c "cat > /tmp/your_validator.txt" << EOM
{
    "pubkey": $PUBKEY,
    "amount": "1000000uzig",
    "moniker": "validator's name",
    "identity": "optional identity signature (ex. UPort or Keybase)",
    "website": "validator's (optional) website",
    "security": "validator's (optional) security contact email",
    "details": "validator's (optional) details",
    "commission-rate": "0.1",
    "commission-max-rate": "0.2",
    "commission-max-change-rate": "0.01",
    "min-self-delegation": "10"
}
EOM
```

Create your validator:
<Tabs groupId="network">
<TabItem value="Mainnet" label="Mainnet" default>

```bash
zigchaind tx staking create-validator /tmp/your_validator.txt \
--from $ACCOUNT \
--gas "auto" \
--gas-prices "0.0025uzig" \
--gas-adjustment 1.5 \
--chain-id zigchain-1 --node https://public-zigchain-rpc.numia.xyz \
--output json | jq -r '.txhash'
```

</TabItem>
<TabItem value="Testnet" label="Testnet">

```bash
zigchaind tx staking create-validator /tmp/your_validator.txt \
--from $ACCOUNT \
--gas "auto" \
--gas-prices "0.0025uzig" \
--gas-adjustment 1.5 \
--chain-id zig-test-2 --node https://public-zigchain-testnet-rpc.numia.xyz \
--output json | jq -r '.txhash'
```

</TabItem>
<TabItem value="Local" label="Local">

```bash
zigchaind tx staking create-validator /tmp/your_validator.txt \
--from zuser1 \
--gas "auto" \
--gas-prices "0.0025uzig" \
--gas-adjustment 1.5 \
--chain-id zigchain-1 --node http://localhost:26657 \
--output json | jq -r '.txhash'
```

</TabItem>
</Tabs>

Confirm transaction and get your validator address:
<Tabs groupId="network">
<TabItem value="Mainnet" label="Mainnet" default>

```bash
zigchaind query tx $TXHASH \
--chain-id zigchain-1 --node https://public-zigchain-rpc.numia.xyz \
| grep raw_log
VALIDATOR_OP_ADDRESS=$(zigchaind q tx $TXHASH \
--output json | jq -r '.tx.body.messages[0].validator_address')

```

</TabItem>
<TabItem value="Testnet" label="Testnet">

```bash
zigchaind query tx $TXHASH \
--chain-id zig-test-2 --node https://public-zigchain-testnet-rpc.numia.xyz \
| grep raw_log
VALIDATOR_OP_ADDRESS=$(zigchaind q tx $TXHASH \
--output json | jq -r '.tx.body.messages[0].validator_address')

```

</TabItem>
<TabItem value="Local" label="Local">

```bash
zigchaind query tx $TXHASH \
--chain-id zigchain-1 --node http://localhost:26657 \
| grep raw_log
VALIDATOR_OP_ADDRESS=$(zigchaind q tx $TXHASH \
--output json | jq -r '.tx.body.messages[0].validator_address')

```

</TabItem>
</Tabs>

Check your validator's status:
<Tabs groupId="network">
<TabItem value="Mainnet" label="Mainnet" default>

```bash
zigchaind query staking validator $VALIDATOR_OP_ADDRESS \
--chain-id zigchain-1 --node https://public-zigchain-rpc.numia.xyz \
-o json | jq -r '.validator.status'
```

</TabItem>
<TabItem value="Testnet" label="Testnet">

```bash
zigchaind query staking validator $VALIDATOR_OP_ADDRESS \
--chain-id zig-test-2 --node https://public-zigchain-testnet-rpc.numia.xyz \
-o json | jq -r '.validator.status'
```

</TabItem>
<TabItem value="Local" label="Local">

```bash
zigchaind query staking validator $VALIDATOR_OP_ADDRESS \
--chain-id zigchain-1 --node http://localhost:26657 \
-o json | jq -r '.validator.status'
```

</TabItem>
</Tabs>

Edit your validator information:
<Tabs groupId="network">
<TabItem value="Mainnet" label="Mainnet" default>

```bash
zigchaind tx staking edit-validator \
--commission-rate 0.05 \
--details "YOUR_DETAILS" \
--identity "YOUR_KEYBASE_ID" \
--min-self-delegation "100" \
--new-moniker "Your new moniker name" \
--website "YOUR_WEBSITE_URL" \
--security-contact "YOUR_EMAIL" \
--from $ACCOUNT \
--gas-adjustment 1.5 \
--gas auto \
--gas-prices="0.0025uzig" \
--chain-id zigchain-1 --node https://public-zigchain-rpc.numia.xyz
```

</TabItem>
<TabItem value="Testnet" label="Testnet">

```bash
zigchaind tx staking edit-validator \
--commission-rate 0.05 \
--details "YOUR_DETAILS" \
--identity "YOUR_KEYBASE_ID" \
--min-self-delegation "100" \
--new-moniker "Your new moniker name" \
--website "YOUR_WEBSITE_URL" \
--security-contact "YOUR_EMAIL" \
--from $ACCOUNT \
--gas-adjustment 1.5 \
--gas auto \
--gas-prices="0.0025uzig" \
--chain-id zig-test-2 --node https://public-zigchain-testnet-rpc.numia.xyz
```

</TabItem>
<TabItem value="Local" label="Local">

```bash
zigchaind tx staking edit-validator \
--commission-rate 0.05 \
--details "YOUR_DETAILS" \
--identity "YOUR_KEYBASE_ID" \
--min-self-delegation "100" \
--new-moniker "Your new moniker name" \
--website "YOUR_WEBSITE_URL" \
--security-contact "YOUR_EMAIL" \
--from zuser1 \
--gas-adjustment 1.5 \
--gas auto \
--gas-prices="0.0025uzig" \
--chain-id zigchain-1 --node http://localhost:26657
```

</TabItem>
</Tabs>

Stake/Delegate with a validator:
<Tabs groupId="network">
<TabItem value="Mainnet" label="Mainnet" default>

```bash
zigchaind tx staking delegate $VALIDATOR_ADDRESS $STAKE_AMOUNT \
--from $ACCOUNT --gas-adjustment 1.5 \
--gas auto --gas-prices="0.0025uzig" \
--chain-id zigchain-1 --node https://public-zigchain-rpc.numia.xyz
```

</TabItem>
<TabItem value="Testnet" label="Testnet">

```bash
zigchaind tx staking delegate $VALIDATOR_ADDRESS $STAKE_AMOUNT \
--from $ACCOUNT --gas-adjustment 1.5 \
--gas auto --gas-prices="0.0025uzig" \
--chain-id zig-test-2 --node https://public-zigchain-testnet-rpc.numia.xyz
```

</TabItem>
<TabItem value="Local" label="Local">

```bash
zigchaind tx staking delegate $VALIDATOR_ADDRESS $STAKE_AMOUNT \
--from $ACCOUNT --gas-adjustment 1.5 \
--gas auto --gas-prices="0.0025uzig" \
--chain-id zigchain-1 --node http://localhost:26657
```

</TabItem>
</Tabs>
<!--
Get the Stakings on a Validator (Please review this if it makes more sense):
```bash
zigchaind query staking delegations-to $VALIDATOR_OP_ADDRESS \
--chain-id zigchain-1 \
--node http://localhost:26657 \
-o json | jq -r '.delegation_responses[] | "\(.delegation.delegator_address): \(.balance.amount) \(.balance.denom)"'
```
-->

Get the Stakings on a Validator:

<Tabs groupId="network">
<TabItem value="Mainnet" label="Mainnet" default>

```bash
zigchaind query staking validator $VALIDATOR_ADDRESS \
--chain-id zigchain-1 --node https://public-zigchain-rpc.numia.xyz -o json \
| jq -r '.validator.delegator_shares'
```

</TabItem>
<TabItem value="Testnet" label="Testnet">

```bash
zigchaind query staking validator $VALIDATOR_ADDRESS \
--chain-id zig-test-2 --node https://public-zigchain-testnet-rpc.numia.xyz -o json \
| jq -r '.validator.delegator_shares'
```

</TabItem>
<TabItem value="Local" label="Local">

```bash
zigchaind query staking validator $VALIDATOR_ADDRESS \
--chain-id zigchain-1 --node http://localhost:26657 -o json \
| jq -r '.validator.delegator_shares'
```

</TabItem>
</Tabs>

Get Delegation between address and validator:
<Tabs groupId="network">
<TabItem value="Mainnet" label="Mainnet" default>

```bash
zigchaind query staking delegation \
$ACCOUNT_ADDRESS $VALIDATOR_ADDRESS \
--chain-id zigchain-1 --node https://public-zigchain-rpc.numia.xyz
```

</TabItem>
<TabItem value="Testnet" label="Testnet">

```bash
zigchaind query staking delegation \
$ACCOUNT_ADDRESS $VALIDATOR_ADDRESS \
--chain-id zig-test-2 --node https://public-zigchain-testnet-rpc.numia.xyz
```

</TabItem>
<TabItem value="Local" label="Local">

```bash
zigchaind query staking delegation \
$ACCOUNT_ADDRESS $VALIDATOR_ADDRESS \
--chain-id zigchain-1 --node http://localhost:26657
```

</TabItem>
</Tabs>

Get Delegations made by one delegator:
<Tabs groupId="network">
<TabItem value="Mainnet" label="Mainnet" default>

```bash
zigchaind query staking delegations $ACCOUNT_ADDRESS \
--chain-id zigchain-1 --node https://public-zigchain-rpc.numia.xyz
```

</TabItem>
<TabItem value="Testnet" label="Testnet">

```bash
zigchaind query staking delegations $ACCOUNT_ADDRESS \
--chain-id zig-test-2 --node https://public-zigchain-testnet-rpc.numia.xyz
```

</TabItem>
<TabItem value="Local" label="Local">

```bash
zigchaind query staking delegations $ACCOUNT_ADDRESS \
--chain-id zigchain-1 --node http://localhost:26657
```

</TabItem>
</Tabs>

Get Delegations made to one validator:
<Tabs groupId="network">
<TabItem value="Mainnet" label="Mainnet" default>

```bash
zigchaind query staking delegations-to $VALIDATOR_ADDRESS \
--chain-id zigchain-1 --node https://public-zigchain-rpc.numia.xyz
```

</TabItem>
<TabItem value="Testnet" label="Testnet">

```bash
zigchaind query staking delegations-to $VALIDATOR_ADDRESS \
--chain-id zig-test-2 --node https://public-zigchain-testnet-rpc.numia.xyz
```

</TabItem>
<TabItem value="Local" label="Local">

```bash
zigchaind query staking delegations-to $VALIDATOR_ADDRESS \
--chain-id zigchain-1 --node http://localhost:26657
```

</TabItem>
</Tabs>

Get Validator Info for given delegator validator pair:
<Tabs groupId="network">
<TabItem value="Mainnet" label="Mainnet" default>

```bash
zigchaind query staking delegator-validator \
$ACCOUNT_ADDRESS $VALIDATOR_ADDRESS \
--chain-id zigchain-1 --node https://public-zigchain-rpc.numia.xyz
```

</TabItem>
<TabItem value="Testnet" label="Testnet">

```bash
zigchaind query staking delegator-validator \
$ACCOUNT_ADDRESS $VALIDATOR_ADDRESS \
--chain-id zig-test-2 --node https://public-zigchain-testnet-rpc.numia.xyz
```

</TabItem>
<TabItem value="Local" label="Local">

```bash
zigchaind query staking delegator-validator \
$ACCOUNT_ADDRESS $VALIDATOR_ADDRESS \
--chain-id zigchain-1 --node http://localhost:26657
```

</TabItem>
</Tabs>

Get All Validators Info for given delegator address:
<Tabs groupId="network">
<TabItem value="Mainnet" label="Mainnet" default>

```bash
zigchaind query staking delegator-validators $ACCOUNT_ADDRESS \
--chain-id zigchain-1 --node https://public-zigchain-rpc.numia.xyz
```

</TabItem>
<TabItem value="Testnet" label="Testnet">

```bash
zigchaind query staking delegator-validators $ACCOUNT_ADDRESS \
--chain-id zig-test-2 --node https://public-zigchain-testnet-rpc.numia.xyz
```

</TabItem>
<TabItem value="Local" label="Local">

```bash
zigchaind query staking delegator-validators $ACCOUNT_ADDRESS \
--chain-id zigchain-1 --node http://localhost:26657
```

</TabItem>
</Tabs>

Unstake from a validator:
<Tabs groupId="network">
<TabItem value="Mainnet" label="Mainnet" default>

```bash
zigchaind tx staking unbond $VALIDATOR_ADDRESS $UNSTAKE_AMOUNT \
--from $ACCOUNT --gas-adjustment 1.5 \
--gas auto --gas-prices="0.0025uzig" \
--chain-id zigchain-1 --node https://public-zigchain-rpc.numia.xyz
```

</TabItem>
<TabItem value="Testnet" label="Testnet">

```bash
zigchaind tx staking unbond $VALIDATOR_ADDRESS $UNSTAKE_AMOUNT \
--from $ACCOUNT --gas-adjustment 1.5 \
--gas auto --gas-prices="0.0025uzig" \
--chain-id zig-test-2 --node https://public-zigchain-testnet-rpc.numia.xyz
```

</TabItem>
<TabItem value="Local" label="Local">

```bash
zigchaind tx staking unbond $VALIDATOR_ADDRESS $UNSTAKE_AMOUNT \
--from zuser1 --gas-adjustment 1.5 \
--gas auto --gas-prices="0.0025uzig" \
--chain-id zigchain-1 --node http://localhost:26657
```

</TabItem>
</Tabs>

Get Unbonding Delegation between address and validator:
<Tabs groupId="network">
<TabItem value="Mainnet" label="Mainnet" default>

```bash
zigchaind query staking unbonding-delegation \
$ACCOUNT_ADDRESS $VALIDATOR_ADDRESS \
--chain-id zigchain-1 --node https://public-zigchain-rpc.numia.xyz
```

</TabItem>
<TabItem value="Testnet" label="Testnet">

```bash
zigchaind query staking unbonding-delegation \
$ACCOUNT_ADDRESS $VALIDATOR_ADDRESS \
--chain-id zig-test-2 --node https://public-zigchain-testnet-rpc.numia.xyz
```

</TabItem>
<TabItem value="Local" label="Local">

```bash
zigchaind query staking unbonding-delegation \
$ACCOUNT_ADDRESS $VALIDATOR_ADDRESS \
--chain-id zigchain-1 --node http://localhost:26657
```

</TabItem>
</Tabs>

Query Unbonding Delegations made by one delegator:
<Tabs groupId="network">
<TabItem value="Mainnet" label="Mainnet" default>

```bash
zigchaind query staking unbonding-delegations $ACCOUNT_ADDRESS \
--chain-id zigchain-1 --node https://public-zigchain-rpc.numia.xyz
```

</TabItem>
<TabItem value="Testnet" label="Testnet">

```bash
zigchaind query staking unbonding-delegations $ACCOUNT_ADDRESS \
--chain-id zig-test-2 --node https://public-zigchain-testnet-rpc.numia.xyz
```

</TabItem>
<TabItem value="Local" label="Local">

```bash
zigchaind query staking unbonding-delegations $ACCOUNT_ADDRESS \
--chain-id zigchain-1 --node http://localhost:26657
```

</TabItem>
</Tabs>

Get Unbonding Delegations made from one validator:
<Tabs groupId="network">
<TabItem value="Mainnet" label="Mainnet" default>

```bash
zigchaind query staking unbonding-delegations-from $VALIDATOR_ADDRESS \
--chain-id zigchain-1 --node https://public-zigchain-rpc.numia.xyz
```

</TabItem>
<TabItem value="Testnet" label="Testnet">

```bash
zigchaind query staking unbonding-delegations-from $VALIDATOR_ADDRESS \
--chain-id zig-test-2 --node https://public-zigchain-testnet-rpc.numia.xyz
```

</TabItem>
<TabItem value="Local" label="Local">

```bash
zigchaind query staking unbonding-delegations-from $VALIDATOR_ADDRESS \
--chain-id zigchain-1 --node http://localhost:26657
```

</TabItem>
</Tabs>

## References

- [Cosmos SDK - Staking Module](https://docs.cosmos.network/main/build/modules/staking)
- [Validators FAQ](../nodes-and-validators/validators-faq)
- [Validator Quick Sheet](../nodes-and-validators/validators-quick-sheet)
