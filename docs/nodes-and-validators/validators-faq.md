---
title: Validators FAQ
description: Frequently asked questions about ZIGChain validators including validator selection, staking requirements, rewards, slashing risks, commission rates, and operational best practices.
keywords:
  [
    ZIGChain validators FAQ,
    ZIGChain validator,
    ZIGChain active validators,
    ZIGChain validator requirements,
    ZIGChain validator selection,
    ZIGChain validator staking,
    ZIGChain validator rewards,
    ZIGChain slashing risk,
    ZIGChain validator commission,
    ZIGChain validator performance,
    ZIGChain validator uptime,
  ]
sidebar_position: 2
---

import Tabs from '@theme/Tabs';
import TabItem from '@theme/TabItem';

# Validators FAQ

## What is a Validator?

A validator is a full node in the ZIGChain blockchain that participates in the consensus process by proposing new blocks and validating transactions. ZIGChain operates under a Proof-of-Stake (PoS) consensus mechanism, where validators are selected based on their staked tokens — either their own tokens or those delegated by other participants.

**Active Validators** are the network's top token holders responsible for **securing and processing** transactions on the blockchain. Their ranking depends on the **total stake**, including their **self-stake and delegated tokens**.

## How Validators Are Selected

ZIGChain selects its active validators based on the **total staked ZIG tokens**, which includes both self-delegated and delegated tokens. The top `N` validators with the highest total stake form the **Active Validator Set** — these validators are responsible for proposing blocks and earning rewards.

To be eligible for selection, a validator must meet the **minimum self-delegation requirement**, which currently stands at **100,000 ZIG**. This bond acts as a commitment mechanism and is enforced on-chain. Validators who do not meet this threshold will not be considered for the active set.

- The maximum number of active validators is defined by the `max_validators` chain parameter. [Get Staking Parameters](../builders/staking-module#staking-cli-quick-sheet)
- Only active validators participate in consensus and earn block rewards.
- The minimum bond threshold and `max_validators` value can be updated through governance proposals.

### How Validator Selection Works

Validator selection is dynamic and happens at the end of every block, following the [Cosmos SDK v0.50 staking module](https://docs.cosmos.network/v0.50/build/modules/staking#end-block) logic. This means the active set may change block by block based on stake changes.

#### The process is as follows:

1. Fetch the maximum validator count from the `max_validators` parameter — for example, 4.

2. Sort all validators by their total staked power (both self and delegated), using `LastTotalPower` and `LastValidatorPower` values.

3. Select the top N validators as the new Active Validator Set.

4. Update validator statuses:

   - Validators entering the top N are marked as Bonded.

   - Validators leaving the top N are transitioned to Unbonding.

5. Unbonding is not immediate — it takes effect over time and may delay actions such as redelegations.

This automatic, block-by-block update ensures that the validator set always reflects the most recent stake distribution.

## Validator Unbonding

Delegators who choose to unstake their ZIG tokens must wait for a fixed unbonding period before their tokens become transferable. On ZIGChain, the standard unbonding period is **21 days**.

To maintain economic stability and avoid mass unbonding events, ZIGChain enforces a per-validator unbonding limit per block. This means only a portion of a validator’s total delegations can be unbonded in a single block, ensuring gradual and secure exits.

## Validators Keys

Validators handle the following keys:

1. **Tendermint Consensus Key** (also known as the CometBFT key)

   - Purpose: Used to sign blocks.
   - Address prefix: `zigvalcons`
   - Public key prefix: `zigvalconspub`
   - Key type: `ed25519` (can be stored in Key Management System (KMS)).
   - Generated during: `zigchaind init process`.

2. **Validator Operator Application key**

   - Purpose: Used to create transactions that create or modify validator parameters.
   - Address prefix: `zigvaloper`.

3. **Validator Owner Key**
   - Purpose: Used to manage the validator and handle auto stake.
   - Address prefix: `zig`.

## Validator Statuses

Validators can exist in three states:

1. **Unbonded**:

   - Not in the Active Set
   - Cannot sign blocks
   - Earns no rewards
   - Can still receive delegations.

2. **Bonded**:

   - In the Active Set
   - Signs blocks and earns rewards
   - Accepts new delegations
   - Faces slashing penalties if misbehaving
   - Delegators must wait through the Unbonding Period if withdrawing stake, during which they remain vulnerable to slashing if their validator commits offenses from the bonded period.

3. **Unbonding**:
   - Happens when a validator:
     - Leaves the Active Set (by choice or due to slashing, jailing, or tombstoning)
     - Starts unbonding all delegations. Delegators must wait for the Unbonding Time before their tokens return to their accounts from the Bonded Pool.

**Jailing** is a special condition that the consensus mechanism can apply under some conditions to validators — while not a status itself, it removes validators from the Active Set and prevents them from signing blocks until the condition is lifted.

## Validator Responsibilities

Validators have several **key responsibilities**:

1. **Proposing and Validating Blocks:**

   - Propose new blocks and validate blocks proposed by other validators. Ensure only valid transactions are included.

2. **Maintaining Network Security:** By validating transactions and maintaining consensus, validators help secure the blockchain against malicious actors and attacks. A key responsibility is to:

   - Prevent double-spending or any tampering with the blockchain's history.
   - Ensure **consensus integrity**.

3. **Uptime and Availability:**
   - Validators must maintain high uptime to avoid penalties
   - Stay consistently online to propose and validate blocks.

Failure to meet uptime requirements can lead to penalties or slashing.

4. **Governance Participation:**
   - Validators vote on key network proposals (influence critical decisions like protocol upgrades, staking parameters, and other blockchain proposals).
   - Voting power is proportional to their stake.
5. **Staking and Delegation:**
   - To operate as a validator, participants must stake a significant amount of ZIG tokens. Higher stakes increase their chances of being selected for validation duties.
   - While personal stakes matter, validators often rely on delegators — users who trust them with additional staked tokens — to enhance their network position.

Delegators are crucial to the system. They help distribute the stake across validators, decentralizing power and reducing the risk of network centralization. In return, delegators receive part of the rewards earned by validators for participating in consensus.

## Validator Rewards: Block Rewards and Transaction Fees

Validators earn rewards from three main sources:

1. **Block Rewards**: Newly minted ZIG tokens distributed to validators and delegators for participating in network activities.
2. **Transaction Fees**: Fees from users for processing transactions, paid in ZIG tokens.
3. **Commissions from Delegators**: A percentage-based fee that validators collect from their delegators' rewards in exchange for validation services.

Rewards are distributed in ZIG tokens and earned through successful transaction validation, block proposals, and maintaining network security.

The rewards are shared between validators and their delegators, with distribution based on their total stake and commission rates. Validators often set a percentage fee that they charge from delegator rewards in exchange for their services.

## Validator Block Reward Example

Assume the following parameters:

- Validator Voting Power: `10%`
- Commission Rate: `5%`
- Self-Delegation: `20%`
- Total Block Reward: `1000 ZIG`

The block reward of 1000 ZIG is distributed to validators based on their voting power — in this case, 100 ZIG for 10% voting power. The amount is then split between validator and delegators according to their stake distribution, with delegators paying a commission fee to the validator.

Reward distribution calculation:

```
Total Reward: 1000 ZIG

Validator Share: 100 * 20% = 20 ZIG

Delegator Commission: 100 * 80% * 5% = 4 ZIG
amount * percentage of delegator funds (not including validators as he doesn't pay commission) * commission rate

Total Validator Earnings: 100 * 20% + 4 (commission) = 24 ZIG

Delegators Earnings: 100 * 80% - 4 (commission) = 76 ZIG
```

## Validator Transaction Fee Example

Transaction fees follow a similar distribution pattern to block rewards. Let's examine a scenario with these parameters:

Assume the following:

- Validator Voting Power: `10%`
- Commission Rate: `5%`
- Self-Delegation: `20%`
- ZIGChain Community Tax: `2%`
- Block proposer has 100% signatures

There is a successful block that collects 1025.51020408 ZIG in fees.

1. First, the 2% tax is applied, and the corresponding ZIG tokens go to the reserve pool.

```
Community Tax Deduction: 1025.51020408 * 2% = 20.51020408 ZIG go to the reserve pool.

Remaining Fees: 1025.51020408 - 20.51020408 = 1005 ZIGs remain to be distributed among validators.
```

2. Your validator pool will receive part of the reward according to its voting power.

```
Validator Pool Reward = 1005 * 10% = 100.5 ZIGs
```

3. Commission paid by delegators:

```
Delegator Commission = 100.5 * 80% * 5% = 4.02 ZIGs

Total Validator Earnings: 100.5 * 20% + 4.02 (commission) = 24.02 ZIGs

Delegators Earnings: 100.5 * 80% - 4.02 (commission) = 76.48 ZIGs
```

✨ Note: ZIGChain relies on the Cosmos SDK Distribution Module. In previous versions of Cosmos SDK, the block proposer received a bonus as a block reward. These parameters were deprecated on v0.47 and are no longer used.

Check the Reward distribution parameters in ZIGChain with the following command:

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

## Slashing

Slashing is a penalty system that reduces staked tokens when validators violate network rules or fail performance standards. This mechanism affects both validator and delegator tokens, providing a strong financial incentive for validators to maintain diligent operation and consistent uptime.

Validators can face slashing under several conditions:

- **Double Signing:** Signing two different blocks at the same height triggers penalties.
- **Downtime:** Validators must remain online and available. If a validator goes offline for too long, their stake can be slashed.
- **Equivocation:** Taking contradictory consensus actions damages network integrity and incurs penalties.

The slashing percentage depends on the severity of the violation, and it serves as a deterrent against malicious or negligent behavior.

Slashing formula:

```
Amount of slashing = slash factor * power at time of infraction
```

Get Slashing Parameters:
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

- **Jailtime:** Validators that are slashed may also be jailed temporarily, preventing them from producing blocks or earning rewards until they are unjailed manually.

## References

- [Reward example in Cosmos SDK](https://docs.cosmos.network/main/build/modules/distribution#reward-to-the-community-pool)
- [Prepare Validators Keys](https://tutorials.cosmos.network/tutorials/9-path-to-prod/3-keys.html#)
- [Validators Statuses Codes](https://github.com/cosmos/cosmos-sdk/blob/main/x/staking/types/staking.pb.go)
- [Validator Selection in Cosmos SDK](https://docs.cosmos.network/v0.50/build/modules/staking#end-block)
