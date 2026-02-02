---
title: usePoolId Hook
description: Documentation for the usePoolId React hook that retrieves pool IDs for token pairs on ZIGChain, useful for accessing specific liquidity pools or trading pairs.
keywords:
  [
    usePoolId,
    React hook,
    pool ID,
    liquidity pool lookup,
    token pair,
    trading pair,
    React SDK,
    pool identification,
  ]
sidebar_position: 7
---

# `usePoolId`

The `usePoolId` hook retrieves the pool ID associated with two specified tokens on the ZIGChain blockchain. This is useful for applications that need to access a specific liquidity pool or trading pair by token.

## Example Usage

This hook can be used to find the pool ID for a pair of tokens, such as `tokenA` and `tokenB`.

```tsx
import { usePoolId } from "@zigchain/zigchain-sdk";

const PoolIdComponent = ({ tokenA, tokenB }) => {
  const poolId = usePoolId(tokenA, tokenB);

  return (
    <div>
      <h3>Pool ID</h3>
      {poolId ? <p>{poolId}</p> : <p>Loading or Pool ID not found</p>}
    </div>
  );
};

export default PoolIdComponent;
```

## Parameters

The `usePoolId` hook accepts the following parameters:

- **`tokenA`**: A string representing the first token in the pool pair.
- **`tokenB`**: A string representing the second token in the pool pair.

## Returned Value

The `usePoolId` hook returns a single value:

| Value    | Type             | Description                                                                          |
| -------- | ---------------- | ------------------------------------------------------------------------------------ |
| `poolId` | `string \| null` | The pool ID for the specified token pair, or `null` if the pool ID is not available. |

## How It Works

1. **Client Initialization**: The hook retrieves the ZIGChain client from `useZigchainClient`.
2. **Validation**: If either `tokenA` or `tokenB` is empty, `poolId` is set to `null`.
3. **Fetch Pool ID**: The `getPoolId` function is called to retrieve the pool ID for the specified tokens. This function is triggered every time `tokenA` or `tokenB` changes.

### Error Handling

The hook does not explicitly handle errors, so any errors encountered by the `getPoolId` function will need to be handled in the fetcher function if desired.

## Conclusion

The `usePoolId` hook simplifies the process of retrieving pool IDs for token pairs, making it a valuable tool for applications that need to query specific liquidity pools or trading pairs on the ZIGChain blockchain.
