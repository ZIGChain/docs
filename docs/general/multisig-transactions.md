---
sidebar_position: 13
---

import Tabs from '@theme/Tabs';
import TabItem from '@theme/TabItem';

# Multisig Transactions

**Multisig (multi-signature) accounts** require multiple signatures to authorize transactions, providing enhanced security as no single individual can control the account's assets or actions without the approval of other participants.

This comprehensive guide covers creating multisig accounts, executing transactions, understanding limitations, and integrating Ledger hardware wallets.

<div class="spacer"></div>

## When to Use Multisig Accounts?

Multisig accounts are ideal for:

- **Shared control over funds**: DAOs (Decentralized Autonomous Organizations) or businesses where multiple parties must approve transactions
- **Enhanced security**: Requiring multiple signatures reduces the risk of theft or loss of funds if one key is compromised.
- **Corporate treasuries** requiring multiple approvals for large transactions
- **Multiple backup access**: Using multisig as a backup mechanism where multiple keys can access funds (note: this does not provide security benefits, only convenience)

<div class="spacer"></div>

## Creating a Multisig Account

### Step 1: Create Individual Signer Keys

First, create the individual signer accounts that will participate in the multisig:

```bash
zigchaind keys add signer1 --keyring-backend file
zigchaind keys add signer2 --keyring-backend file
zigchaind keys add signer3 --keyring-backend file
```

**Example output for signer creation:**

```bash
- address: zig1ykehptq7qfl9m6x7x3dzcp2u825ph4zlehk9rg
  name: signer2
  pubkey: '{"@type":"/cosmos.crypto.secp256k1.PubKey","key":"ApyZAVGwm2gP8ojw8bbvDb1+TgrkyAkZb1UcM4qCbnP4"}'
  type: local


**Important** write this mnemonic phrase in a safe place.
It is the only way to recover your account if you ever forget your password.

tackle surround truly salt job wheat letter farm drip table abuse admit path else girl solar leisure knife judge kangaroo chimney inspire guilt update

⚠️ **Security Note**: Never share your complete mnemonic phrase publicly. The example above is for demonstration purposes only.
```

**Keyring Backend Options:**

The `--keyring-backend` parameter determines where your keys are stored:

- `file`: Keys stored in local files (recommended for development)
- `os`: Keys stored in operating system credential store
- `test`: In-memory storage (for testing only)
- `kwallet`: KDE Wallet (Linux)
- `pass`: Pass password manager (Linux)

For more details on keyring backends, see the [Cosmos SDK Keyring Documentation](https://docs.cosmos.network/v0.46/run-node/keyring.html).

**Multisig Limitations:**

- **Maximum participants**: Up to 7 wallets can participate in a single multisig account
- **Wallet uniqueness**: You cannot use the same exact combination of wallets to create multiple multisig accounts. If you used wallets 1, 2, 3 to create one multisig, you cannot use the same combination (1, 2, 3) to create another multisig. You must use a different combination such as 1, 2, 4 or 1, 2, 3, 4
- **Wallet reuse**: While technically possible to reuse the same wallet in multiple multisigs, this is not recommended for security reasons
- **Threshold**: The threshold must be between 1 and the total number of signers

### Step 2: Create the Multisig Wallet

Create the multisig wallet with a specified threshold (minimum number of signatures required):

```bash
zigchaind keys add multisig-wallet --multisig signer1,signer2,signer3 \
--multisig-threshold 2 --keyring-backend file
```

**Example output for multisig creation:**

```bash
- address: zig1xz0rjzw7kt547c3yhws6nx4mlkeu8d37f2w927
  name: multisig-wallet
  pubkey: '{"@type":"/cosmos.crypto.multisig.LegacyAminoPubKey","threshold":2,"public_keys":[{"@type":"/cosmos.crypto.secp256k1.PubKey","key":"Az1wlHRA135LQQntdot6ETT4LgSG8rnQX92iyqlM/SCI"},{"@type":"/cosmos.crypto.secp256k1.PubKey","key":"ApyZAVGwm2gP8ojw8bbvDb1+TgrkyAkZb1UcM4qCbnP4"},{"@type":"/cosmos.crypto.secp256k1.PubKey","key":"A3ly+VRiXFopoxt3aCrRkAkFFqWEu+9liAxuq3Obxoer"}]}'
  type: multi
```

**Parameters explained:**

- `--multisig-threshold 2`: Requires 2 out of 3 signatures to authorize transactions
- `--keyring-backend`: Specifies where to store the keys (file, test, os, etc.)

### Step 3: Verify the Multisig Address

Check the multisig address that was created:

```bash
zigchaind keys show multisig-wallet --address --keyring-backend file
```

<div class="spacer"></div>

## Executing Multisig Transactions

The following example demonstrates how to execute a transfer transaction from a multisig account to another wallet. This process requires multiple steps: generating an unsigned transaction, collecting signatures from the required number of signers, combining the signatures, and broadcasting the final transaction.

### Step 1: Get Current Sequence Number

Before generating the unsigned transaction, get the current sequence number for the multisig address:

<Tabs>
  <TabItem value="Mainnet" label="Mainnet" default>

```bash
zigchaind query auth account <multisig-address> \
--chain-id zigchain-1 \
--node https://public-zigchain-rpc.numia.xyz
```

  </TabItem>
  <TabItem value="Testnet" label="Testnet">

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

**Example response:**

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

### Step 2: Generate Unsigned Transaction

This step creates an unsigned transaction that will later be signed by the required number of multisig participants. The transaction is generated but not broadcast to the network until it has been properly signed.

**Important**: Before generating the unsigned transaction, ensure the multisig account has sufficient gas fee balance. If the fees are insufficient, all subsequent work will be lost when the transaction fails to broadcast. Check the [Ensure Fee Balance](#step-5-ensure-fee-balance-fund-if-needed) section for details on checking and funding the account, and refer to the [Insufficient gas troubleshooting](#insufficient-gas-or-out-of-gas) section for error handling.

<Tabs>
  <TabItem value="Mainnet" label="Mainnet" default>

```bash
zigchaind tx bank send <multisig-wallet-name> <recipient> <amount> \
--generate-only --gas-prices 0.0025uzig --gas auto --gas-adjustment 1.3 \
--sequence <sequence> --keyring-backend file \
--chain-id zigchain-1 --node https://public-zigchain-rpc.numia.xyz > unsigned_tx.json
```

  </TabItem>
  <TabItem value="Testnet" label="Testnet">

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

**Command Parameters:**

- **`<multisig-wallet-name>`**: Name of the multisig wallet sending the transaction
- **`<recipient>`**: Destination address receiving the tokens
- **`<amount>`**: Amount of tokens to send (e.g., `1000uzig`)
- **`--generate-only`**: Creates unsigned transaction without broadcasting
- **`--sequence <sequence>`**: Account sequence number from Step 1
- **`--keyring-backend file`**: Key storage location
- **`> unsigned_tx.json`**: Output file for the unsigned transaction

**Optional Parameter: `--nosort`**

Controls signature ordering in the final transaction:

- **Default**: Signatures are sorted in canonical order
- **With `--nosort`**: Signatures applied in provided order
- **Usage**: When specific signature order is required for external system compatibility
- **Important**: All signers must use the same sorting preference

### Step 3: Sign with Each Signer

Each signer must sign the transaction individually. **Note**: You only need signatures from enough signers to meet the threshold (e.g., for a 2-of-3 multisig, you need 2 signatures, not all 3).

<Tabs>
<TabItem value="Mainnet" label="Mainnet" default>

```bash
zigchaind tx sign unsigned_tx.json --from <wallet_name> \
--multisig <multisig-wallet-name> --keyring-backend file \
--chain-id zigchain-1 --node https://public-zigchain-rpc.numia.xyz \
--output-document <wallet_name>_signed.json
```

  </TabItem>
<TabItem value="Testnet" label="Testnet">

```bash
zigchaind tx sign unsigned_tx.json --from <wallet_name> \
--multisig <multisig-wallet-name> --keyring-backend file \
--chain-id zig-test-2 --node https://public-zigchain-testnet-rpc.numia.xyz \
--output-document <wallet_name>_signed.json
```

  </TabItem>
  <TabItem value="Local" label="Local">

```bash
zigchaind tx sign unsigned_tx.json --from <wallet_name> \
--multisig <multisig-wallet-name> --keyring-backend file \
--chain-id zigchain-1 --node http://localhost:26657 \
--output-document <wallet_name>_signed.json
```

  </TabItem>
</Tabs>

### Step 4: Combine Signatures

Combine the individual signatures (enough to meet the threshold) into a single signed transaction:

<Tabs>
  <TabItem value="Mainnet" label="Mainnet" default>

```bash
zigchaind tx multisign unsigned_tx.json <multisig-wallet-name> <wallet_name1>_signed.json \
<wallet_name2>_signed.json --keyring-backend file \
--chain-id zigchain-1 --node https://public-zigchain-rpc.numia.xyz \
--output-document multisigned_tx.json
```

  </TabItem>
  <TabItem value="Testnet" label="Testnet">

```bash
zigchaind tx multisign unsigned_tx.json <multisig-wallet-name> <wallet_name1>_signed.json \
<wallet_name2>_signed.json --keyring-backend file \
--chain-id zig-test-2 --node https://public-zigchain-testnet-rpc.numia.xyz \
--output-document multisigned_tx.json
```

  </TabItem>
  <TabItem value="Local" label="Local">

```bash
zigchaind tx multisign unsigned_tx.json <multisig-wallet-name> <wallet_name1>_signed.json \
<wallet_name2>_signed.json --keyring-backend file \
--chain-id zigchain-1 --node http://localhost:26657 \
--output-document multisigned_tx.json
```

  </TabItem>
</Tabs>

### Step 5: Ensure Fee Balance (Fund if Needed)

The multisig account pays the transaction fees when broadcasting the transaction. However, the fees are defined and estimated when generating the unsigned transaction. If the multisig has insufficient balance to cover gas, fund it with a small amount dedicated to fees.

#### Check current balance

<Tabs>
  <TabItem value="Mainnet" label="Mainnet" default>

```bash
zigchaind q bank balances <multisig-address> \
--chain-id zigchain-1 --node https://public-zigchain-rpc.numia.xyz
```

  </TabItem>
  <TabItem value="Testnet" label="Testnet">

```bash
zigchaind q bank balances <multisig-address> \
--chain-id zig-test-2 --node https://public-zigchain-testnet-rpc.numia.xyz
```

  </TabItem>
  <TabItem value="Local" label="Local">

```bash
zigchaind q bank balances <multisig-address> \
--chain-id zigchain-1 --node http://localhost:26657
```

  </TabItem>
</Tabs>

#### Fund the multisig

<Tabs>
  <TabItem value="Mainnet" label="Mainnet" default>

```bash
zigchaind tx bank send <from-wallet> <multisig-address> <amount> \
--gas-prices 0.0025uzig --gas auto --gas-adjustment 1.3 \
--chain-id zigchain-1 --node https://public-zigchain-rpc.numia.xyz --yes
```

  </TabItem>
  <TabItem value="Testnet" label="Testnet">

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

#### Gas Fee Considerations

Gas fees are particularly important in multisig transactions because coordination makes failures costly. Ensure sufficient fees before broadcasting.

#### Best practices

1. Always use `--gas auto` with `--gas-adjustment` (e.g., 1.3–2.5)
2. Monitor network conditions and adjust `--gas-adjustment` upward if needed
3. Test with small amounts first; complex txs (governance, contracts) need more gas

#### Recommended flags

```bash
# Simple transfers
--gas auto --gas-adjustment 1.5

# Complex transactions
--gas auto --gas-adjustment 2.0

# High congestion
--gas auto --gas-adjustment 2.5
```

#### Estimate gas before generating/broadcasting

<Tabs>
  <TabItem value="Mainnet" label="Mainnet" default>

```bash
zigchaind tx bank send <multisig-wallet-name> <recipient> <amount> \
--generate-only --gas-prices 0.0025uzig --gas auto --gas-adjustment 1.3 \
--sequence <sequence> --keyring-backend file \
--chain-id zigchain-1 --node https://public-zigchain-rpc.numia.xyz
```

  </TabItem>
  <TabItem value="Testnet" label="Testnet">

```bash
zigchaind tx bank send <multisig-wallet-name> <recipient> <amount> \
--generate-only --gas-prices 0.0025uzig --gas auto --gas-adjustment 1.3 \
--sequence <sequence> --keyring-backend file \
--chain-id zig-test-2 --node https://public-zigchain-testnet-rpc.numia.xyz
```

  </TabItem>
  <TabItem value="Local" label="Local">

```bash
zigchaind tx bank send <multisig-wallet-name> <recipient> <amount> \
--generate-only --gas-prices 0.0025uzig --gas auto --gas-adjustment 1.3 \
--sequence <sequence> --keyring-backend file \
--chain-id zigchain-1 --node http://localhost:26657
```

  </TabItem>
</Tabs>

```bash
gas estimate: 104665
```

### Step 6: Broadcast Transaction

Finally, broadcast the signed transaction to the network:

<Tabs>
  <TabItem value="Mainnet" label="Mainnet" default>

```bash
zigchaind tx broadcast multisigned_tx.json --chain-id zigchain-1 --node https://public-zigchain-rpc.numia.xyz
```

  </TabItem>
  <TabItem value="Testnet" label="Testnet">

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

### Step 7: Verifying Transactions

<Tabs>
  <TabItem value="Mainnet" label="Mainnet" default>

```bash
zigchaind q bank balances <wallet_address> \
--chain-id zigchain-1 --node https://public-zigchain-rpc.numia.xyz
```

  </TabItem>
  <TabItem value="Testnet" label="Testnet">

```bash
zigchaind q bank balances <wallet_address> \
--chain-id zig-test-2 --node https://public-zigchain-testnet-rpc.numia.xyz
```

  </TabItem>
  <TabItem value="Local" label="Local">

```bash
zigchaind q bank balances <wallet_address> \
--chain-id zigchain-1 --node http://localhost:26657
```

  </TabItem>
</Tabs>

<div class="spacer"></div>

## Multisig with Ledger Hardware Wallets

### Prerequisites

- Ledger device with ZIGChain app installed
- Ledger Live or compatible software
- ZIGChain CLI configured for Ledger

### Creating Multisig with Ledger

1. **Add Ledger keys to keyring:**

```bash
zigchaind keys add ledger-signer1 --ledger --keyring-backend file
zigchaind keys add ledger-signer2 --ledger --keyring-backend file
```

2. **Create multisig with Ledger signers:**

```bash
zigchaind keys add ledger-multisig --multisig ledger-signer1,ledger-signer2 \
--multisig-threshold 2 --keyring-backend file
```

### Signing with Ledger

When signing transactions with Ledger devices:

1. **Generate unsigned transaction** (same as above)
2. **Sign with Ledger:**

```bash
zigchaind tx sign unsigned_tx.json --from ledger-signer1 \
--multisig ledger-multisig --keyring-backend file \
--chain-id zig-test-2 --node https://public-zigchain-testnet-rpc.numia.xyz \
--output-document ledger_signed.json
```

3. **Follow Ledger prompts** to approve the transaction on the device
4. **Combine signatures and broadcast** (same process as above)

### Ledger Best Practices

- Always verify transaction details on the Ledger screen before signing
- Keep your Ledger firmware updated
- Use a secure PIN and enable passphrase protection
- Store recovery phrases in separate, secure locations

<div class="spacer"></div>

## Limitations and Considerations

### Technical Limitations

1. **Sequence Management**: Must manually track and increment sequence numbers
2. **Offline Signing**: Requires careful coordination between signers
3. **File Management**: Multiple signature files must be managed and combined

### Operational Considerations

1. **Signer Availability**: Sufficient signers (meeting the threshold) must be available to complete transactions
2. **Key Security**: Each signer's key must be kept secure
3. **Coordination Overhead**: More complex than single-signature transactions
4. **Recovery Complexity**: Losing signer keys can make funds inaccessible
5. **Gas Fee Planning**: Critical to estimate and allocate sufficient gas fees before starting the multisig process to avoid costly failures

### Best Practices

1. **Threshold Selection**: Choose appropriate threshold (e.g., 2-of-3, 3-of-5)
2. **Key Distribution**: Distribute signer keys across different locations/people
3. **Backup Strategy**: Maintain secure backups of all signer keys
4. **Testing**: Test multisig setup with small amounts first
5. **Documentation**: Keep clear records of signer responsibilities

<div class="spacer"></div>

## Troubleshooting Common Issues

### "Sequence number mismatch"

**Problem**: Transaction fails due to incorrect sequence number.

**Common Error Response**:

```
account sequence mismatch, expected 1, got 0: incorrect account sequence
```

**Solution**: Always query the current sequence before generating transactions:

<Tabs>
  <TabItem value="Mainnet" label="Mainnet" default>

```bash
zigchaind query auth account <multisig-address> \
--chain-id zigchain-1 --node https://public-zigchain-rpc.numia.xyz
```

  </TabItem>
  <TabItem value="Testnet" label="Testnet">

```bash
zigchaind query auth account <multisig-address> \
--chain-id zig-test-2 --node https://public-zigchain-testnet-rpc.numia.xyz
```

  </TabItem>
  <TabItem value="Local" label="Local">

```bash
zigchaind query auth account <multisig-address> \
--chain-id zigchain-1 --node http://localhost:26657
```

  </TabItem>
</Tabs>

### "Insufficient signatures"

**Problem**: Not enough signatures provided for the threshold.

**Common Error Response**:

```
signature verification failed; please verify account number (12), sequence (0) and chain-id (zigchain-1): unauthorized
```

**Solution**: Ensure you have collected signatures from the minimum required number of signers as specified in the multisig threshold.

**How to check the threshold**: You can verify the required number of signatures by checking the multisig wallet details:

```bash
zigchaind keys show <multisig-wallet-name> --keyring-backend file
```

**Example output**:

```bash
- address: zig1ctxxsscu23u7kwj9w0khpmn3fny06l5xtw5v4y
  name: multisig-wallet
  pubkey: '{"@type":"/cosmos.crypto.multisig.LegacyAminoPubKey","threshold":2,"public_keys":[{"@type":"/cosmos.crypto.secp256k1.PubKey","key":"AusqvIxXe45X0Hzl0QaNZdgUD2Mf65h29ESlKM9gMAA3"},{"@type":"/cosmos.crypto.secp256k1.PubKey","key":"AuZc4IQMmN4JrqSpyd2kntewbHCSbQ148T9bhkYD/EVD"},{"@type":"/cosmos.crypto.secp256k1.PubKey","key":"A3oPncBJ5PzqLQeXk3T3M3K5ZwiynFj9QAIbiMSPSLKS"}]}'
  type: multi
```

In this example, the `"threshold":2` indicates that 2 signatures are required out of the 3 available signers.

### "Invalid signature"

**Problem**: One or more signatures are invalid.

**Common Error Response**:

```
signing key is not a part of multisig key
```

**Solution**:

- Verify each signer used the correct key
- Ensure the unsigned transaction hasn't been modified
- Check that all signers are using the same multisig address
- Ensure you are using a signer wallet that was included when creating the multisig account. Only wallets specified in the `--multisig` parameter during multisig creation can sign transactions for that multisig account

### "Insufficient gas" or "Out of gas"

**Problem**: Transaction fails due to insufficient gas fees.

**Solution**:

- **Always estimate gas first** before generating unsigned transactions
- Increase `--gas-adjustment` to 2.0 or higher for complex transactions
- Monitor network conditions and adjust gas accordingly
- Consider the additional complexity of multisig transactions when setting gas limits

**Prevention**: This is the most frustrating multisig failure. Always test gas requirements with small amounts before executing large multisig transactions.

<div class="spacer"></div>

## References

- [Cosmos Multisig Documentation](https://docs.cosmos.network/v0.46/run-node/txs.html#multisig-transactions)
