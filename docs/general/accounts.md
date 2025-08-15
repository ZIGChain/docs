---
sidebar_position: 3
---

import Tabs from '@theme/Tabs';
import TabItem from '@theme/TabItem';

# Accounts

Users interact with the ZIGChain ecosystem through their **Accounts**. Each account is **uniquely identifiable** and is secured through cryptographic principles.

This documentation covers the key components of an account, how users can create and manage their accounts, and advanced features such as multisig capabilities.

<div class="spacer"></div>

## Account Functionalities

Users can utilize their ZIGChain accounts for the following purposes:

- **Digital Asset Management**: Hold, send, and receive tokens and other digital assets.
- **Staking**: Stake tokens to participate in network governance and earn rewards while securing the network.
- **Governance**: Vote on proposals that shape the future of the ZIGChain ecosystem.
- **Smart Contracts**: Create and interact with on-chain applications (smart contracts) to enable decentralized functionalities.
- **DApps**: Engage with decentralized applications built on top of ZIGChain.

<div class="spacer"></div>

## Core Components of an Account

Each ZIGChain account consists of the following elements:

- **Mnemonic Phrase**: A sequence of 12-24 words used as a human-readable backup for recovering an account. If a user loses their private key, this phrase can restore access.
- **Private Key**: Signs transactions and messages to prove account ownership and control.
- **Public Key**: Generates the account's address and verifies transactions signed with the corresponding private key.
- **Address**: A unique identifier derived from the public key that is used to reference an account within the network.
- **Keyring**: An account management system based on the [BIP-32](https://github.com/bitcoin/bips/blob/master/bip-0032.mediawiki) standard for Hierarchical Deterministic (HD) wallets, allowing users to generate multiple key pairs from a single mnemonic seed phrase.

<div class="spacer"></div>

**🔥 Example: Understanding account components**

Consider the following analogy:

Imagine that you are the owner of a hotel, and you have a master key and the instructions to create the master key.

- The **Mnemonic Phrase** is like a set of instructions to recreate the master key for all rooms.
- The **Private Master Key** is the actual master key, giving you access to all rooms.

With the private master key you can create pairs of keys and locks (public and private keys) for each room in the hotel:

- The **Public Key** functions like a lock for each room.
- The **Private Key** acts as the key to open the lock.
- The **Address** represents the unique room number identifying each room.

<div class="spacer"></div>

## 🧑‍💻How to create an account using the ZIGChain CLI

To create an account using the ZIGChain CLI, run the following command:

```
zigchaind keys add <key-name>
```

Response example:

```
- address: zig1dtlhdqsmrwwc9t0es9pwh04x86rfh7c60d2222
  name: <key-name>
  pubkey: '{"@type":"/cosmos.crypto.secp256k1.PubKey","key":"AieWTW5gggcC4X43tZxE3fpaa/f0EiY666+cy8PPzzi"}'
  type: local
```

**Important**: Store your **Mnemonic Phrase** securely. It is the only way to recover your account if you lose access.

```
Mnemonic: "word1 word2 word3 ... word24"
```

<div class="spacer"></div>

**🧑‍💻 Extra Info: Accounts and HD System**

ZIGChain uses a Hierarchical Deterministic (HD) system to generate the keys. Starting from a single seed, the HD system allows users to create multiple key pairs (public and private keys) with their addresses.

This enables:

1. **Efficient Key Management**: HD wallets allow the generation of multiple keys from a single seed, requiring only one seed backup instead of storing individual keys.
2. **Privacy and Security**: Generate unique keys for each transaction, enhancing privacy while maintaining easy recovery through the seed phrase.
3. **Structured Organization**: Hierarchical design enables systematic key organization for different accounts and purposes.

<div class="spacer"></div>

## Account Address Format

Every account on ZIGChain is identified by a unique address structured as follows:

```
zig1<account-address-38-characters>

Example:
zig1wze8mn5nsgl9qrgazq6a92fvh7m5e6psjcx2du
```

ZIGChain distinguishes between different address types using specific Bech32 prefixes:

1. **Account Address**: identify users. Address Prefix: `zig1`
2. **Validator Address**: identify a validator node. Address Prefix: `zigvaloper1`
3. **Consensus Address**: identify a consensus node. Address Prefix: `zigvalcons1`

## Recover an Account using a Mnemonic Phrase

If you lose access to your ZIGChain account, you can recover it using your 12-24 word mnemonic phrase that serves as a backup for your private key.

### 🧑‍💻 CLI Command to Recover an Account

To restore an account using a previously saved mnemonic phrase:

```
zigchaind keys add <key-name> --recover
```

Follow the prompt to enter your 12-24 word mnemonic phrase. Once validated, your account will be restored, displaying the associated details.

<div class="spacer"></div>

## Multisig (multi-signature) Accounts

ZIGChain supports **Multisig Accounts**, which require multiple signatures to authorize transactions. This feature provides enhanced security as no single individual can control the account's assets or actions without the approval of other participants.

Multisig accounts are ideal for:

- **Shared control over funds**: DAOs (Decentralized Autonomous Organizations) or businesses where multiple parties must approve transactions.
- **Enhanced security**: Requiring multiple signatures reduces the risk of theft or losing funds if one key is compromised.
- **Cold storage setups** for long-term holdings

### How to Create a Multisig Account via CLI

Follow these steps to create multisig wallet:

1- Create individual signer keys

```bash
zigchaind keys add signer1 --keyring-backend file
zigchaind keys add signer2 --keyring-backend file
zigchaind keys add signer3 --keyring-backend file
```

2- Create the multisig wallet

```bash
zigchaind keys add multisig-wallet --multisig signer1,signer2,signer3 \
--multisig-threshold 2 --keyring-backend file
```

3- Check the multisig address

```bash
zigchaind keys show multisig-wallet --address --keyring-backend file
```

4- Fund the multisig address

<Tabs>
  <TabItem value="Testnet" label="Testnet" default>

```bash
zigchaind tx bank send <from-wallet> <multisig-address> <amount> \
--gas-prices 0.0025uzig --gas auto --gas-adjustment 1.3 \
--chain-id zig-test-2 --node https://public-zigchain-testnet-rpc.numia.xyz --yes
```

  </TabItem>
  <TabItem value="Local" label="Local">

```bash
zigchaind tx bank send <from-wallet> <multisig-address> <amount> \
--gas-prices 0.0025uzig --gas auto --gas-adjustment 1.3 \
--chain-id zigchain-1 --node http://localhost:26657 --yes
```

  </TabItem>
</Tabs>

5- Get the current sequence number

Before generating the unsigned transaction, you need to get the current sequence number for the multisig address. The sequence number is used to prevent replay attacks and must be incremented for each transaction.

<Tabs>
  <TabItem value="Testnet" label="Testnet" default>

```bash
zigchaind query auth account <multisig-address> \
--chain-id zig-test-2 \
--node https://public-zigchain-testnet-rpc.numia.xyz
```

  </TabItem>
  <TabItem value="Local" label="Local">

```bash
zigchaind query auth account <multisig-address> \
--chain-id zigchain-1 \
--node http://localhost:26657
```

  </TabItem>
</Tabs>

This command will return account information including the current sequence number. For example:

```bash
account:
  type: /cosmos.auth.v1beta1.BaseAccount
  value:
    account_number: "11"
    address: zig1yh05klcmerdjyessgskjdurh3elqtrway0sfc3
    pub_key: null
    sequence: "11"
```

**Important**: Use the next number after the current sequence. In this example, the current sequence is 11, so you would use `12` in the next step. If there is no sequence value, it means no transaction has occurred yet, so the sequence value should be `0`.

6- Generate unsigned transaction

<Tabs>
  <TabItem value="Testnet" label="Testnet" default>

```bash
zigchaind tx bank send <multisig-wallet-name> <recipient> <amount> \
--generate-only --gas-prices 0.0025uzig --gas auto --gas-adjustment 1.3 \
--sequence <sequence> --keyring-backend file \
--chain-id zig-test-2 --node https://public-zigchain-testnet-rpc.numia.xyz > unsigned_tx.json
```

  </TabItem>
  <TabItem value="Local" label="Local">

```bash
zigchaind tx bank send <multisig-wallet-name> <recipient> <amount> \
--generate-only --gas-prices 0.0025uzig --gas auto --gas-adjustment 1.3 \
--sequence <sequence> --keyring-backend file \
--chain-id zigchain-1 --node http://localhost:26657 > unsigned_tx.json
```

  </TabItem>
</Tabs>

7- Sign with each signer

⚠️ _Make sure to update `--from` and `--output-document` values_
<Tabs>
<TabItem value="Testnet" label="Testnet" default>

```bash
zigchaind tx sign unsigned_tx.json --from signer1 \
--multisig multisig-wallet --keyring-backend file \
--chain-id zig-test-2 --node https://public-zigchain-testnet-rpc.numia.xyz \
--output-document signer1_signed.json
```

  </TabItem>
  <TabItem value="Local" label="Local">

```bash
zigchaind tx sign unsigned_tx.json --from signer1 \
--multisig multisig-wallet --keyring-backend file \
--chain-id zigchain-1 --node http://localhost:26657 \
--output-document signer1_signed.json
```

  </TabItem>
</Tabs>

8- Combine signatures

<Tabs>
  <TabItem value="Testnet" label="Testnet" default>

```bash
zigchaind tx multisign unsigned_tx.json multisig-wallet signer1_signed.json \
signer2_signed.json --keyring-backend file \
--chain-id zig-test-2 --node https://public-zigchain-testnet-rpc.numia.xyz \
--output-document multisigned_tx.json
```

  </TabItem>
  <TabItem value="Local" label="Local">

```bash
zigchaind tx multisign unsigned_tx.json multisig-wallet signer1_signed.json \
signer2_signed.json --keyring-backend file \
--chain-id zigchain-1 --node http://localhost:26657 \
--output-document multisigned_tx.json
```

  </TabItem>
</Tabs>

9- Broadcast transaction

<Tabs>
  <TabItem value="Testnet" label="Testnet" default>

```bash
zigchaind tx broadcast multisigned_tx.json --chain-id zig-test-2 --node https://public-zigchain-testnet-rpc.numia.xyz
```

  </TabItem>
  <TabItem value="Local" label="Local">

```bash
zigchaind tx broadcast multisigned_tx.json --chain-id zigchain-1 --node http://localhost:26657
```

  </TabItem>
</Tabs>

<div class="spacer"></div>

## 📌 Security Best Practices

Protect your ZIGChain accounts and assets by following these essential security practices:

**1. Mnemonic Phrase Protection**

- **Use a Hardware Wallet**: Store your mnemonic phrase on a hardware wallet (like Ledger or Trezor). These physical devices are designed to keep your keys safe from online threats.
- **Offline Backups**: Write down your mnemonic phrase on paper or store it on an encrypted USB drive that’s kept offline. Avoid digital storage on computers or clouds.
- **Split Backups for Safety**: Split your phrase into two or more parts and store them in separate, secure places. This way, losing one part won’t compromise your account.

**2. Private Key Security**

- **Encryption**: If you must store your private key on your device, use encryption tools (like GPG or BitLocker) and strong passwords to protect them.
- **Unique Keys for Different Uses**: Use separate keys for different accounts or DApps to minimize risk if one key is compromised.
- **Two-Factor Authentication (2FA)**: Enable 2FA on all accounts and devices accessing your ZIGChain wallet. Hardware keys (like YubiKeys) offer the strongest security.

**3. Using Multisig Accounts**

- **Shared Control for Important Accounts**: For accounts with significant funds, implement multisig (multi-signature) setups that require multiple people to approve each transaction. This safeguards against unauthorized transfers.
- **Cold Storage Multisig**: Store your multisig keys on hardware wallets or offline devices to protect against remote hacking attempts.

**4. Avoiding Phishing and Scams**

- **Check URLs Carefully**: Only use the official ZIGChain website and trusted DApps. Bookmark the official URL to avoid fake sites.
- **Verify Transactions Before Signing**: Always double-check the details of any transaction before approving it in your wallet. Malicious contracts can trick you into sending funds.

<div class="spacer"></div>

## References

- [Cosmos Account Definition](https://docs.cosmos.network/v0.46/basics/accounts.html)
- [Explanation about Mnemonic Phrase (BIP-39)](https://www.blockplate.com/pages/bip-39-wordlist)
- [Ethereum accounts](https://ethereum.org/en/whitepaper/#ethereum-accounts)
