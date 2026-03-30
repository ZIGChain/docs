---
title: Governance Module
description: Complete technical reference for ZIGChain Governance Module including parameters, proposal types, voting mechanisms, deposit requirements, and CLI commands.
keywords:
  [
    ZIGChain governance module,
    ZIGChain governance,
    ZIGChain proposals,
    ZIGChain community voting,
    submit governance proposal ZIGChain,
    vote on Zigchain proposals,
    ZIGChain proposal lifecycle,
    zigchain gov module parameters,
    zigchaind tx gov commands,
    zigchain governance proposal guide,
    zigchain min deposit proposal,
    governance parameters ZIGChain,
    quorum threshold ZIGChain,
    ZIGChain on-chain governance,
    ZIG governance module,
  ]
sidebar_position: 3
---

import Tabs from '@theme/Tabs';
import TabItem from '@theme/TabItem';

# Governance Module

Before you start, you should have a basic understanding of the ZIGChain Governance. Read the [**Governance Article**](../users/governance) to get started.

The ZIGChain Governance is based on the [**Cosmos SDK - Governance Module**](https://docs.cosmos.network/main/build/modules/gov) but with specific parameters, which you can find in the [**Governance Parameters**](#governance-parameters) section.

If you're looking for quick commands, refer to the [Governance Quick Sheet](#governance-cli-quick-sheet).

---

## Governance Parameters

The governance process in ZIGChain is governed by the following parameters:

> ⚠️ _These values may change via governance proposals. Always confirm using the CLI or API._

| **Parameters**                                                  | **Testnet Value**              | **Mainnet Value**                      |
| --------------------------------------------------------------- | ------------------------------ | -------------------------------------- |
| [burn_proposal_deposit_prevote](#burn_proposal_deposit_prevote) | FALSE                          | FALSE                                  |
| [burn_vote_quorum](#burn_vote_quorum)                           | FALSE                          | FALSE                                  |
| [burn_vote_veto](#burn_vote_veto)                               | TRUE                           | TRUE                                   |
| [expedited_min_deposit](#expedited_min_deposit)                 | 5,000,000,000 uzig (5,000 ZIG) | 5,000,000,000,000 uzig (5,000,000 ZIG) |
| [expedited_threshold](#expedited_threshold)                     | 0.667 (66.7%)                  | 0.667 (66.7%)                          |
| [expedited_voting_period](#expedited_voting_period)             | 5m                             | 24h                                    |
| [max_deposit_period](#max_deposit_period)                       | 336h (14 days)                 | 336h (14 days)                         |
| [min_deposit](#min_deposit)                                     | 100,000,000 uzig (100 ZIG)     | 10,000,000,000 uzig (10,000 ZIG)       |
| [min_deposit_ratio](#min_deposit_ratio)                         | 0                              | 0                                      |
| [min_initial_deposit_ratio](#min_initial_deposit_ratio)         | 0.04 (4%)                      | 0.04 (4%)                              |
| [proposal_cancel_ratio](#proposal_cancel_ratio)                 | 0.5 (50%)                      | 0.5 (50%)                              |
| [proposal_cancel_dest](#proposal_cancel_dest)                   | NONE                           | NONE                                   |
| [quorum](#quorum)                                               | 0.334 (33.4%)                  | 0.334 (33.4%)                          |
| [threshold](#threshold)                                         | 0.51 (51%)                     | 0.51 (51%)                             |
| [veto_threshold](#veto_threshold)                               | 0.334 (33.4%)                  | 0.334 (33.4%)                          |
| [voting_period](#voting_period)                                 | 10m                            | 96h (4 days)                           |

---

## Governance Parameters Overview

Below are detailed explanations of the key governance parameters in ZIGChain:

---

### Burn Parameters

#### burn_proposal_deposit_prevote

- **Description**: Determines what happens to the deposit if a proposal fails to meet the minimum deposit requirement by the end of the deposit period.

  - **TRUE**: The deposit is burned (permanently removed from circulation).
  - **FALSE**: The deposit is refunded to the proposer and supporters.

- **Default**: FALSE

- **Observation**: While setting this parameter to `TRUE` can reduce spam, it may also discourage valid proposals.

#### burn_vote_quorum

- **Description**: Determines what happens to the deposit if a proposal does not reach the required quorum during the voting period.

  - **TRUE**: The deposit is burned (permanently removed from circulation).
  - **FALSE**: The deposit is refunded to the proposer and supporters.

- **Default**: FALSE

#### burn_vote_veto

- **Description**: Determines what happens to the deposit if a proposal is rejected due to a high number of "No with Veto" votes and is tagged as vetoed.

  - **TRUE**: Deposited tokens are burned if the veto threshold is met (e.g., over 33.4% "No with Veto").
  - **FALSE**: Deposits are refunded despite the veto outcome.

- **Default**: TRUE

- **Observation**: This parameter is essential to deter spammers and reduce governance fatigue.

---

### Expedited Proposal Parameters

#### expedited_min_deposit

- **Description**: Specifies the minimum deposit required for expedited proposals. Expedited proposals have a higher deposit requirement than regular proposals.

- **Default**: 5,000,000,000,000 uzig (5,000,000 ZIG)

- **Unit**: uzig

#### expedited_threshold

- **Description**: Defines the percentage of "Yes" votes (excluding abstentions) required for expedited proposals to pass. Expedited proposals require a higher threshold than regular proposals.

- **Default**: 0.667 (66.7%)

#### expedited_voting_period

- **Description**: Specifies the voting period duration for expedited proposals. Results are tallied and executed after this period ends.

- **Default**: 24h

---

### Deposit Parameters

#### max_deposit_period

- **Description**: Specifies the maximum time allowed to collect deposits on a proposal.

  - The deposit period ends when either:
    - The required deposit amount is reached.
    - The maximum time limit expires.
  - If the minimum deposit is not reached within this period, the deposit is either returned or burned, depending on the `burn_proposal_deposit_prevote` setting.

- **Default**: 336h (14 days)

#### min_deposit

- **Description**: The minimum amount required for a proposal to proceed to the voting stage.

- **Default**: 10,000,000,000 uzig (10,000 ZIG)

#### min_deposit_ratio

- **Description**: Specifies the minimum deposit as a percentage of `min_deposit`. This affects any deposit, including the initial one.

- **Default**: 0

- **Example**: If `min_deposit` is 100 uzigs and `min_deposit_ratio` is 1%, the required minimum deposit is 1 uzig.

#### min_initial_deposit_ratio

- **Description**: Specifies the required minimum deposit percentage when submitting a proposal. Only affects the initial deposit, not subsequent ones.

- **Default**: 0.04 (4%)

- **Observation**: Ensures proposers have "skin in the game" while keeping participation accessible.

---

### Proposal Cancellation Parameters

#### proposal_cancel_ratio

- **Description**: Determines the percentage of the deposit forfeited when a proposal is canceled before the voting period starts.

- **Default**: 0.5 (50%)

- **Example**: If `proposal_cancel_ratio` is 0.5, 50% of the deposit is lost, and the rest is refunded.

#### proposal_cancel_dest

- **Description**: Specifies where the forfeited deposit is sent if a proposal is canceled.

  - **Empty**: Lost funds are burned.
  - **Specified Address**: Funds are sent to this address.

- **Default**: NONE

---

### Voting Parameters

#### quorum

- **Description**: Minimum percentage of votes from the total bonded stake required for a proposal to be valid.

  - If quorum is not reached, the proposal is canceled, and deposits are either refunded or burned, depending on the `burn_vote_quorum` parameter.

- **Default**: 0.334 (33.4%)

#### threshold

- **Description**: Defines the proportion of "Yes" votes (excluding abstentions) required for a proposal to pass.

- **Default**: 0.51 (51%)

#### veto_threshold

- **Description**: Specifies the threshold of "No with Veto" votes needed to veto a proposal.

  - If "No with Veto" votes exceed this threshold, the proposal is vetoed. Deposits are burned or refunded based on the `burn_vote_veto` parameter.

- **Default**: 0.334 (33.4%)

#### voting_period

- **Description**: Specifies the duration of the voting period for regular proposals. Results are calculated and executed after this period ends.

- **Default**: 96h

## Governance CLI Quick Sheet

Fetch Params CLI

<Tabs groupId="network">
<TabItem value="Mainnet" label="Mainnet" default>

```bash
zigchaind q gov params \
--node https://public-zigchain-rpc.numia.xyz
```

</TabItem>
<TabItem value="Testnet" label="Testnet">

```bash
zigchaind q gov params \
--node https://public-zigchain-testnet-rpc.numia.xyz
```

</TabItem>
  <TabItem value="Local" label="Local">

```bash
zigchaind q gov params \
--node http://localhost:26657
```

</TabItem>
</Tabs>

Fetch Params REST API

<Tabs groupId="network">
  <TabItem value="Mainnet" label="Mainnet" default>

```bash
curl -s "https://api.zigchain.com/cosmos/gov/v1/params/" | jq '.params'
```

</TabItem>
  <TabItem value="Testnet" label="Testnet">

```bash
curl -s "https://testnet-api.zigchain.com/cosmos/gov/v1/params/" | jq '.params'
```

</TabItem>
  <TabItem value="Local" label="Local">

```bash
curl -s "http://localhost:1317/cosmos/gov/v1/params/" | jq '.params'
```

</TabItem>
</Tabs>

Draft a governance proposal:

<Tabs groupId="network">
<TabItem value="Mainnet" label="Mainnet" default>

```bash
zigchaind tx gov draft-proposal \
--chain-id zigchain-1 --node https://public-zigchain-rpc.numia.xyz
```

</TabItem>
<TabItem value="Testnet" label="Testnet">

```bash
zigchaind tx gov draft-proposal \
--chain-id zig-test-2 --node https://public-zigchain-testnet-rpc.numia.xyz
```

</TabItem>
<TabItem value="Local" label="Local">

```bash
zigchaind tx gov draft-proposal \
--chain-id zigchain-1 --node http://localhost:26657
```

</TabItem>
</Tabs>

Submit a governance proposal:

<Tabs groupId="network">
<TabItem value="Mainnet" label="Mainnet" default>

```bash
zigchaind tx gov submit-proposal draft_proposal.json \
--from <key-name> --chain-id zigchain-1 \
--node https://public-zigchain-rpc.numia.xyz \
--gas-prices 0.0025uzig --gas auto --gas-adjustment 1.3
```

</TabItem>
<TabItem value="Testnet" label="Testnet">

```bash
zigchaind tx gov submit-proposal draft_proposal.json \
--from <key-name> --chain-id zig-test-2 \
--node https://public-zigchain-testnet-rpc.numia.xyz \
--gas-prices 0.0025uzig --gas auto --gas-adjustment 1.3
```

</TabItem>
<TabItem value="Local" label="Local">

```bash
zigchaind tx gov submit-proposal draft_proposal.json \
--from <key-name> --chain-id zigchain-1 \
--node http://localhost:26657 \
--gas-prices 0.0025uzig --gas auto --gas-adjustment 1.3
```

</TabItem>
</Tabs>

Check a specific proposal:

<Tabs groupId="network">
<TabItem value="Mainnet" label="Mainnet" default>

```bash
PROPOSAL_ID=1
zigchaind query gov proposal $PROPOSAL_ID \
--chain-id zigchain-1 \
--node https://public-zigchain-rpc.numia.xyz
```

</TabItem>
<TabItem value="Testnet" label="Testnet">

```bash
PROPOSAL_ID=1
zigchaind query gov proposal $PROPOSAL_ID \
--chain-id zig-test-2 \
--node https://public-zigchain-testnet-rpc.numia.xyz
```

</TabItem>
<TabItem value="Local" label="Local">

```bash
PROPOSAL_ID=1
zigchaind query gov proposal $PROPOSAL_ID \
--chain-id zigchain-1 \
--node http://localhost:26657
```

</TabItem>
</Tabs>

Check all proposals:

<Tabs groupId="network">
<TabItem value="Mainnet" label="Mainnet" default>

```bash
zigchaind query gov proposals --chain-id zigchain-1 --node https://public-zigchain-rpc.numia.xyz
```

</TabItem>
<TabItem value="Testnet" label="Testnet">

```bash
zigchaind query gov proposals --chain-id zig-test-2 --node https://public-zigchain-testnet-rpc.numia.xyz
```

</TabItem>
<TabItem value="Local" label="Local">

```bash
zigchaind query gov proposals --chain-id zigchain-1 --node http://localhost:26657
```

</TabItem>
</Tabs>

Deposit funds to a proposal:

<Tabs groupId="network">
<TabItem value="Mainnet" label="Mainnet" default>

```bash
zigchaind tx gov deposit $PROPOSAL_ID 1000000uzig \
--from <key-name> --chain-id zigchain-1 \
--node https://public-zigchain-rpc.numia.xyz \
--gas-prices 0.0025uzig --gas auto --gas-adjustment 1.3
```

</TabItem>
<TabItem value="Testnet" label="Testnet">

```bash
zigchaind tx gov deposit $PROPOSAL_ID 1000000uzig \
--from <key-name> --chain-id zig-test-2 \
--node https://public-zigchain-testnet-rpc.numia.xyz \
--gas-prices 0.0025uzig --gas auto --gas-adjustment 1.3
```

</TabItem>
<TabItem value="Local" label="Local">

```bash
zigchaind tx gov deposit $PROPOSAL_ID 1000000uzig \
--from <key-name> --chain-id zigchain-1 \
--node http://localhost:26657 \
--gas-prices 0.0025uzig --gas auto --gas-adjustment 1.3
```

</TabItem>
</Tabs>

Vote on a proposal:

<Tabs groupId="network">
<TabItem value="Mainnet" label="Mainnet" default>

```bash
zigchaind tx gov vote $PROPOSAL_ID yes --from <key-name> --chain-id zigchain-1 \
--node https://public-zigchain-rpc.numia.xyz \
--gas-prices 0.0025uzig --gas auto --gas-adjustment 1.3
```

</TabItem>
<TabItem value="Testnet" label="Testnet">

```bash
zigchaind tx gov vote $PROPOSAL_ID yes --from <key-name> --chain-id zig-test-2 \
--node https://public-zigchain-testnet-rpc.numia.xyz \
--gas-prices 0.0025uzig --gas auto --gas-adjustment 1.3
```

</TabItem>
<TabItem value="Local" label="Local">

```bash
zigchaind tx gov vote $PROPOSAL_ID yes --from <key-name> --chain-id zigchain-1 \
--node http://localhost:26657 \
--gas-prices 0.0025uzig --gas auto --gas-adjustment 1.3
```

</TabItem>
</Tabs>

Vote with weight on a proposal:

<Tabs groupId="network">
<TabItem value="Mainnet" label="Mainnet" default>

```bash
zigchaind tx gov weighted-vote 1 yes=0.6,no=0.3,abstain=0.05,no_with_veto=0.05 \
--from <key-name> --chain-id zigchain-1 \
--node https://public-zigchain-rpc.numia.xyz \
--gas-prices 0.0025uzig --gas auto --gas-adjustment 1.3
```

</TabItem>
<TabItem value="Testnet" label="Testnet">

```bash
zigchaind tx gov weighted-vote 1 yes=0.6,no=0.3,abstain=0.05,no_with_veto=0.05 \
--from <key-name> --chain-id zig-test-2 \
--node https://public-zigchain-testnet-rpc.numia.xyz \
--gas-prices 0.0025uzig --gas auto --gas-adjustment 1.3
```

</TabItem>
<TabItem value="Local" label="Local">

```bash
zigchaind tx gov weighted-vote 1 yes=0.6,no=0.3,abstain=0.05,no_with_veto=0.05 \
--from <key-name> --chain-id zigchain-1 \
--node http://localhost:26657 \
--gas-prices 0.0025uzig --gas auto --gas-adjustment 1.3
```

</TabItem>
</Tabs>

Cancel a proposal:

<Tabs groupId="network">
<TabItem value="Mainnet" label="Mainnet" default>

```bash
zigchaind tx gov cancel-proposal $PROPOSAL_ID --from <key-name> --chain-id zigchain-1 \
--node https://public-zigchain-rpc.numia.xyz \
--gas-prices 0.0025uzig --gas auto --gas-adjustment 1.3
```

</TabItem>
<TabItem value="Testnet" label="Testnet">

```bash
zigchaind tx gov cancel-proposal $PROPOSAL_ID --from <key-name> --chain-id zig-test-2 \
--node https://public-zigchain-testnet-rpc.numia.xyz \
--gas-prices 0.0025uzig --gas auto --gas-adjustment 1.3
```

</TabItem>
<TabItem value="Local" label="Local">

```bash
zigchaind tx gov cancel-proposal $PROPOSAL_ID --from <key-name> --chain-id zigchain-1 \
--node http://localhost:26657  \
--gas-prices 0.0025uzig --gas auto --gas-adjustment 1.3
```

</TabItem>
</Tabs>

Query the proposal voting status:

<Tabs groupId="network">
<TabItem value="Mainnet" label="Mainnet" default>

```bash
zigchaind query gov tally $PROPOSAL_ID --chain-id zigchain-1 \
--node https://public-zigchain-rpc.numia.xyz
```

</TabItem>
<TabItem value="Testnet" label="Testnet">

```bash
zigchaind query gov tally $PROPOSAL_ID --chain-id zig-test-2 \
--node https://public-zigchain-testnet-rpc.numia.xyz
```

</TabItem>
<TabItem value="Local" label="Local">

```bash
zigchaind query gov tally $PROPOSAL_ID --chain-id zigchain-1 \
--node http://localhost:26657
```

</TabItem>
</Tabs>

Query all the votes in a proposal:

<Tabs groupId="network">
<TabItem value="Mainnet" label="Mainnet" default>

```bash
zigchaind query gov votes $PROPOSAL_ID --chain-id zigchain-1 \
--node https://public-zigchain-rpc.numia.xyz
```

</TabItem>
<TabItem value="Testnet" label="Testnet">

```bash
zigchaind query gov votes $PROPOSAL_ID --chain-id zig-test-2 \
--node https://public-zigchain-testnet-rpc.numia.xyz
```

</TabItem>
<TabItem value="Local" label="Local">

```bash
zigchaind query gov votes $PROPOSAL_ID --chain-id zigchain-1 \
--node http://localhost:26657
```

</TabItem>
</Tabs>

Query a specific vote in a proposal:

<Tabs groupId="network">
<TabItem value="Mainnet" label="Mainnet" default>

```bash
zigchaind query gov vote $PROPOSAL_ID <voter_address> --chain-id zigchain-1 \
--node https://public-zigchain-rpc.numia.xyz
```

</TabItem>
<TabItem value="Testnet" label="Testnet">

```bash
zigchaind query gov vote $PROPOSAL_ID <voter_address> --chain-id zig-test-2 \
--node https://public-zigchain-testnet-rpc.numia.xyz
```

</TabItem>
<TabItem value="Local" label="Local">

```bash
zigchaind query gov vote $PROPOSAL_ID <voter_address> --chain-id zigchain-1 \
--node http://localhost:26657
```

</TabItem>
</Tabs>

Query a specific deposit in a proposal:

<Tabs groupId="network">
<TabItem value="Mainnet" label="Mainnet" default>

```bash
zigchaind query gov deposit $PROPOSAL_ID <depositor_address> --chain-id zigchain-1 \
--node https://public-zigchain-rpc.numia.xyz
```

</TabItem>
<TabItem value="Testnet" label="Testnet">

```bash
zigchaind query gov deposit $PROPOSAL_ID <depositor_address> --chain-id zig-test-2 \
--node https://public-zigchain-testnet-rpc.numia.xyz
```

</TabItem>
<TabItem value="Local" label="Local">

```bash
zigchaind query gov deposit $PROPOSAL_ID <depositor_address> --chain-id zigchain-1 \
--node http://localhost:26657
```

</TabItem>
</Tabs>

Query all the deposits in a proposal:

<Tabs groupId="network">
<TabItem value="Mainnet" label="Mainnet" default>

```bash
zigchaind query gov deposits $PROPOSAL_ID --chain-id zigchain-1 \
--node https://public-zigchain-rpc.numia.xyz
```

</TabItem>
<TabItem value="Testnet" label="Testnet">

```bash
zigchaind query gov deposits $PROPOSAL_ID --chain-id zig-test-2 \
--node https://public-zigchain-testnet-rpc.numia.xyz
```

</TabItem>
<TabItem value="Local" label="Local">

```bash
zigchaind query gov deposits $PROPOSAL_ID --chain-id zigchain-1 \
--node http://localhost:26657
```

</TabItem>
</Tabs>

Query constitution:

<Tabs groupId="network">
<TabItem value="Mainnet" label="Mainnet" default>

```bash
zigchaind query gov constitution --chain-id zigchain-1 \
--node https://public-zigchain-rpc.numia.xyz
```

</TabItem>
<TabItem value="Testnet" label="Testnet">

```bash
zigchaind query gov constitution --chain-id zig-test-2 \
--node https://public-zigchain-testnet-rpc.numia.xyz
```

</TabItem>
<TabItem value="Local" label="Local">

```bash
zigchaind query gov constitution --chain-id zigchain-1 \
--node http://localhost:26657
```

</TabItem>
</Tabs>
---

## References

- [Governance General Information](../users/governance)
- [Cosmos SDK - Governance Module](https://docs.cosmos.network/v0.53/build/modules/gov)
