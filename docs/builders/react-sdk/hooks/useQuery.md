---
title: useQuery Hook
description: Documentation for the useQuery React hook that provides general-purpose async data fetching with loading, error, and data state management for ZIGChain queries.
keywords:
  [
    useQuery,
    React hook,
    async queries,
    data fetching,
    loading states,
    error handling,
    React SDK,
    blockchain queries,
  ]
sidebar_position: 4
---

# `useQuery`

The `useQuery` hook provides a general-purpose way to manage asynchronous data fetching and handle loading, error, and data states. It is highly versatile and can be used with any asynchronous query, including calls to the ZIGChain client for blockchain data.

## Example Usage

The following example demonstrates how to use the `useQuery` hook to fetch a list of denominations from the ZIGChain blockchain.

```tsx
import { useQuery } from "@zigchain/zigchain-sdk";
import { useZigchainClient } from "@zigchain/zigchain-sdk";

const FetchDenomsComponent = () => {
  const client = useZigchainClient();

  const { data, error, isLoading, refetch } = useQuery(() =>
    client.zigchain.factory.denomAll({})
  );

  if (isLoading) return <p>Loading...</p>;
  if (error) return <p>Error: {error.message}</p>;

  return (
    <div>
      <h3>Result</h3>
      <pre>{JSON.stringify(data, null, 2)}</pre>
      <button onClick={refetch}>Refetch Data</button>
    </div>
  );
};

export default FetchDenomsComponent;
```

## Parameters

The `useQuery` hook accepts the following parameters:

1. **`queryInvocation`**: A function that returns a promise, representing the asynchronous query to execute. In this case, it could be a call to the ZIGChain client, such as `client.zigchain.factory.denomAll({})`.
2. **`immediate`** (optional): A boolean indicating whether the query should execute immediately after the component mounts. Defaults to `true`.

## Returned Values

The `useQuery` hook returns the following properties and methods:

| Property/Method | Type                  | Description                                                                       |
| --------------- | --------------------- | --------------------------------------------------------------------------------- |
| `data`          | `TResult \| null`     | The data returned from the query function. Initially `null` until data is loaded. |
| `error`         | `Error \| null`       | An error object if the query fails; otherwise, `null`.                            |
| `isLoading`     | `boolean`             | A boolean indicating if the query is in progress.                                 |
| `refetch`       | `() => Promise<void>` | A function to manually trigger the query again.                                   |

## How It Works

1. **Initial Fetching**: If `immediate` is set to `true`, the query is executed immediately when the component mounts.
2. **Manual Refetch**: The `refetch` function allows you to manually trigger the query function, which is useful for reloading or refreshing data.
3. **Error Handling**: If an error occurs during the query, `error` is set with the error details.
4. **Loading State**: While the query is in progress, `isLoading` is set to `true`. It reverts to `false` after the query completes.

## Conclusion

The `useQuery` hook simplifies managing data fetching with loading, error, and data states. Its versatility makes it suitable for handling various types of asynchronous queries in your application, including ZIGChain client calls for blockchain data.
