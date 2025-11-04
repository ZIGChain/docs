---
sidebar_position: 1
---

# Introduction

Welcome to the **ZIGChain SDK**! This SDK allows developers to seamlessly interact with the ZIGChain blockchain, providing tools for querying data, managing wallets, and performing blockchain transactions in your JavaScript or TypeScript applications. Whether you're building decentralized applications (dApps), integrating blockchain features, or creating custom tools, the ZIGChain SDK provides all the essential components.

## Why Use ZIGChain SDK?

- **Easy to Use**: Simplifies interaction with the ZIGChain blockchain by providing convenient methods and abstractions.
- **Comprehensive**: Supports querying token data, pools, balances, and metadata, as well as performing complex operations such as swaps.
- **Network Flexibility**: Supports different networks like `mainnet`, `testnet`, and allows custom configurations for private or custom blockchain networks.
- **Modular**: Built to be modular and flexible, it integrates with other Cosmos-based chains and wallets seamlessly.

---

## Choosing Between ZIGChain SDK and ZIGChain SDK JS

ZIGChain provides two Software Development Kits (SDKs) for building applications on top of its blockchain: ZIGChain SDK and [ZIGChain SDK JS](../zigchainjs/introduction.md) to build on top of ZIGChain. Below is a comparison to help you to choose the right SDK based on their project requirements:

| Feature             | ZIGChain SDK                                                  | ZIGChain SDK JS                                                |
|---------------------|---------------------------------------------------------------|----------------------------------------------------------------|
| Description         | Frontend (FE) SDK leveraging Cosmos Kit, adapted for ZIGChain | Lightweight SDK suitable for both frontend and backend (FE/BE) |
| Best for            | Rapid development with minimal customization                  | Greater flexibility and customization options                  |
| Frontend/Backend    | Frontend                                                      | Frontend and Backend                                           |
| Other requirements? | Standalone usage                                              | Combine it with Cosmos Kit                                     |
| Expertise level     | Beginner-friendly                                             | Best for advanced users or complex architectures/designs       |

### When to use ZIGChain SDK or ZIGChain SDK JS?

Use **ZIGChain SDK** if:
- ✅ Best for frontend applications that need quick and simple blockchain integration.
- ✅ Built-in wallet management via Cosmos Kit, with minimal setup required.
- ✅ Ideal for querying balances, pools, and executing swaps without deep blockchain knowledge.

**Example Use Case:**
A token factory frontend that enables users to create new tokens, check their balances, and manage supply directly from the UI with minimal configuration.

Use **ZIGChain SDK JS** if:
- ✅ Works for both frontend and backend, enabling full-stack blockchain interactions.
- ✅ Together with Cosmos Kit, provides a powerful set that offers flexibility to build any type of product
- ✅ Gives maximum flexibility for composing, signing, and broadcasting blockchain messages.

**Example Use Case:**
A decentralized lending protocol, where the backend handles smart contract interactions, automates loan issuance, liquidations, and interest calculations. The SDK enables seamless communication between borrowers, lenders, and the protocol’s smart contracts across Cosmos-based networks.

---

# Installation

To get started with the ZIGChain SDK, you need to install it in your project. Use your preferred package manager to install the SDK:

import Tabs from '@theme/Tabs';
import TabItem from '@theme/TabItem';

<Tabs>
  <TabItem value="npm" label="npm" default>

```bash
npm install @zigchain/zigchain-sdk @cosmos-kit/react
```

  </TabItem>
  <TabItem value="yarn" label="Yarn">

```bash
yarn add @zigchain/zigchain-sdk @cosmos-kit/react
```

  </TabItem>
  <TabItem value="pnpm" label="pnpm">

```bash
pnpm add @zigchain/zigchain-sdk @cosmos-kit/react
```

  </TabItem>
</Tabs>

### Cosmos-Kit Dependency

The **ZIGChain SDK** depends on [**cosmos-kit**](https://docs.cosmology.zone/cosmos-kit), a powerful framework for connecting Cosmos wallets and managing blockchain interactions across multiple chains. Cosmos-Kit provides wallet integration and connection management for wallets like Keplr, Cosmostation, Leap, and more, allowing you to easily connect to various Cosmos-based blockchains.

#### Key Benefits of Cosmos-Kit:

- **Multi-Wallet Support**: Integrates seamlessly with popular wallets in the Cosmos ecosystem.
- **Multi-Chain Support**: Easily switch between multiple Cosmos-based blockchains.
- **React Hooks**: Provides hooks for wallet connection management, making it easy to integrate with React applications.
- **Composable Architecture**: Designed for flexibility, making it easy to customize or extend for your specific needs.

For more information on how to integrate wallet support and manage connections with Cosmos-Kit, visit the [official Cosmos-Kit documentation](https://docs.cosmology.zone/cosmos-kit).

---

### Setting up the SDK with `ZigchainContextProvider`

After installing the dependencies, you'll need to configure the SDK in your application. This involves setting up the `ZigchainContextProvider` to manage wallet connections and blockchain interactions. It does not support being rendered as a server component. To use it properly in a Next.js (or similar) environment, it must be wrapped in a client component that includes the `"use client"` directive.

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

### Custom Network Configuration

If you're working with a custom ZIGChain network, you can easily pass custom configuration settings like `rpcURL`, `apiURL`, and `prefix`:

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

This provides flexibility to integrate with custom networks or test environments.

---

## Next Steps

Once you've set up the SDK and `ZigchainContextProvider`, you're ready to start interacting with the ZIGChain blockchain. Check out our [Hooks Documentation](../category/hooks) and examples to see how to query tokens, fetch balances, and perform other blockchain actions.

For more advanced configuration and usage, head over to the [Context Provider](provider.md) section.
