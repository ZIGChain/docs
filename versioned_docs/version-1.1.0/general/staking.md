---
sidebar_position: 5
---

# Staking

ZIGChain Staking is a decentralized process that enables users to **enhance the network’s security** and **governance** by delegating their ZIG tokens to validators. In return, **participants earn rewards** for their contributions.

ZIGChain utilizes the Tendermint Byzantine Fault Tolerance (BFT) consensus mechanism to secure its blockchain, ensuring robust and efficient consensus. Staking is a critical component of the ZIGChain ecosystem, driving its security, decentralization, and long-term resilience.

<div class="spacer"></div>

## Key Components of Staking on ZIGChain

Staking on ZIGChain revolves around two key participants

### Validators

Validators are node operators who:

- Validate transactions, create new blocks, and secure the network
- Maintain secure, highly available infrastructure
- Earn rewards from transaction fees and block rewards
- Are selected based on total delegated ZIG tokens (self-staked \+ delegators)

### Delegators

Delegators are ZIG holders who:

- Participate in network security without operating validator infrastructure
- Contribute to decentralization by delegating tokens to validators
- Earn a portion of block rewards and transaction fees
- Carefully select validators based on performance and reputation
- Share risks, including potential slashing penalties

<div class="spacer"></div>

## How Staking Works on ZIGChain

Staking on ZIGChain follows these steps:

1. **Select a Validator**:

   - Choose from available validators to delegate your ZIG tokens
   - Validators are ranked based on their performance, commission rates, and other factors
   - You can distribute your tokens across multiple validators to diversify your stake

2. **Delegate ZIG Tokens**:

   - Delegate your ZIG tokens to the selected validator using the ZIGChain CLI or a wallet interface
   - Select the amount of ZIG tokens you wish to delegate to your chosen validator(s)

3. **Earn Rewards**:

   - Earn staking rewards based on your delegated amount
   - Rewards are distributed automatically by the network

4. **Unstake**:
   - Delegators can unstake (undelegate) ZIG tokens to withdraw them from the staking pool
   - A 21-day waiting period (unbonding) applies to all unstaking requests for network security
   - ZIG tokens become available for withdrawal after this period

<div class="spacer"></div>

### Stake Using ZIGChain Hub

You can stake $ZIG tokens easily using [ZIGChain Hub](https://hub.zigchain.com/staking/) — a simple and intuitive web interface that doesn’t require any CLI knowledge.

#### Steps to Stake on ZIGChain Hub:

1. Go to [https://hub.zigchain.com/staking/](https://hub.zigchain.com/staking/)
2. Connect your wallet (we recommend **Leap** or **Keplr**)
3. Browse the list of validators and select one to delegate your tokens to
4. Click the **“Stake”** button next to the validator
5. Enter the amount of $ZIG tokens you want to delegate
6. Click **“Stake”** again in the popup window
7. Approve the staking action in your wallet
8. After the transaction is confirmed, the page will refresh — ensure your **staked amount is visible**

#### Manage Your Stake

To view or modify your existing stake:

1. In the validator list, locate the validator you've already staked to

2. Click the “Modify” button — this will open the Manage Stake panel

3. From here, you can:

      Stake More: Delegate additional ZIG tokens

      Unstake: Start the 21-day unbonding process

      Claim: Withdraw your accumulated rewards

Make sure your wallet is connected and you’re on the correct network to see your delegations.

<div class="spacer"></div>

## Security Measures: Slashing and Penalties

While staking on ZIGChain is rewarding, it also comes with inherent risks due to slashing mechanisms. Slashing is a penalty enforced on validators (and indirectly their delegators) for misconduct or negligence. This mechanism ensures that validators remain accountable and uphold the network’s integrity.

Types of Slashing Events

- **Double Signing**: If a validator signs two conflicting blocks at the same height, they incur a severe penalty. This type of violation is considered highly detrimental to network integrity, and the associated penalty slash of 5% on staked tokens and lead to the validator’s removal from the active set.
- **Downtime**: Validators must maintain high uptime. If a validator goes offline for an extended period, they incur a slashing penalty (0.01%). This penalty is intended as a minor deterrent, encouraging validators to maintain high uptime without severely impacting their stake.

<div class="spacer"></div>

## Become a Validator or Delegator on ZIGChain

Dive deeper into ZIGChain staking with this resource:

[//]: # "**Introduction to Validators:** A comprehensive guide on the role of validators, how to calculate rewards, and useful CLI commands, among others."

**[Delegators FAQ:](./delegators_faq.md)** Answers to common questions from delegators about how staking works, rewards, and managing their stake.

<div class="spacer"></div>
