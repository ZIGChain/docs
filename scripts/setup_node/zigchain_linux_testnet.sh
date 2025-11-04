#!/usr/bin/env bash
set -euo pipefail
trap 'echo "Error on line $LINENO: $BASH_COMMAND" >&2' ERR
if [[ "${DEBUG:-0}" == "1" ]]; then set -x; fi

# Zigchain Linux Testnet Setup Script
# This script sets up a ZIGChain testnet node on Linux systems

echo "🚀 Starting ZIGChain Linux Testnet Setup..."

# Check if .zigchain directory exists
if [ -d "$HOME/.zigchain" ]; then
    echo "⚠️  Existing .zigchain directory found at $HOME/.zigchain"
    read -p "Do you want to delete the existing directory and start fresh? (y/N): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        echo "🗑️  Removing existing .zigchain directory..."
        rm -rf "$HOME/.zigchain"
        ZIGCHAIN_HOME="$HOME/.zigchain"
        echo "📁 Setting up testnet node in: $ZIGCHAIN_HOME"
    else
        echo "📁 Keeping existing .zigchain directory, setting up testnet node in separate directory"
        ZIGCHAIN_HOME="$HOME/.zigchain-testnet"
        
        # Check if testnet directory already exists
        if [ -d "$ZIGCHAIN_HOME" ]; then
            echo "⚠️  Testnet directory already exists at $ZIGCHAIN_HOME"
            read -p "Do you want to delete the existing testnet directory and start fresh? (y/N): " -n 1 -r
            echo
            if [[ $REPLY =~ ^[Yy]$ ]]; then
                echo "🗑️  Removing existing testnet directory..."
                rm -rf "$ZIGCHAIN_HOME"
            else
                echo "❌ Setup cancelled. Please remove the existing directory manually or choose 'y' to continue."
                exit 1
            fi
        fi
        echo "📁 Setting up testnet node in: $ZIGCHAIN_HOME"
    fi
else
    ZIGCHAIN_HOME="$HOME/.zigchain"
    echo "📁 Setting up testnet node in: $ZIGCHAIN_HOME"
fi

# Check if Go is installed with correct version
if ! command -v go >/dev/null 2>&1; then
    echo "📦 Go not found. Installing Go 1.24.5..."
    tmpdir=$(mktemp -d)
    pushd "$tmpdir" >/dev/null
    wget -q https://go.dev/dl/go1.24.5.linux-amd64.tar.gz || { echo "Failed to download Go" >&2; exit 1; }
    sudo tar -C /usr/local -xzf go1.24.5.linux-amd64.tar.gz || { echo "Failed to extract Go" >&2; exit 1; }
    popd >/dev/null
    rm -rf "$tmpdir"
    
    # Add Go to PATH
    echo 'export GOROOT=/usr/local/go' >> ~/.bashrc
    echo 'export GOPATH=$HOME/go' >> ~/.bashrc
    echo 'export PATH=$PATH:$GOROOT/bin:$GOPATH/bin' >> ~/.bashrc
    export GOROOT=/usr/local/go
    export GOPATH="$HOME/go"
    export PATH="$PATH:$GOROOT/bin:$GOPATH/bin"
    echo "✅ Go installed successfully"
else
    GO_VERSION=$(go version | grep -o 'go[0-9]\+\.[0-9]\+\.[0-9]\+' | sed 's/go//')
    echo "✅ Go version $GO_VERSION found"
fi

# Check if zigchaind binary exists
if ! command -v zigchaind >/dev/null 2>&1; then
    echo "📦 Installing zigchaind binary..."
    
    # Install required tools
    sudo apt-get update -y
    sudo apt-get install -y curl wget jq tar
    
    # Get latest version
    LATEST_VERSION=$(curl -s https://raw.githubusercontent.com/ZIGChain/networks/refs/heads/main/zig-test-2/version.txt)
    if [ -z "$LATEST_VERSION" ] || [ "$LATEST_VERSION" = "null" ]; then
        echo "Failed to fetch latest zigchaind version" >&2
        exit 1
    fi
    
    # Download and install zigchaind
    tmpdir=$(mktemp -d)
    pushd "$tmpdir" >/dev/null
    wget "https://raw.githubusercontent.com/ZIGChain/networks/refs/heads/main/zig-test-2/binaries/zigchaind-${LATEST_VERSION}-linux-amd64.tar.gz" || { 
        echo "Failed to download zigchaind ${LATEST_VERSION}" >&2; exit 1; 
    }
    tar -zxvf "zigchaind-${LATEST_VERSION}-linux-amd64.tar.gz" || { 
        echo "Failed to extract zigchaind" >&2; exit 1; 
    }
    
    mkdir -p "$HOME/go/bin"
    mv "zigchaind-${LATEST_VERSION}-linux-amd64/zigchaind" "$HOME/go/bin/zigchaind" || { 
        echo "zigchaind binary missing after extract" >&2; exit 1; 
    }
    chmod +x "$HOME/go/bin/zigchaind"
    
    popd >/dev/null
    rm -rf "$tmpdir"
    export PATH="$PATH:$HOME/go/bin"
    echo "✅ zigchaind installed successfully"
else
    echo "✅ zigchaind binary found"
fi


# Initialize the node
echo "🔧 Initializing testnet node..."
read -p "Enter node name (default: mynode): " NODE_NAME
NODE_NAME=${NODE_NAME:-mynode}

zigchaind init "$NODE_NAME" --chain-id zig-test-2 --home "$ZIGCHAIN_HOME" --overwrite

# Download genesis file
echo "📥 Downloading genesis file..."
wget -q https://raw.githubusercontent.com/ZIGChain/networks/refs/heads/main/zig-test-2/genesis.json \
    -O "$ZIGCHAIN_HOME/config/genesis.json" || { 
    echo "Failed to download genesis.json" >&2; exit 1; 
}
echo "✅ Genesis file downloaded"

# Setup state sync
echo "🔄 Configuring state sync..."
SNAP_RPC="https://testnet-rpc.zigchain.com:443"
LATEST_HEIGHT=$(curl -s "$SNAP_RPC/block" | jq -r .result.block.header.height)
if [[ -z "$LATEST_HEIGHT" || "$LATEST_HEIGHT" == "null" ]]; then 
    echo "Failed to fetch latest block height from $SNAP_RPC" >&2; exit 1; 
fi
BLOCK_HEIGHT=$((LATEST_HEIGHT - 5000))
TRUST_HASH=$(curl -s "$SNAP_RPC/block?height=$BLOCK_HEIGHT" | jq -r .result.block_id.hash)

cfg="$ZIGCHAIN_HOME/config/config.toml"
sed -i.bak -E \
    "s|^(enable[[:space:]]*=[[:space:]]*).*$|\1true|; \
     s|^(rpc_servers[[:space:]]*=[[:space:]]*).*$|\1\"$SNAP_RPC,$SNAP_RPC\"|; \
     s|^(trust_height[[:space:]]*=[[:space:]]*).*$|\1$BLOCK_HEIGHT|; \
     s|^(trust_hash[[:space:]]*=[[:space:]]*).*$|\1\"$TRUST_HASH\"|" \
    "$cfg"
echo "✅ State sync configured"

# Setup peers
echo "🌐 Configuring peers..."
SEED_NODES="https://raw.githubusercontent.com/ZIGChain/networks/main/zig-test-2/seed-nodes.txt"
SEED_FILE="$ZIGCHAIN_HOME/config/seed-nodes.txt"
wget -q "$SEED_NODES" -O "$SEED_FILE"
SEEDS=$(paste -sd, "$SEED_FILE")
sed -i -E "s|^(persistent_peers[[:space:]]*=[[:space:]]*).*|\1\"$SEEDS\"|" "$cfg"
echo "✅ Peers configured"

# Setup minimum gas fee
echo "⛽ Setting minimum gas price..."
appcfg="$ZIGCHAIN_HOME/config/app.toml"
sed -i 's/^minimum-gas-prices *=.*/minimum-gas-prices = "0.0025uzig"/' "$appcfg"
echo "✅ Minimum gas price set to 0.0025uzig"

echo ""
echo "🎉 Setup completed successfully!"
echo ""
if [[ "$ZIGCHAIN_HOME" == "$HOME/.zigchain" ]]; then
    echo "To start your testnet node, run:"
    echo "zigchaind start"
    echo ""
    echo "Your node data will be stored in: $ZIGCHAIN_HOME"
else
    echo "To start your testnet node, run:"
    echo "zigchaind start --home $ZIGCHAIN_HOME"
    echo ""
    echo "Your node data will be stored in: $ZIGCHAIN_HOME"
fi
