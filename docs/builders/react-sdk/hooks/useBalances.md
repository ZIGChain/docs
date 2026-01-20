---
title: useBalances Hook
description: Documentation for the useBalances React hook that fetches token balances for ZIGChain addresses with enriched metadata for display in applications.
keywords:
  [
    useBalances,
    React hook,
    token balances,
    balance queries,
    token metadata,
    address balances,
    React SDK,
    balance fetching,
  ]
sidebar_position: 5
---

# `useBalances`

The `useBalances` hook fetches and returns the token balances for a specified ZIGChain address. It retrieves additional metadata for each token, providing enriched information for display in applications.

## Example Usage

```tsx
import { useBalances } from "@zigchain/zigchain-sdk";

const BalancesComponent = ({ address }) => {
  const { balances, isLoading, error, mutate } = useBalances(address);

  if (isLoading) return <p>Loading...</p>;
  if (error) return <p>Error fetching balances: {error.message}</p>;

  return (
    <div>
      <h3>Token Balances for {address}</h3>
      <ul>
        {balances.map((balance, index) => (
          <li key={index}>
            {balance.denom?.ticker || balance.denom?.denom}: {balance.amount}
          </li>
        ))}
      </ul>
      <button onClick={mutate}>Refresh Balances</button>
    </div>
  );
};

export default BalancesComponent;
```

## Parameters

The `useBalances` hook accepts the following parameter:

- **`address`**: A ZIGChain address (`string | undefined`) for which the token balances are fetched. If `address` is undefined, the hook will not attempt to fetch balances.

## Returned Values

The `useBalances` hook returns the following properties:

| Property    | Type                  | Description                                                           |
| ----------- | --------------------- | --------------------------------------------------------------------- |
| `balances`  | `Balance[]`           | An array of balance objects containing token information and amounts. |
| `isLoading` | `boolean`             | A boolean indicating whether the data is currently loading.           |
| `error`     | `Error \| null`       | An error object if the request fails, otherwise `null`.               |
| `mutate`    | `() => Promise<void>` | A function to manually refresh the balance data.                      |

### `Balance` Interface

Each `Balance` object has the following structure:

```ts
interface Balance {
  denom?: ExtendedDenom | undefined;
  amount?: string | undefined;
}
```

- **`denom`**: Contains metadata for the token (such as description, ticker, and icon).
- **`amount`**: The token balance amount for the given address.

## How It Works

1. **Fetches Balances**: Using the `fetchBalances` utility, it retrieves token balances for the given address.
2. **Fetches Metadata**: Additionally, it calls `fetchTokenMetadata` to retrieve metadata for each token (name, symbol, URI, etc.).
3. **Merges Data**: Combines the balance data with metadata to enrich each token's information, which is useful for displaying detailed token data in applications.

## Error Handling

- If an error occurs during data fetching, `error` will contain the error details.
- `isLoading` will be set to `false` after the error occurs.

## Conclusion

The `useBalances` hook is a powerful utility for fetching and displaying token balances, including token metadata. It allows for a seamless display of detailed token information, making it ideal for applications that need to show token holdings with enriched details like name, symbol, and icon.
