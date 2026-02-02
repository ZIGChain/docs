---
title: DEX (Decentralized Exchange)
description: Complete guide to ZIGChain DEX module for decentralized token trading, liquidity pools, constant product market maker model, swaps, and pool management.
keywords:
  [
    ZIGChain DEX module,
    decentralized exchange ZIGChain,
    liquidity pools ZIGChain,
    trade tokens ZIGChain,
    ZIGChain token swap,
    ZIGChain DeFi platform for investors,
    ZIGChain DeFi & RWA ecosystem,
  ]
sidebar_position: 4
---

# DEX (Decentralized Exchange)

The DEX module enables decentralized token trading on the blockchain, allowing users to swap tokens directly from their
wallets without a centralized intermediary.

Each trading pair can have only one liquidity pool, created by providing a base token and a quote token (2 tokens only).

It operates using a constant product market maker model, which means that the product of the reserves of the two tokens
in the pool remains constant. This allows for efficient price discovery and liquidity provision.

## Overview

The DEX module facilitates token trading through liquidity pools.
Each pool maintains a constant product of its token reserves, defined by the formula:

```
x * y = k
```

where `x` and `y` are the reserves of the base and quote tokens, and `k` is a constant.
This model ensures that trades adjust token prices based on supply and demand.

## Features

The DEX module supports the following operations:

- **Create a pool**: Create a new liquidity pool for trading two tokens.
- **Swap tokens**: Swap one token for another, specifying either the incoming or the outgoing token amount.
- **Add liquidity**: Add liquidity to an existing pool by sending in base and quote tokens.
- **Remove liquidity**: Remove liquidity from an existing pool by redeeming LP tokens.
- **Update parameters**: Modify module parameters.

## Create a pool

Creates a new liquidity pool for trading two tokens by providing a base token and a quote token.
An optional receiver address can be specified to receive the LP tokens; otherwise, they default to the sender's address.

### Input

- `base`: The base token to be used in the pool (e.g. `1000000000000000000coin.zig18dtlqe2kqrcyva3th98akycm2560wet6wg992c.pandace`).
- `quote`: The quote token to be used in the pool (e.g. `4000000000000000000uzig`).
- `receiver`: (optional) The address that will receive the LP tokens representing their share in the pool.
  Defaults to the sender's address if not provided.

### Verifications

1. Ensure no existing pool for the same base and quote token pair.
2. Verify that the sender has sufficient balances of the base token, quote token, and uzig for transaction fees.

### LP Token Calculation

The number of LP tokens minted is calculated using the constant product formula:

```
lp_token = sqrt(base_amount * quote_amount)
```

where `base_amount` and `quote_amount` are the amounts of the base and quote tokens sent in the transaction.

### Process

- The pool is assigned a unique, sequentially generated ID (e.g., `zp1`).
- LP tokens are minted and sent to the receiver address (or sender's address if the receiver is not specified).
- The pool's reserves are updated with the provided tokens.

### CLI Command: create-pool

To create a pool using the CLI, you can use the following command:

```bash
zigchaind tx dex create-pool [base] [quote] --receiver (optional)
```

Example:

```bash
zigchaind tx dex create-pool \
1000000000000000000coin.zig18dtlqe2kqrcyva3th98akycm2560wet6wg992c.pandace 4000000000000000000uzig \
--receiver zig1umu42jmf3ln3f32d0zxpj5gngnw6422w72ma7m
--gas auto --gas-adjustment 1.5 --gas-prices 0.025uzig -y
```

### Message: MsgCreatePool

```go
// MsgCreatePool creates pool message needs base and token
message MsgCreatePool {
  option (cosmos.msg.v1.signer) = "creator";
  string creator = 1;
  cosmos.base.v1beta1.Coin base = 2 [ (gogoproto.nullable) = false ];
  cosmos.base.v1beta1.Coin quote = 3 [ (gogoproto.nullable) = false ];
  string receiver = 4;
}
```

### Event: pool_created

When a pool is created, the `pool_created` event is emitted. This event contains the following attributes:

```json
{
  "attributes": [
    {
      "index": true,
      "key": "module",
      "value": "dex"
    },
    {
      "index": true,
      "key": "sender",
      "value": "{address of the sender (e.g. zig1umu42jmf3ln3f32d0zxpj5gngnw6422w72ma7m)}"
    },
    {
      "index": true,
      "key": "pool_id",
      "value": "{pool_id of the pool (e.g. zp1)}"
    },
    {
      "index": true,
      "key": "token_in",
      "value": "{tokens sent in (e.g. 100coin.zig18dtlqe2kqrcyva3th98akycm2560wet6wg992c.pandace,400coin.zig18dtlqe2kqrcyva3th98akycm2560wet6wg992c.quotece)}"
    },
    {
      "index": true,
      "key": "lp_token_out",
      "value": "{lp token received (e.g. 20000zp1)}"
    },
    {
      "index": true,
      "key": "receiver",
      "value": "{address of the receiver (e.g. zig1umu42jmf3ln3f32d0zxpj5gngnw6422w72ma7m)}"
    },
    {
      "index": true,
      "key": "pool_address",
      "value": "{address of the pool (e.g. zig1umu42jmf3ln3f32d0zxpj5gngnw6422w72ma7m)}"
    },
    {
      "index": true,
      "key": "msg_index",
      "value": "0"
    }
  ],
  "type": "pool_created"
}
```

## Swap Tokens

Swap one token for another in a liquidity pool, where the incoming token amount is specified and the outgoing token amount is determined
by the pool's exchange rate. The swap can fail if the minimum outgoing token amount is not met.
An optional receiver address can be provided; otherwise, the swapped tokens are sent to the sender's address.

It is possible to swap tokens in two ways:

- Specifying the incoming token amount (`Swap Exact In`).
- Specifying the outgoing token amount (`Swap Exact Out`).

### Swap Exact In

Swaps a specified amount of input tokens for an output amount determined by the pool's exchange rate.
The swap fails if the minimum output amount is not met.

#### Verifications

1. Verify that the sender has sufficient balance of the incoming token and zig for the fees to execute the swap.
2. Ensure that the minimum outgoing token amount is met, otherwise the transaction fails.

#### Calculation

To calculate the outgoing token amount, the DEX module uses the constant product formula:

```
# 1. Calculate the constant product:
x * y = k

# 2. Calculate the fee
fee = (in_amount * swap_fee) / scaling_factor

# 3. Calculate the amount in without the fee
in_after_fee = in_amount - fee

# 4. New reserve after incoming token
new_reserve_in = reserve_in + in_after_fee

# 5. Calculate the outgoing token amount
out_amount = reserve_out - (k / new_reserve_in)
```

where `reserve_in` and `reserve_out` are the pool's reserves of the incoming and outgoing tokens, respectively.

Example:
If the pool has 10,000 base tokens and 100,000 quote tokens, and the swap fee is 500 (which is equivalent of 0.5%),
and the sender wants to swap 1,000 base tokens, the calculation would be:

```
# 1. Calculate the constant product:
k = 10000 * 100000 = 1000000000

# 2. Calculate the fee
fee = (1000 * 500) / 100000 = 5

# 3. Calculate the amount in without the fee
in_after_fee = 1000 - 5 = 995

# 4. New reserve after incoming token
new_reserve_in = 10000 + 995 = 10995

# 5. Calculate the outgoing token amount
out_amount = 100000 - (1000000000 / 10995) = 9090.91 ~= 9090
```

#### CLI Command: swap-exact-in

To swap tokens specifying the incoming amount using the CLI, you can use the following command:

```bash
zigchaind tx dex swap-exact-in [pool-id] [token] --receiver (optional) --outgoing-min (optional)
```

Example:

```bash
zigchaind tx dex swap-exact-in 100coin.zig18dtlqe2kqrcyva3th98akycm2560wet6wg992c.pandace zp1 \
--receiver zig1umu42jmf3ln3f32d0zxpj5gngnw6422w72ma7m \
--outgoing-min 36coin.zig18dtlqe2kqrcyva3th98akycm2560wet6wg992c.quotece \
--gas auto --gas-adjustment 1.5 --gas-prices 0.025uzig -y
```

#### Message: MsgSwapExactIn

Message to swap tokens specifying the incoming amount.

```go
// MsgSwap swaps tokens from one to another
message MsgSwapExactIn {
  option (cosmos.msg.v1.signer) = "signer";
  string signer = 1;
  cosmos.base.v1beta1.Coin incoming = 2 [ (gogoproto.nullable) = false ];
  string pool_id = 3;
  // receiver is optional the address that will receive the swapped token, if
  // not provided it goes to sender
  string receiver = 4;
  // outgoing_min is the minimum amount of outgoing token to receive, or swap
  // will fail
  cosmos.base.v1beta1.Coin outgoing_min = 5 [ (gogoproto.nullable) = true ];
}
```

#### Event: token_swapped

When a swap is executed, the `token_swapped` event is emitted.

```json
{
  "attributes": [
    {
      "index": true,
      "key": "module",
      "value": "dex"
    },
    {
      "index": true,
      "key": "sender",
      "value": "{address of the sender (e.g. zig1umu42jmf3ln3f32d0zxpj5gngnw6422w72ma7m)}"
    },
    {
      "index": true,
      "key": "receiver",
      "value": "{address of the receiver (e.g. zig1umu42jmf3ln3f32d0zxpj5gngnw6422w72ma7m)}"
    },
    {
      "index": true,
      "key": "pool_id",
      "value": "{pool_id of the pool (e.g. zp1)}"
    },
    {
      "index": true,
      "key": "token_in",
      "value": "{tokens sent in (e.g. 100coin.zig18dtlqe2kqrcyva3th98akycm2560wet6wg992c.pandace,400coin.zig18dtlqe2kqrcyva3th98akycm2560wet6wg992c.quotece)}"
    },
    {
      "index": true,
      "key": "token_out",
      "value": "{tokens received (e.g. 36coin.zig18dtlqe2kqrcyva3th98akycm2560wet6wg992c.quotece)}"
    },
    {
      "index": true,
      "key": "swap_fee",
      "value": "{swap fee charged (e.g. 1coin.zig18dtlqe2kqrcyva3th98akycm2560wet6wg992c.quotece)}"
    },
    {
      "index": true,
      "key": "pool_snapshot",
      "value": "{tokens in the pool after the swap (e.g. 10110coin.zig18dtlqe2kqrcyva3th98akycm2560wet6wg992c.pandace,40364coin.zig18dtlqe2kqrcyva3th98akycm2560wet6wg992c.quotece,20200zp1)}"
    },
    {
      "index": true,
      "key": "msg_index",
      "value": "0"
    }
  ],
  "type": "token_swapped"
}
```

### Swap Exact Out

Swaps tokens by specifying the desired outgoing token amount. The incoming token amount is determined by the pool's exchange rate,
and the swap fails if the maximum incoming token amount is exceeded.

#### Verifications

1. Confirm the sender has sufficient balance of the input token and uzig for fees.
2. Ensure the input amount does not exceed the specified maximum; otherwise, the transaction fails.

#### CLI Command: swap-exact-out

To swap tokens specifying the outgoing amount using the CLI, you can use the following command:

```bash
zigchaind tx dex swap-exact-out [pool-id] [token] --receiver (optional) --incoming-max (optional)
```

Example:

```bash
zigchaind tx dex swap-exact-out 36coin.zig18dtlqe2kqrcyva3th98akycm2560wet6wg992c.quotece zp1 \
--receiver zig1umu42jmf3ln3f32d0zxpj5gngnw6422w72ma7m \
--incoming_max 100coin.zig18dtlqe2kqrcyva3th98akycm2560wet6wg992c.pandace \
--gas auto --gas-adjustment 1.5 --gas-prices 0.025uzig -y
```

#### Message: MsgSwapExactOut

Message to swap tokens specifying the outgoing amount.

```go
// MsgSwap swaps tokens from one to another
message MsgSwapExactOut {
  option (cosmos.msg.v1.signer) = "signer";
  string signer = 1;
  cosmos.base.v1beta1.Coin outgoing = 2 [ (gogoproto.nullable) = false ];
  string pool_id = 3;
  // receiver is optional the address that will receive the swapped token, if
  // not provided it goes to sender
  string receiver = 4;
  // incoming_max is the maximum amount of incoming token to pay, or swap will
  // fail noinspection ProtoFieldName
  cosmos.base.v1beta1.Coin incoming_max = 5 [ (gogoproto.nullable) = true ];
}
```

#### Event: token_swapped

When a swap is executed, the `token_swapped` event is emitted.
The event is the same as for swap exact in [token_swapped event](#event-token_swapped).

## Add Liquidity

Adds liquidity to an existing pool by contributing base and quote tokens. LP tokens are minted and sent to the receiver
address (or sender if not specified). The token amounts must match the pool's current ratio; excess tokens are refunded.

### Verifications:

1. Confirm the pool exists for the specified pool_id.
2. Verify the sender has sufficient balances of the base token, quote token, and uzig for fees to add liquidity.
3. Ensure the ratio of base to quote tokens matches the pool's ratio within, otherwise the transaction will fail.
   If the ratio does not match, but it is within a threshold, the excess tokens will be returned to the sender.

Once all verifications pass:

- The base and quote tokens are transferred from the sender to the pool.
- The LP tokens are sent to the receiver's address (or the sender's address if the receiver is not provided).
- If any excess tokens are sent that do not match the pool's ratio, they will be returned to the sender.
- The pool's reserves are updated to reflect the new amounts of base and quote tokens.

### LP Token Calculation

The constant formula determines the number of LP tokens created:

```
1. Calculate the liquidity pool amount based on the existing pool reserves and the base and quote tokens sent in to check
the minimum amount of LP tokens to be created:
lp_token_with_base = (base_amount * pool_quote_reserve) / pool_base_reserve
lp_token_with_quote = (quote_amount * pool_base_reserve) / pool_quote_reserve

2. The LP tokens created will be the minimum of the two amounts calculated above:
lp_token = min(lp_token_with_base, lp_token_with_quote)

3. Assuming lp_token_with_base is the minimum. We calculate the amount of base and quote tokens that will be added to the pool:
base_added = base_amount
quote_added = base_amount / pool_ratio
```

### CLI Command: add-liquidity

To add liquidity to a pool using the CLI, you can use the following command:

```bash
zigchaind tx dex add-liquidity [pool_id] [base] [quote] --receiver (optional)
```

Example:

```bash
zigchaind tx dex add-liquidity zp1 \
1000000000000000000coin.zig18dtlqe2kqrcyva3th98akycm2560wet6wg992c.pandace 4000000000000000000uzig \
--receiver zig1umu42jmf3ln3f32d0zxpj5gngnw6422w72ma7m \
--gas auto --gas-adjustment 1.5 --gas-prices 0.025uzig -y
```

### Message: MsgAddLiquidity

Message to add liquidity to a pool by sending in base and quote tokens.

```go
// MsgAddLiquidity adds liquidity to the pool, from the base and quote tokens
// send in
message MsgAddLiquidity {
  option (cosmos.msg.v1.signer) = "creator";
  string creator = 1;
  string pool_id = 2;
  cosmos.base.v1beta1.Coin base = 3 [ (gogoproto.nullable) = false ];
  cosmos.base.v1beta1.Coin quote = 4 [ (gogoproto.nullable) = false ];
  string receiver = 5;
}
```

### Event: liquidity_added

When liquidity is added to a pool, the `liquidity_added` event is emitted. This event contains the following attributes:

```json
{
  "attributes": [
    {
      "index": true,
      "key": "module",
      "value": "dex"
    },
    {
      "index": true,
      "key": "sender",
      "value": "{address of the sender (e.g. zig1umu42jmf3ln3f32d0zxpj5gngnw6422w72ma7m)"
    },
    {
      "index": true,
      "key": "pool_id",
      "value": "{pool_id of the pool (e.g. zp1)}"
    },
    {
      "index": true,
      "key": "token_in",
      "value": "{tokens sent in (e.g. 100coin.zig18dtlqe2kqrcyva3th98akycm2560wet6wg992c.pandace,400coin.zig18dtlqe2kqrcyva3th98akycm2560wet6wg992c.quotece)}"
    },
    {
      "index": true,
      "key": "lp_token_out",
      "value": "{lp token received (e.g. 20000zp1)}"
    },
    {
      "index": true,
      "key": "returned_coins",
      "value": "{returned coins for not matching the liquidity pool (e.g. 100coin.zig18dtlqe2kqrcyva3th98akycm2560wet6wg992c.pandace,400coin.zig18dtlqe2kqrcyva3th98akycm2560wet6wg992c.quotece)}"
    },
    {
      "index": true,
      "key": "pool_snapshot",
      "value": "{tokens in the pool after adding liquidity (e.g. 10110coin.zig18dtlqe2kqrcyva3th98akycm2560wet6wg992c.pandace,40364coin.zig18dtlqe2kqrcyva3th98akycm2560wet6wg992c.quotece,20200zp1)}"
    },
    {
      "index": true,
      "key": "receiver",
      "value": "{address of the receiver (e.g. zig1umu42jmf3ln3f32d0zxpj5gngnw6422w72ma7m)}"
    },
    {
      "index": true,
      "key": "msg_index",
      "value": "0"
    }
  ],
  "type": "liquidity_added"
}
```

## Remove Liquidity

Removes liquidity from an existing pool by redeeming LP tokens.
The withdrawn tokens are sent to the receiver address (or sender if not specified).

### Verifications

1. Confirm the pool exists for the specified pool_id.
2. Verify the sender has sufficient LP tokens and uzig for fees.
3. Calculate the proportion of base and quote tokens to withdraw based on the LP tokens provided.

### Process

- Burn the provided LP tokens.
- Transfer the proportional amounts of base and quote tokens to the receiver.
- Update the pool's reserves.

### CLI Command: remove-liquidity

To remove liquidity from a pool using the CLI, you can use the following command:

```bash
zigchaind tx dex remove-liquidity [pool_id] [lptoken] --receiver (optional)
```

Example:

```bash
zigchaind tx dex remove-liquidity zp1 20000zp1 \
--receiver zig1umu42jmf3ln3f32d0zxpj5gngnw6422w72ma7m \
--gas auto --gas-adjustment 1.5 --gas-prices 0.025uzig -y
```

### MsgRemoveLiquidity

Message to remove liquidity from a pool by sending in LP tokens.

```go
// MsgRemoveLiquidity removes liquidity from the pool, from the lptoken send in
message MsgRemoveLiquidity {
  option (cosmos.msg.v1.signer) = "creator";
  string creator = 1;
  cosmos.base.v1beta1.Coin lptoken = 2 [ (gogoproto.nullable) = false ];
  string receiver = 3;
}
```

### Event: liquidity_removed

When liquidity is removed from a pool, the `liquidity_removed` event is emitted. This event contains the following attributes:

```json
{
  "attributes": [
    {
      "index": true,
      "key": "module",
      "value": "dex"
    },
    {
      "index": true,
      "key": "sender",
      "value": "{address of the sender (e.g. zig1umu42jmf3ln3f32d0zxpj5gngnw6422w72ma7m)}"
    },
    {
      "index": true,
      "key": "pool_id",
      "value": "{pool_id of the pool (e.g. zp1)}"
    },
    {
      "index": true,
      "key": "lp_token_in",
      "value": "{lp token sent in (e.g. 20000zp1)}"
    },
    {
      "index": true,
      "key": "token_out",
      "value": "{tokens received (e.g. 100coin.zig18dtlqe2kqrcyva3th98akycm2560wet6wg992c.pandace,399coin.zig18dtlqe2kqrcyva3th98akycm2560wet6wg992c.quotece)}"
    },
    {
      "index": true,
      "key": "pool_snapshot",
      "value": "{tokens in the pool after the removing liquidity (e.g. 110110coin.zig18dtlqe2kqrcyva3th98akycm2560wet6wg992c.pandace,40364coin.zig18dtlqe2kqrcyva3th98akycm2560wet6wg992c.quotece,20200zp1)}"
    },
    {
      "index": true,
      "key": "receiver",
      "value": "{address of the receiver (e.g. zig1umu42jmf3ln3f32d0zxpj5gngnw6422w72ma7m)}"
    },
    {
      "index": true,
      "key": "msg_index",
      "value": "0"
    }
  ],
  "type": "liquidity_removed"
}
```

## Update Parameters

Updates the DEX module's parameters, such as fees or other configurations. This operation is restricted to the authority
address specified in the module's configuration. All parameters must be provided, as partial updates are not supported.

### Message: MsgUpdateParams

Message to update the DEX module parameters.

```go
// MsgUpdateParams is the Msg/UpdateParams request type.
message MsgUpdateParams {
  option (cosmos.msg.v1.signer) = "authority";
  option (amino.name) = "zigchain/x/dex/MsgUpdateParams";

  // authority is the address that controls the module (defaults to x/gov unless
  // overwritten).
  string authority = 1 [ (cosmos_proto.scalar) = "cosmos.AddressString" ];

  // params defines the module parameters to update.

  // NOTE: All parameters must be supplied.
  Params params = 2
      [ (gogoproto.nullable) = false, (amino.dont_omitempty) = true ];
}
```
