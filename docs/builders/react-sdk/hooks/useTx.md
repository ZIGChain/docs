---
title: useTx Hook
description: Documentation for the useTx React hook that handles transaction signing, broadcasting, error handling, and status management for ZIGChain transactions.
keywords:
  [
    useTx,
    React hook,
    transaction execution,
    transaction signing,
    transaction broadcasting,
    transaction status,
    error handling,
    React SDK,
  ]
sidebar_position: 3
---

# `useTx`

The `useTx` hook allows you to execute transactions on the ZIGChain blockchain, handling signing, broadcasting, and error handling. It leverages the `useZigchain` hook to get access to the signing client and other necessary utilities for transaction management.

## Example Usage

This hook is ideal for any component that needs to send transactions to the ZIGChain network. The hook handles transaction signing and broadcasting, along with optional fee estimation.

```tsx
import { useTx, TxStatus } from "@zigchain/zigchain-sdk";

const SendTxComponent = () => {
  const { tx } = useTx();

  const handleSendTx = async () => {
    const msgs = [
      {
        typeUrl: "/cosmos.bank.v1beta1.MsgSend",
        value: {
          fromAddress: "zig1...",
          toAddress: "zig1...",
          amount: [{ denom: "uzig", amount: "1000" }],
        },
      },
    ];

    const result = await tx(msgs, {
      onSuccess: () => console.log("Transaction was successful!"),
    });

    if (result === TxStatus.Successful) {
      console.log("Transaction successfully broadcasted!");
    } else if (result === TxStatus.Failed) {
      console.error("Transaction failed.");
    }
  };

  return <button onClick={handleSendTx}>Send Transaction</button>;
};

export default SendTxComponent;
```

## Parameters

The `tx` function accepts two parameters:

1. **`msgs`**: An array of message objects representing the transaction data.

   - Each `Msg` object should contain:
     - **`typeUrl`**: The URL specifying the message type (e.g., `/cosmos.bank.v1beta1.MsgSend`).
     - **`value`**: The message payload.

2. **`options`**: An object of type `TxOptions` that provides optional configuration for the transaction.
   - **`fee`**: An optional `StdFee` object specifying the transaction fee. If not provided, the fee will be estimated.
   - **`onSuccess`**: An optional callback function triggered when the transaction succeeds.

### `TxOptions` Interface

```ts
interface TxOptions {
  fee?: StdFee | null;
  onSuccess?: () => void;
}
```

## Return Value

The `tx` function returns a `TxStatus` value indicating the transaction's status:

- **`TxStatus.Successful`**: Transaction broadcast was successful.
- **`TxStatus.Failed`**: Transaction failed to broadcast or execute.
- **`TxStatus.Broadcasting`**: Transaction is being broadcast.

## Error Handling

Errors are logged to the console, and the hook returns `TxStatus.Failed` when any error occurs during signing or broadcasting.

### Additional Constants

The hook also exports `TxStatus`, which is an enumeration of possible transaction statuses:

```ts
export enum TxStatus {
  Failed = "Transaction Failed",
  Successful = "Transaction Successful",
  Broadcasting = "Transaction Broadcasting",
}
```

## Detailed Behavior

1. **Address Check**: If no address is found, the hook logs an error and exits.
2. **Fee Estimation**: If no fee is provided in `options`, the hook will estimate the fee.
3. **Signing**: The hook uses the signing client to sign the transaction with the address, messages, and fee.
4. **Broadcasting**: The hook attempts to broadcast the transaction. If successful, it calls `onSuccess` (if provided) and returns `TxStatus.Successful`. Otherwise, it returns `TxStatus.Failed`.

## Example with Custom Fee

```tsx
const handleSendCustomTx = async () => {
  const msgs = [
    {
      typeUrl: "/cosmos.bank.v1beta1.MsgSend",
      value: {
        fromAddress: "zig1...",
        toAddress: "zig1...",
        amount: [{ denom: "uzig", amount: "2000" }],
      },
    },
  ];

  const fee = {
    amount: [{ denom: "uzig", amount: "500" }],
    gas: "200000",
  };

  const result = await tx(msgs, {
    fee,
    onSuccess: () => console.log("Transaction with custom fee was successful!"),
  });

  console.log(result); // Logs TxStatus.Successful or TxStatus.Failed
};
```

---

## Conclusion

The `useTx` hook provides a streamlined interface for executing transactions on the ZIGChain blockchain. It automates common tasks like signing, broadcasting, and fee estimation, making it a powerful tool for applications that need to interact with ZIGChain.
