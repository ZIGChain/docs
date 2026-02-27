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

The following example demonstrates how to execute a transfer transaction from a multisig account to another wallet. This process requires multiple steps: ensuring fee balance, generating an unsigned transaction, collecting signatures from the required number of signers, combining the signatures, and broadcasting the final transaction.

### Step 1: Ensure Fee Balance (Fund if Needed)

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

### Step 2: Get Current Sequence Number

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

### Step 3: Generate Unsigned Transaction

This step creates an unsigned transaction that will later be signed by the required number of multisig participants. The transaction is generated but not broadcast to the network until it has been properly signed.

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
- **`--sequence <sequence>`**: Account sequence number from Step 2
- **`--keyring-backend file`**: Key storage location
- **`> unsigned_tx.json`**: Output file for the unsigned transaction

**Batch preparation**: Repeat this step to create multiple unsigned transaction files (e.g., `unsigned_tx1.json`, `unsigned_tx2.json`). Before requesting signatures you can merge the messages into a single batch transaction so signers only approve once. Use a JSON processor such as `jq` to concatenate the `body.messages` arrays and save the result to a new file (for example, `jq -s 'reduce .[] as $tx (.[0]; .body.messages += $tx.body.messages)' unsigned_tx*.json > unsigned_batch.json`). After merging, re-estimate fees so the final `auth_info.fee` covers every message and confirm the sequence value matches the next unused sequence for the multisig account.

**Example batch workflow**:

<Tabs groupId="batch-workflow-env">
  <TabItem value="batch-mainnet" label="Mainnet" default>

Generate two unsigned transfers and then merge them into a single batch for mainnet.

```bash
zigchaind tx bank send multisig-wallet zig1abc... 5000uzig \
  --generate-only --gas-prices 0.0025uzig --gas auto --gas-adjustment 1.3 \
  --sequence 12 --keyring-backend file --chain-id zigchain-1 \
  --node https://public-zigchain-rpc.numia.xyz > unsigned_tx1.json
```

```bash
zigchaind tx bank send multisig-wallet zig1def... 7500uzig \
  --generate-only --gas-prices 0.0025uzig --gas auto --gas-adjustment 1.3 \
  --sequence 12 --keyring-backend file --chain-id zigchain-1 \
  --node https://public-zigchain-rpc.numia.xyz > unsigned_tx2.json
```

```bash
jq -s 'reduce .[] as $tx (.[0]; .body.messages += $tx.body.messages)' \
  unsigned_tx1.json unsigned_tx2.json > unsigned_batch.json
```

  </TabItem>
  <TabItem value="batch-testnet" label="Testnet">

Generate two unsigned transfers and then merge them into a single batch for testnet.

```bash
zigchaind tx bank send multisig-wallet zig1abc... 5000uzig \
  --generate-only --gas-prices 0.0025uzig --gas auto --gas-adjustment 1.3 \
  --sequence 12 --keyring-backend file --chain-id zig-test-2 \
  --node https://public-zigchain-testnet-rpc.numia.xyz > unsigned_tx1.json
```

```bash
zigchaind tx bank send multisig-wallet zig1def... 7500uzig \
  --generate-only --gas-prices 0.0025uzig --gas auto --gas-adjustment 1.3 \
  --sequence 12 --keyring-backend file --chain-id zig-test-2 \
  --node https://public-zigchain-testnet-rpc.numia.xyz > unsigned_tx2.json
```

```bash
jq -s 'reduce .[] as $tx (.[0]; .body.messages += $tx.body.messages)' \
  unsigned_tx1.json unsigned_tx2.json > unsigned_batch.json
```

  </TabItem>
  <TabItem value="batch-local" label="Local">

Generate two unsigned transfers and then merge them into a single batch for a local validator.

```bash
zigchaind tx bank send multisig-wallet zig1abc... 5000uzig \
  --generate-only --gas-prices 0.0025uzig --gas auto --gas-adjustment 1.3 \
  --sequence 12 --keyring-backend file --chain-id zigchain-1 \
  --node http://localhost:26657 > unsigned_tx1.json
```

```bash
zigchaind tx bank send multisig-wallet zig1def... 7500uzig \
  --generate-only --gas-prices 0.0025uzig --gas auto --gas-adjustment 1.3 \
  --sequence 12 --keyring-backend file --chain-id zigchain-1 \
  --node http://localhost:26657 > unsigned_tx2.json
```

```bash
jq -s 'reduce .[] as $tx (.[0]; .body.messages += $tx.body.messages)' \
  unsigned_tx1.json unsigned_tx2.json > unsigned_batch.json
```

  </TabItem>
</Tabs>

The merged `unsigned_batch.json` now contains both messages under a single `auth_info` and `body`. A truncated example with three transfers is shown below (note the shared sequence of `12`):

```json
{
  "body": {
    "messages": [
      {
        "@type": "/cosmos.bank.v1beta1.MsgSend",
        "from_address": "zig1multisig...",
        "to_address": "zig1abc...",
        "amount": [{ "denom": "uzig", "amount": "5000" }]
      },
      {
        "@type": "/cosmos.bank.v1beta1.MsgSend",
        "from_address": "zig1multisig...",
        "to_address": "zig1def...",
        "amount": [{ "denom": "uzig", "amount": "7500" }]
      },
      {
        "@type": "/cosmos.bank.v1beta1.MsgSend",
        "from_address": "zig1multisig...",
        "to_address": "zig1ghi...",
        "amount": [{ "denom": "uzig", "amount": "2500" }]
      }
    ],
    "... additional body fields omitted for brevity ..."
  },
  "auth_info": {
    "signer_infos": [],
    "fee": {
      "amount": [{ "denom": "uzig", "amount": "0" }],
      "gas_limit": "104665"
    }
  },
  "signatures": []
}
```

**Re-estimate fees after merging**:

1. Run a simulation against the merged file to obtain a fresh gas estimate:

    <Tabs>
      <TabItem value="Mainnet" label="Mainnet" default>

   ```bash
   zigchaind tx simulate unsigned_batch.json --from multisig-wallet --keyring-backend file \
     --chain-id zigchain-1 \
     --node https://public-zigchain-rpc.numia.xyz \
     --gas-prices 0.0025uzig --gas-adjustment 1.3
   ```

      </TabItem>
      <TabItem value="Testnet" label="Testnet">

   ```bash
   zigchaind tx simulate unsigned_batch.json --from multisig-wallet --keyring-backend file \
     --chain-id zig-test-2 \
     --node https://public-zigchain-testnet-rpc.numia.xyz \
     --gas-prices 0.0025uzig --gas-adjustment 1.3
   ```

      </TabItem>
      <TabItem value="Local" label="Local">

   ```bash
   zigchaind tx simulate unsigned_batch.json --from multisig-wallet --keyring-backend file \
     --chain-id zigchain-1 \
     --node http://localhost:26657 \
     --gas-prices 0.0025uzig --gas-adjustment 1.3
   ```

      </TabItem>
    </Tabs>

   Output:

   ```bash
   gas_info:
   gas_used: "122219"
   gas_wanted: "100000000"
   ```

   The CLI prints a line such as `gas_used: 214380`. Update `auth_info.fee.gas_limit` to this value (add a safety buffer if the transaction is complex or the network is congested).

2. Recalculate the fee amount by multiplying the chosen gas price by the new gas limit. For example, with `214380` gas and a price of `0.0025uzig`, the minimum fee is `536 uzig`. Update `auth_info.fee.amount[0].amount` accordingly:

   ```bash
   jq '.auth_info.fee.gas_limit = "214380" |
       .auth_info.fee.amount[0].amount = "536"' \
     unsigned_batch.json > unsigned_batch_with_fee.json
   ```

3. Share the updated file (`unsigned_batch_with_fee.json`) with signers so the signature step uses the refreshed fee parameters.

**Optional Parameter: `--nosort`**

Controls signature ordering in the final transaction:

- **Default**: Signatures are sorted in canonical order
- **With `--nosort`**: Signatures applied in provided order
- **Usage**: When specific signature order is required for external system compatibility

**Important**: All signers must use the same sorting preference

### Step 4: Sign with Each Signer

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

### Step 5: Combine Signatures

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

## Extracting Multisig Members from a Transaction

Follow the same sequence of CLI commands shared below to recover every signer in the multisig wallet from a transaction hash.

### Step 1 - Get Pubkey from all member of multisig wallet

Query the transaction in JSON format and isolate the signer metadata:

<Tabs>
  <TabItem value="Mainnet" label="Mainnet" default>

```bash
zigchaind q tx <TX_HASH> \
  --chain-id zigchain-1 \
  --node https://public-zigchain-rpc.numia.xyz \
  -o json > tx.json

cat tx.json | jq '.tx.auth_info.signer_infos'
```

  </TabItem>
  <TabItem value="Testnet" label="Testnet">

```bash
zigchaind q tx <TX_HASH> \
  --chain-id zig-test-2 \
  --node https://public-zigchain-testnet-rpc.numia.xyz \
  -o json > tx.json

cat tx.json | jq '.tx.auth_info.signer_infos'
```

  </TabItem>
  <TabItem value="Local" label="Local">

```bash
zigchaind q tx <TX_HASH> \
  --chain-id zigchain-1 \
  --node http://localhost:26657 \
  -o json > tx.json

cat tx.json | jq '.tx.auth_info.signer_infos'
```

  </TabItem>
</Tabs>

Response:

```json
{
  "public_key": {
    "@type": "/cosmos.crypto.multisig.LegacyAminoPubKey",
    "threshold": 3,
    "public_keys": [
      {
        "@type": "/cosmos.crypto.secp256k1.PubKey",
        "key": "A523ynlGdDjRHycNTiaeBvKRXhwJVzgMfvd0hDUkBQft"
      },
      {
        "@type": "/cosmos.crypto.secp256k1.PubKey",
        "key": "AilMqRZeIIEv6h/MdTvccUwyrq1o1SUmZgzYjxcS0f2K"
      },
      {
        "@type": "/cosmos.crypto.secp256k1.PubKey",
        "key": "AxXCbPZsBkY+tGE7kX+hrCbeVhNnfrF0wa2tI5woDeR6"
      },
      {
        "@type": "/cosmos.crypto.secp256k1.PubKey",
        "key": "A/Wop1RBnxLjo8tDQdKERH8ZA14EZmvWXHWYOlUta1/O"
      }
    ]
  }
}
```

### Step 2 - Debug PubKey

Run the debug helper against each public key value returned in Step 1:

```bash
zigchaind debug pubkey '{"@type":"/cosmos.crypto.secp256k1.PubKey","key":"<KEY>"}'
```

Ex:

```bash
zigchaind debug pubkey '{"@type":"/cosmos.crypto.secp256k1.PubKey","key":"AqWONfbFLlvq8N9w5vdYuNTJyyslI8HXWgYqQ2lud6zq"}'
```

Response:

```bash
Address: 199846F5ECF6318E8BBBC192EDC40EDDDA8F9DFE
PubKey Hex: 02a58e35f6c52e5beaf0df70e6f758b8d4c9cb2b2523c1d75a062a43696e77acea
```

### Step 3 - Debug Address

Inspect the address returned in Step 2 to derive its Bech32 variants:

```bash
zigchaind debug addr <ADDRESS_FROM_DEBUG_PUBKEY>
```

Ex:

```bash
zigchaind debug addr 5C0DA7BA68A1B4F3EB94BCEE5DBB89C773E93EB8
```

Example:

```bash
Address: [92 13 167 186 104 161 180 243 235 148 188 238 93 187 137 199 115 233 62 184]
Address (hex): 5C0DA7BA68A1B4F3EB94BCEE5DBB89C773E93EB8
Bech32 Acc: zig1tsx60wng5x6086u5hnh9mwufcae7j04c9kxr37
Bech32 Val: zigvaloper1tsx60wng5x6086u5hnh9mwufcae7j04cs329s8
Bech32 Con: zigvalcons1tsx60wng5x6086u5hnh9mwufcae7j04cyzeeux
```

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
