#!/usr/bin/env bash
set -euo pipefail
trap 'echo "Error on line $LINENO: $BASH_COMMAND" >&2' ERR
if [[ "${DEBUG:-0}" == "1" ]]; then set -x; fi

# Zigchain MacOS ARM Mainnet Setup Script
# This script sets up a ZIGChain mainnet node on MacOS ARM systems (Apple Silicon)

echo "🚀 Starting ZIGChain MacOS ARM Mainnet Setup..."

# Detect architecture
ARCH=$(uname -m)
if [[ "$ARCH" != "arm64" ]]; then
    echo "❌ This script is for ARM64 (Apple Silicon) Macs only."
    echo "Detected architecture: $ARCH"
    echo "Please use the appropriate script for your system."
    exit 1
fi

echo "✅ Detected ARM64 architecture (Apple Silicon)"

# Check if .zigchain directory exists
if [ -d "$HOME/.zigchain" ]; then
    echo "⚠️  Existing .zigchain directory found at $HOME/.zigchain"
    read -p "Do you want to delete the existing directory and start fresh? (y/N): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        echo "🗑️  Removing existing .zigchain directory..."
        rm -rf "$HOME/.zigchain"
        ZIGCHAIN_HOME="$HOME/.zigchain"
        echo "📁 Setting up mainnet node in: $ZIGCHAIN_HOME"
    else
        echo "📁 Keeping existing .zigchain directory, setting up mainnet node in separate directory"
        ZIGCHAIN_HOME="$HOME/.zigchain-mainnet"
        
        # Check if mainnet directory already exists
        if [ -d "$ZIGCHAIN_HOME" ]; then
            echo "⚠️  Mainnet directory already exists at $ZIGCHAIN_HOME"
            read -p "Do you want to delete the existing mainnet directory and start fresh? (y/N): " -n 1 -r
            echo
            if [[ $REPLY =~ ^[Yy]$ ]]; then
                echo "🗑️  Removing existing mainnet directory..."
                rm -rf "$ZIGCHAIN_HOME"
            else
                echo "❌ Setup cancelled. Please remove the existing directory manually or choose 'y' to continue."
                exit 1
            fi
        fi
        echo "📁 Setting up mainnet node in: $ZIGCHAIN_HOME"
    fi
else
    ZIGCHAIN_HOME="$HOME/.zigchain"
    echo "📁 Setting up mainnet node in: $ZIGCHAIN_HOME"
fi

# Check if Go is installed with correct version
if ! command -v go >/dev/null 2>&1; then
    echo "📦 Go not found. Installing Go 1.24.5 for ARM64..."
    tmpdir=$(mktemp -d)
    pushd "$tmpdir" >/dev/null
    curl -L -O https://go.dev/dl/go1.24.5.darwin-arm64.tar.gz || { echo "Failed to download Go" >&2; exit 1; }
    sudo tar -C /usr/local -xzf go1.24.5.darwin-arm64.tar.gz || { echo "Failed to extract Go" >&2; exit 1; }
    popd >/dev/null
    rm -rf "$tmpdir"
    
    # Add Go to PATH
    echo 'export GOROOT=/usr/local/go' >> ~/.zshrc
    echo 'export GOPATH=$HOME/go' >> ~/.zshrc
    echo 'export PATH=$PATH:$GOROOT/bin:$GOPATH/bin' >> ~/.zshrc
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
    echo "📦 Installing zigchaind binary for ARM64..."
    
    # Install required tools
    if ! command -v brew >/dev/null 2>&1; then
        echo "📦 Installing Homebrew..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    fi
    
    brew install curl wget jq || true
    
    # Get latest version
    LATEST_VERSION=$(curl -s https://raw.githubusercontent.com/ZIGChain/networks/refs/heads/main/zig-test-2/version.txt)
    if [ -z "$LATEST_VERSION" ] || [ "$LATEST_VERSION" = "null" ]; then
        echo "Failed to fetch latest zigchaind version" >&2
        exit 1
    fi
    
    # Download and install zigchaind
    tmpdir=$(mktemp -d)
    pushd "$tmpdir" >/dev/null
    curl -O "https://raw.githubusercontent.com/ZIGChain/networks/refs/heads/main/zig-test-2/binaries/zigchaind-${LATEST_VERSION}-darwin-arm64.tar.gz" || { 
        echo "Failed to download zigchaind ${LATEST_VERSION}" >&2; exit 1; 
    }
    tar -zxvf "zigchaind-${LATEST_VERSION}-darwin-arm64.tar.gz" || { 
        echo "Failed to extract zigchaind" >&2; exit 1; 
    }
    
    mkdir -p "$HOME/go/bin"
    mv "zigchaind-${LATEST_VERSION}-darwin-arm64/zigchaind" "$HOME/go/bin/zigchaind" || { 
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
echo "🔧 Initializing mainnet node..."
read -p "Enter node name (default: mynode): " NODE_NAME
NODE_NAME=${NODE_NAME:-mynode}

zigchaind init "$NODE_NAME" --chain-id zigchain-1 --home "$ZIGCHAIN_HOME" --overwrite

# Download genesis file
echo "📥 Downloading genesis file..."
curl -O https://raw.githubusercontent.com/ZIGChain/networks/refs/heads/main/zigchain-1/genesis.json || { 
    echo "Failed to download genesis.json" >&2; exit 1; 
}
mv genesis.json "$ZIGCHAIN_HOME/config/genesis.json"
echo "✅ Genesis file downloaded"

# Setup state sync
echo "🔄 Configuring state sync..."
SNAP_RPC="https://public-zigchain-rpc.numia.xyz:443"
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
SEED_NODES="https://raw.githubusercontent.com/ZIGChain/networks/main/zigchain-1/seed-nodes.txt"
SEED_FILE="$ZIGCHAIN_HOME/config/seed-nodes.txt"
curl -o "$SEED_FILE" "$SEED_NODES"
SEEDS=$(paste -sd, "$SEED_FILE")
sed -i '' -E "s|^(persistent_peers[[:space:]]*=[[:space:]]*).*|\1\"$SEEDS\"|" "$cfg"
echo "✅ Peers configured"

# Setup minimum gas fee
echo "⛽ Setting minimum gas price..."
appcfg="$ZIGCHAIN_HOME/config/app.toml"
sed -i '' 's/^minimum-gas-prices *=.*/minimum-gas-prices = "0.0025uzig"/' "$appcfg"
echo "✅ Minimum gas price set to 0.0025uzig"

echo ""
echo "🎉 Setup completed successfully!"
echo ""
if [[ "$ZIGCHAIN_HOME" == "$HOME/.zigchain" ]]; then
    echo "To start your mainnet node, run:"
    echo "zigchaind start"
    echo ""
    echo "Your node data will be stored in: $ZIGCHAIN_HOME"
else
    echo "To start your mainnet node, run:"
    echo "zigchaind start --home $ZIGCHAIN_HOME"
    echo ""
    echo "Your node data will be stored in: $ZIGCHAIN_HOME"
fi
