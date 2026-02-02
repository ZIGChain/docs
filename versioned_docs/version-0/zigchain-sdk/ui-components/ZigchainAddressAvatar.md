---
sidebar_position: 1
---

# `ZigchainAddressAvatar`

The `ZigchainAddressAvatar` component generates a unique, gradient-based avatar for a ZIGChain address. This is useful for visually representing addresses in a recognizable way, even in cases where users may not want to reveal the full address.

## Example Usage

This component can be used to display a unique avatar for each blockchain address, providing a consistent visual representation for each address.

```tsx
import { ZigchainAddressAvatar } from "@zigchain/zigchain-sdk";

const AddressAvatarComponent = ({ address }) => {
  return (
    <div>
      <h3>Address Avatar</h3>
      <ZigchainAddressAvatar address={address} />
    </div>
  );
};

export default AddressAvatarComponent;
```

## Parameters

The `ZigchainAddressAvatar` component accepts the following props:

| Prop        | Type     | Description                                              |
| ----------- | -------- | -------------------------------------------------------- |
| `address`   | `string` | The blockchain address for which to generate the avatar. |
| `className` | `string` | Additional CSS class for styling the avatar container.   |

## How It Works

1. **Clean Address**: The function removes any common prefix (e.g., `zig1`) to focus on the unique part of the address.
2. **Generate Colors**: The address is segmented, and each segment is hashed to produce a set of RGB colors. The colors are used to form the radial gradients.
3. **Apply Gradient Style**: The generated colors are applied to a radial gradient background, creating a unique avatar for the address.

## Conclusion

The `ZigchainAddressAvatar` component offers a visually distinctive way to represent blockchain addresses in the UI. By generating a unique gradient pattern for each address, this component helps users quickly identify addresses visually.
