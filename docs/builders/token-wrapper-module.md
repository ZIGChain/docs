---
title: Token Wrapper
description: Technical documentation for ZIGChain Token Wrapper module enabling IBC bridging between Axelar and ZIGChain, ERC20 to native ZIG conversion, and decimal precision handling.
keywords:
  [
    ZIGChain Token Wrapper Module,
    ZIGChain IBC channels,
    IBC transfer ZIGChain,
    ZIGChain cross-chain bridge,
    bridge tokens to ZIGChain,
    ZIGChain cross-chain interoperability,
    Cosmos interoperability,
    ZIGChain cross-chain communication,
    ERC-20 to ZIGChain transfer,
  ]
sidebar_position: 4
---

# Token Wrapper - IBC Bridging for ZIG Tokens

The Token Wrapper module is a crucial part of the ZIGChain blockchain that facilitates the bridging between Axelar ZIG tokens (originating from ERC20 ZIG tokens) and native ZIG tokens through IBC (Inter-Blockchain Communication).

## Purpose

The module serves as a bridge between Axelar and ZIGChain, enabling seamless token transfers between ERC20 ZIG tokens on Ethereum and native ZIG tokens on ZIGChain via Axelar, while maintaining proper token wrapping and unwrapping mechanisms.

## Core Functionality

### 1. IBC Token Bridging

- When IBC transfers occur from Axelar to ZIGChain:

  - IBC vouchers are locked within the module wallet
  - The module releases an equivalent amount of native ZIG tokens to the ZIGChain recipient address
  - Token amounts are scaled down from Axelar's 18-decimal precision to ZIGChain's 6-decimal precision
  - **Minimum Transfer Threshold**: Due to the decimal conversion (division by 10^12), transfers that would result in less than 1 native ZIG token (after conversion) are rejected. This is because the division rounds down, and amounts less than the conversion factor would result in zero tokens.

- When native ZIG tokens are sent via IBC to an Axelar address:
  - Native tokens are locked in the module wallet
  - IBC vouchers are released and sent to the Axelar recipient address
  - Token amounts are scaled up from ZIGChain's 6-decimal precision to Axelar's 18-decimal precision

### 2. IBC Escrow and Voucher Mechanism

The module implements the IBC fungible token transfer protocol (ICS-20) with specific handling of escrow and voucher mechanisms:

#### Escrow Mechanism

- When tokens are sent from Axelar to ZIGChain:
  - The source chain (Axelar) escrows the original tokens in a special escrow account
  - The escrow account is derived from the IBC channel and port identifiers
  - This ensures tokens cannot be double-spent while in transit
  - The escrow is released only when the transfer is acknowledged or timed out

#### Voucher Burning

- When tokens are sent back to Axelar:
  - The IBC vouchers on ZIGChain are burned (destroyed)
  - This burning action signals the source chain (Axelar) to release the escrowed tokens
  - The burning mechanism ensures the total supply remains constant across chains
  - This follows the ICS-20 specification for maintaining token fungibility

**Key Mechanism: Burning and Unescrowing**

- Burning IBC vouchers on ZIGChain is directly tied to the IBC packet that instructs Axelar to unescrow the original tokens

```go
im.keeper.BurnIbcTokens(ctx, ibcCoins)
```

- These operations are atomic - both must succeed or both fail
- The IBC packet contains the information needed to release the correct amount of escrowed tokens

```go
im.unescrowToken(ctx, escrowAddress, sender, nativeCoins[0])
```

For more details on the IBC fungible token transfer protocol, refer to the [ICS-20 specification](https://github.com/cosmos/ibc/blob/main/spec/app/ics-020-fungible-token-transfer/README.md#packet-relay).

### 3. IBC Middleware Integration

The module implements IBC middleware hooks:

- `OnRecvPacket`: Handles incoming IBC packets and manages token wrapping
- `SendPacket`: Manages outgoing IBC packets and handles token unwrapping

Here is a more detailed diagram of the IBC middleware integration:

![IBC Middleware Integration](./img/token_wrapper/ibc_middleware_integration.png)

### 4. Operator Controls

An operator address has the following capabilities:

- Set IBC native and counterparty port, channel, and denom for Axelar-ZIGChain communication
- Configure the `decimal_difference` parameter to manage token scaling between chains
- Enable/disable the module in case of IBC channel anomalies
- Fund the module wallet with native ZIG tokens
- Withdraw excess tokens from the module wallet
- Manage pauser addresses (add/remove)

## Governance and Operator Roles

The module implements a dual-role system for managing module parameters and operations:

### Governance Role

- The module includes a standard governance interface (`MsgUpdateParams`) that follows the Cosmos SDK pattern
- The governance authority (typically the x/gov module account) has permission to update module parameters
- Currently, the `Params` struct is empty as all operational parameters are managed through the operator role
- This design maintains compatibility with the Cosmos SDK governance pattern while allowing for future parameter additions

### Operator Role

The operator role has direct control over operational parameters through dedicated message types:

#### Operator Transfer Process

The operator transfer process is a two-step operation to ensure security:

1. **Propose Operator Address**:

   - Only the current operator can propose a new operator address
   - The proposed operator address is stored in state
   - The current operator retains their role and can still:
     - Perform all operator operations
     - Propose a different operator address (overwriting the previous proposal)
   - This step can be executed using the `ProposeOperatorAddress` message

2. **Claim Operator Address**:
   - Only the proposed operator can claim the role
   - The role is transferred to the new operator
   - The proposed operator address is cleared from state
   - The previous operator loses their privileges
   - This step can be executed using the `ClaimOperatorAddress` message

#### Pauser Management

The module implements a pauser role system for emergency control:

1. **Pauser Capabilities**:

   - Pausers can only execute the `MsgDisableTokenWrapper` message
   - This allows them to disable the token wrapper functionality in emergency situations
   - Multiple pauser addresses can be set simultaneously

2. **Pauser Management**:

   - Only the operator can add or remove pauser addresses
   - The operator can manage multiple pauser addresses
   - This provides a distributed emergency control mechanism
   - Pausers can be added or removed at any time by the operator

3. **Use Cases**:
   - Emergency response to security incidents
   - Temporary suspension of token wrapping functionality
   - Distributed control over critical module functions

#### Other Operator Controls

- `MsgEnableTokenWrapper`: Enable the token wrapper functionality
- `MsgDisableTokenWrapper`: Disable the token wrapper functionality
- `MsgUpdateIbcSettings`: Update IBC-related parameters (client IDs, ports, channels, etc.)
- `MsgFundModuleWallet`: Fund the module wallet with native tokens
- `MsgWithdrawFromModuleWallet`: Withdraw excess tokens from the module wallet
- `MsgAddPauserAddress`: Add a new pauser address
- `MsgRemovePauserAddress`: Remove a pauser address
- `MsgProposeOperatorAddress`: Propose a new operator

This separation of concerns allows for:

1. Governance control over high-level module parameters (when needed)
2. Efficient operational management through the operator role
3. Clear distinction between governance-level and operational-level changes
4. Emergency control through distributed pauser addresses

## Module Wallet Management

The module wallet requires sufficient balances of:

- Native ZIG tokens
- IBC vouchers

To maintain proper bridging functionality, the operator can:

- Fund the module wallet with native ZIG tokens
- Withdraw excess tokens when necessary
- Monitor wallet balances and token flows

## Features

### Add Pauser Address

Through the `MsgAddPauserAddress`, the Token Wrapper Operator can whitelist an address to pause the Token Wrapper.

**Inputs:**

- `new_pauser`: new pauser address (e.g. zig1umu42jmf3ln3f32d0zxpj5gngnw6422w72ma7m).

**Verifications:**

1. Check that signer is the Token Wrapper Operator
2. Check that new_pauser address provided is valid

**State updates:**

1. Add the new pauser address to the list of pauser addresses

Once the address is added, the [pauser_address_added event](#event-pauser_address_added) is emitted.

#### Message: MsgAddPauserAddress

```go
// MsgAddPauserAddress represents a message to add a new pauser address
message MsgAddPauserAddress {
    option (cosmos.msg.v1.signer) = "signer";
    option (amino.name) = "zigchain/x/tokenwrapper/MsgAddPauserAddress";

    string signer = 1;
    string new_pauser = 2;
}
```

#### Response Message: MsgAddPauserAddressResponse

```go
message MsgAddPauserAddressResponse {
    string signer = 1 [ (cosmos_proto.scalar) = "cosmos.AddressString" ];
    repeated string pauser_addresses = 6
    [ (cosmos_proto.scalar) = "cosmos.AddressString" ];
}
```

#### Event: pauser_address_added

Example of the `pauser_address_added` event emitted when a new pauser address is added:

```json
{
  "attributes": [
    {
      "index": true,
      "key": "pauser_address",
      "value": "zig1umu42jmf3ln3f32d0zxpj5gngnw6422w72ma7m"
    },
    {
      "index": true,
      "key": "msg_index",
      "value": "0"
    }
  ],
  "type": "pauser_address_added"
}
```

### Claim Operator Address

Through the `MsgClaimOperatorAddress`, the new proposed operator gets the Token Wrapper Operator Role. This is the second step in the Token Wrapper Operator transfer process.

**Inputs:**
None

**Verifications:**

1. Check that there is an address proposed as new operator.
2. Check that the signer address matches the proposed operator address.

**State updates:**

1. Update the Token Wrapper Operator Address to the new proposed operator.
2. Clear the proposed operator address

Once the Token Wrapper Operator address is updated, the [operator_address_claimed event](#event-operator_address_claimed) is emitted.

#### Message: MsgClaimOperatorAddress

```go
// MsgClaimOperatorAddress represents a message to claim the operator role
message MsgClaimOperatorAddress {
    option (cosmos.msg.v1.signer) = "signer";
    option (amino.name) = "zigchain/x/tokenwrapper/MsgClaimOperatorAddress";

    string signer = 1 [ (cosmos_proto.scalar) = "cosmos.AddressString" ];
}
```

#### Response Message: MsgClaimOperatorAddressResponse

```go
message MsgClaimOperatorAddressResponse {
string signer = 1 [ (cosmos_proto.scalar) = "cosmos.AddressString" ];
string operator_address = 2
[ (cosmos_proto.scalar) = "cosmos.AddressString" ];
}
```

#### Event: operator_address_claimed

Example of the `operator_address_claimed` event emitted when the new operator claims the role:

```json
{
  "attributes": [
    {
      "index": true,
      "key": "old_operator",
      "value": "zig1umu42jmf3ln3f32d0zxpj5gngnw6422w72ma7m"
    },
    {
      "index": true,
      "key": "new_operator",
      "value": "zig1d7j35kdlwchfa8ch0f9f52vteh0hxwx0etxwjw"
    },
    {
      "index": true,
      "key": "msg_index",
      "value": "0"
    }
  ],
  "type": "operator_address_claimed"
}
```

### Disable Token Wrapper

Through the `MsgDisableTokenWrapper`, the Token Wrapper operator or any of the pauser addresses can stop the Token Wrapper Module.

**Inputs:**
None

**Verifications:**

1. Check that the signer is either the Token Wrapper operator or one of the pauser addresses.

**State updates:**

1. Change the status of the Token Wrapper to Pause / Disable.

While the token wrapper is disabled the transfers matching the settings will not be effective. Once the Token Wrapper is set up as disabled, the [tokenwrapper_disabled event](#event-tokenwrapper_disabled) is emitted.

#### Message: MsgDisableTokenWrapper

```go
// MsgDisableTokenWrapper represents a message to disable the token wrapper
// functionality
message MsgDisableTokenWrapper {
    option (cosmos.msg.v1.signer) = "signer";
    option (amino.name) = "zigchain/x/tokenwrapper/MsgDisableTokenWrapper";

    string signer = 1 [ (cosmos_proto.scalar) = "cosmos.AddressString" ];
}
```

#### Response Message: MsgDisableTokenWrapperResponse

```go
message MsgDisableTokenWrapperResponse {
    string signer = 1 [ (cosmos_proto.scalar) = "cosmos.AddressString" ];
    bool enabled = 2;
}
```

#### Event: tokenwrapper_disabled

Example of the `tokenwrapper_disabled` event emitted when the token wrapper is disabled:

```json
{
  "attributes": [
    {
      "index": true,
      "key": "signer",
      "value": "zig1umu42jmf3ln3f32d0zxpj5gngnw6422w72ma7m"
    },
    {
      "index": true,
      "key": "msg_index",
      "value": "0"
    }
  ],
  "type": "tokenwrapper_disabled"
}
```

### Enable Token Wrapper

Through the `MsgEnableTokenWrapper`, the Token Wrapper operator can unpause or enable the Token Wrapper Module.

**Inputs:**
None

**Verifications:**

1. Check that the signer is the Token Wrapper operator.

**State updates:**

1. Change the status of the Token Wrapper to Unpause / Enable.

Once the Token Wrapper is set up as enabled, the [tokenwrapper_enabled event](#event-tokenwrapper_enabled) is emitted.

#### Message: MsgEnableTokenWrapper

```go
// MsgEnableTokenWrapper represents a message to enable the token wrapper
// functionality
message MsgEnableTokenWrapper {
    option (cosmos.msg.v1.signer) = "signer";
    option (amino.name) = "zigchain/x/tokenwrapper/MsgEnableTokenWrapper";

    string signer = 1 [ (cosmos_proto.scalar) = "cosmos.AddressString" ];
}
```

#### Response Message: MsgEnableTokenWrapperResponse

```go
message MsgEnableTokenWrapperResponse {
    string signer = 1 [ (cosmos_proto.scalar) = "cosmos.AddressString" ];
    bool enabled = 2;
}
```

#### Event: tokenwrapper_enabled

Example of the `tokenwrapper_enabled` event emitted when the token wrapper is enabled:

```json
{
  "attributes": [
    {
      "index": true,
      "key": "signer",
      "value": "zig1umu42jmf3ln3f32d0zxpj5gngnw6422w72ma7m"
    },
    {
      "index": true,
      "key": "msg_index",
      "value": "0"
    }
  ],
  "type": "tokenwrapper_enabled"
}
```

### Fund Module Wallet

Through the `MsgFundModuleWallet`, the Token Wrapper operator can add funds to the Token Wrapper Module address.

**Inputs:**

- `amount`: amount and token name (e.g. 1000uzig)

**Verifications:**

1. Check that the signer is the Token Wrapper operator.
2. Ensure that the Token Wrapper operator has the amount.

**State updates:**

1. Transfer the funds from the Token Wrapper operator to the Module wallet.

Once the funds are sent, the [module_wallet_funded event](#event-module_wallet_funded) is emitted.

#### Message: MsgFundModuleWallet

```go
message MsgFundModuleWallet {
    option (cosmos.msg.v1.signer) = "signer";
    option (amino.name) = "zigchain/x/tokenwrapper/MsgFundModuleWallet";

    string signer = 1 [ (cosmos_proto.scalar) = "cosmos.AddressString" ];
    repeated cosmos.base.v1beta1.Coin amount = 2 [ (gogoproto.nullable) = false ];
}
```

#### Response Message: MsgFundModuleWalletResponse

```go
message MsgFundModuleWalletResponse {
    string signer = 1 [ (cosmos_proto.scalar) = "cosmos.AddressString" ];
    repeated cosmos.base.v1beta1.Coin amount = 2 [ (gogoproto.nullable) = false ];
    repeated cosmos.base.v1beta1.Coin balances = 3 [ (gogoproto.nullable) = false ];
    string module_address = 4 [ (cosmos_proto.scalar) = "cosmos.AddressString" ];
}
```

#### Event: module_wallet_funded

Example of the `module_wallet_funded` event emitted when the module wallet is funded:

```json
{
  "attributes": [
    {
      "index": true,
      "key": "signer",
      "value": "zig1umu42jmf3ln3f32d0zxpj5gngnw6422w72ma7m"
    },
    {
      "index": true,
      "key": "module_address",
      "value": "zig1hdq87rzf327fwz8rw9rnmchj7qa3uxrpxds2ff"
    },
    {
      "index": true,
      "key": "amount",
      "value": "1000uzig"
    },
    {
      "index": true,
      "key": "balances",
      "value": "1000uzig"
    },
    {
      "index": true,
      "key": "msg_index",
      "value": "0"
    }
  ],
  "type": "module_wallet_funded"
}
```

### Propose Operator Address

Through the `MsgProposeOperatorAddress`, the current Token Wrapper operator can propose a new address to be the new Token Wrapper operator. This is the first step in the Token Wrapper Operator transfer process.

**Inputs:**

- `new_operator`: proposed operator address (e.g. zig1umu42jmf3ln3f32d0zxpj5gngnw6422w72ma7m).

**Verifications:**

1. Check that the signer is the current operator.
2. Check that the new proposed address is valid.
3. Check that the new proposed address is not the current operator address.

**State updates:**

1. Store the new proposed operator address.

Once the new operator address is stored, the [operator_address_proposed event](#event-operator_address_proposed) is emitted.

#### Message: MsgProposeOperatorAddress

```go
// MsgProposeOperatorAddress represents a message to propose a new operator
// address
message MsgProposeOperatorAddress {
    option (cosmos.msg.v1.signer) = "signer";
    option (amino.name) = "zigchain/x/tokenwrapper/MsgProposeOperatorAddress";

    string signer = 1 [ (cosmos_proto.scalar) = "cosmos.AddressString" ];
    string new_operator = 2 [ (cosmos_proto.scalar) = "cosmos.AddressString" ];
}
```

#### Response Message:

```go
message MsgProposeOperatorAddressResponse {
    string signer                    = 1 [ (cosmos_proto.scalar) = "cosmos.AddressString" ];
    string proposed_operator_address = 2 [ (cosmos_proto.scalar) = "cosmos.AddressString" ];
}
```

#### Event: operator_address_proposed

Example of the `operator_address_proposed` event emitted when a new operator address is proposed:

```json
{
  "attributes": [
    {
      "index": true,
      "key": "old_operator",
      "value": "zig15yk64u7zc9g9k2yr2wmzeva5qgwxps6y8c2amk"
    },
    {
      "index": true,
      "key": "new_operator",
      "value": "zig1umu42jmf3ln3f32d0zxpj5gngnw6422w72ma7m"
    },
    {
      "index": true,
      "key": "msg_index",
      "value": "0"
    }
  ],
  "type": "operator_address_proposed"
}
```

### Remove Pauser Address

Through the `MsgRemovePauserAddress`, the Token Wrapper Operator can remove an address from the list of addresses with pause privileges.

**Inputs:**

- `pauser`: pauser address to be removed (e.g. zig1umu42jmf3ln3f32d0zxpj5gngnw6422w72ma7m).

**Verifications:**

1. Check that signer is the Token Wrapper Operator
2. Check that pauser address provided is valid

**State updates:**

1. Remove the pauser address from the list of whitelisted pauser addresses

Once the address is removed, the [pauser_address_removed event](#event-pauser_address_removed) is emitted.

#### Message: MsgRemovePauserAddress

```go
// MsgRemovePauserAddress represents a message to remove a pauser address
message MsgRemovePauserAddress {
    option (cosmos.msg.v1.signer) = "signer";
    option (amino.name) = "zigchain/x/tokenwrapper/MsgRemovePauserAddress";

    string signer = 1;
    string pauser = 2;
}
```

#### Response Message: MsgRemovePauserAddressResponse

```go
message MsgRemovePauserAddressResponse {
    string signer = 1 [ (cosmos_proto.scalar) = "cosmos.AddressString" ];
    repeated string pauser_addresses = 6 [ (cosmos_proto.scalar) = "cosmos.AddressString" ];
}
```

#### Event: pauser_address_removed

Example of the `pauser_address_removed` event emitted when a pauser address is removed:

```json
{
  "attributes": [
    {
      "index": true,
      "key": "pauser_address",
      "value": "zig1umu42jmf3ln3f32d0zxpj5gngnw6422w72ma7m"
    },
    {
      "index": true,
      "key": "msg_index",
      "value": "0"
    }
  ],
  "type": "pauser_address_removed"
}
```

### Update IBC Settings

Through the `MsgUpdateIbcSettings`, the Token Wrapper Operator can update the IBC settings that will be considered to wrap an IBC Token.

**Inputs:**

- `native_client_id`: client id of the native chain, ZIGChain in this case (e.g. "07-tendermint-0").
- `counterparty_client_id`: client id of the connected IBC chain (e.g. "07-tendermint-1").
- `native_port`: IBC port of the IBC connection for the native chain, ZIGChain in this case (e.g. "transfer").
- `counterparty_port`: IBC port of the IBC connection for the counterparty chain (e.g. "transfer").
- `native_channel`: IBC channel of the IBC connection for the native chain, ZIGChain in this case (e.g. "channel-0").
- `counterparty_channel`: IBC channel of the IBC connection for the counterparty chain (e.g. "channel-1").
- `denom`: Token name
- `decimal_difference`: number of decimals positions difference between the token native chain and the counterparty chain (e.g. 12)

**Verifications:**

1. Check that signer is the Token Wrapper Operator

**State updates:**

1. Update the Parameters in the Token Wrapper Module with the parameters provided.

Once the parameters are updated, the [ibc_settings_updated event](#event-ibc_settings_updated) is emitted.

#### Message: MsgUpdateIbcSettings

```go
message MsgUpdateIbcSettings {
    option (cosmos.msg.v1.signer) = "signer";
    option (amino.name) = "zigchain/x/tokenwrapper/MsgUpdateIbcSettings";

    string signer = 1 [ (cosmos_proto.scalar) = "cosmos.AddressString" ];
    string native_client_id = 2;
    string counterparty_client_id = 3;
    string native_port = 4;
    string counterparty_port = 5;
    string native_channel = 6;
    string counterparty_channel = 7;
    string denom = 8;
    uint32 decimal_difference = 9;
}
```

#### Response Message: MsgUpdateIbcSettingsResponse

```go
message MsgUpdateIbcSettingsResponse {
    string signer = 1 [ (cosmos_proto.scalar) = "cosmos.AddressString" ];
    string native_client_id = 2;
    string counterparty_client_id = 3;
    string native_port = 4;
    string counterparty_port = 5;
    string native_channel = 6;
    string counterparty_channel = 7;
    string denom = 8;
    uint32 decimal_difference = 9;
}
```

#### Event: ibc_settings_updated

```json
{
  "attributes": [
    {
      "index": true,
      "key": "signer",
      "value": "zig1umu42jmf3ln3f32d0zxpj5gngnw6422w72ma7m"
    },
    {
      "index": true,
      "key": "native_client_id",
      "value": "07-tendermint-99"
    },
    {
      "index": true,
      "key": "counterparty_client_id",
      "value": "07-tendermint-100"
    },
    {
      "index": true,
      "key": "native_port",
      "value": "transfer"
    },
    {
      "index": true,
      "key": "counterparty_port",
      "value": "transfer"
    },
    {
      "index": true,
      "key": "native_channel",
      "value": "channel-90"
    },
    {
      "index": true,
      "key": "counterparty_channel",
      "value": "channel-91"
    },
    {
      "index": true,
      "key": "denom",
      "value": "denom-zig"
    },
    {
      "index": true,
      "key": "decimal_difference",
      "value": "14"
    },
    {
      "index": true,
      "key": "msg_index",
      "value": "0"
    }
  ],
  "type": "ibc_settings_updated"
}
```

### Withdraw From Module Wallet

Through the `MsgWithdrawFromModuleWallet`, the Token Wrapper Operator can withdraw funds from the Token Wrapper Module address and receive them in its wallet. This is mechanism to reduce the risk of having too many funds in one single wallet.

**Inputs:**

- `amount`: amount and token name (e.g. 1000uzig)

**Verifications:**

1. Check that the signer is the Token Wrapper operator.
2. Ensure that the Token Wrapper Module has the amount.

**State updates:**

1. Transfer the funds from the Token Wrapper Module to the Operator wallet.

Once the funds are sent, the [module_wallet_withdrawn event](#event-module_wallet_withdrawn) is emitted.

#### Message: MsgWithdrawFromModuleWallet

```go
message MsgWithdrawFromModuleWallet {
option (cosmos.msg.v1.signer) = "signer";
option (amino.name) = "zigchain/x/tokenwrapper/MsgWithdrawFromModuleWallet";

string signer = 1 [ (cosmos_proto.scalar) = "cosmos.AddressString" ];
repeated cosmos.base.v1beta1.Coin amount = 2 [ (gogoproto.nullable) = false ];
}
```

#### Response Message: MsgWithdrawFromModuleWalletResponse

```go
message MsgWithdrawFromModuleWalletResponse {
    string signer = 1 [ (cosmos_proto.scalar) = "cosmos.AddressString" ];
    repeated cosmos.base.v1beta1.Coin amount = 2 [ (gogoproto.nullable) = false ];
    repeated cosmos.base.v1beta1.Coin balances = 3 [ (gogoproto.nullable) = false ];
    string module_address = 4 [ (cosmos_proto.scalar) = "cosmos.AddressString" ];
    string receiver = 5 [ (cosmos_proto.scalar) = "cosmos.AddressString" ];
}
```

#### Event: module_wallet_withdrawn

Example of the `module_wallet_withdrawn` event emitted when the module wallet is withdrawn:

```json
{
  "attributes": [
    {
      "index": true,
      "key": "signer",
      "value": "zig1umu42jmf3ln3f32d0zxpj5gngnw6422w72ma7m"
    },
    {
      "index": true,
      "key": "module_address",
      "value": "zig1hdq87rzf327fwz8rw9rnmchj7qa3uxrpxds2ff"
    },
    {
      "index": true,
      "key": "amount",
      "value": "1ibc/B6863C1B541063B17C757293EC2E45BD2984AAC8CADD5ED7EDC2DA58B99445DC"
    },
    {
      "index": true,
      "key": "balances",
      "value": "999999999999ibc/B6863C1B541063B17C757293EC2E45BD2984AAC8CADD5ED7EDC2DA58B99445DC,999uzig"
    },
    {
      "index": true,
      "key": "msg_index",
      "value": "0"
    }
  ],
  "type": "module_wallet_withdrawn"
}
```

### Recover ZIG

The `MsgRecoverZig` functionality provides a recovery mechanism for failed ZIG token bridging operations. This feature allows users to recover their native ZIG tokens when the bridging process from EVM (Ethereum or Sepolia) fails to complete properly.

#### When Recovery is Needed

The recovery process becomes necessary in the following scenarios:

- **Insufficient Module Wallet Balance**: The TokenWrapper module wallet doesn't have enough native ZIG tokens to fulfill the bridging request
- **IBC Settings Mismatch**: The received IBC vouchers don't match the configured IBC settings for proper token wrapping
- **Module Disabled**: The TokenWrapper module is temporarily disabled due to maintenance, security concerns, or emergency situations
- **Decimal Precision Scaling**: When bridging ZIG ERC20 tokens from EVM chains (18-decimal precision) to ZIGChain (6-decimal precision), small amounts may result in zero native ZIG tokens after scaling down. In this case, IBC vouchers are still released to the receiver address and can be recovered later using `MsgRecoverZig` when accumulated vouchers reach a sufficient amount to produce a positive native ZIG balance after decimal scaling

In these cases, users receive IBC vouchers in their ZIGChain address instead of the expected native ZIG tokens, requiring manual intervention to complete the conversion.

#### Permission-Less Recovery

The `MsgRecoverZig` message is designed to be **permission-less**, meaning anyone can trigger the recovery process on behalf of any address that holds IBC vouchers requiring conversion. This design provides several important benefits:

1. **Automated Recovery**: Enables automated systems to monitor and recover stuck tokens without requiring user intervention
2. **Reduced End-User Friction**: Users don't need to hold native ZIG tokens for gas payment to initiate recovery
3. **Enhanced User Experience**: Prevents users from being blocked or frustrated by failed bridging operations

#### Recovery Process

**Inputs:**

- `signer`: The address initiating the recovery (can be any valid address)
- `address`: The target address holding the IBC vouchers to be recovered

**Verifications:**

1. Check that the signer address is valid
2. Check that the target address is valid
3. Verify that the target address holds IBC vouchers that match the configured IBC settings
4. Ensure the module wallet has sufficient native ZIG tokens for the conversion

**State updates:**

1. Lock the IBC vouchers from the target address
2. Transfer the corresponding amount of native ZIG tokens (adjusted for the decimal difference) from the module wallet to the target address

Once the recovery is completed, the [address_zig_recovered event](#event-address_zig_recovered) is emitted.

#### Message: MsgRecoverZig

```go
message MsgRecoverZig {
  option (cosmos.msg.v1.signer) = "signer";
  string signer = 1;
  string address = 2;
}
```

#### Response Message: MsgRecoverZigResponse

```go
message MsgRecoverZigResponse {
  string signer = 1 [ (cosmos_proto.scalar) = "cosmos.AddressString" ];
  string receiving_address = 2
      [ (cosmos_proto.scalar) = "cosmos.AddressString" ];
  cosmos.base.v1beta1.Coin locked_ibc_amount = 3
      [ (gogoproto.nullable) = false ];
  cosmos.base.v1beta1.Coin unlocked_native_amount = 4
      [ (gogoproto.nullable) = false ];
}
```

#### Event: address_zig_recovered

Example of the `address_zig_recovered` event emitted when ZIG tokens are successfully recovered:

```json
{
  "attributes": [
    {
      "index": true,
      "key": "signer",
      "value": "zig1umu42jmf3ln3f32d0zxpj5gngnw6422w72ma7m"
    },
    {
      "index": true,
      "key": "address",
      "value": "zig1umu42jmf3ln3f32d0zxpj5gngnw6422w72ma7m"
    },
    {
      "index": true,
      "key": "locked_ibc_amount",
      "value": "1000000000000000000ibc/B6863C1B541063B17C757293EC2E45BD2984AAC8CADD5ED7EDC2DA58B99445DC"
    },
    {
      "index": true,
      "key": "unlocked_native_amount",
      "value": "1000000uzig"
    },
    {
      "index": true,
      "key": "msg_index",
      "value": "0"
    }
  ],
  "type": "address_zig_recovered"
}
```

## Error Handling

The module includes comprehensive error handling for:

- Invalid IBC packets
- Insufficient module wallet balances
- Invalid operator actions
- Module state inconsistencies
- IBC channel anomalies
