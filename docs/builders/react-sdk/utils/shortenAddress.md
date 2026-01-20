---
title: shortenAddress Utility
description: Documentation for the shortenAddress utility function that shortens ZIGChain addresses to fit within specified character limits while retaining start and end characters.
keywords:
  [
    shortenAddress,
    utility function,
    address formatting,
    address display,
    address shortening,
    React SDK,
    address utility,
  ]
sidebar_position: 1
---

# `shortenAddress`

The `shortenAddress` utility function provides a concise way to display blockchain addresses by shortening them to fit within a specified maximum number of characters. This is particularly useful for UI elements where displaying the full address would take up too much space.

## Example Usage

This utility can be used in components to display a shortened version of an address, while retaining the ability to recognize the start and end characters.

```tsx
import { shortenAddress } from "@zigchain/zigchain-sdk";

const AddressDisplayComponent = ({ address }) => {
  return (
    <div>
      <p>Full Address: {address}</p>
      <p>Shortened Address: {shortenAddress(address)}</p>
    </div>
  );
};

export default AddressDisplayComponent;
```

## Parameters

The `shortenAddress` function accepts the following parameters:

- **`bech32`**: A string representing the full blockchain address to be shortened.

## Returned Value

The `shortenAddress` function returns a shortened version of the address, formatted as follows:

| Input Address                                | Output Address         |
| -------------------------------------------- | ---------------------- |
| `zig1rgjz3fz3trf7u3r22revgtwvc9nxrg6u5q70kz` | `zig1rgjz3fz...5q70kz` |

## How It Works

1. **Prefix Extraction**: The function extracts the prefix of the Bech32 address (e.g., `zig` in `zig1...`).
2. **Address Body Processing**: The function calculates the available length for the address body after accounting for the prefix, ellipsis (`...`), and separator (`1`).
3. **Ellipsis Placement**: If the address exceeds the maximum allowed length, it shortens the middle portion of the address, leaving the prefix and the suffix intact.

### Error Handling

The `shortenAddress` function handles invalid inputs by returning the input address as-is if it is not a valid Bech32 address. This ensures the function does not throw errors or behave unpredictably.

**Behavior:**

- If the input is a valid Bech32 address, the function shortens it as expected.
- If the input is invalid (e.g., missing the `1` separator, `null`, `undefined`, or not a string), the function simply returns the input without modification.

This approach ensures the function avoids breaking your application when invalid input is encountered. No additional validation is required before calling the function.

## Conclusion

The `shortenAddress` utility is a flexible and efficient tool for creating a user-friendly display of Cosmos blockchain addresses. It enhances readability by reducing visual clutter in user interfaces while maintaining the ability to recognize the critical parts of an address.
