---
title: ZIGChain Context Provider
description: Complete guide to using ZigchainContextProvider in React applications, including network configuration, custom configs, and accessing the ZIGChain client context.
keywords:
  [
    ZigchainContextProvider,
    React context,
    network configuration,
    mainnet,
    testnet,
    custom network,
    client setup,
    React hooks,
    context provider,
  ]
sidebar_position: 2
---

# ZIGChain Context Provider

The `ZigchainContextProvider` is a React context provider that manages the state and configuration of the `ZIGChain` client, including the network and its configuration. It allows easy access to the `ZIGChain` client and provides methods for switching between networks (`mainnet`, `testnet`, or custom) dynamically. It does not support being rendered as a server component. To use it properly in a Next.js (or similar) environment, it must be wrapped in a client component that includes the `"use client"` directive.

### Installation

To use the `ZigchainContextProvider` in your project, import it along with the required dependencies:

```tsx
import {
  ZigchainContextProvider,
  useZigchainContext,
} from "@zigchain/zigchain-sdk";
```

### Provider: `ZigchainContextProvider`

The `ZigchainContextProvider` wraps your application and provides the `ZIGChain` client and configuration via a React context.

#### Props

| Prop           | Type                                               | Description                                                                                                     |
| -------------- | -------------------------------------------------- | --------------------------------------------------------------------------------------------------------------- |
| `network`      | `"mainnet" \| "testnet" \| "localnet" \| "custom"` | (Optional) The initial network to use. Defaults to `"testnet"`.                                                 |
| `customConfig` | `CustomConfig`                                     | (Optional) Custom network configuration (RPC and API URLs, and prefix). Only used when `network` is `"custom"`. |
| `children`     | `React.ReactNode`                                  | The React component tree that will be wrapped by the context provider.                                          |

#### Example Usage

Wrap your application with the `ZigchainContextProvider` and `ChainProvider`:

```tsx
import { ZigchainContextProvider } from "@zigchain/zigchain-sdk";
import {
  zigchain,
  localzigchainAssetlist,
  mainnetConfig,
} from "@zigchain/zigchain-sdk"; // ZIGChain configurations

function App() {
  return (
    <ZigchainContextProvider network="mainnet">
      {/* Your app components */}
    </ZigchainContextProvider>
  );
}

export default App;
```

If you need to provide a custom network configuration:

```tsx
const customConfig = {
  rpcURL: "https://custom-rpc.example.com",
  apiURL: "https://custom-api.example.com",
  prefix: "custom",
};

<ZigchainContextProvider network="custom" customConfig={customConfig}>
  {/* Your app components */}
</ZigchainContextProvider>;
```

### Using the `useZigchainContext` Hook

You can access the `ZigchainContext` using the `useZigchainContext` hook. This hook provides access to the `client`, current `network`, `networkConfig`, and functions for updating the network.

#### Values from `useZigchainContext`

| Value              | Type                                               | Description                                                                            |
| ------------------ | -------------------------------------------------- | -------------------------------------------------------------------------------------- |
| `client`           | `Client \| null`                                   | The `ZIGChain` client instance.                                                        |
| `network`          | `"mainnet" \| "testnet" \| "localnet" \| "custom"` | The currently selected network.                                                        |
| `networkConfig`    | `CustomConfig`                                     | The current network configuration, including `rpcURL`, `apiURL`, and `prefix`.         |
| `setNetwork`       | `(network: Network) => void`                       | Function to change the network (`"mainnet"`, `"testnet"`, `"localnet"` or `"custom"`). |
| `setNetworkConfig` | `(config: CustomConfig) => void`                   | Function to update the network configuration (for custom networks).                    |

#### Example Usage

```tsx
import React, { useEffect } from "react";
import { useZigchainContext } from "@zigchain/zigchain-sdk";

const MyComponent = () => {
  const { client, network, setNetwork } = useZigchainContext();

  useEffect(() => {
    if (client) {
      // Example usage of the client
      client.zigchain.factory
        .denomAll({})
        .then((response) => console.log(response))
        .catch((error) => console.error(error));
    }
  }, [client]);

  return (
    <div>
      <p>Current Network: {network}</p>
      <button onClick={() => setNetwork("mainnet")}>Switch to Mainnet</button>
      <button onClick={() => setNetwork("testnet")}>Switch to Testnet</button>
      <button onClick={() => setNetwork("localnet")}>Switch to Testnet</button>
    </div>
  );
};

export default MyComponent;
```

### Custom Configuration Example

If you're using a custom network, you can update the `networkConfig` with custom `rpcURL`, `apiURL`, and `prefix` values using `setNetworkConfig`:

```tsx
import { useZigchainContext } from "@zigchain/zigchain-sdk";

const CustomNetworkComponent = () => {
  const { setNetwork, setNetworkConfig } = useZigchainContext();

  const switchToCustomNetwork = () => {
    setNetworkConfig({
      rpcURL: "https://custom-rpc.example.com",
      apiURL: "https://custom-api.example.com",
      prefix: "custom",
    });
    setNetwork("custom");
  };

  return (
    <button onClick={switchToCustomNetwork}>Switch to Custom Network</button>
  );
};

export default CustomNetworkComponent;
```

### Context Structure

#### `ZigchainContextValue` Interface

The `ZigchainContextValue` interface provides structure for the context, allowing access to the following:

| Value              | Type                                               | Description                                                                |
| ------------------ | -------------------------------------------------- | -------------------------------------------------------------------------- |
| `client`           | `Client \| null`                                   | The `ZIGChain` client instance.                                            |
| `network`          | `"mainnet" \| "testnet" \| "localnet" \| "custom"` | The currently selected network.                                            |
| `networkConfig`    | `CustomConfig`                                     | The current network configuration (`rpcURL`, `apiURL`, `prefix`).          |
| `setNetwork`       | `(network: Network) => void`                       | Function to change the network.                                            |
| `setNetworkConfig` | `(config: CustomConfig) => void`                   | Function to change the network configuration (useful for custom networks). |

#### `CustomConfig` Interface

This interface defines the structure for custom network configurations:

| Field    | Type     | Description                                |
| -------- | -------- | ------------------------------------------ |
| `rpcURL` | `string` | The RPC URL for the custom network.        |
| `apiURL` | `string` | The API URL for the custom network.        |
| `prefix` | `string` | The address prefix for the custom network. |
