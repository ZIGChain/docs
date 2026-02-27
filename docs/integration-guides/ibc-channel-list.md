---
title: IBC Channel List
description: Complete list of active IBC channels between ZIGChain and other networks including Axelar, Noble, and Cosmos Hub for testnet and mainnet.
keywords:
  [
    ZIGChain IBC channels,
    IBC transfer ZIGChain,
    Cosmos interoperability,
    ZIGChain cross-chain communication,
    ZIGChain cross-chain interoperability,
    ZIGChain Bridge,
    ZIGChain cross-chain bridge,
  ]
sidebar_position: 9
---

# IBC Channel List

This page lists all active Inter-Blockchain Communication (IBC) channels between ZIGChain and other networks. These channels enable secure token transfers and cross-chain communication across the Cosmos ecosystem.

### TestNet Channels

The following IBC connections are established on the ZIGChain TestNet (`zig-test-2`):

| Source Chain ID | Source Channel | Destination | Destination Chain ID    | Destination Channel |
| --------------- | -------------- | ----------- | ----------------------- | ------------------- |
| zig-test-2      | channel-0      | Axelar      | axelar-testnet-lisbon-3 | channel-612         |
| zig-test-2      | channel-44     | Noble       | grand-1                 | channel-704         |
| zig-test-2      | channel-43     | Cosmos      | provider                | channel-566         |

### MainNet Channels

The following IBC connections are established on the ZIGChain MainNet (`zigchain-1`):

| Source Chain ID | Source Channel | Destination | Destination Chain ID | Destination Channel |
| --------------- | -------------- | ----------- | -------------------- | ------------------- |
| zigchain-1      | channel-1      | Axelar      | axelar-dojo-1        | channel-182         |
| zigchain-1      | channel-3      | Noble       | noble-1              | channel-175         |
| zigchain-1      | channel-4      | Cosmos      | cosmoshub-4          | channel-1555        |
