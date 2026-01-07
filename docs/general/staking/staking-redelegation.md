---
title: Staking Redelegation
sidebar_position: 3
---

import Tabs from '@theme/Tabs';
import TabItem from '@theme/TabItem';

# Staking Redelegation on ZIGChain

Before diving into redelegation, we recommend reading the [Staking on
ZIGChain](../staking) Article. It provides the necessary background on how staking works, the role of validators, and how delegators
can participate in securing the network while earning rewards.

Redelegation allows you to move your staked ZIG tokens from one validator to another without first unbonding and waiting
through the 21-day unbonding period. This feature is designed to give delegators more flexibility and responsiveness when
managing their stake, while still protecting the network’s security.

<div class="spacer"></div>

## Benefits of Redelegation

- **No 21-day wait:** Instead of unbonding and waiting for your stake to become liquid, you can instantly reallocate it to another validator.

- **Validator flexibility:** If your current validator has high downtime, commission changes, or you want to support a different validator, you can act immediately.

- **Continuous rewards:** Since your stake is not placed into unbonding, you continue to earn staking rewards without interruption.

- **Network health:** Redelegation encourages decentralization by making it easier for delegators to move away from over-concentrated validators.

<div class="spacer"></div>

## How to Redelegate

**1. Verify to which validators you are delegating:**

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

**2. Redelegate to a new validator:**

<Tabs>
  <TabItem value="Mainnet" label="Mainnet" default>

```sh
zigchaind zigchaind tx staking redelegate $VAL_A $VAL_B $AMOUNT \
  --from $ACCOUNT \
  --chain-id zigchain-1 \
  --node https://public-zigchain-rpc.numia.xyz \
  --gas-prices 0.0025uzig \
  --gas auto \
  --gas-adjustment 1.3
```

  </TabItem>
  <TabItem value="Testnet" label="Testnet">

```sh
zigchaind zigchaind tx staking redelegate $VAL_A $VAL_B $AMOUNT \
  --from $ACCOUNT \
  --chain-id zig-test-2 \
  --node https://public-zigchain-testnet-rpc.numia.xyz \
  --gas-prices 0.0025uzig \
  --gas auto \
  --gas-adjustment 1.3
```

  </TabItem>
  <TabItem value="Local" label="Local">

```sh
zigchaind zigchaind tx staking redelegate $VAL_A $VAL_B $AMOUNT \
  --from zuser1 \
  --chain-id zigchain-1 \
  --node http://localhost:26657 \
  --gas-prices 0.0025uzig \
  --gas auto \
  --gas-adjustment 1.3
```

  </TabItem>

</Tabs>

Once submitted, your stake will immediately be delegated to the new validator without entering the unbonding period.

<div class="spacer"></div>

## Rules and Limits

Redelegation is a powerful feature, but there are important rules to be aware of:

> ⚠️ These rules **apply only when redelegating to bonded (active) validators**. If you redelegate to an unbonded validator,
> these restrictions do not apply, and you may redelegate without limit

### 21-Day Cooldown Period

- **Redelegation lock**  
  After you redelegate from Validator A → Validator B, the tokens now staked with Validator B cannot be redelegated
  again for 21 days. You can still claim rewards, delegate more tokens to Validator B, or undelegate, but you cannot
  redelegate those specific tokens until the cooldown expires.

- **Undelegation transactions**  
  The same cooldown logic applies to undelegations. You may only perform up to 7 **undelegations from the same validator**
  within a 21-day window, and each undelegation counts toward this limit.

### 7-Stack Rule

- **Per-wallet redelegation limits**  
  Each wallet can perform up to **7 redelegations between the same pair of validators** within a 21-day window. Once this
  limit is reached, you must wait until the cooldown period from the first redelegation has expired before initiating
  another redelegation between those two validators.

- **Applies per validator pair**  
  This rule is enforced per wallet and per validator pair. For example, if you hit the limit on redelegations from
  Validator A → Validator B, you may still redelegate from Validator A → Validator C without restriction.

- **Undelegation limits**  
  Just like with redelegation, undelegations are also capped at **7 per validator within 21 days**. This ensures that frequent
  partial undelegations cannot be abused to bypass cooldown mechanics.

### Serial Redelegation

- **No validator hopping**  
  You cannot chain redelegations directly (e.g., A → B → C) within the cooldown period. Once tokens are redelegated to a
  new validator, that validator is locked from further redelegations for 21 days.

- **Re-delegating after fresh delegation**  
  Even if you undelegate all tokens from a validator and then delegate to it again during the 21-day window, that
  validator remains locked for redelegation until the cooldown has fully expired.

<div class="spacer"></div>

## Practical Explanation

To make redelegation rules clearer, let’s look at some sample scenarios:

**Scenario 1 — Redelegating from Validator A to Validator B**  
Suppose you have 10 ZIG delegated to Validator A.

- You may split this and redelegate small portions (e.g., 1 ZIG each time) to Validator B, but only up to 7 redelegation transactions within a 21-day period.
- Attempting an 8th redelegation during that window will fail.
- Once 21 days have passed since your first redelegation, you may begin redelegating again from A → B.
- These same limits also apply when you choose to undelegate instead of redelegate.

**Scenario 2 — Redelegation lock on the receiving validator**  
After your tokens are redelegated to Validator B, that validator becomes “locked” for further redelegations for 21 days:

- You can still delegate more ZIG, undelegate, or claim rewards with Validator B.
- However, you cannot redelegate from Validator B to another validator (e.g., C) until the 21-day period ends.
- Even if you remove all tokens from Validator B and delegate fresh tokens again, the redelegation lock still applies.

**Scenario 3 — Resetting the lock**

- If you redelegate from another validator (e.g., C → B) before the 21-day period expires, the countdown resets.
  This means you’ll need to wait a new full 21 days before you can redelegate from Validator B again.

In summary, whenever a redelegation is made, the destination validator (the one receiving the redelegated tokens) is
placed under a 21-day redelegation lock.

## References

- [Staking](../staking)
