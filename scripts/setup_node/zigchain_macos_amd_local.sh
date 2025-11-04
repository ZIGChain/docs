#!/usr/bin/env bash
set -euo pipefail
trap 'echo "Error on line $LINENO: $BASH_COMMAND" >&2' ERR
if [[ "${DEBUG:-0}" == "1" ]]; then set -x; fi

# Zigchain MacOS AMD Local Setup Script
# This script sets up a ZIGChain local development node on MacOS AMD systems (Intel Macs)

echo "🚀 Starting ZIGChain MacOS AMD Local Setup..."

# Detect architecture
ARCH=$(uname -m)
if [[ "$ARCH" != "x86_64" ]]; then
    echo "❌ This script is for x86_64 (Intel) Macs only."
    echo "Detected architecture: $ARCH"
    echo "Please use the appropriate script for your system."
    exit 1
fi

echo "✅ Detected x86_64 architecture (Intel Mac)"

# Local setup always uses the default .zigchain directory
ZIGCHAIN_HOME="$HOME/.zigchain"

# Check if .zigchain directory exists
if [ -d "$HOME/.zigchain" ]; then
    echo "⚠️  Existing .zigchain directory found at $HOME/.zigchain"
    read -p "Do you want to delete the existing directory and start fresh? (y/N): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        echo "🗑️  Removing existing .zigchain directory..."
        rm -rf "$HOME/.zigchain"
        echo "📁 Setting up local node in: $ZIGCHAIN_HOME"
    else
        echo "❌ Setup cancelled. Please remove the existing directory manually or choose 'y' to continue."
        exit 1
    fi
else
    echo "📁 Setting up local node in: $ZIGCHAIN_HOME"
fi

# Check if Go is installed with correct version
if ! command -v go >/dev/null 2>&1; then
    echo "📦 Go not found. Installing Go 1.24.5 for x86_64..."
    tmpdir=$(mktemp -d)
    pushd "$tmpdir" >/dev/null
    curl -L -O https://go.dev/dl/go1.24.5.darwin-amd64.tar.gz || { echo "Failed to download Go" >&2; exit 1; }
    sudo tar -C /usr/local -xzf go1.24.5.darwin-amd64.tar.gz || { echo "Failed to extract Go" >&2; exit 1; }
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
    echo "📦 Installing zigchaind binary for x86_64..."
    
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
    curl -O "https://raw.githubusercontent.com/ZIGChain/networks/refs/heads/main/zig-test-2/binaries/zigchaind-${LATEST_VERSION}-darwin-amd64.tar.gz" || { 
        echo "Failed to download zigchaind ${LATEST_VERSION}" >&2; exit 1; 
    }
    tar -zxvf "zigchaind-${LATEST_VERSION}-darwin-amd64.tar.gz" || { 
        echo "Failed to extract zigchaind" >&2; exit 1; 
    }
    
    mkdir -p "$HOME/go/bin"
    mv "zigchaind-${LATEST_VERSION}-darwin-amd64/zigchaind" "$HOME/go/bin/zigchaind" || { 
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


# Install jq if not present
if ! command -v jq >/dev/null 2>&1; then
    echo "📦 Installing jq..."
    brew install jq
    echo "✅ jq installed successfully"
fi

# Download and execute the local setup script
echo "🔧 Running local setup script..."
cd /tmp/
curl -O https://raw.githubusercontent.com/ZIGChain/docs/main/scripts/zigchain_local_setup.sh || { 
    echo "Failed to download local setup script" >&2; exit 1; 
}
chmod +x zigchain_local_setup.sh

# Set the home directory for the local setup
export ZIGCHAIN_HOME="$ZIGCHAIN_HOME"
./zigchain_local_setup.sh

# Setup minimum gas price
echo "⛽ Setting minimum gas price..."
appcfg="$ZIGCHAIN_HOME/config/app.toml"
if [ -f "$appcfg" ]; then
    sed -i '' 's/^minimum-gas-prices *=.*/minimum-gas-prices = "0.0025uzig"/' "$appcfg"
    echo "✅ Minimum gas price set to 0.0025uzig"
else
    echo "⚠️  Warning: app.toml not found at $appcfg"
    echo "   The external setup script may not have completed properly"
    echo "   You may need to set the minimum gas price manually"
fi

echo ""
echo "🎉 Local setup completed successfully!"
echo ""
echo "To start your local node, run:"
echo "zigchaind start"
echo ""
echo "Your local node data will be stored in: $ZIGCHAIN_HOME"
echo ""
echo "Test accounts created during setup:"
echo "VAL_KEY: valuser1"
echo "ZUSER1_KEY: zuser1"
echo "ZUSER2_KEY: zuser2"
echo "ZUSER3_KEY: zuser3"
echo "ZUSER4_KEY: zuser4"
echo "ZUSER5_KEY: zuser5"
echo ""
echo "Check the quick-start.md file for test account mnemonics and usage examples."
