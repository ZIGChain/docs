---
sidebar_position: 1
---

# How to Set Up Oracle Integration

This guide walks you through setting up oracle integration on ZIGChain using Stork Network's price feeds. Stork provides reliable off-chain price feeds and tools to push data on-chain.

<div class="spacer"></div>

## Overview

Stork Network enables you to:

- Access off-chain price feeds for real-time market data
- Push price updates on-chain via chain pusher
- Integrate reliable oracle services into your ZIGChain applications

Before you begin, you will need to contact the ZIGChain team to obtain your API key and establish communication with the Stork team.

<div class="spacer"></div>

## Prerequisites

Before setting up the oracle integration, ensure you have:

- A running ZIGChain node (see [Set Up a Node](../nodes_validators/setup-node.md))
- Basic understanding of blockchain oracles
- Development environment set up

<div class="spacer"></div>

## Step 1: Contact ZIGChain Team for API Access

To integrate Stork oracles, you need a unique API key for your project.

### Request API Access

Contact the ZIGChain team to request API access:

- **[Discord](https://discord.com/channels/486954374845956097/)**: Reach out in the #developer-support channel
- **[Telegram](https://t.me/ZignalyHQ)**: Connect with the team for direct support

For additional support options, see [Community & Support](../resources/community-support.md).

### Information to Provide

When requesting API access, please include:

1. **Project name** and description
2. **Use case** for the oracle integration
3. **Expected data feed requirements** (which price pairs you need)
4. **Contact information** for your development team

The ZIGChain team will:

- Review your request
- Create a dedicated communication channel with the Stork team
- Provide you with your unique API key

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


Step 1: Connect to the WebSocket endpoint:

```bash
wscat -c 'wss://api.jp.stork-oracle.network/evm/subscribe' \
  -H "Authorization: Basic YOUR_API_KEY"
```

Step 2: After connection is established, send the subscription message by typing or pasting:

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

- Fetch latest price from Stork API when user interacts with your dApp
- Submit price update and your contract call in a single atomic transaction
- End users pay gas fees as part of their transaction
- Most efficient approach for pull oracles

For network configuration details (RPC endpoints, chain IDs), refer to the [Endpoints](../build/endpoints.md) documentation.

<div class="spacer"></div>

## Additional Resources

- [Stork Network Documentation](https://docs.stork.network)
- [ZIGChain SDK](../zigchain-sdk/introduction.md)
- [Block Explorers](../resources/block-explorers.md)
- [Developer Resources](../resources/developer-resources.md)
