---
title: How to Set up Oracle
description: Complete guide to integrating Stork Network oracle services on ZIGChain for reliable price feeds and external data. Learn how to access off-chain price feeds and push data on-chain.
keywords:
  [
    ZIGChain oracle,
    Stork Network,
    oracle integration,
    price feeds,
    ZIGChain price oracle,
    Stork oracle setup,
    oracle API,
    chain pusher,
    per-interaction updates,
    ZIGChain oracle integration,
  ]
sidebar_position: 1
---

# How to Set up Oracle

This guide walks you through setting up oracle integration on ZIGChain using [Stork Network's](https://stork.network) price feeds. Stork provides reliable off-chain price feeds and tools to push data on-chain.

<div class="spacer"></div>

## ZIGChain Oracles

Oracles provide a verifiable source of truth for external information flowing into blockchain environments from both onchain and offchain sources. In DeFi, oracles primarily deliver price feeds, often reference prices calculated from multiple sources. When evaluating oracle solutions, key factors include latency, frequency, reliability, data quality, and asset coverage.

### Stork

Stork delivers accurate price feeds with ultra-low latency, high uptime, and broad asset coverage, supporting perp DEXs, lending protocols, and DeFi ecosystems. Visit the [Stork docs](https://docs.stork.network) to get started.

<div class="spacer"></div>

## Overview

Stork Network

- Access off-chain price feeds for real-time market data
- Push price updates on-chain via chain pusher
- Integrate reliable oracle services into your ZIGChain applications

For detailed information about Stork Network's capabilities and features, see the [Stork Network documentation](https://docs.stork.network).

Before you begin, you will need to contact the ZIGChain team to facilitate obtaining your API key from Stork Network.

<div class="spacer"></div>

## Prerequisites

Before setting up the oracle integration, ensure you have:

- Access to ZIGChain network (public RPC endpoints are sufficient; see [Endpoints](/integration-guides/endpoints))
- Basic understanding of blockchain oracles
- Development environment set up

> **Note**: A local ZIGChain node is optional and only required if you need to run Chain Pusher locally or require private RPC access. For most use cases, public RPC endpoints are sufficient.

<div class="spacer"></div>

## Step 1: Request API Access

To integrate Stork oracles, you need a unique API key for your project. The ZIGChain team facilitates the connection with Stork Network, who will provide your API key.

### Request API Access

Contact the ZIGChain team to request API access:

- **Primary**: [Discord](https://discord.com/channels/486954374845956097/) - Reach out in the #developer-support channel
- **Alternative**: [Telegram](https://t.me/ZignalyHQ) - For direct support if Discord is unavailable

For additional support options, see [Community & Support](/about-zigchain/community-support).

### Information to Provide

When requesting API access, please include:

1. **Project name** and description
2. **Use case** for the oracle integration
3. **Expected data feed requirements** (which price pairs you need)
4. **Contact information** for your development team

### Process

The ZIGChain team will:

- Review your request
- Facilitate communication with the Stork team
- Coordinate with Stork Network to provide you with your unique API key

Once approved, Stork Network will issue your API key, which you'll use to authenticate with their REST and WebSocket APIs.

<div class="spacer"></div>

## Step 2: Set Up Off-Chain Price Feeds

Stork Network operates as a pull oracle, providing real-time price data through REST and WebSocket APIs. Follow the official Stork documentation to become a subscriber and access price feeds.

📖 **[Stork Documentation: Becoming a Subscriber](https://docs.stork.network/getting-started/becoming-a-subscriber)**

### Access Methods

Stork Network provides two primary methods to access price data:

1. **REST API**: For on-demand price queries
2. **WebSocket API**: For real-time streaming price updates

### Key Steps

1. **Obtain API credentials** from the ZIGChain team (as described in Step 1)
2. **Choose your access method**: REST for periodic updates or WebSocket for real-time streaming
3. **Configure authentication**: Use your API key in request headers
4. **Subscribe to price feeds**: Specify the asset pairs you need (e.g., ZIG/USD, BTC/USD)
5. **Verify data signatures**: Ensure data integrity by validating cryptographic signatures

### REST API Example

Query price data on-demand using the Stork REST API:

```bash
# Get latest price for specific assets
curl -X GET "https://rest.jp.stork-oracle.network/v1/prices/latest?assets=ZIGUSD,BTCUSD" \
  -H "Authorization: Basic YOUR_API_KEY"
```

For more details on the REST API, see the [Stork REST API documentation](https://docs.stork.network/api-reference/rest-api).

### WebSocket API Example

Subscribe to real-time price updates using the [Stork WebSocket API](https://docs.stork.network/api-reference/websocket-api/subscriber):

**Step 1**: Connect to the WebSocket endpoint:

```bash
wscat -c 'wss://api.jp.stork-oracle.network/evm/subscribe' \
  -H "Authorization: Basic YOUR_API_KEY"
```

**Step 2**: After connection is established, send the subscription message:

```json
{ "type": "subscribe", "trace_id": "test-123", "data": ["ZIGUSD", "BTCUSD"] }
```

<div class="spacer"></div>

## Step 3: Push Price Updates On-Chain

To use Stork price data in your smart contracts, the data must be written to the Stork contract on ZIGChain. Stork provides two methods:

📖 **[Stork Documentation: Putting Data On-Chain](https://docs.stork.network/getting-started/putting-data-on-chain)**

### Method 1: Chain Pusher (Continuous Updates)

Run the open-source Chain Pusher application to automatically maintain price updates on-chain.

- Download from the [stork-external GitHub repository](https://github.com/Stork-Oracle/stork-external)
- Configure which assets to push and update triggers
- You pay gas fees (split among all subscribers for the same asset)

### Method 2: Per-Interaction Updates (Recommended)

Integrate price updates directly into your dApp user interactions.

📖 **[Stork Documentation: Per-Interaction Updates](https://docs.stork.network/getting-started/putting-data-on-chain#updating-on-a-per-interaction-basis)**

This method follows this pattern:

- Fetch latest price from Stork API when user interacts with your dApp
- Submit price update and your contract call in a single atomic transaction
- End users pay gas fees as part of their transaction
- Most efficient approach for pull oracles

For network configuration details (RPC endpoints, chain IDs), refer to the [Endpoints](/integration-guides/endpoints) documentation.

<div class="spacer"></div>

## Additional Resources

- [Stork Network Documentation](https://docs.stork.network)
- [ZIGChain JS SDK](./js-sdk/introduction.md)
- [Block Explorers](/users/tools/block-explorers)
- [Developer Resources](./developer-tools/developer-resources.md)
