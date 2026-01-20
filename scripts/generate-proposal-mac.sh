#!/bin/bash

#############################################
# ZIGChain WASM Whitelist Proposal Generator
# Platform: macOS (BSD coreutils)
#############################################

set -e

# Configuration
CHAIN_ID="zigchain-1"
RPC_NODE="https://public-zigchain-rpc.numia.xyz"
OUTPUT_FILE="proposal.json"
AUTHORITY="zig10d07y265gmmuvt4z0w9aw880jnsr700jmgkh5m"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Print colored output
print_info() {
    printf "${BLUE}[INFO]${NC} %s\n" "$1"
}

print_success() {
    printf "${GREEN}[SUCCESS]${NC} %s\n" "$1"
}

print_warning() {
    printf "${YELLOW}[WARNING]${NC} %s\n" "$1"
}

print_error() {
    printf "${RED}[ERROR]${NC} %s\n" "$1"
}

print_header() {
    printf "${CYAN}========================================${NC}\n"
    printf "${CYAN}%s${NC}\n" "$1"
    printf "${CYAN}========================================${NC}\n"
}

# Check required dependencies
check_dependencies() {
    print_info "Checking dependencies..."
    
    if ! command -v zigchaind &> /dev/null; then
        print_error "zigchaind is not installed or not in PATH"
        echo "Please install zigchaind and ensure it's accessible in your PATH"
        exit 1
    fi
    
    if ! command -v jq &> /dev/null; then
        print_error "jq is not installed"
        echo "Please install jq: brew install jq"
        exit 1
    fi
    
    print_success "All dependencies found"
}

# Fetch WASM parameters from chain
fetch_wasm_params() {
    print_info "Fetching WASM parameters from chain..."
    
    WASM_PARAMS=$(zigchaind q wasm params \
        --chain-id "$CHAIN_ID" \
        --node "$RPC_NODE" \
        --output json 2>/dev/null) || {
        print_error "Failed to fetch WASM parameters from chain"
        exit 1
    }
    
    EXISTING_ADDRESSES=$(echo "$WASM_PARAMS" | jq -r '.code_upload_access.addresses')
    EXISTING_COUNT=$(echo "$EXISTING_ADDRESSES" | jq 'length')
    
    print_success "Fetched WASM parameters"
    print_info "Authority (hardcoded): $AUTHORITY"
    print_info "Current whitelisted addresses: $EXISTING_COUNT"
}

# Fetch governance parameters from chain
fetch_gov_params() {
    print_info "Fetching governance parameters from chain..."
    
    GOV_PARAMS=$(zigchaind q gov params \
        --chain-id "$CHAIN_ID" \
        --node "$RPC_NODE" \
        --output json 2>/dev/null) || {
        print_error "Failed to fetch governance parameters from chain"
        exit 1
    }
    
    # Extract minimum deposit (remove 'uzig' suffix and get numeric value)
    MIN_DEPOSIT_RAW=$(echo "$GOV_PARAMS" | jq -r '.params.min_deposit[0].amount // .min_deposit[0].amount // "0"')
    # Use sed for BSD compatibility to remove non-numeric characters
    MIN_DEPOSIT=$(echo "$MIN_DEPOSIT_RAW" | sed 's/[^0-9]//g')
    
    # Extract expedited minimum deposit if available
    EXPEDITED_MIN_DEPOSIT_RAW=$(echo "$GOV_PARAMS" | jq -r '.params.expedited_min_deposit[0].amount // .expedited_min_deposit[0].amount // "0"')
    EXPEDITED_MIN_DEPOSIT=$(echo "$EXPEDITED_MIN_DEPOSIT_RAW" | sed 's/[^0-9]//g')
    
    # Fallback if expedited deposit not found
    if [ -z "$EXPEDITED_MIN_DEPOSIT" ] || [ "$EXPEDITED_MIN_DEPOSIT" = "0" ]; then
        EXPEDITED_MIN_DEPOSIT=$MIN_DEPOSIT
    fi
    
    print_success "Fetched governance parameters"
}

# Validate zig address format
validate_address() {
    local addr="$1"
    # BSD-compatible regex check
    if echo "$addr" | grep -qE '^zig1[a-z0-9]{38,}$'; then
        return 0
    fi
    return 1
}

# Get team name from user
get_team_name() {
    echo ""
    print_header "Step 1: Team Name"
    echo ""
    echo "Enter the name of the team requesting whitelist access."
    printf "${YELLOW}Example: DeFa${NC}\n"
    echo ""
    
    while true; do
        printf "Enter the team name: "
        read TEAM_NAME
        if [ -n "$TEAM_NAME" ]; then
            break
        fi
        print_warning "Team name cannot be empty. Please try again."
    done
    
    print_success "Team name set to: $TEAM_NAME"
}

# Get project description from user
get_project_description() {
    echo ""
    print_header "Step 2: Project Description"
    echo ""
    echo "Enter a description about the project (markdown supported)."
    echo "This will appear in the proposal summary under 'About $TEAM_NAME'"
    echo ""
    printf "${YELLOW}Example:${NC}\n"
    echo "Invoice-based financing that creates a pool of funds backed by invoices,"
    echo "allowing lenders to finance these invoices by providing loans. When borrowers"
    echo "repay, lenders receive their principal and interest based on their shareholding"
    echo "in the pool"
    echo ""
    
    while true; do
        printf "Enter the project description: "
        read PROJECT_DESCRIPTION
        if [ -n "$PROJECT_DESCRIPTION" ]; then
            break
        fi
        print_warning "Project description cannot be empty. Please try again."
    done
    
    print_success "Project description recorded"
}

# Get wallet addresses from user
get_wallet_addresses() {
    echo ""
    print_header "Step 3: Wallet Address(es)"
    echo ""
    echo "Enter the wallet address(es) to whitelist."
    echo "For multiple addresses, separate with commas."
    echo ""
    printf "${YELLOW}Example (single): zig1sewps82xyc7neay2nkfn8q7uw6erj330etrmj8${NC}\n"
    printf "${YELLOW}Example (multiple): zig1abc..., zig1def..., zig1ghi...${NC}\n"
    echo ""
    
    while true; do
        printf "Enter wallet address(es): "
        read ADDRESS_INPUT
        
        if [ -z "$ADDRESS_INPUT" ]; then
            print_warning "Address cannot be empty. Please try again."
            continue
        fi
        
        # Parse addresses (comma-separated) - macOS compatible
        NEW_ADDRESSES=()
        VALID=true
        
        # Save original IFS
        OLDIFS="$IFS"
        IFS=','
        
        for addr in $ADDRESS_INPUT; do
            # Trim whitespace using xargs (BSD compatible)
            addr=$(echo "$addr" | xargs)
            
            if ! validate_address "$addr"; then
                print_error "Invalid address format: $addr"
                print_warning "Address must start with 'zig1' and be a valid bech32 address"
                VALID=false
                break
            fi
            
            NEW_ADDRESSES+=("$addr")
        done
        
        # Restore IFS
        IFS="$OLDIFS"
        
        if [ "$VALID" = true ] && [ ${#NEW_ADDRESSES[@]} -gt 0 ]; then
            break
        fi
    done
    
    NEW_ADDRESS_COUNT=${#NEW_ADDRESSES[@]}
    print_success "Validated $NEW_ADDRESS_COUNT address(es)"
}

# Ask if expedited proposal
get_expedited_option() {
    echo ""
    print_header "Step 4: Expedited Proposal"
    echo ""
    echo "Expedited proposals have a faster voting period but require a higher deposit."
    echo ""
    
    while true; do
        printf "Do you want this to be an expedited proposal? (y/n): "
        read EXPEDITED_INPUT
        case "$EXPEDITED_INPUT" in
            [yY]|[yY][eE][sS])
                EXPEDITED=true
                print_success "Proposal will be expedited"
                break
                ;;
            [nN]|[nN][oO])
                EXPEDITED=false
                print_success "Proposal will NOT be expedited"
                break
                ;;
            *)
                print_warning "Please enter 'y' for yes or 'n' for no"
                ;;
        esac
    done
}

# Get deposit amount from user
get_deposit_amount() {
    echo ""
    print_header "Step 5: Deposit Amount"
    echo ""
    
    # Determine minimum based on expedited status
    if [ "$EXPEDITED" = true ]; then
        REQUIRED_MIN=$EXPEDITED_MIN_DEPOSIT
        printf "${YELLOW}Expedited proposal minimum deposit: ${REQUIRED_MIN} uzig${NC}\n"
    else
        REQUIRED_MIN=$MIN_DEPOSIT
        printf "${YELLOW}Regular proposal minimum deposit: ${REQUIRED_MIN} uzig${NC}\n"
    fi
    
    echo ""
    echo "You can use the minimum deposit or enter a higher amount."
    echo ""
    
    while true; do
        printf "Enter deposit amount (press Enter to use minimum $REQUIRED_MIN): "
        read DEPOSIT_INPUT
        
        # Use minimum if empty
        if [ -z "$DEPOSIT_INPUT" ]; then
            DEPOSIT_AMOUNT=$REQUIRED_MIN
            print_success "Using minimum deposit: ${DEPOSIT_AMOUNT} uzig"
            break
        fi
        
        # Remove any non-numeric characters using sed (BSD compatible)
        DEPOSIT_INPUT=$(echo "$DEPOSIT_INPUT" | sed 's/[^0-9]//g')
        
        if [ -z "$DEPOSIT_INPUT" ]; then
            print_warning "Please enter a valid numeric amount"
            continue
        fi
        
        if [ "$DEPOSIT_INPUT" -lt "$REQUIRED_MIN" ]; then
            print_error "Deposit amount cannot be less than minimum ($REQUIRED_MIN uzig)"
            continue
        fi
        
        DEPOSIT_AMOUNT=$DEPOSIT_INPUT
        print_success "Deposit amount set to: ${DEPOSIT_AMOUNT} uzig"
        break
    done
}

# Generate the proposal JSON
generate_proposal() {
    print_info "Generating proposal.json..."
    
    # Determine title based on address count
    if [ "$NEW_ADDRESS_COUNT" -eq 1 ]; then
        TITLE="Whitelist $TEAM_NAME address to Upload Contracts"
    else
        TITLE="Whitelist $TEAM_NAME addresses to Upload Contracts"
    fi
    
    # Build address list for summary
    ADDRESS_LIST=""
    local i=0
    for addr in "${NEW_ADDRESSES[@]}"; do
        if [ $i -eq 0 ]; then
            ADDRESS_LIST="$addr"
        elif [ $i -eq $((NEW_ADDRESS_COUNT - 1)) ]; then
            ADDRESS_LIST="$ADDRESS_LIST and $addr"
        else
            ADDRESS_LIST="$ADDRESS_LIST, $addr"
        fi
        i=$((i + 1))
    done
    
    # Determine wallet(s) wording
    if [ "$NEW_ADDRESS_COUNT" -eq 1 ]; then
        WALLET_WORD="wallet"
        WALLET_WORD2="wallet is"
    else
        WALLET_WORD="wallets"
        WALLET_WORD2="wallets are"
    fi
    
    # Build summary
    SUMMARY="This proposal seeks approval to whitelist the ${WALLET_WORD} ${ADDRESS_LIST} for smart contract deployments on ZIGChain Mainnet. The ${WALLET_WORD2} controlled by ${TEAM_NAME} team, an external team building on ZIGChain.\\n\\n## About ${TEAM_NAME}\\n\\n${PROJECT_DESCRIPTION}"
    
    # Build new addresses array for JSON - macOS compatible
    NEW_ADDR_JSON="["
    local first=true
    for addr in "${NEW_ADDRESSES[@]}"; do
        if [ "$first" = true ]; then
            NEW_ADDR_JSON="${NEW_ADDR_JSON}\"$addr\""
            first=false
        else
            NEW_ADDR_JSON="${NEW_ADDR_JSON},\"$addr\""
        fi
    done
    NEW_ADDR_JSON="${NEW_ADDR_JSON}]"
    
    # Merge existing addresses with new addresses
    ALL_ADDRESSES=$(echo "$EXISTING_ADDRESSES" | jq --argjson new "$NEW_ADDR_JSON" '. + $new')
    
    # Calculate total count
    TOTAL_ADDRESS_COUNT=$(echo "$ALL_ADDRESSES" | jq 'length')
    
    # Generate the JSON
    cat > "$OUTPUT_FILE" << EOF
{
  "messages": [
    {
      "@type": "/cosmwasm.wasm.v1.MsgUpdateParams",
      "authority": "$AUTHORITY",
      "params": {
        "code_upload_access": {
          "permission": "AnyOfAddresses",
          "addresses": $ALL_ADDRESSES
        },
        "instantiate_default_permission": "Everybody"
      }
    }
  ],
  "metadata": "",
  "deposit": "${DEPOSIT_AMOUNT}uzig",
  "title": "$TITLE",
  "summary": "$SUMMARY",
  "expedited": $EXPEDITED
}
EOF
    
    # Format with jq for pretty printing
    jq '.' "$OUTPUT_FILE" > "${OUTPUT_FILE}.tmp" && mv "${OUTPUT_FILE}.tmp" "$OUTPUT_FILE"
    
    print_success "Generated $OUTPUT_FILE"
}

# Print final summary
print_summary() {
    echo ""
    print_header "        PROPOSAL SUMMARY"
    echo ""
    printf "File Location:      ${GREEN}./$OUTPUT_FILE${NC}\n"
    printf "Title:              ${CYAN}$TITLE${NC}\n"
    printf "Team:               %s\n" "$TEAM_NAME"
    
    if [ "$EXPEDITED" = true ]; then
        printf "Expedited:          ${YELLOW}Yes${NC}\n"
    else
        printf "Expedited:          No\n"
    fi
    
    printf "Deposit:            %s uzig\n" "$DEPOSIT_AMOUNT"
    printf "Authority:          %s\n" "$AUTHORITY"
    echo "----------------------------------------"
    printf "Existing Addresses: %s\n" "$EXISTING_COUNT"
    printf "New Address(es):    ${GREEN}$NEW_ADDRESS_COUNT${NC}\n"
    
    for addr in "${NEW_ADDRESSES[@]}"; do
        printf "  - ${GREEN}%s${NC}\n" "$addr"
    done
    
    printf "Total Addresses:    %s\n" "$TOTAL_ADDRESS_COUNT"
    echo ""
    print_header "    PROPOSAL FILE CONTENTS"
    echo ""
    cat "$OUTPUT_FILE"
    echo ""
    print_header "        SUBMIT COMMAND"
    echo ""
    echo "To submit this proposal, run the following command:"
    echo ""
    printf "${YELLOW}zigchaind tx gov submit-proposal $OUTPUT_FILE \\
  --chain-id $CHAIN_ID \\
  --node $RPC_NODE \\
  --gas-prices 0.0025uzig --gas auto --gas-adjustment 1.3 \\
  --from <KEY_NAME>${NC}\n"
    echo ""
    print_warning "Replace <KEY_NAME> with your actual key name"
    print_warning "Review the proposal file before submitting!"
    echo ""
}

# Main execution
main() {
    clear
    print_header "ZIGChain WASM Whitelist Proposal Generator"
    echo "Platform: macOS"
    echo ""
    
    # Check dependencies
    check_dependencies
    
    # Fetch chain data
    fetch_wasm_params
    fetch_gov_params
    
    # Get user inputs
    get_team_name
    get_project_description
    get_wallet_addresses
    get_expedited_option
    get_deposit_amount
    
    # Generate proposal
    generate_proposal
    
    # Print summary
    print_summary
    
    print_success "Proposal generation complete!"
}

# Run main function
main
