---
title: How to Claim BSC ZIG Rewards and Bridge to ZIGChain
description: Guide to claiming ZIG rewards from Binance Smart Chain staking program and bridging tokens from BSC to Ethereum, then to ZIGChain mainnet.
keywords:
  [
    BSC rewards,
    claim rewards,
    bridge ZIG,
    BSC to ZIGChain,
    BEP-20 bridge,
    token bridge,
    ZIGStake migration,
    cross-chain bridge,
  ]
sidebar_position: 8
---

# How to Claim BSC ZIG Rewards and Bridge to ZIGChain

> ⚠️ **Important Notice**  
> Currently, **only bridging ZIG tokens from Ethereum (ERC-20) to ZIGChain is supported.**  
> Bridging directly from **BSC (BEP-20) to ZIGChain** is **not yet available.**

This guide explains how users who staked **ZIG** on **Binance Smart Chain (BSC)** through the [ZIGStake program](https://staking.zigchain.com/) can **claim their rewards** and prepare their tokens for use on **ZIGChain**.

If your ZIG tokens were staked on BSC, you’ll need to first **unstake and move them to Ethereum**, then **bridge them from Ethereum to ZIGChain** to continue participating in the ecosystem.

---

## Step-by-Step Guide

### 1. Withdraw Your Staked ZIG and Rewards from BSC

1. Visit [https://staking.zigchain.com/](https://staking.zigchain.com/) to access the old staking platform.
2. Follow the detailed [unstaking guide](./how-to-unstake-from-old-staking-program.md) for step-by-step instructions.
3. After unstaking, your ZIG tokens will be immediately available in your **BEP-20 wallet** (there is no unbonding period since the program has completed).

---

### 2. Bridge ZIG from BSC to Ethereum (ERC-20)

Because direct bridging from BSC to ZIGChain is not yet supported, you must first move your tokens to Ethereum.

You can do this in one of two ways:

- **Using a Centralized Exchange (CEX):**

  - Deposit your BEP-20 ZIG into a CEX that supports both BSC and Ethereum networks.
  - Withdraw your ZIG to your Ethereum wallet, selecting the **ERC-20 network**.

- **Using a Cross-Chain Bridge or Aggregator:**
  - Use a trusted bridge such as [**HoudiniSwap**](https://houdiniswap.com/?tokenIn=ZIGBSC&tokenOut=ZIGETH) or another multi-chain solution that supports ZIG.
  - Double-check the token contract and network before confirming the swap.

💡 **Tip:** Make sure you have enough **BNB** (for BSC gas fees) and **ETH** (for Ethereum gas fees) before starting the transfer.

---

### 3. Bridge ZIG from Ethereum to ZIGChain

Once your ZIG is on Ethereum:

1. Go to the [**official ZIGChain Bridge**](https://hub.zigchain.com/bridge/) on the ZIGHub.
2. Connect your Ethereum wallet.
3. Connec your ZIGChain wallet. If you dont have a ZIGChain wallet yet, [follow this guide to set it up.](./zigchain-wallet.md)
4. Choose the amount of ZIG you want to bridge to ZIGChain. Please note that in order to claim rewards you must bridge at least 90% of the total of your last staked amount.
5. Confirm and approve the transaction in your wallet.

After processing, your ZIG tokens will appear on **ZIGChain**.

---

### 4. Claim Your Rewards on ZIGChain

Once your tokens are on ZIGChain:

1. Visit the ZIGChain Hub.
2. Go to the [**Claim Rewards**](https://hub.zigchain.com/claim-rewards/) section and connect your ZIGChain wallet.
3. Claim your rewards daily!

> **Note:** Reward claims will be available starting **November 5th, 2025**.

For a detailed step-by-step guide and frequently asked questions about claiming rewards, refer to the [**ZIGStake Rewards guide**](../users/hub/claim-rewards).

---

## Additional Notes

- **Gas & Bridge Fees:** Each transfer (BSC → ETH → ZIGChain) involves small network fees. Plan ahead.
- **Processing Times:** Cross-chain transactions may take several minutes or longer, depending on network congestion.
- **Security:** Always verify the **token contract** and **bridge URLs** from official sources.
