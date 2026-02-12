# Chain fundamentals and consensus

Block time, consensus, finality, chain IDs, mainnet status, and related protocol basics.

_Last updated: Oct 31st, 2025_

---

## What is the average block time?

Approximately 3.5 seconds.

---

## Does ZIGChain use a UTXO or account-based model?

Account-based model (Cosmos SDK).

---

## What is the consensus mechanism?

CometBFT/Tendermint-style BFT, Proof-of-Stake.

---

## How many on-chain confirmations are recommended for deposits?

Immediate finality on commit with CometBFT; one block is sufficient (many exchanges opt for 2–3 as a safety buffer).

---

## What is the block production rate (average interval per block)?

Approximately 3.5 seconds.

Example calculation command:

`RPC="http://localhost:26657"`  
`LATEST=$(curl -s $RPC/status | jq -r '.result.sync_info.latest_block_height')`  
`EARLIER=$((LATEST - 100))`  
`T1=$(curl -s "$RPC/block?height=$LATEST" | jq -r '.result.block.header.time')`  
`T0=$(curl -s "$RPC/block?height=$EARLIER" | jq -r '.result.block.header.time')`  
`S1=$(date -d "$T1" +%s)`  
`S0=$(date -d "$T0" +%s)`  
`echo "scale=3; ($S1 - $S0) / ($LATEST - $EARLIER)" | bc`

---

## What preventive measures exist to avoid chain forks?

Cosmos uses CometBFT consensus, providing instant finality and eliminating fork risk.

---

## What is the consensus mode (PoW/PoS) and 51% attack prevention?

ZIGChain operates on Proof-of-Stake (PoS) using CometBFT, ensuring immediate finality and protection against 51% attacks.

---

## Is rollback possible after a block is committed?

Cosmos chains with CometBFT have instant finality.  
 Once a block is committed, rollback does not occur.

---

## What is the mainnet transfer status?

Mainnet transfers are active since June 2025.

---

## Is the node code open source?

Yes.  
 ZIGChain is built with the Cosmos SDK, a fully open-source framework.

---

## What is the transaction model?

Account-based.  
 Docs: [https://docs.zigchain.com/general/accounts](https://docs.zigchain.com/general/accounts)

---

## What is the consensus algorithm?

Proof of Stake (PoS)  
 Docs: [https://docs.zigchain.com/nodes_validators/validators](https://docs.zigchain.com/nodes_validators/validators)

---

## What is the average block production speed?

Approximately 3.5 seconds.

---

## What is the recommended confirmation count for safety?

CometBFT provides instant finality once a block is committed.  
 For critical actions, 5–20 confirmations are recommended.

---

## What is the base chain (framework)?

ZIGChain is built on Cosmos SDK.

---

## Is there supernode voting?

Not applicable.  
 See: [https://docs.zigchain.com/nodes_validators/validators](https://docs.zigchain.com/nodes_validators/validators)

---

## Is there a dividend or interest mechanism?

ZIGChain includes a governance module and supports staking rewards.  
 Docs: [https://docs.zigchain.com/general/governance](https://docs.zigchain.com/general/governance)

---

## What is the base blockchain framework and version?

ZIGChain runs on Cosmos SDK v0.47.0 or newer.

---

## What are the chain IDs (testnet and mainnet)?

Testnet: `zig-test-2`  
 Mainnet: `zigchain-1`

---

## What network types are supported (mainnet/testnet)?

Mainnet and Testnet

---

## What is the finality confirmation (instant finality)?

Instant finality once block is confirmed.

---

## What is the block time?

Average 3.5 seconds.

---

## What is the chain mainnet status?

Mainnet is live since June 2025.

---

## What is the chain name?

ZIGChain

---

## What is the native currency and denom summary?

Ticker: ZIG  
 Currency full name: ZIGCoin  
 Base denom (protocol unit): uZIG

---

## Does ZIGChain have unique features compared to standard Cosmos SDK chains?

Yes. ZIGChain includes three custom modules: **Token Factory**, **DEX**, and **Token Wrapper** (documented in `docs.zigchain.com`).  
 The core chain logic is aligned with the **Cosmos SDK v0.50** line.

---

## What is the maximum TPS or transactions per block?

Current managed throughput is approximately **125–150 TPS** (under present configuration and typical workloads).

---

## What is the recommended block confirmation count for deposits and withdrawals?

• **Safe on-chain deposit confirmation:** **1–3 blocks** (CometBFT finality; many exchanges use 2–3 as buffer).  
 • **Safe withdrawal confirmation:** **~5–20 blocks** for additional safety on high-value flows.

---
