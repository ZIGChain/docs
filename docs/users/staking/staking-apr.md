---
title: Staking APR on ZIGChain
description: Complete guide to understanding and calculating APR for ZIGChain staking, including nominal APR, actual APR, final APR, and how validator commissions affect returns.
keywords:
  [
    staking APR,
    annual percentage rate,
    staking returns,
    validator commission,
    bonded ratio,
    inflation rate,
    staking rewards calculation,
    APR formula,
  ]
sidebar_position: 2
---

import Tabs from '@theme/Tabs';
import TabItem from '@theme/TabItem';

# Staking APR on ZIGChain

When staking assets on ZIGChain, one of the most important factors to consider is the **Annual Percentage Rate (APR)**,
as it determines the efficiency and profitability of staking.

This article explains how APR will be calculated for ZIGChain, breaking down key concepts such as annual provisions,
community tax, bonded tokens ratio, and the difference between **nominal** and **actual** APR.

---

## What is APR in ZIGChain Staking?

For users [staking on ZIGChain](https://hub.zigchain.com/staking/), APR reflects the interest earned on bonded assets
over a year. The calculation first derives **Nominal APR**, then adjusts it to obtain **Actual APR**
(reflecting live network conditions), and —on validator pages— **Final APR** (after that validator’s commission).

### 1) Nominal APR

The nominal APR is the theoretical rate based on protocol issuance (inflation or annual provisions) and staking participation (bonded ratio)

- Includes: Community tax adjustment
- Excludes: Real-time block production and validator commissions

There are two **equivalent** ways to compute Nominal APR:

**Inflation form (i)**

```
Nominal APR = (Inflation Rate × (1 - Community Tax)) / Bonded Tokens Ratio
```

**Annual Provisions form (AP)**

```
Nominal APR = (Annual Provisions × (1 - Community Tax)) / Bonded Tokens
```

These two formulas are equivalent because:

```
Annual Provisions = Inflation Rate × Total Supply
(AP × (1 - ct)) / Staked = (i × TotalSupply × (1 - ct)) / Staked
= (i × (1 - ct)) / (Staked / TotalSupply)
```

To fully grasp both formulas, it is essential to understand the following parameters:

| Parameter             | Description                                                                                                              |
| --------------------- | ------------------------------------------------------------------------------------------------------------------------ |
| `annual provisions`   | Number of ZIG tokens the network mints in one year (ZIG/year).                                                           |
| `bonded_tokens`       | Total ZIG actively staked (bonded).                                                                                      |
| `bonded_tokens` ratio | Percentage of total ZIG that is actively staked: `Bonded / Total Supply`.                                                |
| `community_tax`       | Portion of staking rewards allocated for network development and governance. More [here](../../builders/distribution-module). |
| `inflation` rate      | Percentage of tokens issued annually relative to the [total supply](../../about-zigchain/zig#zig-token-distribution).         |

**Some values may change via governance proposals. Always confirm using the CLI or API.**

### 2) Actual APR

The actual APR is the Nominal APR adjusted by how many blocks were actually produced versus the target. If the network recently produced fewer (or more) blocks than the “expected per year,” the realized rewards rate changes accordingly.

The calculation is as it follows:

Actual APR accounts for **real network conditions**, such as block-minting speed:

```
Actual APR = Nominal APR × (Observed Blocks per Year / Expected Blocks per Year)
```

| Factor                | Description                                                                                                    |
| --------------------- | -------------------------------------------------------------------------------------------------------------- |
| Block time variations | Real block production (Observed) may differ from the target (Expected) due to network conditions and upgrades. |

### 3) Final APR (Per-Validator Display)

The Final APR is the rate a delegator actually earns after the chosen validator’s commission.

This is the calculation to obtain it:

Apply the validator’s commission:

```
Final APR = Actual APR × (1 - Validator's Commission)
```

Since validator commissions vary, users can optimize rewards by selecting validators with lower fees. However, commission
is **not** the only factor to consider:

- **Reliability & Performance** – High uptime and secure infrastructure help ensure consistent rewards.
- **Governance Participation** – Validators active in governance, aligned with your values.
- **Decentralization** – A diverse validator set strengthens security and resilience.

---

## Verifiability and Transparency

This methodology is fully transparent and reproducible with on-chain data. Anyone can verify the inputs using simple CLI commands. In other words, the APR shown in the [ZIGChain Hub](https://hub.zigchain.com/staking/) is not a `black box`: it’s a deterministic computation based on values you can independently query at any time.

**Units:** On-chain amounts are in `uzig`.

### Annual Provisions

<Tabs groupId="network">
<TabItem value="Mainnet" label="Mainnet" default>

```bash
zigchaind query mint annual-provisions --chain-id zigchain-1 --node https://public-zigchain-rpc.numia.xyz
```

</TabItem>
<TabItem value="Testnet" label="Testnet">

```bash
zigchaind query mint annual-provisions --chain-id zig-test-2 --node https://public-zigchain-testnet-rpc.numia.xyz
```

</TabItem>
<TabItem value="Local" label="Local">

```bash
zigchaind query mint annual-provisions --chain-id zigchain-1 --node http://localhost:26657
```

</TabItem>
</Tabs>

### Inflation

<Tabs groupId="network">
<TabItem value="Mainnet" label="Mainnet" default>

```bash
zigchaind query mint inflation --chain-id zigchain-1 --node https://public-zigchain-rpc.numia.xyz
```

</TabItem>
<TabItem value="Testnet" label="Testnet">

```bash
zigchaind query mint inflation --chain-id zigchain-1 --node https://public-zigchain-testnet-rpc.numia.xyz
```

</TabItem>
<TabItem value="Local" label="Local">

```bash
zigchaind query mint inflation --chain-id zigchain-1 --node http://localhost:26657
```

</TabItem>
</Tabs>

### Community Tax

<Tabs groupId="network">
<TabItem value="Mainnet" label="Mainnet" default>

```bash
zigchaind query distribution params --chain-id zigchain-1 --node https://public-zigchain-rpc.numia.xyz
```

</TabItem>
<TabItem value="Testnet" label="Testnet">

```bash
zigchaind query distribution params --chain-id zigchain-1 --node https://public-zigchain-testnet-rpc.numia.xyz
```

</TabItem>
<TabItem value="Local" label="Local">

```bash
zigchaind query distribution params --chain-id zigchain-1 --node http://localhost:26657
```

</TabItem>
</Tabs>

### Bonded Tokens

<Tabs groupId="network">
<TabItem value="Mainnet" label="Mainnet" default>

```bash
zigchaind query staking pool --chain-id zigchain-1 --node https://public-zigchain-rpc.numia.xyz
```

</TabItem>
<TabItem value="Testnet" label="Testnet">

```bash
zigchaind query staking pool --chain-id zigchain-1 --node https://public-zigchain-testnet-rpc.numia.xyz
```

</TabItem>
<TabItem value="Local" label="Local">

```bash
zigchaind query staking pool --chain-id zigchain-1 --node http://localhost:26657
```

</TabItem>
</Tabs>

### Blocks per year (Expected)

<Tabs groupId="network">
<TabItem value="Mainnet" label="Mainnet" default>

```bash
zigchaind query mint params --chain-id zigchain-1 --node https://public-zigchain-rpc.numia.xyz
```

</TabItem>
<TabItem value="Testnet" label="Testnet">

```bash
zigchaind query mint params --chain-id zigchain-1 --node https://public-zigchain-testnet-rpc.numia.xyz
```

</TabItem>
<TabItem value="Local" label="Local">

```bash
zigchaind query mint params --chain-id zigchain-1 --node http://localhost:26657
```

</TabItem>
</Tabs>

### Blocks per year (Observed)

:::note
On the Hub APR calculation, `OBSERVED_BLOCKS_PER_YEAR=12,000,000` is used.
:::

<Tabs groupId="network">
<TabItem value="Mainnet" label="Mainnet" default>

```bash
RPC=https://public-zigchain-rpc.numia.xyz
CHAIN=zigchain-1
YEAR_SECS=31557600
if command -v gdate >/dev/null 2>&1; then D=gdate; else D=date; fi
OBS=0
for WIN in 100000 50000 20000 10000 5000 2000 1000 500 200 100; do
  H=$(curl -s "$RPC/status" | jq -r '.result.sync_info.latest_block_height // 0')
  [[ "$H" =~ ^[0-9]+$ ]] || { echo "RPC/status not reachable"; break; }
  H0=$(( H>WIN ? H-WIN : 1 ))
  T1=$(curl -s "$RPC/block?height=$H"  | jq -r '.result.block.header.time // empty')
  T0=$(curl -s "$RPC/block?height=$H0" | jq -r '.result.block.header.time // empty')
  [[ -n "$T1" && -n "$T0" ]] || continue
  t1=$($D -d "$T1" +%s 2>/dev/null || echo 0)
  t0=$($D -d "$T0" +%s 2>/dev/null || echo 0)
  (( t1>t0 )) || continue
  dt=$((t1 - t0))
  db=$((H - H0))
  OBS=$(( db * YEAR_SECS / dt ))
  echo "ObservedBlocksPerYear=$OBS (window=$WIN)"
  break
done
```

</TabItem>
<TabItem value="Testnet" label="Testnet">

```bash
RPC=https://public-zigchain-testnet-rpc.numia.xyz
CHAIN=zig-test-2
YEAR_SECS=31557600
if command -v gdate >/dev/null 2>&1; then D=gdate; else D=date; fi
OBS=0
for WIN in 100000 50000 20000 10000 5000 2000 1000 500 200 100; do
  H=$(curl -s "$RPC/status" | jq -r '.result.sync_info.latest_block_height // 0')
  [[ "$H" =~ ^[0-9]+$ ]] || { echo "RPC/status not reachable"; break; }
  H0=$(( H>WIN ? H-WIN : 1 ))
  T1=$(curl -s "$RPC/block?height=$H"  | jq -r '.result.block.header.time // empty')
  T0=$(curl -s "$RPC/block?height=$H0" | jq -r '.result.block.header.time // empty')
  [[ -n "$T1" && -n "$T0" ]] || continue
  t1=$($D -d "$T1" +%s 2>/dev/null || echo 0)
  t0=$($D -d "$T0" +%s 2>/dev/null || echo 0)
  (( t1>t0 )) || continue
  dt=$((t1 - t0))
  db=$((H - H0))
  OBS=$(( db * YEAR_SECS / dt ))
  echo "ObservedBlocksPerYear=$OBS (window=$WIN)"
  break
done
```

</TabItem>
<TabItem value="Local" label="Local">

```bash
RPC=http://localhost:26657
CHAIN=zigchain-1
YEAR_SECS=31557600
if command -v gdate >/dev/null 2>&1; then D=gdate; else D=date; fi
OBS=0
for WIN in 100000 50000 20000 10000 5000 2000 1000 500 200 100; do
  H=$(curl -s "$RPC/status" | jq -r '.result.sync_info.latest_block_height // 0')
  [[ "$H" =~ ^[0-9]+$ ]] || { echo "RPC/status not reachable"; break; }
  H0=$(( H>WIN ? H-WIN : 1 ))
  T1=$(curl -s "$RPC/block?height=$H"  | jq -r '.result.block.header.time // empty')
  T0=$(curl -s "$RPC/block?height=$H0" | jq -r '.result.block.header.time // empty')
  [[ -n "$T1" && -n "$T0" ]] || continue
  t1=$($D -d "$T1" +%s 2>/dev/null || echo 0)
  t0=$($D -d "$T0" +%s 2>/dev/null || echo 0)
  (( t1>t0 )) || continue
  dt=$((t1 - t0))
  db=$((H - H0))
  OBS=$(( db * YEAR_SECS / dt ))
  echo "ObservedBlocksPerYear=$OBS (window=$WIN)"
  break
done

```

</TabItem>
</Tabs>

**Expected output:** `ObservedBlocksPerYear=XXXXXXXX`

**Units:** On-chain amounts are in `uzig`.

---

## Conclusion

ZIGChain’s staking APR is determined by multiple factors, including issuance (via **inflation** or **annual provisions**),
staking participation (bonded ratio), and live network conditions (block production). **Nominal APR** is theoretical;
**Actual APR** adjusts for observed vs. expected blocks; and **Final APR** further reflects a validator’s commission.

By understanding these factors, ZIGChain users can make informed staking decisions for maximum profitability.
