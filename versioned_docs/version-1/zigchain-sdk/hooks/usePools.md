---
sidebar_position: 6
---

# `usePools`

The `usePools` hook fetches a paginated list of pools from the ZIGChain blockchain and enriches each pool with metadata for the tokens involved in the pool. This hook is especially useful for applications that need to display pool data with detailed token information.

## Example Usage

This hook can be used to fetch and display pools along with their associated token metadata.

```tsx
import { usePools } from "@zigchain/zigchain-sdk";

const PoolsComponent = ({ page }) => {
  const { data: pools, isLoading, error, mutate } = usePools(page);

  if (isLoading) return <p>Loading pools...</p>;
  if (error) return <p>Error: {error.message}</p>;

  return (
    <div>
      <h3>Pools</h3>
      <ul>
        {pools.map((pool, index) => (
          <li key={index}>
            <p>Pool ID: {pool.poolId}</p>
            <ul>
              {pool.tokens.map((token, i) => (
                <li key={i}>
                  {token.metadata?.symbol || token.denom}:{" "}
                  {token.metadata?.name}
                </li>
              ))}
            </ul>
          </li>
        ))}
      </ul>
      <button onClick={() => mutate()}>Refetch Pools</button>
    </div>
  );
};

export default PoolsComponent;
```

## Parameters

The `usePools` hook accepts the following parameter:

- **`page`**: A number representing the page of pools to fetch.

## Returned Values

The `usePools` hook returns the following properties:

| Property    | Type                 | Description                                                      |
| ----------- | -------------------- | ---------------------------------------------------------------- |
| `data`      | `PoolWithMetadata[]` | An array of pools enriched with token metadata.                  |
| `isLoading` | `boolean`            | A boolean indicating whether the pool data is currently loading. |
| `error`     | `Error \| null`      | An error object if the request fails; otherwise, `null`.         |
| `mutate`    | `() => void`         | A function to manually refresh the pool data.                    |

### `PoolWithMetadata` Interface

Each pool in `data` is of type `PoolWithMetadata` and includes metadata for the tokens within each pool:

```ts
interface PoolWithMetadata extends Pool {
  tokens: ExtendedDenom[];
}

interface Pool {
  poolId?: string;
  coins?: { denom?: string }[];
}
```

- **`poolId`**: The unique identifier for the pool.
- **`tokens`**: An array of tokens in the pool, enriched with metadata from `ExtendedDenom`.

## How It Works

1. **Fetches Pools**: The hook retrieves pool data using the `fetchPools` utility function, passing the `page` parameter.
2. **Fetches Token Metadata**: It also retrieves metadata for tokens using the `useTokenMetadata` hook.
3. **Combines Data**: Each pool is then enriched with metadata for its tokens, providing additional information such as token name, symbol, and other details.
4. **Data Management**: The enriched pool data is stored in `poolsWithMetadata` state, which is then returned to the component.

## Conclusion

The `usePools` hook is an effective way to retrieve and display pools enriched with token metadata, enabling applications to present comprehensive information about pools and their constituent tokens on the ZIGChain blockchain.
