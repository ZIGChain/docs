# Addresses, transactions, and fees

Address formats, memo, gas, fees, transaction types, verification, and deposit scanning.

_Last updated: Oct 31st, 2025_

---

## What address formats does ZIGChain use? (What are the address format rules?)

ZIGChain uses Bech32 prefixes for account and validator addresses.  
Accounts: `zig1…`; validator operator: `zigvaloper1…`; consensus: `zigvalcons1…`.  
Example: `zig1234567890abcdefghijklmnopqrstuvwxyzabcdef`.

---

## Does ZIGChain support memo, and is it recommended for exchanges?

Cosmos-style optional memo is supported at the transaction level via SDK/CLI.  
 Maximum memo length: 256 characters.  
 For exchanges, prefer unique deposit addresses over memo routing.

---

## What are the common transaction failure conditions?

Common causes: gas price below minimum, insufficient gas limit, timeout, invalid sequence number, or insufficient funds.  
 Fees are consumed even if the transaction fails.

---

## When can a broadcast transaction be considered failed (not uploaded to the chain)?

Transaction status different from 0\.

---

## Are there other special protocol points (e.g. inflation) to consider?

ZIGCoin (base denom `uZIG`) features inflation and `blocks_per_year` parameters documented in the protocol.

---

## What are the steps to scan deposits from the blockchain?

Common to Cosmos blockchains. Three main methods:

1. Scan block by block.

2. Query using the address.

3. Monitor blockchain events.

---

## How do I build and sign a transaction offline (demo)?

Common to Cosmos blockchains. Example — create unsigned transaction for governance voting:

`zigchaind tx gov vote $VOTE_ID yes \`  
`--from $ACCOUNT \`  
`--chain-id zigchain-1 \`  
`--node https://public-zigchain-testnet-rpc.numia.xyz/ \`  
`--gas auto \`  
`--gas=250000 \`  
`--fees=1000000uZIG \`  
`--generate-only \`  
`-o json \`  
`> ~/output.file`

TX_ID is obtained from the previous request message.

`zigchaind q tx $TX_ID --node https://public-zigchain-testnet-rpc.numia.xyz/`

Broadcast the transaction:

`zigchaind tx broadcast ~/output.file --chain-id zigchain-1 --node https://public-zigchain-testnet-rpc.numia.xyz/`

---

## How do I decode a signed transaction?

Common to Cosmos blockchains.  
 Decode via gRPC `POST /cosmos/tx/v1beta1/decode` or Amino `/decode/amino`.  
 CLI command:

`zigchaind tx decode $TX`

---

## What is the precision (smallest unit) for transactions?

Precision is integer-based. The smallest unit of ZIGCoin is `uZIG`, equivalent to 6 decimal places.

---

## What is the account information API endpoint?

Endpoint: `/cosmos/auth/v1beta1/accounts/{account}`  
 Example:  
 [https://testnet-api.zigchain.com/cosmos/auth/v1beta1/accounts/zig1jwgjeaxct84g97nea7vdfuuwvctzvee03x0xaw](https://testnet-api.zigchain.com/cosmos/auth/v1beta1/accounts/zig1jwgjeaxct84g97nea7vdfuuwvctzvee03x0xaw)

---

## What is the best block height (node status) API endpoint?

Endpoint: `/cosmos/base/node/v1beta1/status`  
 Example:  
 [https://testnet-api.zigchain.com/cosmos/base/node/v1beta1/status](https://testnet-api.zigchain.com/cosmos/base/node/v1beta1/status)

---

## How do I query account history (transactions)?

Query example:  
 `/cosmos/tx/v1beta1/txs?events=coin_received.receiver='zig1abc...'&pagination.limit=100`

---

## How do I get detailed transaction information by hash?

Endpoint: `/cosmos/tx/v1beta1/txs/{hash}`  
 Example:  
 [https://testnet-api.zigchain.com/cosmos/tx/v1beta1/txs/DD82C55A81FCA848EE245944512B3688DD41E9F41CE1F5136988FBE076FA2189](https://testnet-api.zigchain.com/cosmos/tx/v1beta1/txs/DD82C55A81FCA848EE245944512B3688DD41E9F41CE1F5136988FBE076FA2189)

---

## How do I verify a transaction to prevent fraudulent deposits?

Check status code = 0 for success.  
 Ensure confirmations are completed and verify final balance on the destination wallet.

---

## How do I get the balance of an account?

Endpoint: `/cosmos/bank/v1beta1/balances/{account}`  
 Example:  
 [https://testnet-api.zigchain.com/cosmos/bank/v1beta1/balances/zig1urape39hlscx2ed7vp5ck6lwa426lu97fx7fun](https://testnet-api.zigchain.com/cosmos/bank/v1beta1/balances/zig1urape39hlscx2ed7vp5ck6lwa426lu97fx7fun)

---

## What are the most common transaction types?

Common to Cosmos blockchains:  
 MsgSend, MsgMultiSend, MsgDelegate, MsgUndelegate.

---

## What is the average payload size of a transaction?

ZIGChain does not enforce a fixed transaction payload size.  
Transaction size depends on the message type.  
For a standard transfer (MsgSend), the average transaction payload size is typically a few hundred bytes (approximately 200–500 bytes), which is consistent with Cosmos SDK–based blockchains.

---

## Is there a transaction timeout mechanism?

Yes. The mempool timeout mechanism is configurable in `config.toml`.  
 Transfers may specify `--timeout-height` to invalidate after a certain height.

---

## Is there a rent or reservation requirement for accounts?

No rent or reservation mechanism.

---

## If UTXO-based, how would failed transactions be determined?

Not applicable — ZIGChain uses an account-based model.

---

## Are address formats reused across chains?

ZIGChain addresses are not reused from other chains.  
 ZIGChain uses the standard Cosmos SDK Bech32 format (`zig1…`), which is unique to its network.

---

## Does ZIGChain support smart contract functionality?

Yes. ZIGChain mainnet supports smart contract functionality through Cosmos SDK modules.

---

## Does ZIGChain support multiple tokens?

Yes. ZIGChain supports multiple tokens through its Token Factory and other modules.

---

## Are there address activation requirements?

No. Once a key pair is generated, the address is valid immediately and can receive or send funds.

---

## Can a user address be derived from the seed? How are accounts created?

**Yes.** On ZIGChain (Cosmos SDK), the address is **deterministically derived** from the seed (mnemonic).  
Flow: mnemonic/seed → (BIP-32/39/44 HD derivation) → private key → public key → address (hash of public key, then Bech32 with prefix `zig1`).  
Anyone with the same seed and derivation path can reproduce the same address offline.

**How accounts are created:**  
Accounts are created by generating a key pair (e.g. `zigchaind keys add` or restoring from mnemonic). The address is derived from the public key; there is **no on-chain account registration or activation**. The address is valid as soon as the key pair exists and can receive funds immediately.

This differs from systems such as **Hedera** or **Canton**, where account identifiers are assigned by the network (e.g. created via a transaction or by a participant node), and the address/account ID is not derivable from a user seed alone.

---

## Does ZIGChain support multi-signature?

Yes. ZIGChain supports multi-signature accounts and transactions.

---

## Is there a transaction expiration mechanism? (Do transactions expire if not included in a block?)

Yes. Transactions can include the `--timeout-height` flag; if the specified height is reached and the transaction remains unconfirmed, it becomes invalid.  
Mempool timeouts are also configurable in `config.toml`.

---

## Are there transaction fees?

Yes, ZIGChain applies transaction fees for all operations.  
 Reference: [https://docs.zigchain.com/general/fees](https://docs.zigchain.com/general/fees)

---

## Are there coinbase transactions?

No. ZIGChain is a standard Cosmos SDK blockchain without coinbase transactions.

---

## Is there a delayed transaction mechanism?

No delayed transaction mechanism is currently implemented at the blockchain level.

---

## Is offline signature supported?

Yes. Offline signing is fully supported.  
 Reference: [https://docs.cosmos.network/main/user/run-node/txs\#generating-a-transaction](https://docs.cosmos.network/main/user/run-node/txs#generating-a-transaction)

---

## What types of transactions affect account balances?

- Transfers between accounts

- Payment of transaction fees

- Governance proposal participation

- Staking and unstaking

- Reward collection (staking or module rewards)

- Smart contract execution

- Token Factory or DEX module interactions

- Airdrops

- Vesting

- Validator slashing

---

## What is the logic for confirming a successful transaction?

Transactions may fail during execution due to insufficient funds or other errors.  
 A successful transaction must include `"code": 0` and no error in `raw_log`.

---

## Where is address generation and validation documented?

Reference: [https://docs.cosmos.network/main/learn/beginner/accounts\#implementing-secp256r1-algo](https://docs.cosmos.network/main/learn/beginner/accounts#implementing-secp256r1-algo)

Address validation:

- Must use Bech32 prefix `zig`.

- Must pass checksum validation → `sdk.AccAddressFromBech32(address)`.  
   No activation required.

---

## Where is deposit processing logic documented?

To verify and analyze successful transfers:

- `/tx_search?query=...` → search by address event tags.

- `/tx?hash=...` → verify specific transaction.

- `/block?height=X` → review specific block.

---

## Where is transaction construction and offline signing documented?

Step-by-step guide:  
 [https://docs.cosmos.network/main/user/run-node/txs\#generating-a-transaction](https://docs.cosmos.network/main/user/run-node/txs#generating-a-transaction)

---

## Is the endpoint /cosmos/auth/v1beta1/accounts/{account} supported?

Yes.  
 Example: [https://testnet-api.zigchain.com/cosmos/auth/v1beta1/accounts/zig1jwgjeaxct84g97nea7vdfuuwvctzvee03x0xaw](https://testnet-api.zigchain.com/cosmos/auth/v1beta1/accounts/zig1jwgjeaxct84g97nea7vdfuuwvctzvee03x0xaw)

---

## Is the endpoint /cosmos/tx/v1beta1/txs supported?

Yes.  
 Requires query parameters.  
 Example:  
 [https://testnet-api.zigchain.com/cosmos/tx/v1beta1/txs?order_by=ORDER_BY_UNSPECIFIED&query=message.sender%3D'zig1](https://testnet-api.zigchain.com/cosmos/tx/v1beta1/txs?order_by=ORDER_BY_UNSPECIFIED&query=message.sender%3D'zig1)...'

---

## Is the endpoint /cosmos/tx/v1beta1/txs/{txHash} supported?

Yes.  
 Example:  
 [https://testnet-api.zigchain.com/cosmos/tx/v1beta1/txs/DD82C55A81FCA848EE245944512B3688DD41E9F41CE1F5136988FBE076FA2189](https://testnet-api.zigchain.com/cosmos/tx/v1beta1/txs/DD82C55A81FCA848EE245944512B3688DD41E9F41CE1F5136988FBE076FA2189)

---

## Is the endpoint /cosmos/base/tendermint/v1beta1/blocks/latest supported?

Yes.  
 Example:  
 [https://testnet-api.zigchain.com/cosmos/base/tendermint/v1beta1/blocks/latest](https://testnet-api.zigchain.com/cosmos/base/tendermint/v1beta1/blocks/latest)

---

## Is the endpoint /cosmos/tx/v1beta1/simulate supported?

Yes.  
 Requires parameters.  
 Documentation: [https://testnet-api.zigchain.com/#/Service/AuthService_Simulate](https://testnet-api.zigchain.com/#/Service/AuthService_Simulate)

---

## Is the endpoint /cosmos/bank/v1beta1/balances/{account} supported?

Yes.  
 Example:  
 [https://testnet-api.zigchain.com/cosmos/bank/v1beta1/balances/zig1urape39hlscx2ed7vp5ck6lwa426lu97fx7fun](https://testnet-api.zigchain.com/cosmos/bank/v1beta1/balances/zig1urape39hlscx2ed7vp5ck6lwa426lu97fx7fun)

---

## Is the endpoint /cosmos/base/tendermint/v1beta1/blocks/{height} supported?

Yes.  
 Example:  
 [https://testnet-api.zigchain.com/cosmos/base/tendermint/v1beta1/blocks/1200000](https://testnet-api.zigchain.com/cosmos/base/tendermint/v1beta1/blocks/1200000)

---

## What transaction serialization standard is used?

Canonical Cosmos Protobufs are used for serialization.  
 Transaction type: `/cosmos.bank.v1beta1.MsgSend`  
 Public key type: `/cosmos.crypto.secp256k1.PubKey`

---

## How do I obtain the fee structure (e.g. per block)?

Transaction fees can be obtained via:  
 `/cosmos/base/tendermint/v1beta1/blocks/{block_number}`

---

## Where can I check gas limits (reference)?

Gas limits can be checked via:  
 `/cosmos/base/tendermint/v1beta1/blocks/{block_number}`

---

## What is the address derivation and Bech32 formatting?

Bech32 prefix: `zig1`

---

## Which derivation paths are supported? Is it compatible with standard Cosmos derivation paths?

ZIGChain follows the default Cosmos SDK key management behavior and does not introduce any custom derivation logic.  
It is compatible with standard Cosmos derivation paths.

---

## Is there a fee requirement for transactions?

Yes.

---

## What is the highest transaction fee observed per block?

Observed aggregate fees around **\~5,000 uZIG per block** (indicative; varies with traffic and gas prices).

---

## Are there restrictions on withdrawals or outbound transfers?

No notable restrictions beyond standard Cosmos behavior. Mempool limits and timeouts are configurable; no per-account per-block cap is specified in the current guidance.

---

## Where are examples of failed transfer transactions?

**TBD — Internal.** Please provide 1–2 example failed transaction hashes to include here.

---

## Is there a minimum gas fee requirement?

Yes. **Minimum gas price: 0.0025 uZIG**.

---

## What is the highest single transaction fee observed?

Transactions on ZIGChain are typically inexpensive; **transactions consuming \> \~2,000,000 gas are uncommon**.  
 **TBD — Internal:** provide a specific example hash if a precise “highest observed” value is required.

---

## What is the recommended transaction fee for inclusion?

- **Minimum recommended gas price:** **0.0025 uZIG**

- **Common/average gas price used:** **\~0.025 uZIG**  
   Use price bumps as needed during peak network activity.

---

## What is the typical gas limit for a transfer or delegate?

- **Regular transfer (MsgSend):** \~**100,000** gas units (a conservative setup is **\~200,000**).  
   Example:  
   [https://app.range.org/tx/zigchain/49da391f4d62c21589c4fe659d01e9e57755057ea83210b175aaca4e87b0467c?height=2558822](https://app.range.org/tx/zigchain/49da391f4d62c21589c4fe659d01e9e57755057ea83210b175aaca4e87b0467c?height=2558822)

- **Delegate (MsgDelegate):** \~**200,000** gas units (good setup **\~250,000–300,000**).  
   Example:  
   [https://app.range.org/tx/zigchain/548100c3eac58ac030ecb1f68df38f382f6a3cc3dbaf5f968ab20602499d537a?height=3024794](https://app.range.org/tx/zigchain/548100c3eac58ac030ecb1f68df38f382f6a3cc3dbaf5f968ab20602499d537a?height=3024794)

---

## How do I auto-estimate gas for transfers?

Use automatic estimation and an adjustment factor, e.g.:  
 `--gas-prices 0.0025uZIG --gas auto --gas-adjustment 1.5`

---

## What is the minimum dust amount (smallest spendable balance)?

**1 uZIG = 0.000001 ZIG** (six decimal places).

---
