---
sidebar_position: 4
---

# Gas Fees

In ZIGChain a small fee is paid upfront for each transaction. This small fee is commonly known as the **Gas Fee**.

The Gas Fee is a mechanism that:

1. Ensures transactions do **not consume too many resources**.
2. **Prevents spam** on the network.
3. Ensures the network **has reliable validators**, and they get compensated for their work.

So, users are charged a small amount of $ZIG as a gas fee on every transaction (charged to the sender of the message). The amount of the Gas Fee depends on the Gas Units required to perform the transaction and the Gas Price.

Usually the Gas Fee is expressed in uZIG, which is the smallest unit of ZIGChain.

[//]: # "```"
[//]: # "1 uZIG = 0.000001 ZIG"
[//]: # "1,000,000 uZIG = 1 ZIG"
[//]: # "```"

The topics covered in this document are:

- Core Components of Gas Fees
- Paying options
- Common reasons for failed transactions
- Paying more fees to go faster?

<div class="spacer"></div>

## Core Components of Gas Fees

- **Gas Units** are based on the computational effort or how much work will be required to execute the transaction's code. This is calculated on the server. A metaphor can be the fuel amount that your car uses to take you from one city to another.

- **Gas Limit** is the maximum amount of gas a user is willing to spend on a transaction, set when creating the transaction in their wallet. It is normally set to auto, adjusting to match the required Gas Units.Think of it as setting a maximum fuel budget that you are willing to spend to go from one city to another.

- **Gas Price** is the cost per unit of gas, determined by the network traffic and demand in each block. Similar to the price of fuel per litre.

- **Gas Fee** Is what the user pays, which is

```
Gas Fee = round_up(Gas Limit * Gas Price)
```

Following the metaphor, the Gas Fee is the Total Cost of fuel you will pay to go from one city to another.

<div class="spacer"></div>

## Payment Options

When creating a transaction, users must set a combination of two parameters:

1. **Gas Price** or **Gas Fees** (one of them).
2. **Gas Limit** as the maximum execution gas.

You can set either **Gas Price** and **Gas Limit** or **Gas Fees** and **Gas Limit**, but not all three simultaneously.

**Note:** It is common to set a Gas Adjustment Rate to ensure that the **Gas Limit** is sufficient to execute the transaction. The Gas Adjustment Rate is a factor that multiplies the **Gas Limit** to ensure successful execution.

[//]: # "This is explained in detail in the Gas Adjustment section [LINK]."

It is important to set the fee correctly because the entire Gas Fee provided will be consumed before executing the transaction.

The validator must execute the transaction regardless of the result, meaning the Gas Fee will be consumed in all the following scenarios:

1. If the transaction is successful, the Gas Fee will be consumed.
2. If the transaction fails, the Gas Fee will be consumed.
3. If the transaction fails because the Gas Fee is insufficient, the Gas Fee will be consumed.
4. If the fee provided is more than required, the remaining Gas Fee will still be consumed.

### Common reasons for failed transactions

There are two cases in which the transaction will fail:

1. If the **Gas Price** provided was less than **min-gas-prices** established by the validators, the transaction could be delayed or failed.
2. If the **Gas Limit** is insufficient, the transaction will fail, and any changes will be rolled back without refunding the Gas Fees.

### Paying more fees to go faster?

In ZIGChain, paying a higher Gas Price will not make the transaction faster. The transaction will be executed in the order that it was received.

Theoretically, if your gas is above the **minimum-gas-prices** of all validators, your transaction may be processed faster since more validators will be willing to include it in their blocks, compared to when it falls below some validators' minimum thresholds.

<div class="spacer"></div>

## References

- Cosmos SDK Gas and Fees: [https://docs.cosmos.network/main/learn/beginner/gas-fees](https://docs.cosmos.network/main/learn/beginner/gas-fees)

- Cosmos SDK Simulation: [https://docs.cosmos.network/main/user/run-node/txs\#simulating-a-transaction](https://docs.cosmos.network/main/user/run-node/txs#simulating-a-transaction)
