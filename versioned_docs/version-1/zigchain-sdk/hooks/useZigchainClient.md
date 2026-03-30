---
sidebar_position: 2
---

# `useZigchainClient`

The `useZigchainClient` hook provides access to the initialized ZIGChain client (`Client` instance). This client allows you to interact directly with the ZIGChain blockchain by performing queries, transactions, and other chain-specific actions.

## Example Usage

This hook is ideal for when you need to perform specific operations on the ZIGChain blockchain through the client.

```tsx
import { useZigchainClient } from "@zigchain/zigchain-sdk";

const MyComponent = () => {
  const client = useZigchainClient();

  const fetchTokenData = async () => {
    try {
      const response = await client.zigchain.factory.denomAll({});
      console.log("Fetched tokens:", response);
    } catch (error) {
      console.error("Error fetching tokens:", error);
    }
  };

  return (
    <div>
      <button onClick={fetchTokenData}>Fetch Tokens</button>
    </div>
  );
};

export default MyComponent;
```

## Functionality

The `useZigchainClient` hook gives you access to the `Client` instance, which you can use to call various modules in the ZIGChain SDK, such as `ZigchainFactory`, `ZigchainDex`, and other Cosmos modules (e.g., `CosmosBankV1Beta1`, `CosmosStakingV1Beta1`).

### How It Works

Internally, `useZigchainClient` accesses the client from the ZIGChain context (`ZigchainContext`). If the client is not available, it throws an error, ensuring that the client is properly configured before being used.

```tsx
export function useZigchainClient(): InstanceType<typeof Client> {
  const { client } = useZigchainContext();

  if (!client) {
    throw new Error(
      "Client is not available. Make sure the network is configured correctly."
    );
  }

  return client;
}
```

### Error Handling

- If the client is not initialized, the hook will throw an error: `"Client is not available. Make sure the network is configured correctly."`
- This ensures that the client is available and configured properly, providing a safer usage experience.

## Returns

The `useZigchainClient` hook returns the following:

- **`client`**: The instance of `Client`, through which you can perform queries, transactions, and other interactions with ZIGChain.

## Conclusion

The `useZigchainClient` hook is essential for interacting directly with the ZIGChain blockchain client. It provides a direct interface to query data, manage transactions, and interact with modules available on ZIGChain. This hook should be used in situations where you need direct access to the client for advanced operations.
