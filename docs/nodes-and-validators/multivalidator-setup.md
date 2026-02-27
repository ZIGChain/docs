---
title: Multi-Validator Local Network Setup Guide
description: Step-by-step guide to setting up a local ZIGChain network with multiple validators for testing and development using the multivalidator.sh script.
keywords:
  [
    ZIGChain local network,
    multi-validator testnet,
    localnet setup ZIGChain,
    ZIGChain development environment,
    ZIGChain genesis configuration,
    ZIGChain validators,
    ZIGChain node setup,
    ZIGChain testnet,
    ZIGChain consensus module,
  ]
sidebar_position: 6
---

# Multi-Validator Local Network Setup Guide

When building and testing on ZIGChain, running a single validator node is often enough to get started. But real blockchain networks rely on multiple validators working together to reach consensus, secure the chain, and process governance decisions.
The `multivalidator.sh` script sets up a local ZIGChain network with three validators for testing and development purposes. This creates a more realistic blockchain environment compared to a single-node setup.

## What the Script Does

The script automates the creation of a three-validator ZIGChain network with the following features:

- **Three separate validator nodes** running on different ports
- **Pre-configured test accounts** with known mnemonics for easy testing
- **Genesis configuration** with proper denom settings and governance parameters
- **Network connectivity** between all three validators
- **Ready-to-use RPC endpoints** for application development

## Quick Start

> **Important**: Follow the [Quick Start Guide](../builders/quick-start) to install `zigchaind` and `jq` if you haven't already

### 1. Download & Execute the Script

Download and run the multivalidator setup script:

```sh
cd /tmp/
curl -O https://raw.githubusercontent.com/ZIGChain/docs/main/scripts/multivalidator.sh
chmod +x multivalidator.sh
./multivalidator.sh
```

The script will automatically:

- Set up three validator nodes with different port configurations
- Create and fund test accounts with known mnemonics
- Configure genesis parameters for local development
- Generate connection information and start commands

### 2. After Running the Script

Once the script completes successfully, you'll see output with:

- **Node IDs and connection information** for all three validators
- **Validator operator addresses** for use in contracts and tests
- **Start commands** for each validator
- **RPC endpoint URLs** for connecting your applications

### 3. Starting the Validators

The script will display three start commands with the correct node IDs and connection details. Copy and run each command in a separate terminal:

1. **Terminal 1** - Start the first validator (bootstrap node)
2. **Terminal 2** - Start the second validator (connects to first)
3. **Terminal 3** - Start the third validator (connects to first)

## Connecting Applications

Use any of the three RPC endpoints to connect your applications:

- Node1 RPC: `http://127.0.0.1:26657`
- Node2 RPC: `http://127.0.0.1:26667`
- Node3 RPC: `http://127.0.0.1:26669`

This setup is ideal for testing multi-validator scenarios, governance proposals, and distributed application development.
