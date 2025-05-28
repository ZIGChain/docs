---
sidebar_position: 1
---

# Introduction

Welcome to the **ZIGChain JS SDK**! This SDK allows developers to seamlessly interact with the ZIGChain blockchain, providing tools for querying data, composing messages, managing wallets, and performing blockchain transactions in JavaScript or TypeScript applications. Whether you're building decentralized applications (dApps), integrating blockchain features, or creating custom tools, the ZIGChain JS SDK provides all the essential components.

## Why Use ZIGChain JS SDK?

- **Easy to Use**: Simplifies interaction with the ZIGChain blockchain by providing convenient methods and abstractions.
- **Comprehensive**: Supports querying balances, composing messages, and broadcasting transactions for Cosmos, CosmWasm, and IBC modules.
- **Network Flexibility**: Supports different networks like `mainnet`, `testnet`, and custom configurations.
- **Modular**: Built to be modular and flexible, it integrates seamlessly with Cosmos-based chains and wallets.

---

## Choosing Between ZIGChain SDK and ZIGChain SDK JS

ZIGChain provides two Software Development Kits (SDKs) for building applications on top of its blockchain: [ZIGChain SDK](../zigchain-sdk/introduction.md) and **ZIGChain SDK JS** to build on top of ZIGChain. Below is a comparison to help you to choose the right SDK based on their project requirements:

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

## Installation

To get started with the ZIGChain JS SDK, install it in your project using your preferred package manager:

import Tabs from '@theme/Tabs';
import TabItem from '@theme/TabItem';

<Tabs>
  <TabItem value="npm" label="npm" default>

```bash
npm install @zigchain/zigchainjs @cosmjs/encoding @cosmjs/proto-signing @cosmjs/stargate
```

  </TabItem>
  <TabItem value="yarn" label="Yarn">

```bash
yarn add @zigchain/zigchainjs @cosmjs/encoding @cosmjs/proto-signing @cosmjs/stargate
```

  </TabItem>
</Tabs>

---

## Usage

### RPC Clients

```js
import { zigchain } from "@zigchain/zigchainjs";

const { createRPCQueryClient } = zigchain.ClientFactory;
const client = await createRPCQueryClient({ rpcEndpoint: RPC_ENDPOINT });

// now you can query the cosmos modules
const balance = await client.cosmos.bank.v1beta1.allBalances({
  address: "zigchain1addresshere",
});

// you can also query the zigchain modules
const denoms = await client.zigchain.factory.denomAll();
```

### Composing Messages

Import the `zigchain` object from `zigchainjs`.

```js
import { zigchain } from "@zigchain/zigchainjs";

const { createDenom, setDenomMetadata, mintAndSendTokens } = zigchain.factory.MessageComposer.withTypeUrl;
```

#### Cosmos Messages

```js
import { cosmos } from "@zigchain/zigchainjs";

const {
  fundCommunityPool,
  setWithdrawAddress,
  withdrawDelegatorReward,
  withdrawValidatorCommission,
} = cosmos.distribution.v1beta1.MessageComposer.fromPartial;

const { multiSend, send } = cosmos.bank.v1beta1.MessageComposer.fromPartial;

const {
  beginRedelegate,
  createValidator,
  delegate,
  editValidator,
  undelegate,
} = cosmos.staking.v1beta1.MessageComposer.fromPartial;

const { deposit, submitProposal, vote, voteWeighted } =
  cosmos.gov.v1beta1.MessageComposer.fromPartial;
```

## Connecting with Wallets and Signing Messages

For web interfaces, we recommend using [cosmos-kit](https://docs.cosmology.zone/cosmos-kit). This framework simplifies wallet connections and management. Continue below to see how to manually construct signers and clients.

### Initializing the Stargate Client

Use `getSigningZIGChainClient` to get your `SigningStargateClient`, with the proto/amino messages full-loaded. No need to manually add amino types, just require and initialize the client:

```js
import { getSigningZIGChainClient } from "@zigchain/zigchainjs";

const stargateClient = await getSigningZIGChainClient({
  rpcEndpoint,
  signer, // OfflineSigner
});
```

### Creating Signers and Broadcast Client

To broadcast messages, you can create signers with a variety of options:

- [cosmos-kit](https://docs.cosmology.zone/cosmos-kit) (recommended)
- [keplr](https://docs.keplr.app/api/cosmjs.html)
- [cosmjs](https://gist.github.com/webmaster128/8444d42a7eceeda2544c8a59fbd7e1d9)

:::warning

IT IS NOT RECOMMENDED TO USE PLAIN-TEXT MNEMONICS. Please take care of your security and use best practices.

:::

```js
import { chains } from "chain-registry";
import { DirectSecp256k1HdWallet, OfflineDirectSigner, Registry, } from "@cosmjs/proto-signing";
import { SigningStargateClient, GasPrice } from "@cosmjs/stargate";

const mnemonic = "<INSERT-MNEMONIC>";
const chain = chains.find(({ chain_name }) => chain_name === "zigchain");

const offlineSigner = await DirectSecp256k1HdWallet.fromMnemonic(mnemonic, {
  prefix: chain.bech32_prefix,
});

const gasPrice = GasPrice.fromString("0.00025uzig");

const registry = new Registry([]);

const stargateClient = await SigningStargateClient.connectWithSigner(
  rpcEndpoint,
  offlineSigner,
  { registry, gasPrice }
);
```

### Broadcasting Messages

Now that you have your `stargateClient`, you can broadcast messages:

```js
const { send } = cosmos.bank.v1beta1.MessageComposer.withTypeUrl;

const msg = send({
  amount: [
    {
      denom: "uzig",
      amount: "1000",
    },
  ],
  toAddress: address,
  fromAddress: address,
});

const fee: StdFee = {
  amount: [
    {
      denom: "uzig",
      amount: "864",
    },
  ],
  gas: "86364",
};
const response = await stargateClient.signAndBroadcast(address, [msg], fee);
```

## Advanced Usage

When working with Cosmos SDK-based blockchains like ZIGChain, there are scenarios where you might need more control over how clients interact with the blockchain. For example, you might want to customize the transaction signing process, handle specific message types, or register additional proto definitions and Amino converters.

The code snippet below demonstrates how to manually construct a `SigningStargateClient`, which is a client capable of signing and broadcasting transactions to the blockchain. This approach allows you to define custom proto registries and Amino converters, enabling interaction with ZIGChain-specific messages and other Cosmos SDK modules.

```js
import { OfflineSigner, GeneratedType, Registry } from "@cosmjs/proto-signing";
import { AminoTypes, SigningStargateClient } from "@cosmjs/stargate";

import {
  cosmosAminoConverters,
  cosmosProtoRegistry,
  ibcProtoRegistry,
  ibcAminoConverters,
  zigchainAminoConverters,
  zigchainProtoRegistry
} from '@zigchain/zigchainjs';

const signer: OfflineSigner = /* create your signer (see above)  */
const rpcEndpint = 'https://rpc.cosmos.directory/zigchain'; // or another URL

const protoRegistry: ReadonlyArray<[string, GeneratedType]> = [
    ...cosmosProtoRegistry,
    ...ibcProtoRegistry,
    ...zigchainProtoRegistry
];

const aminoConverters = {
    ...cosmosAminoConverters,
    ...ibcAminoConverters,
    ...zigchainAminoConverters
};

const registry = new Registry(protoRegistry);
const aminoTypes = new AminoTypes(aminoConverters);
const gasPrice = GasPrice.fromString("0.00025uzig");

const stargateClient = await SigningStargateClient.connectWithSigner(rpcEndpoint, signer, {
    registry,
    aminoTypes,
    gasPrice,
});
```
