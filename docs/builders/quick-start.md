---
title: Quick Start Guide
description: Step-by-step guide to installing and setting up zigchaind CLI tool for ZIGChain development on Linux, Mac, and Windows (WSL). Learn to interact with the ZIGChain network.
keywords:
  [
    zigchaind CLI,
    ZIGChain build guide,
    ZIGChain developers,
    ZIGChain node setup,
    ZIGChain SDK quick start,
    ZIGChain development environment,
    ZIGChain blockchain,
    ZIGChain testnet,
    ZIGChain mainnet,
    ZIGChain developer tools,
  ]
sidebar_position: 1
---

import Tabs from '@theme/Tabs';
import TabItem from '@theme/TabItem';

# Quick Start Guide

`zigchaind` is the ZIGChain CLI. It is a command line tool that allows you to interact with the ZIGChain network. It is the primary tool for managing your ZIGChain node, wallet, and other related tasks on the ZIGChain network.

<div class="spacer"></div>

## Windows (WSL)

> 💡 **Windows Users:**  
> We recommend using [Windows Subsystem for Linux (WSL)](https://learn.microsoft.com/en-us/windows/wsl/) to run the Linux commands on your Windows machine.  
> Follow the steps below to get started with WSL, then continue with either the automated scripts or the manual setup.

### Setting Up WSL (for Windows users)

1. **Enable WSL**  
   Open **PowerShell** or **Command Prompt** as Administrator and run:

   ```bash
   wsl --install
   ```

   This installs WSL with Ubuntu as the default distribution. Restart your computer if prompted.

2. **Initialize Ubuntu**  
   Open WSL from your Start menu and create your UNIX username/password when prompted.

   Alternatively, you can also launch WSL anytime by running:

   ```bash
   wsl
   ```

3. **Update packages**

   ```bash
   sudo apt update
   ```

4. **Install build tools**

   ```bash
   sudo apt install build-essential
   ```

✅ Once WSL is ready, you can continue with the **Linux** instructions below as if you're on a native Linux system.

> 🔗 For more information: [Microsoft WSL Documentation](https://learn.microsoft.com/en-us/windows/wsl/)

<div class="spacer"></div>

## Automated Setup Scripts

You can use our automated setup scripts to quickly install and configure your ZIGChain node, or install it manually by following the [steps below](#quick-start-on-a-local-machine).

**Supported platforms**

- Linux (x86)
- Mac (Apple Silicon)
- Mac (Intel)

<Tabs groupId="platform">
  <TabItem value="Linux" label="Linux" default>
  
```bash
curl -O https://raw.githubusercontent.com/ZIGChain/docs/main/scripts/start-linux.sh
chmod +x start-linux.sh
./start-linux.sh
```

  </TabItem>
  <TabItem value="Mac ARM" label="Mac ARM">

```bash
curl -O https://raw.githubusercontent.com/ZIGChain/docs/main/scripts/start-macos.sh
chmod +x start-macos.sh
./start-macos.sh
```

  </TabItem>
  <TabItem value="Mac AMD" label="Mac AMD">

```bash
curl -O https://raw.githubusercontent.com/ZIGChain/docs/main/scripts/start-macos.sh
chmod +x start-macos.sh
./start-macos.sh
```

  </TabItem>
</Tabs>

The scripts will guide you through:

- Installing the `zigchaind` binary
- Setting up your node for Mainnet, Testnet, or Local development
- Configuring state sync and peer connections
- Setting up your node with the correct chain-id and genesis file

<div class="spacer"></div>

## Quick Start on a Local Machine

The following steps guide you through installing ZIGChain manually on an x86 Linux machine or on a Mac (Apple Silicon or Intel).

> **Windows (WSL):** If you're on Windows, set up WSL first: [Windows (WSL)](#windows-wsl).

### Install ZIGChain Binary

Install the ZIGChain CLI by downloading the latest pre-built binaries. The tar file also contains the script to launch and generate the genesis.  
Check the latest binaries here: https://github.com/ZIGChain/networks

<Tabs groupId="platform">
  <TabItem value="Linux" label="Linux" default>
  
```sh
cd /tmp/
LATEST_VERSION=$(curl -s https://raw.githubusercontent.com/ZIGChain/networks/refs/heads/main/zig-test-2/version.txt)
wget "https://raw.githubusercontent.com/ZIGChain/networks/refs/heads/main/zig-test-2/binaries/zigchaind-${LATEST_VERSION}-linux-amd64.tar.gz"
tar -zxvf "zigchaind-${LATEST_VERSION}-linux-amd64.tar.gz"
cd zigchaind-${LATEST_VERSION}-linux-amd64
mkdir -p $HOME/.local/bin
mv ./zigchaind $HOME/.local/bin/zigchaind
```

  </TabItem>
  <TabItem value="Mac ARM" label="Mac ARM">

```sh
cd /tmp/
LATEST_VERSION=$(curl -s https://raw.githubusercontent.com/ZIGChain/networks/refs/heads/main/zig-test-2/version.txt)
curl -O "https://raw.githubusercontent.com/ZIGChain/networks/refs/heads/main/zig-test-2/binaries/zigchaind-${LATEST_VERSION}-darwin-arm64.tar.gz"
tar -zxvf "zigchaind-${LATEST_VERSION}-darwin-arm64.tar.gz"
cd zigchaind-${LATEST_VERSION}-darwin-arm64
mkdir -p $HOME/.local/bin
mv ./zigchaind $HOME/.local/bin/zigchaind
```

  </TabItem>
  <TabItem value="Mac AMD" label="Mac AMD">

```sh
cd /tmp/
LATEST_VERSION=$(curl -s https://raw.githubusercontent.com/ZIGChain/networks/refs/heads/main/zig-test-2/version.txt)
curl -O "https://raw.githubusercontent.com/ZIGChain/networks/refs/heads/main/zig-test-2/binaries/zigchaind-${LATEST_VERSION}-darwin-amd64.tar.gz"
tar -zxvf "zigchaind-${LATEST_VERSION}-darwin-amd64.tar.gz"
cd zigchaind-${LATEST_VERSION}-darwin-amd64
mkdir -p $HOME/.local/bin
mv ./zigchaind $HOME/.local/bin/zigchaind
```

  </TabItem>
</Tabs>

Check that it works by running the following command:

```sh
zigchaind --help
```

⚠️ _If `$HOME/.local/bin` is not already in your `PATH`, add it or move `zigchaind` to another directory that is._

Example for zsh:

```sh
echo 'export PATH=$HOME/.local/bin:$PATH' >> ~/.zshrc
source ~/.zshrc
```

Example for bash:

```sh
echo 'export PATH=$HOME/.local/bin:$PATH' >> ~/.bashrc
source ~/.bashrc
```

⚠️ _If you have problem with permissions, ensure the folder has the correct permissions._

### Execute the Local Setup Script

The `zigchain_local_setup.sh` script automates the process of setting up your local ZIGChain blockchain environment. This script will:

- Initialize the blockchain with genesis configuration
- Create test accounts with predefined mnemonics
- Set up the necessary configuration files
- Prepare the blockchain for local development and testing

First, check if installed and if not, install jq:

<Tabs groupId="platform">
  <TabItem value="Linux" label="Linux" default>
    Check if jq is installed:
    ```
    which jq
    ```

    Install jq (if not installed):
    ```
    sudo apt install jq
    ```

  </TabItem>
  <TabItem value="Mac ARM" label="Mac ARM">
    Check if jq is installed:
    ```
    which jq
    ```

    Install jq (if not installed):
    ```
    brew install jq
    ```

  </TabItem>
  <TabItem value="Mac AMD" label="Mac AMD">
    Check if jq is installed:
    ```
    which jq
    ```

    Install jq (if not installed):
    ```
    brew install jq
    ```

  </TabItem>
</Tabs>

Download & Execute the script:

```sh
  cd /tmp/
  curl -O https://raw.githubusercontent.com/ZIGChain/docs/main/scripts/zigchain_local_setup.sh
  chmod +x zigchain_local_setup.sh
  ./zigchain_local_setup.sh
```

### Start the Blockchain

Once the setup script has completed successfully, you can start your local ZIGChain blockchain:

```sh
zigchaind start
```

This command will start the blockchain node and begin processing transactions. The blockchain will be accessible locally for development and testing purposes.

<div class="spacer"></div>

## Test accounts created

On genesis, the following accounts are created for testing purposes with the following mnemonics

```text
VAL_KEY="valuser1"
VAL_MNEMONIC="debate pottery prize tag lottery lounge protect fancy keep orbit person stage ten possible expect spend utility estate hope people attack input oval bird"

ZUSER1_KEY="zuser1"
ZUSER1_MNEMONIC="horse elite dog fix slide moon rely wife convince pear visa woman make rent giraffe under lawn impulse visit improve together above mixed what"

ZUSER2_KEY="zuser2"
ZUSER2_MNEMONIC="motion toddler sad surge present spot destroy clarify lyrics drastic cactus rhythm cupboard govern space soft fan accuse source spend artwork state smart motor"

ZUSER3_KEY="zuser3"
ZUSER3_MNEMONIC="design coral crawl aerobic airport engine spice impulse hobby limit twelve budget praise dog usage comic rain icon miss custom worth upper blade path"

ZUSER4_KEY="zuser4"
ZUSER4_MNEMONIC="blue define teach split satisfy mention food loop economy gravity lobster keep card milk smile unable barely attack shoot bulk vapor hybrid board drift"

ZUSER5_KEY="zuser5"
ZUSER5_MNEMONIC="net impact drift popular debris coast wrong iron amazing patient poet forward occur any private chunk tonight final clump general video bracket abstract fade"
```

<div class="spacer"></div>

## Examples to interact with the zigchaind

### Send and broadcast a transaction

In this example, we will:

1. Send a transaction from one account to another using the ZIGChain CLI.
2. Broadcast the transaction.

#### Step 1️⃣: Get the initial balance of the accounts

```sh
zigchaind query bank balances zuser1 --chain-id zigchain-1
zigchaind query bank balances zuser5 --chain-id zigchain-1
```

#### Step 2️⃣: Send a transaction

```sh
zigchaind tx bank send $(zigchaind keys show zuser1 -a) $(zigchaind keys show zuser5 -a) 100uzig --from zuser1 --gas auto --gas-adjustment 1.3 --gas-prices 0.0025uzig --chain-id zigchain-1
```

Get the transaction id (txhash) from the response

#### Step 3️⃣: Check the transaction

```sh
TX_ID=REPLACE_ME
zigchaind query tx $TX_ID --chain-id zigchain-1
```

Check the information under the "raw_log" field. If empty, means that everything went well.

#### Step 4️⃣: Verify that the sender's balance has decreased by the transferred amount plus gas fees

```sh
zigchaind query bank balances zuser1 --chain-id zigchain-1
zigchaind query bank balances zuser5 --chain-id zigchain-1
```

## Troubleshooting

### Handling "failed to initialize database: resource temporarily unavailable"

If you encounter the following error when starting `zigchaind`:

```
Error: failed to initialize database: resource temporarily unavailable
```

This typically means a `zigchaind` process is already running in the background, which is locking the database.

#### Step 1️⃣: Check Running Processes

Use the following command to list any running `zigchaind` processes:

```bash
ps -ef | grep zigchaind
```

**Example output:**

```
501 91972 88195   0  8:43PM ??        52:43.17 zigchaind start
501  7790  5112   0  4:46PM ttys008    0:00.00 grep --color=auto zigchaind
```

Look for a line showing `zigchaind start`. Note the process ID (e.g., `91972`).

#### Step 2️⃣: Kill the Process

Terminate the process using the following command:

```bash
kill -9 [PROCESS_ID]
```

**Example:**

```bash
kill -9 91972
```

#### 💡 Tip: Stop from the Terminal Tab

If you started `zigchaind` in a terminal tab, you can stop it directly with:

```bash
Ctrl + C
```

Once the process is stopped, you can retry your `zigchaind` command.

---

✅ This should resolve the database initialization issue and allow you to continue working with your local ZIGChain node.

<div class="spacer"></div>

## Zigchain Testnet Essentials

Everything you need to get started with Zigchain Testnet in one place.

---

### Network Details

| Component     | Description                   | Documentation Link                                         |
| ------------- | ----------------------------- | ---------------------------------------------------------- |
| **Endpoints** | RPC, API, and Faucet URLs     | [Endpoints Documentation](../integration-guides/endpoints) |
| **Explorers** | Block explorers and analytics | [Block Explorers](../users/tools/block-explorers)          |

---

### Chain IDs

| Environment           | Chain ID     |
| --------------------- | ------------ |
| **Testnet**           | `zig-test-2` |
| **Local Development** | `zigchain-1` |

---

### Developer Resources

| Guide/Tool                       | Description                          | Link                                                                  |
| -------------------------------- | ------------------------------------ | --------------------------------------------------------------------- |
| **Validator / Node Setup Guide** | Step-by-step node setup              | [Node Setup](../nodes-and-validators/setup-node)                      |
| **SDK for Development**          | JavaScript SDK & usage guides        | [SDK Docs](./react-sdk/introduction)                                  |
| **Multi-Validator Setup**        | Local test network with 3 validators | [Multi-Validator Setup](../nodes-and-validators/multivalidator-setup) |

---
