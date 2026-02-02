#!/bin/bash

rm -rf ~/.zigchain

CHAINID="zig-devnet-1"
MONIKER="devnet-node"
PASSPHRASE="12345678"

# Set moniker and chain-id
echo "Init ZIGChain Devnet"
zigchaind init $MONIKER --chain-id $CHAINID

jq '.app_state.crisis.constant_fee.denom = "uzig" | .app_state.crisis.constant_fee.amount = "1000"' $HOME/.zigchain/config/genesis.json > $HOME/.zigchain/config/tmp_genesis.json \
&& mv $HOME/.zigchain/config/tmp_genesis.json $HOME/.zigchain/config/genesis.json

# Update gov params
jq '.app_state.gov.params.min_deposit[0].denom = "uzig" | 
    .app_state.gov.params.min_deposit[0].amount = "100000000" |
    .app_state.gov.params.expedited_min_deposit[0].denom = "uzig" |
    .app_state.gov.params.expedited_min_deposit[0].amount = "5000000000" |
    .app_state.gov.params.expedited_voting_period = "120s" |
    .app_state.gov.params.voting_period = "600s" |
    .app_state.gov.params.max_deposit_period = "3600s" |
    .app_state.gov.params.quorum = "0.334" |
    .app_state.gov.params.threshold = "0.51" |
    .app_state.gov.params.veto_threshold = "0.334" |
    .app_state.gov.params.expedited_threshold = "0.667" |
    .app_state.gov.params.burn_vote_veto = true |
    .app_state.gov.params.burn_proposal_deposit_prevote = false |
    .app_state.gov.params.burn_vote_quorum = false |
    .app_state.gov.params.min_deposit_ratio = "0.0" |
    .app_state.gov.params.min_initial_deposit_ratio = "0.04" |
    .app_state.gov.params.proposal_cancel_ratio = "0.5" |
    .app_state.gov.params.proposal_cancel_dest = ""' $HOME/.zigchain/config/genesis.json > $HOME/.zigchain/config/tmp_genesis.json \
&& mv $HOME/.zigchain/config/tmp_genesis.json $HOME/.zigchain/config/genesis.json

# Update mint params
jq '.app_state.mint.params.mint_denom = "uzig" |
    .app_state.mint.params.blocks_per_year = "12614400" |
    .app_state.mint.params.goal_bonded = "0.20" |
    .app_state.mint.params.inflation_max = "0.03" |
    .app_state.mint.params.inflation_min = "0.01" |
    .app_state.mint.params.inflation_rate_change = "0.02"' $HOME/.zigchain/config/genesis.json > $HOME/.zigchain/config/tmp_genesis.json \
&& mv $HOME/.zigchain/config/tmp_genesis.json $HOME/.zigchain/config/genesis.json

# Update staking params
jq '.app_state.staking.params.bond_denom = "uzig" |
    .app_state.staking.params.historical_entries = 10000 |
    .app_state.staking.params.max_entries = 7 |
    .app_state.staking.params.max_validators = 33 |
    .app_state.staking.params.min_commission_rate = "0.0" |
    .app_state.staking.params.unbonding_time = "1814400s"' $HOME/.zigchain/config/genesis.json > $HOME/.zigchain/config/tmp_genesis.json \
&& mv $HOME/.zigchain/config/tmp_genesis.json $HOME/.zigchain/config/genesis.json

# Update dex params
jq '.app_state.dex.params.max_slippage = 0 |
    .app_state.dex.params.creationFee = "10000000" |
    .app_state.dex.params.creation_fee = 100000000 |
    .app_state.dex.params.minimal_liquidity_lock = 1000 |
    .app_state.dex.params.newPoolFeePct = "100" |
    .app_state.dex.params.new_pool_fee_pct = 500 |
    .app_state.dex.params.beneficiary = ""' $HOME/.zigchain/config/genesis.json > $HOME/.zigchain/config/tmp_genesis.json \
&& mv $HOME/.zigchain/config/tmp_genesis.json $HOME/.zigchain/config/genesis.json

# Update distribution params
jq '.app_state.distribution.params.base_proposer_reward = "0.000000000000000000" |
    .app_state.distribution.params.bonus_proposer_reward = "0.000000000000000000" |
    .app_state.distribution.params.community_tax = "0.02" |
    .app_state.distribution.params.withdraw_addr_enabled = true' $HOME/.zigchain/config/genesis.json > $HOME/.zigchain/config/tmp_genesis.json \
&& mv $HOME/.zigchain/config/tmp_genesis.json $HOME/.zigchain/config/genesis.json

# Update slashing params
jq '.app_state.slashing.params.downtime_jail_duration = "600s" |
    .app_state.slashing.params.min_signed_per_window = "0.05" |
    .app_state.slashing.params.signed_blocks_window = 35000 |
    .app_state.slashing.params.slash_fraction_double_sign = "0.05" |
    .app_state.slashing.params.slash_fraction_downtime = "0.010000000000000000"' $HOME/.zigchain/config/genesis.json > $HOME/.zigchain/config/tmp_genesis.json \
&& mv $HOME/.zigchain/config/tmp_genesis.json $HOME/.zigchain/config/genesis.json

# Update factory params
jq '.app_state.factory.params.createFeeAmount = 100000000 |
    .app_state.factory.params.createFeeDenom = "uzig" |
    .app_state.factory.params.create_fee_amount = 1000 |
    .app_state.factory.params.create_fee_denom = "uzig" |
    .app_state.factory.params.beneficiary = ""' $HOME/.zigchain/config/genesis.json > $HOME/.zigchain/config/tmp_genesis.json \
&& mv $HOME/.zigchain/config/tmp_genesis.json $HOME/.zigchain/config/genesis.json

# Update tokenwrapper settings
jq '.app_state.tokenwrapper.native_client_id = "07-tendermint-0" | 
    .app_state.tokenwrapper.counterparty_client_id = "07-tendermint-0" | 
    .app_state.tokenwrapper.native_port = "transfer" | 
    .app_state.tokenwrapper.counterparty_port = "transfer" | 
    .app_state.tokenwrapper.native_channel = "channel-0" | 
    .app_state.tokenwrapper.counterparty_channel = "channel-0" | 
    .app_state.tokenwrapper.decimal_difference = 0 |
    .app_state.tokenwrapper.enabled = false |
    .app_state.tokenwrapper.denom = "uzig" |
    .app_state.tokenwrapper.operator_address = "zig1qqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqk9whvl" |
    .app_state.tokenwrapper.proposed_operator_address = "zig1qqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqk9whvl" |
    .app_state.tokenwrapper.params = {} |
    .app_state.tokenwrapper.pauser_addresses = [] |
    .app_state.tokenwrapper.total_transferred_in = "0" |
    .app_state.tokenwrapper.total_transferred_out = "0"' $HOME/.zigchain/config/genesis.json > $HOME/.zigchain/config/tmp_genesis.json \
&& mv $HOME/.zigchain/config/tmp_genesis.json $HOME/.zigchain/config/genesis.json

# Add minimum fee for transactions to app.toml (0.00025uzig as per config)
perl -pi -e 's/^minimum-gas-prices.*/minimum-gas-prices = "0.00025uzig"/' $HOME/.zigchain/config/app.toml

# Enable prometheus
perl -pi -e 's/^prometheus = .*/prometheus = true/' $HOME/.zigchain/config/config.toml

# Key mnemonics (generated BIP39 24-word phrases)
Z_KEY="z"
Z_MNEMONIC="decade uphold idea stool wife churn zebra buzz improve stick case piano lucky erosion hobby exile finger caught enact clutch cup script control flip"

FAUCET_KEY="faucet"
FAUCET_MNEMONIC="token tribe renew language reject now whisper bullet erode broken often wage express people goddess trust novel burden noble rough rely vicious royal assault"

ZUSER1_KEY="zuser1"
ZUSER1_MNEMONIC="toss avocado orange admit urge lion pole actual scrap hope champion focus reunion blade swift abandon genre attack culture ramp brick share wisdom share"

ZUSER2_KEY="zuser2"
ZUSER2_MNEMONIC="provide labor build amount child onion anger enemy world inform kitten bamboo mother program tuna program dinosaur metal struggle exhibit region away sadness brisk"

ZUSER3_KEY="zuser3"
ZUSER3_MNEMONIC="arctic moon lobster again march patient tank casual enjoy gas air toy copy boring endless arctic mouse egg kidney fortune duck stem mask length"

ZUSER4_KEY="zuser4"
ZUSER4_MNEMONIC="zebra ticket paddle elevator brief artist cabin word include size inform melt vessel latin human puppy derive rate select video battle worry giraffe puppy"

ZUSER5_KEY="zuser5"
ZUSER5_MNEMONIC="wrist swear deal weekend loop follow usual shoulder render there verify violin output morning kite priority lion unit husband tennis cream tiny edge digital"

NK_KEY="nk"
NK_MNEMONIC="record trial during menu yellow subway oblige capital horn artefact stomach acid please need crater detect ice veteran street tired parent cloth sign thunder"

NEWLINE=$'\n'

# Import keys from mnemonics
echo "Importing Keys from Mnemonics"

import_key() {
    local mnemonic=$1
    local key_name=$2

    if [[ "$(uname)" == "Darwin" ]]; then
        echo -e "$mnemonic\n$PASSPHRASE\n$PASSPHRASE" | zigchaind keys add "$key_name" --recover
    else
        yes "$mnemonic$NEWLINE$PASSPHRASE$NEWLINE$PASSPHRASE" | zigchaind keys add "$key_name" --recover
    fi
}

import_key "$Z_MNEMONIC" "$Z_KEY"
import_key "$FAUCET_MNEMONIC" "$FAUCET_KEY"
import_key "$ZUSER1_MNEMONIC" "$ZUSER1_KEY"
import_key "$ZUSER2_MNEMONIC" "$ZUSER2_KEY"
import_key "$ZUSER3_MNEMONIC" "$ZUSER3_KEY"
import_key "$ZUSER4_MNEMONIC" "$ZUSER4_KEY"
import_key "$ZUSER5_MNEMONIC" "$ZUSER5_KEY"
import_key "$NK_MNEMONIC" "$NK_KEY"

# Allocate genesis accounts with amounts from config_devnet.yml
echo "Allocate funds to genesis accounts"
yes $PASSPHRASE | zigchaind genesis add-genesis-account $(zigchaind keys show $Z_KEY -a) 200000000000000000000uzig
yes $PASSPHRASE | zigchaind genesis add-genesis-account $(zigchaind keys show $FAUCET_KEY -a) 10000000000000000000000000uzig
yes $PASSPHRASE | zigchaind genesis add-genesis-account $(zigchaind keys show $ZUSER1_KEY -a) 10000000000000000uzig
yes $PASSPHRASE | zigchaind genesis add-genesis-account $(zigchaind keys show $ZUSER2_KEY -a) 10000000000000000uzig
yes $PASSPHRASE | zigchaind genesis add-genesis-account $(zigchaind keys show $ZUSER3_KEY -a) 10000000000000000uzig
yes $PASSPHRASE | zigchaind genesis add-genesis-account $(zigchaind keys show $ZUSER4_KEY -a) 10000000000000000uzig
yes $PASSPHRASE | zigchaind genesis add-genesis-account $(zigchaind keys show $ZUSER5_KEY -a) 10000000000000000uzig
yes $PASSPHRASE | zigchaind genesis add-genesis-account $(zigchaind keys show $NK_KEY -a) 10000000000000000uzig
yes $PASSPHRASE | zigchaind genesis add-genesis-account zig1razss9rgpa8dn3ekl83c4jdg2s8m23pesp44en 10000000000000000uzig
yes $PASSPHRASE | zigchaind genesis add-genesis-account zig1urape39hlscx2ed7vp5ck6lwa426lu97fx7fun 10000000000000000uzig

# Sign genesis transaction (validator z with bonded amount from config)
# Commission rates: rate=10%, max_rate=20%, max_change_rate=1%, min_self_delegation=1
echo "Signing genesis transaction"
yes $PASSPHRASE | zigchaind genesis gentx $Z_KEY 100000000000000000000uzig \
    --chain-id $CHAINID \
    --commission-rate 0.1 \
    --commission-max-rate 0.2 \
    --commission-max-change-rate 0.01 \
    --min-self-delegation 1

# Collect genesis tx
echo "Collecting genesis transaction"
yes $PASSPHRASE | zigchaind genesis collect-gentxs

echo "Validating genesis"

# Run this to ensure everything worked and that the genesis file is set up correctly
zigchaind genesis validate

echo "Setup done!"

