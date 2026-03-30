#!/bin/bash



CHAINID="zigchain-1"
PASSPHRASE="12345678"

VAL1_HOME=".zigchain"
VAL2_HOME=".zigchain2"
VAL3_HOME=".zigchain3"

VAL1_MONIKER="validator-1"
VAL2_MONIKER="validator-2"
VAL3_MONIKER="validator-3"


# Node 1 (defaults)
RPC1=26657
P2P1=26656
API1=1317
GRPC1=9090
GRPCWEB1=9091

# Node 2
RPC2=26667
P2P2=26666
API2=1318
GRPC2=9092
GRPCWEB2=9093

# Node 3
RPC3=26669
P2P3=26668
API3=1319
GRPC3=9094
GRPCWEB3=9095

rm -rf ~/$VAL1_HOME
rm -rf ~/$VAL2_HOME
rm -rf ~/$VAL3_HOME


# Initialize chain
echo "Init ZIGChain"
zigchaind init $VAL1_MONIKER --chain-id $CHAINID --home $HOME/$VAL1_HOME
zigchaind init $VAL2_MONIKER --chain-id $CHAINID --home $HOME/$VAL2_HOME
zigchaind init $VAL3_MONIKER --chain-id $CHAINID --home $HOME/$VAL3_HOME

# Update denom configurations
update_genesis() {
  jq "$1" $HOME/$VAL1_HOME/config/genesis.json > tmp.json && mv tmp.json $HOME/$VAL1_HOME/config/genesis.json
}

update_genesis '.app_state.crisis.constant_fee.denom = "uzig"'
update_genesis '.app_state.gov.params.min_deposit[0] = {"denom": "uzig", "amount": "100"}'
update_genesis '.app_state.gov.params.expedited_min_deposit[0] = {"denom": "uzig", "amount": "500"}'
update_genesis '.app_state.mint.params.mint_denom = "uzig"'
update_genesis '.app_state.staking.params.bond_denom = "uzig"'
update_genesis '.app_state.gov.voting_params.voting_period = "120s"'
update_genesis '.app_state.ibc.connection_genesis.params.max_expected_time_per_block = "1000000000"'
update_genesis '.consensus.params.evidence.max_age_duration = "1000000000"'
update_genesis '.app_state.staking.params.unbonding_time = "30s"'

# Set minimum gas price
perl -pi -e 's/^minimum-gas-prices.*/minimum-gas-prices = "0.00025uzig"/' $HOME/$VAL1_HOME/config/app.toml
perl -pi -e 's/^minimum-gas-prices.*/minimum-gas-prices = "0.00025uzig"/' $HOME/$VAL2_HOME/config/app.toml
perl -pi -e 's/^minimum-gas-prices.*/minimum-gas-prices = "0.00025uzig"/' $HOME/$VAL3_HOME/config/app.toml

# Key configuration
declare -A KEY_MNEMONICS=(
  ["valuser1"]="debate pottery prize tag lottery lounge protect fancy keep orbit person stage ten possible expect spend utility estate hope people attack input oval bird"
  ["zuser1"]="horse elite dog fix slide moon rely wife convince pear visa woman make rent giraffe under lawn impulse visit improve together above mixed what"
  ["zuser2"]="motion toddler sad surge present spot destroy clarify lyrics drastic cactus rhythm cupboard govern space soft fan accuse source spend artwork state smart motor"
  ["zuser3"]="design coral crawl aerobic airport engine spice impulse hobby limit twelve budget praise dog usage comic rain icon miss custom worth upper blade path"
  ["zuser4"]="blue define teach split satisfy mention food loop economy gravity lobster keep card milk smile unable barely attack shoot bulk vapor hybrid board drift"
  ["zuser5"]="net impact drift popular debris coast wrong iron amazing patient poet forward occur any private chunk tonight final clump general video bracket abstract fade"
)

declare -A KEY_MNEMONICS2=(
  ["valuser2"]="leader deal minor fade steak make thank install demand home decade forget loop proof attack ostrich answer banana climb evidence civil float pact trend"
)

declare -A KEY_MNEMONICS3=(
  ["valuser3"]="crush develop hover feature velvet wall bomb acid airport hobby innocent elephant rate whisper child predict twist broccoli since borrow people hospital develop slice"
)

# Key import function
import_key() {
  local key_name=$1
  local mnemonic=$3
  
  if [[ "$(uname)" == "Darwin" ]]; then
    echo -e "$mnemonic\n$PASSPHRASE\n$PASSPHRASE" | zigchaind keys add "$key_name" --recover --home $HOME/$2
  else
    yes "$mnemonic"$'\n'"$PASSPHRASE"$'\n'"$PASSPHRASE" | zigchaind keys add "$key_name" --recover --home $HOME/$2
  fi
}

# Import keys to individual nodes
for key in "${!KEY_MNEMONICS[@]}"; do
  echo "Importing $key..."
  import_key "$key" "$VAL1_HOME" "${KEY_MNEMONICS[$key]}"
done

for key in "${!KEY_MNEMONICS2[@]}"; do
  echo "Importing $key..."
  import_key "$key" "$VAL2_HOME" "${KEY_MNEMONICS2[$key]}"
done

for key in "${!KEY_MNEMONICS3[@]}"; do
  echo "Importing $key..."
  import_key "$key" "$VAL3_HOME" "${KEY_MNEMONICS3[$key]}"
done

# Fund accounts all to node 1
fund_account() {
  yes $PASSPHRASE | zigchaind genesis add-genesis-account $(zigchaind keys show $1 -a --home $HOME/$2) 1000000000000000000000uzig --home $HOME/$2
}

fund_account valuser1 $VAL1_HOME
fund_account valuser2 $VAL1_HOME
fund_account valuser3 $VAL1_HOME
fund_account zuser1 $VAL1_HOME
fund_account zuser2 $VAL1_HOME
fund_account zuser3 $VAL1_HOME
fund_account zuser4 $VAL1_HOME

fund_account valuser1 $VAL2_HOME
fund_account valuser2 $VAL2_HOME
fund_account valuser3 $VAL2_HOME
fund_account zuser1 $VAL2_HOME
fund_account zuser2 $VAL2_HOME
fund_account zuser3 $VAL2_HOME
fund_account zuser4 $VAL2_HOME

fund_account valuser1 $VAL3_HOME
fund_account valuser2 $VAL3_HOME
fund_account valuser3 $VAL3_HOME
fund_account zuser1 $VAL3_HOME
fund_account zuser2 $VAL3_HOME
fund_account zuser3 $VAL3_HOME
fund_account zuser4 $VAL3_HOME


# Create gentx
echo "Creating genesis transaction..."
yes $PASSPHRASE | zigchaind genesis gentx valuser1 1000000000000000000uzig --chain-id $CHAINID --home $HOME/$VAL1_HOME --ip 127.0.0.1 --p2p-port $P2P1 --moniker validator-1
yes $PASSPHRASE | zigchaind genesis gentx valuser2 1000000000000000000uzig --chain-id $CHAINID --home $HOME/$VAL2_HOME --ip 127.0.0.1 --p2p-port $P2P2 --moniker validator-2
yes $PASSPHRASE | zigchaind genesis gentx valuser3 1000000000000000000uzig --chain-id $CHAINID --home $HOME/$VAL3_HOME --ip 127.0.0.1 --p2p-port $P2P3 --moniker validator-3

# Collect gentxs
echo "Collecting genesis transactions..."
cp $HOME/$VAL2_HOME/config/gentx/* $HOME/$VAL1_HOME/config/gentx/
cp $HOME/$VAL3_HOME/config/gentx/* $HOME/$VAL1_HOME/config/gentx/

yes $PASSPHRASE | zigchaind genesis collect-gentxs --home $HOME/$VAL1_HOME

cp $HOME/$VAL1_HOME/config/genesis.json $HOME/$VAL2_HOME/config/genesis.json
cp $HOME/$VAL1_HOME/config/genesis.json $HOME/$VAL3_HOME/config/genesis.json

# Validate genesis
echo "Validating genesis..."
zigchaind genesis validate --home $HOME/$VAL1_HOME
zigchaind genesis validate --home $HOME/$VAL2_HOME
zigchaind genesis validate --home $HOME/$VAL3_HOME

jq '.app_state.genutil.gen_txs | length' ~/.zigchain/config/genesis.json  # should be 3


echo "🎉 Setup completed successfully!"

########################################
# Seed-based wiring (print commands)
########################################
ID1=$(zigchaind tendermint show-node-id --home $HOME/$VAL1_HOME)
ID2=$(zigchaind tendermint show-node-id --home $HOME/$VAL2_HOME)
ID3=$(zigchaind tendermint show-node-id --home $HOME/$VAL3_HOME)

for H in $HOME/$VAL1_HOME $HOME/$VAL2_HOME $HOME/$VAL3_HOME; do
  perl -pi -e 's/^pex = .*/pex = false/'               $H/config/config.toml
  perl -pi -e 's/^addr_book_strict = .*/addr_book_strict = false/' $H/config/config.toml
  perl -pi -e 's/^allow_duplicate_ip = .*/allow_duplicate_ip = true/' $H/config/config.toml
done

echo ""
echo "Node IDs:"
echo "  Node1: ${ID1}@127.0.0.1:${P2P1}"
echo "  Node2: ${ID2}@127.0.0.1:${P2P2}"
echo "  Node3: ${ID3}@127.0.0.1:${P2P3}"
echo ""
echo "Validator operator address (use this in contracts/tests):"
echo "  val1: $(zigchaind keys show valuser1 -a --bech val --home $HOME/$VAL1_HOME)"
echo ""
echo "Start each validator in a separate terminal (in this order):"
echo "  1) zigchaind start \\
  --home $HOME/$VAL1_HOME \\
  --rpc.laddr tcp://127.0.0.1:${RPC1} \\
  --p2p.laddr tcp://0.0.0.0:${P2P1} \\
  --p2p.pex=false"
echo ""
echo "  2) zigchaind start \\
  --home $HOME/$VAL2_HOME \\
  --rpc.laddr tcp://127.0.0.1:${RPC2} \\
  --p2p.laddr tcp://0.0.0.0:${P2P2} \\
  --p2p.persistent_peers \"$ID1@127.0.0.1:${P2P1}\" \\
  --p2p.unconditional_peer_ids \"$ID1\" \\
  --p2p.pex=false"
echo ""
echo "  3) zigchaind start \\
  --home $HOME/$VAL3_HOME \\
  --rpc.laddr tcp://127.0.0.1:${RPC3} \\
  --p2p.laddr tcp://0.0.0.0:${P2P3} \\
  --p2p.persistent_peers \"$ID1@127.0.0.1:${P2P1}\" \\
  --p2p.unconditional_peer_ids \"$ID1\" \\
  --p2p.pex=false"

echo ""
echo "You can now connect your app to RPC endpoints:"
echo "  Node1 RPC: http://127.0.0.1:${RPC1}"
echo "  Node2 RPC: http://127.0.0.1:${RPC2}"
echo "  Node3 RPC: http://127.0.0.1:${RPC3}"
echo ""
echo "🎉 Setup done! You can copy the start commands above into three terminals."