---
sidebar_position: 1
---

# `useZigchain`

The `useZigchain` hook returns the `ChainContext`, which provides a comprehensive set of tools and methods to interact with wallets, connect to the ZIGChain blockchain, and perform transactions.

## Example Usage

Here's an example of how you can use the `useZigchain` hook:

```tsx
import { useZigchain } from "@zigchain/zigchain-sdk";

const MyComponent = () => {
  const {
    address,
    connect,
    disconnect,
    getStargateClient,
    signAndBroadcast,
    isWalletConnected,
    isWalletDisconnected,
  } = useZigchain();

  // Connect wallet on button click
  const handleConnect = async () => {
    try {
      await connect();
      console.log("Wallet connected!");
    } catch (error) {
      console.error("Failed to connect wallet", error);
    }
  };

  return (
    <div>
      <button onClick={handleConnect} disabled={isWalletConnected}>
        Connect Wallet
      </button>
      {address && <p>Connected to {address}</p>}
      <button onClick={disconnect} disabled={isWalletDisconnected}>
        Disconnect Wallet
      </button>
    </div>
  );
};

export default MyComponent;
```

## Available Methods and Properties

### Wallet Connection and Status

| Property/Method        | Type                                             | Description                                                                    |
| ---------------------- | ------------------------------------------------ | ------------------------------------------------------------------------------ |
| `address`              | `string \| undefined`                            | The address of the connected wallet, or `undefined` if no wallet is connected. |
| `username`             | `string \| undefined`                            | The username associated with the wallet, if available.                         |
| `isWalletConnected`    | `boolean`                                        | `true` if the wallet is connected, otherwise `false`.                          |
| `isWalletDisconnected` | `boolean`                                        | `true` if the wallet is disconnected, otherwise `false`.                       |
| `connect()`            | `() => Promise<void>`                            | Connects the wallet.                                                           |
| `disconnect()`         | `(options?: DisconnectOptions) => Promise<void>` | Disconnects the wallet.                                                        |
| `status`               | `WalletStatus`                                   | The current status of the wallet (e.g., connected, connecting, disconnected).  |
| `isWalletConnecting`   | `boolean`                                        | `true` if the wallet is currently in the process of connecting.                |
| `isWalletRejected`     | `boolean`                                        | `true` if the wallet connection was rejected.                                  |
| `isWalletNotExist`     | `boolean`                                        | `true` if the wallet does not exist or is unavailable.                         |
| `isWalletError`        | `boolean`                                        | `true` if an error occurred while trying to interact with the wallet.          |

### Query and Endpoint Management

| Property/Method                     | Type                                            | Description                                                                  |
| ----------------------------------- | ----------------------------------------------- | ---------------------------------------------------------------------------- |
| `getRpcEndpoint(isLazy?: boolean)`  | `() => Promise<string \| ExtendedHttpEndpoint>` | Fetches the RPC endpoint for the connected chain.                            |
| `getRestEndpoint(isLazy?: boolean)` | `() => Promise<string \| ExtendedHttpEndpoint>` | Fetches the REST endpoint for the connected chain.                           |
| `getStargateClient()`               | `() => Promise<StargateClient>`                 | Retrieves the Stargate client for making blockchain queries.                 |
| `getSigningStargateClient()`        | `() => Promise<SigningStargateClient>`          | Retrieves the signing Stargate client for signing and sending transactions.  |
| `getCosmWasmClient()`               | `() => Promise<CosmWasmClient>`                 | Retrieves the CosmWasm client for interacting with CosmWasm smart contracts. |
| `getSigningCosmWasmClient()`        | `() => Promise<SigningCosmWasmClient>`          | Retrieves the signing CosmWasm client for signing and sending transactions.  |

### Signing and Transaction Management

| Property/Method      | Type                                                                                    | Description                                                         |
| -------------------- | --------------------------------------------------------------------------------------- | ------------------------------------------------------------------- |
| `signAndBroadcast()` | `(messages: EncodeObject[], fee?: StdFee, memo?: string) => Promise<DeliverTxResponse>` | Signs and broadcasts the transaction using the connected wallet.    |
| `sign()`             | `(messages: EncodeObject[], fee?: StdFee, memo?: string) => Promise<TxRaw>`             | Signs the transaction without broadcasting.                         |
| `broadcast()`        | `(signedMessages: TxRaw) => Promise<DeliverTxResponse>`                                 | Broadcasts a previously signed transaction.                         |
| `estimateFee()`      | `(messages: EncodeObject[], memo?: string) => Promise<StdFee>`                          | Estimates the fee for a transaction based on the provided messages. |

### Wallet Management

| Property/Method      | Type                                                                      | Description                                            |
| -------------------- | ------------------------------------------------------------------------- | ------------------------------------------------------ |
| `getAccount()`       | `() => Promise<WalletAccount>`                                            | Retrieves the account details of the connected wallet. |
| `getOfflineSigner()` | `() => OfflineSigner`                                                     | Returns an offline signer for the connected wallet.    |
| `signAmino()`        | `(signer: string, signDoc: StdSignDoc) => Promise<AminoSignResponse>`     | Signs a transaction using the Amino signing method.    |
| `signDirect()`       | `(signer: string, signDoc: DirectSignDoc) => Promise<DirectSignResponse>` | Signs a transaction using the Direct signing method.   |

### UI Management

| Property/Method | Type                  | Description                                                      |
| --------------- | --------------------- | ---------------------------------------------------------------- |
| `openView()`    | `() => void`          | Opens the wallet view for connecting or managing wallets.        |
| `closeView()`   | `() => void`          | Closes the wallet view.                                          |
| `enable()`      | `() => Promise<void>` | Enables wallet interactions by requesting necessary permissions. |

### Example Use Case for Transaction:

```tsx
import { useZigchain } from "@zigchain/zigchain-sdk";

const SendTransactionComponent = () => {
  const { signAndBroadcast, address, connect, isWalletConnected } =
    useZigchain();

  const handleSendTx = async () => {
    if (!isWalletConnected) {
      await connect();
    }

    const messages = [
      // Define your transaction messages here
    ];

    const fee = {
      amount: [
        {
          denom: "uzig",
          amount: "5000",
        },
      ],
      gas: "200000",
    };

    try {
      const result = await signAndBroadcast(messages, fee);
      console.log("Transaction result:", result);
    } catch (error) {
      console.error("Failed to sign and broadcast transaction:", error);
    }
  };

  return (
    <div>
      <button onClick={handleSendTx}>Send Transaction</button>
    </div>
  );
};
```

---

## Conclusion

The `useZigchain` hook is a powerful utility for interacting with ZIGChain wallets and blockchain functionality. It provides an easy-to-use interface for wallet management, query execution, and transaction signing, making it a key tool for developing decentralized applications on the ZIGChain blockchain.
