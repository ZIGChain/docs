---
title: Securing Cosmos Validators with Sentry Nodes
description: Comprehensive guide to implementing sentry node architecture for ZIGChain validators to protect against DDoS attacks, including topology design, configuration, and best practices.
sidebar_position: 10
---

# Securing Cosmos Validators with Sentry Nodes

## 1. Introduction

Validators in Cosmos-based networks are critical infrastructure components responsible for block production and network consensus. However, their operational requirements make them vulnerable to Distributed Denial of Service (DDoS) attacks that can cause missed blocks, consensus failures, and ultimately slashing penalties that result in financial losses and reputation damage.

Sentry architecture provides a proven defensive topology designed specifically for blockchain validators. By hiding validators behind a layer of proxy nodes called sentries, this architecture makes targeted attacks significantly harder to execute while maintaining the validator's ability to participate fully in network consensus. This guide presents the concepts, topology, and configuration required to implement sentry architecture on any infrastructure type.

## 2. The Problem

Validators in Cosmos-based blockchains face unique security challenges that make them attractive targets for DDoS attacks:

**Fixed Network Location:** Unlike traditional web services that can leverage content delivery networks and dynamic routing, validators must maintain persistent network identities. They operate at fixed network locations that peers connect to, creating a predictable target for attackers.

**Deterministic Block Proposer Selection:** The Tendermint consensus algorithm used by Cosmos chains selects block proposers in a deterministic, round-robin fashion based on voting power. This means an attacker can predict exactly which validator will propose the next block, allowing them to time targeted attacks for maximum impact during the validator's proposer turn.

**Consensus Participation Requirements:** Validators must maintain constant connectivity to the network to participate in consensus rounds. Any disruption in network connectivity prevents them from receiving proposals, broadcasting votes, and participating in the two-phase commit process (pre-vote and pre-commit). Even brief interruptions can cause missed blocks.

**Slashing Penalties:** Missing blocks or being offline during consensus rounds results in automatic slashing penalties. These penalties reduce the validator's staked tokens and damage its reputation with delegators. Repeated failures can lead to jailing, temporarily removing the validator from the active set.

**Resource Exhaustion Attacks:** Opening standard ports like RPC (26657) and API (1317) to the public internet exposes validators to resource exhaustion attacks. Malicious actors can flood these endpoints with requests, consuming CPU, memory, and bandwidth until the validator can no longer process legitimate consensus messages.

## 3. Sentry Architecture Topology

### 3.1 Core Concept

Sentry architecture solves the validator exposure problem by implementing a two-layer network topology that separates the validator's consensus participation from its public network presence. This design is analogous to traditional enterprise security architectures where critical backend systems are isolated from the public internet behind DMZ proxy layers.

**Private Layer (Backend):**
The validator operates in a completely private network environment with no direct public internet connectivity. It has no public IP address and accepts connections only from a whitelist of known sentry nodes. This isolation makes the validator invisible to potential attackers scanning the network. The validator communicates with its sentries through private network channels such as VPN tunnels, direct fiber connections, or cloud provider private networking.

**Public Layer (Frontend):**
Multiple sentry nodes operate with both private and public network interfaces. Their public IPs are visible to the blockchain network and accept connections from peers worldwide. Their private interfaces connect exclusively to the validator. Sentries act as trusted relays, forwarding consensus messages between the validator and the public network without revealing the validator's identity or location. Because sentries don't hold signing keys and perform no consensus-critical operations, they can be destroyed, replaced, or scaled horizontally without risk to the validator's stake.

### 3.2 Communication Flow

The information flow in sentry architecture follows this pattern:

```
Public Blockchain Network <--> Sentry Nodes <--> Private Network <--> Validator
```

**Inbound Flow:** Block proposals, votes, and other consensus messages arrive at sentry nodes from public peers. Sentries validate these messages at the protocol level and forward them through private connections to the validator. The validator processes these messages, participates in consensus, and generates its own votes and proposals.

**Outbound Flow:** When the validator creates votes, proposals, or other consensus messages, it sends them to its connected sentries through private channels. Sentries then broadcast these messages to their public peers, which gossip them throughout the network. From the network's perspective, messages appear to originate from the sentry nodes, not the validator.

**Gossip Protocol Isolation:** The CometBFT peer exchange (PEX) reactor allows nodes to discover peers by gossiping peer information. In sentry architecture, sentries participate normally in PEX, sharing information about public peers they connect to. However, they are specifically configured to never gossip the validator's node ID or IP address, keeping the validator hidden from the network's peer discovery process.

### 3.3 Key Principles

The sentry architecture is built on four fundamental security principles:

**Isolation:** The validator's network identity (IP address and node ID) is never exposed to the public network. Only the sentries know how to reach the validator, and they are explicitly configured to keep this information private. This eliminates the validator as a direct attack target.

**Redundancy:** Operating multiple sentry nodes ensures that if one sentry is compromised or overwhelmed by an attack, the validator maintains connectivity through remaining sentries. With 2-3 sentries distributed geographically, the validator can withstand individual sentry failures or localized attacks without missing blocks.

**Scalability:** Because sentries are stateless proxies that don't participate in consensus or hold sensitive key material, new sentries can be deployed rapidly during an attack. Using state-sync, a new sentry can synchronize with the network in minutes rather than hours or days. This allows operators to horizontally scale their defense in response to active attacks.

**Obscurity:** Without the validator's IP address, attackers cannot direct traffic to it. They must attack the public-facing sentries, which can be quickly replaced with new IPs. The attacker faces a moving target while the validator remains safely hidden and operational behind the sentry layer.

## 4. DDoS Response Capabilities

### 4.1 Architectural Defenses

The sentry architecture provides several layers of defense against DDoS attacks:

**Sentry Multiplication:** When under attack, operators can rapidly deploy additional sentry nodes to distribute and absorb attack traffic. Since sentries can synchronize via state-sync in minutes, this response can be executed quickly. New sentries immediately begin accepting public connections, diluting the attack across more targets.

**IP Address Rotation:** If specific sentry IPs are targeted, those sentries can be destroyed and recreated with new IP addresses. The attacker must discover the new IPs and redirect their attack, buying time for the operator. This cat-and-mouse game favors defenders since IP changes are faster than attack redirection.

**Geographic Distribution:** Deploying sentries across different data centers, regions, or network providers prevents attackers from saturating network links at any single location. An attack powerful enough to overwhelm one region's bandwidth still leaves sentries in other regions operational.

**Connection Budget Management:** By controlling the maximum number of peer connections each node accepts, operators prevent resource exhaustion from connection floods. Sentries can accept many connections from public peers while validators maintain minimal connections only to known sentries.

### 4.2 Network-Level Tools

Beyond the architectural design, operators can deploy additional network security tools:

**Firewall Rate Limiting:** Modern firewalls can limit connection attempts per source IP, preventing any single attacker from consuming all available connection slots. Tools like iptables, nftables, and cloud security groups implement connection rate limiting and SYN flood protection.

**Connection State Tracking:** Firewalls track connection states and can drop connections that don't complete handshakes properly, mitigating SYN floods and half-open connection attacks.

**Bandwidth Shaping:** Quality-of-Service (QoS) rules can prioritize P2P traffic (port 26656) over other services, ensuring consensus messages get through even under heavy load on other ports.

**Geographic IP Filtering:** If attack traffic originates from specific geographic regions irrelevant to validator operations, entire IP ranges can be blocked at the firewall level.

**Connection Whitelisting:** When possible, sentries can whitelist known validator peers and trusted nodes, accepting their connections preferentially while rate-limiting unknown peers.

### 4.3 Protocol-Level Protection

CometBFT itself provides configuration options for DDoS mitigation:

**Peer Exchange Control:** The `pex` setting controls whether a node participates in peer gossiping. Validators disable this completely to avoid advertising themselves, while sentries enable it to participate in network peer discovery while hiding the validator.

**Private Peer Lists:** The `private_peer_ids` configuration ensures that even when PEX is enabled, specific node IDs (like the validator) are never included in gossip messages sent to other peers.

**Connection Limits:** Parameters like `max_num_inbound_peers` and `max_num_outbound_peers` control how many simultaneous connections a node maintains. Setting appropriate limits prevents attackers from exhausting connection tables or file descriptor limits.

**Bandwidth Throttling:** The `send_rate` and `recv_rate` parameters limit bandwidth consumed per peer connection. This prevents any single malicious peer from monopolizing the node's network capacity and ensures fair bandwidth allocation across all peers.

**Message Size Limits:** Configuration options limit the maximum size of messages accepted from peers, preventing memory exhaustion attacks that send oversized payloads.

## 5. Configuration Guide

This section provides concrete configuration examples for a production sentry architecture with 1 validator and 2 sentry nodes. This demonstrates redundancy while remaining simple enough to understand and replicate.

**Network Setup:**

- Validator: `10.0.1.5:26656` (private IP only, no public access)
- Sentry 1: `10.0.1.10:26656` (private IP), `203.0.113.50:26656` (public IP)
- Sentry 2: `10.0.1.11:26656` (private IP), `203.0.113.51:26656` (public IP)

**Node IDs (examples):**

- Validator: `abc123...` (40-character hex string)
- Sentry 1: `def456...`
- Sentry 2: `ghi789...`

To obtain your node ID, run: `<daemon> tendermint show-node-id`

### 5.1 Validator Node Settings

The validator configuration focuses on complete network isolation and minimal connectivity.

**Primary Configuration (config.toml):**

| Parameter                | Value            | Purpose                                                                                   |
| ------------------------ | ---------------- | ----------------------------------------------------------------------------------------- |
| `pex`                    | `false`          | Disables peer gossiping completely - validator will not share or request peer information |
| `persistent_peers`       | Sentry node list | Maintains persistent connections only to trusted sentries                                 |
| `private_peer_ids`       | (omit)           | Not needed when pex=false since validator doesn't gossip anything                         |
| `addr_book_strict`       | `false`          | Allows connections to private IP addresses (10.0.x.x, 192.168.x.x, 172.16.x.x ranges)     |
| `max_num_inbound_peers`  | `10`             | Limits inbound connections to expected sentry count plus small buffer                     |
| `max_num_outbound_peers` | `10`             | Controls outbound connection attempts to match expected sentries                          |

**Example config.toml (~/.app/config/config.toml):**

```toml
[p2p]
# Disable peer exchange - validator will not gossip or accept gossiped peers
pex = false

# Only connect to our two sentry nodes
persistent_peers = "def456...@10.0.1.10:26656,ghi789...@10.0.1.11:26656"

# Allow private IP addresses
addr_book_strict = false

# Limit peer connections to our sentries only
max_num_inbound_peers = 10
max_num_outbound_peers = 10

[rpc]
# Bind RPC only to localhost - no public access
laddr = "tcp://127.0.0.1:26657"
```

**Rationale:** With `pex = false`, the validator becomes a completely passive node that only communicates with explicitly configured peers in `persistent_peers`. It will never attempt to discover new peers or share peer information with others. The low peer limits prevent accidental connections even if something is misconfigured. Binding RPC to localhost ensures the validator can be managed locally but provides no remote access point for attacks.

### 5.2 Sentry Node Settings

Sentry nodes require a balanced configuration that allows public network participation while maintaining their relationship with the validator.

**Primary Configuration (config.toml):**

| Parameter                | Value                                  | Purpose                                                                                       |
| ------------------------ | -------------------------------------- | --------------------------------------------------------------------------------------------- |
| `pex`                    | `true`                                 | Enables peer discovery and gossiping - sentry participates in network peer exchange           |
| `persistent_peers`       | Validator ID + optionally other sentry | Ensures validator connection always maintained and optionally connects sentries to each other |
| `private_peer_ids`       | Validator node ID                      | Prevents validator's node ID from being included in gossip messages                           |
| `addr_book_strict`       | `false`                                | Allows connection to validator on private IP while also accepting public peers                |
| `max_num_inbound_peers`  | `40-60`                                | Accepts many public connections to serve as effective proxy                                   |
| `max_num_outbound_peers` | `40-60`                                | Actively connects to many peers for good network propagation                                  |
| `external_address`       | Public IP:port                         | Explicitly sets the address sentries advertise to the network in gossip                       |

**Example config.toml for Sentry 1 (~/.app/config/config.toml):**

```toml
[p2p]
# Enable peer exchange - participate in network gossip
pex = true

# Always maintain connection to validator and optionally to other sentry
persistent_peers = "abc123...@10.0.1.5:26656,ghi789...@10.0.1.11:26656"

# Never gossip the validator's node ID to other peers
private_peer_ids = "abc123..."

# Allow both private IP (validator) and public IPs (network peers)
addr_book_strict = false

# Accept many peer connections from the public network
max_num_inbound_peers = 60
max_num_outbound_peers = 40

# Advertise our public IP in peer exchange messages
external_address = "203.0.113.50:26656"
```

**Example config.toml for Sentry 2 (~/.app/config/config.toml):**

```toml
[p2p]
# Enable peer exchange - participate in network gossip
pex = true

# Always maintain connection to validator and optionally to other sentry
persistent_peers = "abc123...@10.0.1.5:26656,def456...@10.0.1.10:26656"

# Never gossip the validator's node ID to other peers
private_peer_ids = "abc123..."

# Allow both private IP (validator) and public IPs (network peers)
addr_book_strict = false

# Accept many peer connections from the public network
max_num_inbound_peers = 60
max_num_outbound_peers = 40

# Advertise our public IP in peer exchange messages
external_address = "203.0.113.51:26656"
```

**Note on sentry-to-sentry connections:**
Including the other sentry in `persistent_peers` is optional but provides benefits. When sentries connect to each other, they can directly exchange peer information and consensus messages, improving redundancy. If one sentry temporarily loses connectivity to the validator, it may still relay messages through the other sentry. Additionally, sentry-to-sentry connections help ensure sentries learn about new peers quickly and maintain consistent address books. The tradeoff is slightly increased configuration complexity and one additional connection per sentry.

**Rationale:** Sentries operate with `pex = true` to actively participate in the network's peer discovery process. However, `private_peer_ids` ensures the validator is never mentioned in PEX messages. The `external_address` setting is critical - it explicitly tells the sentry what IP address to advertise to other peers during PEX. Without this, the sentry might advertise its private IP (10.0.1.x), which is useless to public peers. High peer limits allow sentries to maintain connections to many public nodes, ensuring good message propagation and network connectivity.

### 5.3 Bandwidth and Connection Controls

These parameters help prevent resource exhaustion and provide fine-grained control over network behavior.

**Rate Limiting (config.toml):**

| Parameter                     | Suggested Value | Purpose                                                                           |
| ----------------------------- | --------------- | --------------------------------------------------------------------------------- |
| `send_rate`                   | `5120000`       | Bytes per second sent to each peer (5 MB/s) - prevents bandwidth monopolization   |
| `recv_rate`                   | `5120000`       | Bytes per second received from each peer (5 MB/s) - prevents flooding             |
| `max_packet_msg_payload_size` | `1024`          | Maximum message size in kilobytes - prevents memory exhaustion from huge messages |
| `flush_throttle_timeout`      | `100ms`         | Batching delay for outbound messages - balances latency vs efficiency             |

**Connection Timeouts:**

| Parameter           | Suggested Value | Purpose                                               |
| ------------------- | --------------- | ----------------------------------------------------- |
| `dial_timeout`      | `3s`            | How long to wait for outbound connection to establish |
| `handshake_timeout` | `20s`           | How long to wait for peer handshake to complete       |

**Example (config.toml):**

```toml
[p2p]
# ... other settings ...

# Limit bandwidth per peer
send_rate = 5120000
recv_rate = 5120000

# Limit message sizes
max_packet_msg_payload_size = 1024

# Control message batching
flush_throttle_timeout = "100ms"

# Connection timeouts
dial_timeout = "3s"
handshake_timeout = "20s"
```

**Rationale:** Rate limiting per peer ensures no single connection can consume all available bandwidth. Even if an attacker establishes 60 connections to a sentry, each is individually limited to 5 MB/s. The `max_packet_msg_payload_size` prevents memory exhaustion attacks where malicious peers send enormous messages. Timeout values are set conservatively to drop connections that don't complete handshakes promptly, freeing resources for legitimate peers.

### 5.4 Firewall Rules

Firewall configuration enforces the network isolation required by sentry architecture.

**Validator Firewall:**

| Port  | Protocol | Access                                 | Notes                                               |
| ----- | -------- | -------------------------------------- | --------------------------------------------------- |
| 26656 | TCP      | Sentry IPs only (10.0.1.10, 10.0.1.11) | P2P communication - accept only from known sentries |

**Sentry Firewall:**

| Port  | Protocol | Access                    | Notes                                                   |
| ----- | -------- | ------------------------- | ------------------------------------------------------- |
| 26656 | TCP      | Public (with rate limits) | P2P communication - accept from any peer but rate limit |
| 26657 | TCP      | Optional/restricted       | RPC endpoint - only if exposing RPC service to public   |
| 1317  | TCP      | Optional/restricted       | REST API endpoint - only if exposing API service        |

**Rationale:** The validator firewall implements a strict whitelist approach - only the two known sentry IPs can establish P2P connections. The sentry firewall uses rate limiting to accept public connections while preventing any single IP from opening too many connections too quickly. This stops simple connection flood attacks. The rate limit of 20 connections per minute per IP allows legitimate peers to connect while blocking rapid connection attempts typical of DDoS attacks.

## 6. Deployment Best Practices

**Minimum Requirements:**

Successful sentry architecture requires these fundamental elements:

- **At least 2 sentry nodes:** A single sentry creates a single point of failure.. Two sentries provide redundancy so validator remains connected if one sentry fails or is attacked.

- **Private network connectivity:** Validator must reach sentries through private channels that cannot be accessed from public internet. This can be VPN tunnels, direct fiber/ethernet connections, or cloud provider private networking features.

- **Strict firewall enforcement:** Firewall rules must be correctly configured and active on all nodes. Misconfigured firewalls undermine the entire architecture by exposing the validator.

**Operational Guidelines:**

- **Never expose validator IP:** This is the cardinal rule. No configuration, documentation, or public communication should ever reveal the validator's IP address or direct network location.

- **Adding new sentries:** Deploy the new sentry, sync it (preferably with state-sync), then add its node ID and IP to the validator's `persistent_peers` list. After updating configuration, restart the validator to establish the connection.

- **Removing compromised sentries:** If a sentry is compromised or under active attack, immediately remove it from the validator's `persistent_peers` list and restart the validator. Destroy the compromised sentry and investigate the breach.

- **Testing failover:** Periodically shut down one sentry to verify the validator continues operating normally with remaining sentries. This validates your redundancy and ensures you can handle sentry failures in production.

- **Software synchronization:** Keep all sentries and the validator on the same software version. Version mismatches can cause consensus failures or prevent proper message relay between validator and network.

**Scaling During Attack:**

When under active DDoS attack, rapid deployment of additional sentries dilutes the attack:

1. **Deploy new sentry using state-sync:** Launch a new sentry node and configure it to use state-sync for rapid synchronization. State-sync allows the node to start from a recent network snapshot rather than syncing from genesis, reducing sync time from hours to minutes.

2. **Update validator configuration:** Add the new sentry's node ID and IP to the validator's `persistent_peers` list in config.toml.

3. **Restart validator:** For the new peer to be recognized, restart the validator process. The validator will establish a connection to the new sentry.

4. **Alternative - unsafe RPC method:** Instead of restarting, you can use the `/dial_peers` RPC endpoint to dynamically add peers without restart. However, this requires `rpc.unsafe = true` in config.toml and should be used with caution as it bypasses safety checks. Example:

```bash
curl -s "http://localhost:26657/dial_peers?persistent=true&peers=[\"newsentry_id@10.0.1.12:26656\"]"
```

## 7. Limitations

While sentry architecture significantly improves validator security, it has operational and technical limitations:

**Operational Complexity:**

- **Configuration management:** Adding or removing sentries requires updating the validator's `persistent_peers` configuration and typically restarting the validator. This coordination overhead increases with the number of sentries.

- **Restart requirement:** Most configuration changes require validator restart. While restarts are usually fast (seconds), the validator briefly stops participating in consensus. Using the unsafe RPC `/dial_peers` endpoint avoids restarts but requires `rpc.unsafe = true`, which exposes other risks.

- **State synchronization time:** Even with state-sync, new sentries need several minutes to synchronize and become fully operational. During large-scale attacks requiring many new sentries, this delay affects response time. Full sync without state-sync can take hours or days depending on chain history.

**Architecture Constraints:**

- **Private network dependency:** Sentry architecture requires private network connectivity between validator and sentries. Setting up VPNs, direct connections, or cloud private networking adds infrastructure complexity and potentially recurring costs.

- **Connection limits:** CometBFT defaults to a maximum of 50 peer connections (though configurable). The validator's peer slots are consumed by sentries, limiting how many sentries can be effectively used. However, 50 sentries is far more than typically needed.

- **Persistent connectivity requirement:** Sentries must maintain constant connection to the validator. If all sentries simultaneously lose connection to the validator (network partition, validator crash, etc.), the validator cannot participate in consensus even if it's running. This makes the sentry connections a critical path.

- **Consensus message latency:** Every message travels an extra hop (through sentries) compared to validators directly connected to the network. While typically negligible (milliseconds), in extremely high-latency scenarios this could theoretically affect consensus participation.

## 8. Verification

After deploying sentry architecture, verify it's working correctly:

**Confirm Validator is Hidden:**

Check that the validator only connects to its sentries and no other peers:

On Validator Node

```bash
curl -s localhost:26657/net_info | jq '.result.peers'
```

Expected output: Only your 2 sentry nodes appear in the peers list. The `remote_ip` fields should show your private sentry IPs (10.0.1.10, 10.0.1.11). If you see any other peers or public IPs, your configuration is incorrect.

**Confirm Sentry Not Gossiping Validator:**

Check that the validator's node ID never appears in public network peer lists:

On any public node or using a public RPC endpoint

```bash

curl -s http://public_node_rpc:26657/net_info | jq '.result.peers[] | select(.node_info.id=="abc123...")'
```

Expected output: Empty result. If this query returns your validator's information, the `private_peer_ids` setting on your sentries is not working correctly and your validator is being gossiped to the network.

**Check Sentry Connections:**

Verify sentries maintain connection to validator and have many public peers:

On sentry node

```bash
curl -s localhost:26657/net_info | jq '.result.n_peers'
```

Expected output: A number greater than 1 (at minimum: validator + other sentry if configured). Typically, sentries should show 30-60 peers - one being the validator, possibly one being the other sentry, and the rest being public network peers.

You can also check that the validator appears in the sentry's peer list:

On sentry node

```bash
curl -s localhost:26657/net_info | jq '.result.peers[] | select(.node_info.id=="abc123...")'
```

Expected output: Your validator's information with `remote_ip` showing the validator's private IP (10.0.1.5).

**Check Network Visibility:**

From a machine outside your infrastructure, attempt to connect to the validator's IP on port 26656. This should fail or timeout:

From external machine

```bash
telnet <validator_public_ip_if_any> 26656
nc -zv <validator_public_ip_if_any> 26656
```

Expected result: Connection refused or timeout. If the connection succeeds, your validator has a public IP and is not properly isolated.

---
