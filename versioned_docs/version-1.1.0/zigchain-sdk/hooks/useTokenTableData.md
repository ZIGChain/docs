---
sidebar_position: 9
---

# `useTokenTableData`

The `useTokenTableData` hook retrieves paginated token data from the ZIGChain blockchain and enriches it with metadata. This hook is particularly useful for displaying token information in a table format, with additional details such as description, symbol, and social links.

## Example Usage

This hook can be used to fetch and display token data with detailed metadata, such as descriptions, symbols, and other enriched information.

```tsx
import { useTokenTableData } from "@zigchain/zigchain-sdk";

const TokenTableComponent = ({ page, rowsPerPage }) => {
  const { data, isLoading, error, mutate } = useTokenTableData(
    page,
    rowsPerPage
  );

  if (isLoading) return <p>Loading token data...</p>;
  if (error) return <p>Error: {error.message}</p>;

  return (
    <div>
      <h3>Token Data Table</h3>
      <table>
        <thead>
          <tr>
            <th>Symbol</th>
            <th>Name</th>
            <th>Description</th>
            <th>Website</th>
          </tr>
        </thead>
        <tbody>
          {data?.map((token, index) => (
            <tr key={index}>
              <td>{token.metadata.symbol}</td>
              <td>{token.metadata.name}</td>
              <td>{token.metadata.description}</td>
              <td>
                <a
                  href={token.extraData.websiteUrl}
                  target="_blank"
                  rel="noopener noreferrer"
                >
                  {token.extraData.websiteUrl}
                </a>
              </td>
            </tr>
          ))}
        </tbody>
      </table>
      <button onClick={mutate}>Refresh Data</button>
    </div>
  );
};

export default TokenTableComponent;
```

## Parameters

The `useTokenTableData` hook accepts the following parameters:

- **`page`**: A string representing the current page of tokens to retrieve.
- **`rowsPerPage`**: A string indicating the number of rows (tokens) per page.

## Returned Values

The `useTokenTableData` hook returns the following properties:

| Property    | Type                  | Description                                                      |
| ----------- | --------------------- | ---------------------------------------------------------------- |
| `data`      | `ExtendedDenom[]`     | An array of tokens enriched with metadata and extra information. |
| `isLoading` | `boolean`             | A boolean indicating if the token data is currently loading.     |
| `error`     | `Error \| null`       | An error object if the request fails; otherwise, `null`.         |
| `mutate`    | `() => Promise<void>` | A function to manually refresh both token and metadata data.     |

### ExtendedDenom Structure

Each item in `data` is an `ExtendedDenom` object that includes metadata and extra information for the token.

```ts
interface ExtendedDenom extends Denom {
  metadata: Metadata;
  extraData: ExtraData;
}

interface Metadata {
  description: string;
  denom_units: DenomUnit[];
  base: string;
  display: string;
  name: string;
  symbol: string;
  uri: string;
  uri_hash: string;
}

interface ExtraData {
  description: string;
  twitter: string;
  telegram: string;
  websiteUrl: string;
  icon: string;
}
```

- **`metadata`**: Contains the basic information about the token, such as symbol, name, and URI.
- **`extraData`**: Additional information, including social media links and an icon.

## How It Works

1. **Fetch Token Data**: The hook uses `useSWR` to retrieve token data based on the specified `page`, calling `fetchTokens`.
2. **Fetch Metadata**: It also retrieves token metadata using `fetchTokenMetadata`, based on `rowsPerPage`.
3. **Combine Data**: Each token is enriched with its corresponding metadata and extra data, forming a structured dataset.
4. **Manual Data Refresh**: The `mutate` function allows you to refresh both token and metadata data simultaneously.

## Conclusion

The `useTokenTableData` hook is a versatile tool for retrieving and displaying token data enriched with metadata on the ZIGChain blockchain. It’s ideal for applications that require a detailed view of token information in a structured, table-friendly format.
