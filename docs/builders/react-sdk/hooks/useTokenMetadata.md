---
title: useTokenMetadata Hook
description: Documentation for the useTokenMetadata React hook that retrieves enriched metadata for tokens on ZIGChain including descriptions, symbols, URIs, and other details.
keywords:
  [
    useTokenMetadata,
    React hook,
    token metadata,
    token information,
    token details,
    React SDK,
    metadata queries,
  ]
sidebar_position: 8
---

# `useTokenMetadata`

The `useTokenMetadata` hook retrieves metadata for tokens on the ZIGChain blockchain, including additional data such as descriptions, symbols, URIs, and other details. This metadata is useful for displaying enriched information about each token.

## Example Usage

This hook can be used to fetch and display metadata for a set of tokens, limited by a specified number.

```tsx
import { useTokenMetadata } from "@zigchain/zigchain-sdk";

const TokenMetadataComponent = ({ limit }) => {
  const { data, isLoading, error } = useTokenMetadata(limit);

  if (isLoading) return <p>Loading token metadata...</p>;
  if (error) return <p>Error: {error.message}</p>;

  return (
    <div>
      <h3>Token Metadata</h3>
      <ul>
        {data?.map((token, index) => (
          <li key={index}>
            <p>Symbol: {token.metadata.symbol}</p>
            <p>Description: {token.extraData.description}</p>
          </li>
        ))}
      </ul>
    </div>
  );
};

export default TokenMetadataComponent;
```

## Parameters

The `useTokenMetadata` hook accepts the following parameter:

- **`limit`**: A string representing the maximum number of tokens to retrieve metadata for.

## Returned Values

The `useTokenMetadata` hook returns the following properties:

| Property    | Type                                                  | Description                                                |
| ----------- | ----------------------------------------------------- | ---------------------------------------------------------- |
| `data`      | `Array<{ metadata: Metadata, extraData: ExtraData }>` | The list of tokens with enriched metadata.                 |
| `isLoading` | `boolean`                                             | A boolean indicating if the metadata is currently loading. |
| `error`     | `Error \| null`                                       | An error object if the request fails; otherwise, `null`.   |
| `mutate`    | `() => void`                                          | A function to manually refresh the token metadata data.    |

### Metadata Structure

Each item in `data` consists of `metadata` and `extraData`:

```ts
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

- **`metadata`**: Contains basic information about the token, including name, symbol, and URI.
- **`extraData`**: Includes additional information such as social links and an icon.

## How It Works

1. **Data Fetching**: The hook uses `useSWR` to retrieve metadata for tokens based on the specified limit, calling `fetchTokenMetadata`.
2. **Enriching Metadata**: Once token metadata is fetched, the hook makes additional requests to the `uri` endpoint in each token’s metadata to retrieve `extraData`.
3. **Combining Data**: Metadata and `extraData` are combined and stored in `tokenMetadata`, which is returned for display.

## Conclusion

The `useTokenMetadata` hook is a powerful tool for fetching and displaying detailed metadata for tokens on the ZIGChain blockchain. It provides enriched information about each token, making it suitable for applications that need to present comprehensive token data.
