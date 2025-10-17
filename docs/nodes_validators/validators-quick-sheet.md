---
sidebar_position: 3
---

# Validator Quick Sheet

This quick sheet provides essential commands for managing validators on ZIGChain, including setup, status checks, and reward management.

<div class="spacer"></div>

## Quick Commands

### Get your node validator pub key

```sh
zigchaind tendermint show-validator
```

### Create a file with your validator info

```sh
PUBKEY=$(zigchaind tendermint show-validator)
bash -c "cat > /tmp/your_validator.txt" << EOM
{
    "pubkey": $PUBKEY,
    "amount": "1000000uzig",
    "moniker": "validator's name",
    "identity": "optional identity signature (ex. UPort or Keybase)",
    "website": "validator's (optional) website",
    "security": "validator's (optional) security contact email",
    "details": "validator's (optional) details",
    "commission-rate": "0.1",
    "commission-max-rate": "0.2",
    "commission-max-change-rate": "0.01",
    "min-self-delegation": "10"
}
EOM
```

### Create your validator

import Tabs from '@theme/Tabs';
import TabItem from '@theme/TabItem';

<Tabs>
  <TabItem value="Mainnet" label="Mainnet" default>

```sh
zigchaind tx staking create-validator /tmp/your_validator.txt \
--from $ACCOUNT \
--chain-id zigchain-1 --node https://public-zigchain-rpc.numia.xyz \
--gas "auto" \
--gas-prices "0.0025uzig" \
--gas-adjustment 1.5
```

  </TabItem>
  <TabItem value="Testnet" label="Testnet">

```sh
zigchaind tx staking create-validator /tmp/your_validator.txt \
--from $ACCOUNT \
--chain-id zig-test-2 --node https://public-zigchain-testnet-rpc.numia.xyz \
--gas "auto" \
--gas-prices "0.0025uzig" \
--gas-adjustment 1.5
```

  </TabItem>
  <TabItem value="Local" label="Local">

```sh
zigchaind tx staking create-validator /tmp/your_validator.txt \
--from zuser1 \
--chain-id zigchain-1 --node http://localhost:26657 \
--gas "auto" \
--gas-prices "0.0025uzig" \
--gas-adjustment 1.5
```

  </TabItem>
</Tabs>

### Confirm transaction and get your validator address

<Tabs>
  <TabItem value="Mainnet" label="Mainnet" default>

```sh
zigchaind query tx $TXHASH \
--chain-id zigchain-1 --node https://public-zigchain-rpc.numia.xyz | grep raw_log
VALIDATOR_OP_ADDRESS=$(zigchaind q tx $TXHASH --output json | jq -r '.tx.body.messages[0].validator_address')
```

  </TabItem>
  <TabItem value="Testnet" label="Testnet">

```sh
zigchaind query tx $TXHASH \
--chain-id zig-test-2 --node https://public-zigchain-testnet-rpc.numia.xyz | grep raw_log
VALIDATOR_OP_ADDRESS=$(zigchaind q tx $TXHASH --output json | jq -r '.tx.body.messages[0].validator_address')
```

  </TabItem>
  <TabItem value="Local" label="Local">

```sh
zigchaind query tx $TXHASH \
--chain-id zigchain-1 --node http://localhost:26657 | grep raw_log
VALIDATOR_OP_ADDRESS=$(zigchaind q tx $TXHASH --output json | jq -r '.tx.body.messages[0].validator_address')
```

  </TabItem>
</Tabs>

### Check your validator status

<Tabs>
  <TabItem value="Mainnet" label="Mainnet" default>

```sh
zigchaind query staking validator $VALIDATOR_OP_ADDRESS \
--chain-id zigchain-1 --node https://public-zigchain-rpc.numia.xyz
```

  </TabItem>
  <TabItem value="Testnet" label="Testnet">

```sh
zigchaind query staking validator $VALIDATOR_OP_ADDRESS \
--chain-id zig-test-2 --node https://public-zigchain-testnet-rpc.numia.xyz
```

  </TabItem>
  <TabItem value="Local" label="Local">

```sh
zigchaind query staking validator $VALIDATOR_OP_ADDRESS \
--chain-id zigchain-1 --node http://localhost:26657
```

  </TabItem>
</Tabs>

### Check if the validator is part of the active set

<Tabs>
  <TabItem value="Mainnet" label="Mainnet" default>

```sh
zigchaind query tendermint-validator-set \
--chain-id zigchain-1 --node https://public-zigchain-rpc.numia.xyz \
 | grep "$(zigchaind tendermint show-address)"
```

  </TabItem>
  <TabItem value="Testnet" label="Testnet">

```sh
zigchaind query tendermint-validator-set \
--chain-id zig-test-2 --node https://public-zigchain-testnet-rpc.numia.xyz \
 | grep "$(zigchaind tendermint show-address)"
```

  </TabItem>
  <TabItem value="Local" label="Local">

```sh
zigchaind query tendermint-validator-set \
--chain-id zigchain-1 --node http://localhost:26657 \
| grep "$(zigchaind tendermint show-address)"
```

  </TabItem>
</Tabs>

### Get your validator's consensus address

```sh
zigchaind comet show-address
VALIDATOR_CON_ADDRESS=$(zigchaind comet show-address)
```

### Edit your validator information

<Tabs>
  <TabItem value="Mainnet" label="Mainnet" default>

```sh
zigchaind tx staking edit-validator \
--commission-rate 0.05 \
--details "YOUR_DETAILS" \
--identity "YOUR_KEYBASE_ID" \
--min-self-delegation "100" \
--new-moniker "Your new moniker name" \
--website "YOUR_WEBSITE_URL" \
--security-contact "YOUR_EMAIL" \
--chain-id zigchain-1 --node https://public-zigchain-rpc.numia.xyz \
--from $ACCOUNT \
--gas-adjustment 1.5 \
--gas auto \
--gas-prices "0.0025uzig"
```

  </TabItem>
  <TabItem value="Testnet" label="Testnet">

```sh
zigchaind tx staking edit-validator \
--commission-rate 0.05 \
--details "YOUR_DETAILS" \
--identity "YOUR_KEYBASE_ID" \
--min-self-delegation "100" \
--new-moniker "Your new moniker name" \
--website "YOUR_WEBSITE_URL" \
--security-contact "YOUR_EMAIL" \
--chain-id zig-test-2 --node https://public-zigchain-testnet-rpc.numia.xyz\
--from $ACCOUNT \
--gas-adjustment 1.5 \
--gas auto \
--gas-prices "0.0025uzig"
```

  </TabItem>
  <TabItem value="Local" label="Local">

```sh
zigchaind tx staking edit-validator \
--commission-rate 0.05 \
--details "YOUR_DETAILS" \
--identity "YOUR_KEYBASE_ID" \
--min-self-delegation "100" \
--new-moniker "Your new moniker name" \
--website "YOUR_WEBSITE_URL" \
--security-contact "YOUR_EMAIL" \
--chain-id zigchain-1 --node http://localhost:26657 \
--from zuser1 \
--gas-adjustment 1.5 \
--gas auto \
--gas-prices "0.0025uzig"
```

  </TabItem>
</Tabs>

### Know when your validator will be unjailed

<Tabs>
  <TabItem value="Mainnet" label="Mainnet" default>

```sh
zigchaind query slashing signing-info $VALIDATOR_CON_ADDRESS \
--chain-id zigchain-1 --node https://public-zigchain-rpc.numia.xyz
zigchaind query slashing signing-info $(zigchaind tendermint show-validator) \
--chain-id zigchain-1 --node https://public-zigchain-rpc.numia.xyz
```

  </TabItem>
  <TabItem value="Testnet" label="Testnet">

```sh
zigchaind query slashing signing-info $VALIDATOR_CON_ADDRESS \
--chain-id zig-test-2 --node https://public-zigchain-testnet-rpc.numia.xyz
zigchaind query slashing signing-info $(zigchaind tendermint show-validator) \
--chain-id zig-test-2 --node https://public-zigchain-testnet-rpc.numia.xyz
```

  </TabItem>
  <TabItem value="Local" label="Local">

```sh
zigchaind query slashing signing-info $VALIDATOR_CON_ADDRESS --chain-id zigchain-1 --node http://localhost:26657
zigchaind query slashing signing-info $(zigchaind tendermint show-validator) --chain-id zigchain-1 --node http://localhost:26657
```

  </TabItem>
</Tabs>

### Unjail your validator

<Tabs>
  <TabItem value="Mainnet" label="Mainnet" default>

```sh
zigchaind tx slashing unjail \
--chain-id zigchain-1 \
--node https://public-zigchain-rpc.numia.xyz \
--gas "auto" \
--gas-prices "0.0025uzig" \
--from $ACCOUNT \
--gas-adjustment 1.5
```

  </TabItem>
  <TabItem value="Testnet" label="Testnet">

```sh
zigchaind tx slashing unjail \
--chain-id zig-test-2 \
--node https://public-zigchain-testnet-rpc.numia.xyz \
--gas "auto" \
--gas-prices "0.0025uzig" \
--from $ACCOUNT \
--gas-adjustment 1.5
```

  </TabItem>
  <TabItem value="Local" label="Local">

```sh
zigchaind tx slashing unjail \
--chain-id zigchain-1 \
--node http://localhost:26657 \
--gas "auto" \
--gas-prices "0.0025uzig" \
--from zuser1 \
--gas-adjustment=1.5
```

  </TabItem>
</Tabs>

### Get your validator's operator address

<Tabs>
  <TabItem value="Mainnet" label="Mainnet" default>

```sh
zigchaind query staking validator \
--chain-id zigchain-1 --node https://public-zigchain-rpc.numia.xyz
```

  </TabItem>
  <TabItem value="Testnet" label="Testnet">

```sh
zigchaind query staking validator \
--chain-id zig-test-2 --node https://public-zigchain-testnet-rpc.numia.xyz
```

  </TabItem>
  <TabItem value="Local" label="Local">

```sh
zigchaind query staking validator \
--chain-id zigchain-1 --node http://localhost:26657
```

  </TabItem>
</Tabs>

### Get your slashing info and unjail period end

<Tabs>
  <TabItem value="Mainnet" label="Mainnet" default>

```sh
zigchaind query slashing signing-info $(zigchaind tendermint show-validator) \
--chain-id zigchain-1 --node https://public-zigchain-rpc.numia.xyz
```

  </TabItem>
  <TabItem value="Testnet" label="Testnet">

```sh
zigchaind query slashing signing-info $(zigchaind tendermint show-validator) \
--chain-id zig-test-2 --node https://public-zigchain-testnet-rpc.numia.xyz
```

  </TabItem>
  <TabItem value="Local" label="Local">

```sh
zigchaind query slashing signing-info $(zigchaind tendermint show-validator) \
--chain-id zigchain-1 --node http://localhost:26657
```

  </TabItem>
</Tabs>

### Get the rewards of your validator

<Tabs>
  <TabItem value="Mainnet" label="Mainnet" default>

```sh
zigchaind query distribution commission $VALIDATOR_OP_ADDRESS \
--chain-id zigchain-1 --node https://public-zigchain-rpc.numia.xyz
```

  </TabItem>
  <TabItem value="Testnet" label="Testnet">

```sh
zigchaind query distribution commission $VALIDATOR_OP_ADDRESS \
--chain-id zig-test-2 --node https://public-zigchain-testnet-rpc.numia.xyz
```

  </TabItem>
  <TabItem value="Local" label="Local">

```sh
zigchaind query distribution commission $VALIDATOR_OP_ADDRESS \
--chain-id zigchain-1 --node http://localhost:26657
```

  </TabItem>
</Tabs>

### Get the rewards of your validator and the self-bonded rewards

<Tabs>
  <TabItem value="Mainnet" label="Mainnet" default>

```sh
zigchaind query distribution validator-distribution-info $VALIDATOR_OP_ADDRESS \
--chain-id zigchain-1 --node https://public-zigchain-rpc.numia.xyz
```

  </TabItem>
  <TabItem value="Testnet" label="Testnet">

```sh
zigchaind query distribution validator-distribution-info $VALIDATOR_OP_ADDRESS \
--chain-id zig-test-2 --node https://public-zigchain-testnet-rpc.numia.xyz
```

  </TabItem>
  <TabItem value="Local" label="Local">

```sh
zigchaind query distribution validator-distribution-info $VALIDATOR_OP_ADDRESS \
--chain-id zigchain-1 --node http://localhost:26657
```

  </TabItem>
</Tabs>

### Withdraw your rewards

<Tabs>
  <TabItem value="Mainnet" label="Mainnet" default>

```sh
zigchaind tx distribution withdraw-rewards $VALIDATOR_OP_ADDRESS \
--chain-id zigchain-1 --node https://public-zigchain-rpc.numia.xyz \
--from z \
--gas-adjustment=1.5 \
--gas auto \
--gas-prices="0.0025uzig"
```

  </TabItem>
  <TabItem value="Testnet" label="Testnet">

```sh
zigchaind tx distribution withdraw-rewards $VALIDATOR_OP_ADDRESS \
--chain-id zig-test-2 --node https://public-zigchain-testnet-rpc.numia.xyz \
--from z \
--gas-adjustment=1.5 \
--gas auto \
--gas-prices="0.0025uzig"
```

  </TabItem>
  <TabItem value="Local" label="Local">

```sh
zigchaind tx distribution withdraw-rewards $VALIDATOR_OP_ADDRESS \
--chain-id zigchain-1 --node http://localhost:26657 \
--from z \
--gas-adjustment=1.5 \
--gas auto \
--gas-prices="0.0025uzig"
```

  </TabItem>
</Tabs>

<div class="spacer"></div>
