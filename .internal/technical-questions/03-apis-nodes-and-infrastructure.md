# APIs, nodes, and infrastructure

RPC/LCD URLs, node installation, config, hardware, documentation links, and faucet.

_Last updated: Oct 31st, 2025_

---

## What SDK or CLI is available for address generation and offline transaction building or signing?

`zigchain` CLI.  
 Binaries: [https://github.com/ZIGChain/networks/tree/main/zig-test-2/binaries](https://github.com/ZIGChain/networks/tree/main/zig-test-2/binaries)  
 Installation guide: [https://docs.zigchain.com/build/quick-start](https://docs.zigchain.com/build/quick-start)

---

## Where is the blockchain explorer?

Range App Explorer (ZIGChain section):  
 [https://app.range.org/zigchain/general](https://app.range.org/zigchain/general)

(Also: Range App Explorer — [https://app.range.org/zigchain/general](https://app.range.org/zigchain/general))

---

## Where is the technical documentation?

[https://docs.zigchain.com](https://docs.zigchain.com)

---

## How do I access public nodes (RPC, LCD, faucet)?

Testnet RPC: [https://public-zigchain-testnet-rpc.numia.xyz](https://public-zigchain-testnet-rpc.numia.xyz)  
 LCD/API: [https://public-zigchain-testnet-lcd.numia.xyz](https://public-zigchain-testnet-lcd.numia.xyz)  
 Faucet: [https://faucet.zigchain.com](https://faucet.zigchain.com)

---

## Where is the node API documentation?

Use LCD/gRPC endpoints (Cosmos APIs) via the public API:  
 [https://public-zigchain-testnet-lcd.numia.xyz](https://public-zigchain-testnet-lcd.numia.xyz)

---

## Where are the steps or documentation for installing a node?

Set up a node (testnet) and Quick Start guide for local development:  
 [https://docs.zigchain.com/build/quick-start](https://docs.zigchain.com/build/quick-start)

---

## How do I generate an address and private key (demo)?

Quick Start creates test accounts with sample mnemonics.  
 `zigchaind keys add` supports key generation and recovery.

---

## Where is the GitHub repository?

[https://github.com/ZIGChain](https://github.com/ZIGChain)  
 Currently private; access available upon request.

---

## What are the recommended hardware requirements for a node?

- CPU: 8-core (4 physical cores), x86_64 architecture

- Memory: 32 GB RAM

- Storage: 1 TB SSD

- Network: Stable internet connection

---

## Where are block data or snapshots available?

Snapshot URL available but dynamic; not publicly accessible yet.

---

## What are the public API (LCD) and RPC interface URLs?

**Mainnet:**  
 API → [https://public-zigchain-lcd.numia.xyz](https://public-zigchain-lcd.numia.xyz)  
 RPC → [https://public-zigchain-rpc.numia.xyz](https://public-zigchain-rpc.numia.xyz)

**Testnet:**  
 API → [https://public-zigchain-testnet-lcd.numia.xyz](https://public-zigchain-testnet-lcd.numia.xyz)  
 RPC → [https://public-zigchain-testnet-rpc.numia.xyz](https://public-zigchain-testnet-rpc.numia.xyz)

---

## Where is the documentation for creating accounts?

[https://docs.zigchain.com/general/accounts](https://docs.zigchain.com/general/accounts)

---

## Where is the configuration file directory?

Default data directory: `~/.zigchain`

`~/.zigchain`  
`├── config`  
`│   ├── app.toml`  
`│   ├── client.toml`  
`│   ├── config.toml`  
`│   ├── genesis.json`  
`│   ├── node_key.json`  
`│   └── priv_validator_key.json`  
`└── data`  
 `└── priv_validator_state.json`

---

## How do I customize the RPC port and blockchain data directory?

To customize the port: edit `~/.zigchain/config/config.toml` and `~/.zigchain/config/app.toml`.  
 To change the home directory:

`zigchaind init mynode --home $PATH`

---

## Where is the RPC/SDK documentation?

[https://docs.zigchain.com/zigchain-sdk/introduction](https://docs.zigchain.com/zigchain-sdk/introduction)

---

## Where is the API reference (e.g. Swagger)?

Swagger documentation available at:  
 [https://testnet-api.zigchain.com/](https://testnet-api.zigchain.com/)

---

## Which node ports need to be exposed externally?

Light nodes only require P2P connections, usually through port `26656`.  
 No need to expose the wallet node to external networks.

---

## Is IP whitelisting required for node synchronization?

No IP whitelisting is required for node synchronization.

---

## Where is the open source or code documentation?

Public documentation: [https://docs.zigchain.com](https://docs.zigchain.com)  
 Repository currently private; view access available upon request.

---

## Where is the node building documentation?

Reference: [https://docs.zigchain.com/category/nodes-and-validators](https://docs.zigchain.com/category/nodes-and-validators)  
 The DevRel team can schedule a call to address missing or unclear details.

---

## Where is the node interface (RPC/API) documentation?

Endpoints and usage examples:

- Latest block height → GET `/status` or `/block/latest`

- Get block by height → GET `/block?height=X`

- Get transaction by hash → GET `/tx?hash=...`

- Search transactions → GET `/tx_search?query="..."`

Full API/RPC documentation:  
 [https://testnet-rpc.zigchain.com/](https://testnet-rpc.zigchain.com/)  
 [https://testnet-api.zigchain.com/](https://testnet-api.zigchain.com/)

---

## Where is wallet usage documented?

**Browser wallets:** Leap Wallet, Keplr  
 **Hardware wallets:** Ledger, CLI

Setup guide: [https://docs.zigchain.com/general/add-testnet](https://docs.zigchain.com/general/add-testnet)  
 SDK: [https://docs.zigchain.com/zigchainjs/introduction](https://docs.zigchain.com/zigchainjs/introduction)

---

## Is the chain supported by any hardware or device applications?

Yes. **Keplr** and **Leap** wallets are used to integrate with hardware wallets (e.g. Ledger with the Cosmos app).

---

## What are the node RPC and LCD URLs (public/foundation)?

**Testnet:**  
 API → [https://public-zigchain-testnet-lcd.numia.xyz](https://public-zigchain-testnet-lcd.numia.xyz)  
 RPC → [https://public-zigchain-testnet-rpc.numia.xyz](https://public-zigchain-testnet-rpc.numia.xyz)

**Mainnet:**  
 API → [https://public-zigchain-lcd.numia.xyz](https://public-zigchain-lcd.numia.xyz)  
 RPC → [https://public-zigchain-rpc.numia.xyz](https://public-zigchain-rpc.numia.xyz)

RPS = 5 × TPS

---

## Where are full archive node or snapshot URLs?

Testnet: [https://snapshots.zigchain.com](https://snapshots.zigchain.com)  
 Mainnet: [https://snapshots.zigchain.com](https://snapshots.zigchain.com)

**History availability (archive node):**  
For mainnet, snapshot files are available and generated daily to support fast synchronization.  
However, exchanges can quickly set up their own nodes using state sync on both mainnet and testnet.

---

## Are nodes pruned or is full history kept?

We have both pruned and non-pruned (archive) nodes.  
Exchanges and integrators can run their own node with the pruning strategy that fits their needs.

---

## Is there an indexing client or indexing service?

ZIGChain exposes standard Cosmos SDK RPC and LCD APIs.  
Exchanges can run their own indexer or use third-party Cosmos indexers.  
No custom or proprietary indexing client is required.

---

## What is the notification period for breaking changes?

Three weeks' advance notice is provided for breaking changes.

---

## Where is the faucet for testnet?

[https://faucet.zigchain.com](https://faucet.zigchain.com)

---

## Is Fireblocks IP whitelisting required?

No — whitelisting is not required.

---

## Where is the block explorer?

[https://app.range.org/zigchain/general](https://app.range.org/zigchain/general)

---
