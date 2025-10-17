---
sidebar_position: 2
title: Staking APR
---

# Understanding APR Calculation for ZIGChain Staking

When staking assets on ZIGChain, one of the most important factors to consider is the **Annual Percentage Rate (APR)**, as it determines the efficiency and profitability of staking. Staking rewards on ZIGChain will include both income from inflation and transaction gas fee distribution. This article explains how APR will be calculated for ZIGChain, breaking down key concepts such as **community tax, bonded tokens ratio, and the difference between nominal and actual APR**.

<div class="spacer"></div>

## What is APR in ZIGChain Staking?

For users staking on ZIGChain, APR reflects the interest earned on bonded assets over a year. The calculation involves calculating Nominal APR first. While the **Nominal APR** is derived from the formula below, the **Actual APR** accounts for real network conditions, such as block-minting speed and validator commissions. We will first calculate the Nominal APR and then the Actual APR.

**Nominal APR = (Inflation Rate × (1 - Community Tax)) / Bonded Tokens Ratio**

This formula determines the staking rewards distributed across validators and delegators. 

To fully grasp the APR calculation, it is essential to understand the following parameters:

* **Community tax** is a small portion of staking rewards allocated for network development and governance. You can find out more about community tax [here](https://docs.zigchain.com/build/distribution-module).  
* **Bonded tokens ratio** is the percentage of total ZIG tokens that are actively staked. For example, if ZIGChain has a total supply of 10 million tokens and 8 million are staked, the bonded tokens ratio would be **80%**. This ratio directly impacts APR since only staked tokens receive rewards.  
* **Inflation rate** is the percentage of tokens issued annually relative to the existing total supply.

<div class="spacer"></div>

## Actual Staking APR on ZIGChain

Now let's calculate **actual APR** accounting for real network conditions, such as block-minting speed and validator commissions.

**Actual Staking APR = Nominal APR × (Observed Blocks per Year / Expected Blocks per Year)**

Factors affecting actual APR:

1. **Block time variations** – The real-time minting of blocks may differ from expected values due to network adjustments or upgrades.  
2. **Validator commissions** – Validators charge a commission on rewards before distributing them to delegators.

The final staking APR is calculated as:

**Final APR = Actual Staking APR × (1 - Validator's Commission)**

Since validator commissions vary, users can optimize their staking rewards by selecting validators with lower fees. However, commission rates aren't the only factor to consider. When selecting a validator, it's also important to evaluate, among other factors:

* **Reliability & Performance** – Look for validators with high uptime and a secure infrastructure to ensure consistent rewards.  
* **Governance Participation** – Choose validators actively involved in network decisions, especially those whose values align with yours.  
* **Decentralization** – Supporting a diverse set of validators helps strengthen the network's security and resilience.

<div class="spacer"></div>

## Example

Below is a numeric example of how APR might be calculated on ZIGChain, reflecting the [Mint Module](https://docs.zigchain.com/build/mint-module) parameters.

### Example Parameters

1. **Total Supply**: 100,000,000 ZIG  
2. **Chosen Inflation Rate**: 2%  
3. **Community Tax**: 2%  
4. **Bonded Tokens Ratio**: 20%  
5. **Blocks per Year**: 12,614,400  
6. **Observed Blocks per Year**: 12,000,000  
7. **Validator Commission**: 5%

### Step-by-Step Calculation

1. **Nominal APR (Ignoring Actual Block Production)**

```
Nominal APR = (Inflation Rate × (1 - Community Tax)) / Bonded Tokens Ratio
            = (0.02 × (1 - 0.02)) / 0.20
            = 0.098 (i.e., 9.8%)
```

2. **Adjust for Real Block Production**

```
Ratio of Actual to Target Blocks = (Observed Blocks per Year / blocks_per_year)
                                = 12,000,000 / 12,614,400
                                ≈ 0.9513
```

3. **Calculate Actual APR**

```
Actual APR = Nominal APR × Ratio of Actual to Target Blocks
           = 9.8% × 0.9513
           ≈ 9.3%
```

4. **Subtract Validator Commission**

```
Final APR = Actual APR × (1 - Validator Commission)
          = 9.3% × (1 - 0.05)
          = 8.8%
```

### Final Result

* **Nominal APR**: 9.8%  
* **Actual APR** (block-time adjusted): 9.3%  
* **Final APR** (after 5% commission): 8.8%

<div class="spacer"></div>

## Conclusion

ZIGChain's staking APR estimates staking rewards based on inflation and staking participation. While nominal APR gives a theoretical interest rate, the actual APR is slightly lower due to factors like block time fluctuations and validator commissions. Additionally, transaction fees may further increase rewards beyond the calculated APR.

By understanding these factors, ZIGChain users can make informed staking decisions for maximum profitability.

