---
sidebar_position: 11
---

# `useCreateToken`

The `useCreateToken` hook is a custom hook designed to simplify the process of creating a new token on the ZIGChain network. This hook allows you to specify essential details for token creation, including name, ticker, max supply, metadata URI, and other custom data fields. It encapsulates multiple transaction messages (denomination creation, metadata setting, and token minting) into a single interface, making it easy to set up new tokens.

## Example Usage

Here’s how to use `useCreateToken` to create a new token:

```tsx
import React, { useState } from "react";
import { useCreateToken } from "@zigchain/zigchain-sdk";

export default function TokenCreationForm() {
  const { createToken, isLoading, error } = useCreateToken();
  const [signer, setSigner] = useState("");
  const [recipient, setRecipient] = useState("");
  const [name, setName] = useState("");
  const [ticker, setTicker] = useState("");
  const [maxSupply, setMaxSupply] = useState(1000);
  const [fixedSupply, setFixedSupply] = useState(true);
  const [metadataUri, setMetadataUri] = useState(
    "https://example.com/metadata"
  );
  const [uriHash, setUriHash] = useState("exampleUriHash");

  const handleCreateToken = async () => {
    await createToken({
      signer,
      recipient,
      name,
      ticker,
      maxSupply,
      fixedSupply,
      metadataUri,
      uriHash,
      onSuccess: () => {
        console.log("Token created successfully!");
      },
    });
  };

  return (
    <div>
      <input
        placeholder="Signer Address"
        value={signer}
        onChange={(e) => setSigner(e.target.value)}
      />
      <input
        placeholder="Recipient Address"
        value={recipient}
        onChange={(e) => setRecipient(e.target.value)}
      />
      <input
        placeholder="Token Name"
        value={name}
        onChange={(e) => setName(e.target.value)}
      />
      <input
        placeholder="Token Ticker"
        value={ticker}
        onChange={(e) => setTicker(e.target.value)}
      />
      <input
        type="number"
        placeholder="Max Supply"
        value={maxSupply}
        onChange={(e) => setMaxSupply(parseInt(e.target.value, 10))}
      />
      <input
        placeholder="Metadata URI"
        value={metadataUri}
        onChange={(e) => setMetadataUri(e.target.value)}
      />
      <input
        placeholder="URI Hash"
        value={uriHash}
        onChange={(e) => setUriHash(e.target.value)}
      />
      <button onClick={handleCreateToken} disabled={isLoading}>
        {isLoading ? "Creating..." : "Create Token"}
      </button>
      {error && <p>Error: {error.message}</p>}
    </div>
  );
}
```

## Hook Parameters and Returns

### Parameters

The `createToken` function accepts an object with the following properties:

| Property      | Type       | Description                                                                      |
| ------------- | ---------- | -------------------------------------------------------------------------------- |
| `signer`      | `string`   | The address of the account signing and creating the token.                       |
| `recipient`   | `string`   | The address that will receive the minted token.                                  |
| `name`        | `string`   | The name of the token.                                                           |
| `ticker`      | `string`   | The ticker symbol for the token.                                                 |
| `maxSupply`   | `number`   | The maximum supply of the token.                                                 |
| `fixedSupply` | `boolean`  | Determines if the token supply can be changed after creation.                    |
| `metadataUri` | `string`   | The URI where metadata for the token is stored.                                  |
| `uriHash`     | `string`   | The hash of the metadata, used to verify the integrity of the metadata URI.      |
| `onSuccess`   | `function` | A callback function that is triggered after a successful transaction (optional). |

### Returned Values

The `useCreateToken` hook returns the following values:

| Property      | Type            | Description                                                        |
| ------------- | --------------- | ------------------------------------------------------------------ |
| `createToken` | `Function`      | Function to initiate the token creation process.                   |
| `isLoading`   | `boolean`       | Indicates if the token creation process is ongoing.                |
| `error`       | `Error \| null` | Contains error details if the transaction fails, otherwise `null`. |

## Metadata Structure

The `metadataUri` in this hook points to a JSON file containing details about the token. The structure of the metadata JSON is described below. This data allows users to attach additional information about the token, enhancing its usability and providing a richer experience.

### `ExtraData` Interface

```typescript
export interface ExtraData {
  description: string;
  twitter: string;
  telegram: string;
  websiteUrl: string;
  icon: string;
}
```

Each field in `ExtraData` provides context and branding details:

| Field         | Type     | Description                                                               |
| ------------- | -------- | ------------------------------------------------------------------------- |
| `description` | `string` | A short description of the token.                                         |
| `twitter`     | `string` | URL to the token’s official Twitter profile.                              |
| `telegram`    | `string` | URL to the token’s official Telegram group.                               |
| `websiteUrl`  | `string` | The URL for the official website of the token.                            |
| `icon`        | `string` | A URL pointing to an icon or logo representing the token (e.g., on IPFS). |

#### Example Metadata JSON

Below is an example of what the metadata file might look like:

```json
{
  "description": "A utility token for the ZIGChain ecosystem.",
  "twitter": "https://twitter.com/ZIGChain",
  "telegram": "https://t.me/ZigchainCommunity",
  "websiteUrl": "https://zigchain.com",
  "icon": "https://example.com/token-icon.png"
}
```

### How It Works

1. **Create Denom Message**: Constructs a `MsgCreateDenom` message for creating the token denomination.
2. **Set Metadata Message**: Constructs a `MsgSetDenomMetadata` message to set the metadata for the token, including `metadataUri` and `uriHash`.
3. **Mint and Send Message**: Constructs a `MsgMintAndSendTokens` message to mint the specified amount of tokens to the recipient’s address.
4. **Transaction Execution**: Executes all three messages as a single transaction, ensuring the token is created, metadata is set, and the initial supply is minted.

## Error Handling and Loading State

- **`isLoading`**: This boolean value is set to `true` when the transaction is initiated and reset to `false` once completed.
- **`error`**: If the transaction fails, this value will contain an error message, which can be displayed to the user.

## Conclusion

The `useCreateToken` hook provides a comprehensive solution for creating and minting a new token on ZIGChain. With customizable parameters, metadata flexibility, and built-in transaction management, it makes token creation straightforward and efficient. The metadata fields help give the token a unique identity and facilitate user engagement by linking social media and website details directly to the token.

This hook encapsulates the entire token creation workflow, allowing you to quickly integrate token creation functionality into your application.
