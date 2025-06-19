---
sidebar_position: 10
---

# `useAddChain`

The `useAddChain` hook allows developers to add the ZIGChain network (either `mainnet` or `testnet`) to compatible wallets such as Keplr or Leap. If the wallet is not installed, the hook provides an installation URL for user guidance.

## Example Usage

This hook is helpful for adding blockchain network configurations to user wallets directly from your application.

```tsx
import { useAddChain } from "@zigchain/zigchain-sdk";

const AddChainComponent = () => {
  const { addChain, isLoading, error, installUrl } = useAddChain();

  const handleAddTestnet = async () => {
    await addChain("keplr", "testnet");
  };

  const handleAddMainnet = async () => {
    await addChain("keplr", "mainnet");
  };

  return (
    <div>
      {installUrl ? (
        <div>
          <p>Wallet not found. You need to install it first.</p>
          <a href={installUrl} target="_blank" rel="noopener noreferrer">
            Install Wallet
          </a>
        </div>
      ) : (
        <>
          <button onClick={handleAddTestnet} disabled={isLoading}>
            {isLoading ? "Adding..." : "Add ZIGChain Testnet"}
          </button>
          <button onClick={handleAddMainnet} disabled={isLoading}>
            {isLoading ? "Adding..." : "Add ZIGChain Mainnet"}
          </button>
        </>
      )}
      {error && <p>Error: {error.message}</p>}
    </div>
  );
};

export default AddChainComponent;
```

## Hook Parameters and Returns

### Parameters

The `addChain` function within the hook accepts the following parameters:

- **`walletKey`**: A string that specifies the target wallet (`"keplr"` or `"leap"`).
- **`chainType`**: A string indicating which network to add, either `"testnet"` or `"mainnet"`.

### Returned Values

The `useAddChain` hook returns the following values:

| Property     | Type                             | Description                                                                             |
| ------------ | -------------------------------- | --------------------------------------------------------------------------------------- |
| `addChain`   | `(walletKey, chainType) => void` | Function to add the specified network (`mainnet` or `testnet`) to the specified wallet. |
| `isLoading`  | `boolean`                        | A boolean indicating if the chain addition is in progress.                              |
| `error`      | `Error \| null`                  | Error object if an error occurs during the process, otherwise `null`.                   |
| `installUrl` | `string \| null`                 | Installation URL if the specified wallet is not found.                                  |

## How It Works

1. **Wallet Check**: Checks if the specified wallet (`"keplr"` or `"leap"`) is available. If not, `installUrl` is set with the URL for wallet installation.
2. **Chain Configuration**: Based on the `chainType`, the hook selects `testnetConfig` or `mainnetConfig` and configures the chain details like `rpcURL`, `apiURL`, and prefix.
3. **Suggest Chain**: Uses the wallet’s `experimentalSuggestChain` method to add the specified chain to the wallet.
4. **Enable Chain**: Once added, the hook enables the chain in the wallet for user interaction.

## Chain Configuration

The ZIGChain chain configuration is created dynamically based on the selected network type (`mainnet` or `testnet`), including options like:

- **`bip44`**: Contains the coin type.
- **`bech32Config`**: Specifies address prefixes for different account types.
- **`currencies`, `stakeCurrency`, and `feeCurrencies`**: Derived from the chain itself at that given moment.
- **`suggestOptions`**: Defines chain-related options, including network endpoints and chain icon.

## Conclusion

The `useAddChain` hook offers a user-friendly way to add the ZIGChain network to compatible wallets, with customization for mainnet or testnet. It provides error handling and install prompts to guide users through the process.
