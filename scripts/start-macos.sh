#!/usr/bin/env bash

set -euo pipefail

NETWORKS_REPO_BASE="https://raw.githubusercontent.com/ZIGChain/networks"
NETWORKS_MAIN_BRANCH="${NETWORKS_REPO_BASE}/main"
NETWORKS_HEAD_MAIN="${NETWORKS_REPO_BASE}/refs/heads/main"
DOCS_REPO_BASE="https://raw.githubusercontent.com/ZIGChain/docs/main"
export PATH="$HOME/.local/bin:$PATH"

show_banner() {
  clear 2>/dev/null || true
  cat <<'BANNER'
░█████████ ░██████  ░██████    ░██████  ░██                   ░██           
      ░██    ░██   ░██   ░██  ░██   ░██ ░██                                  
     ░██     ░██  ░██        ░██        ░████████   ░██████   ░██░████████  
   ░███      ░██  ░██  █████ ░██        ░██    ░██       ░██  ░██░██    ░██ 
  ░██        ░██  ░██     ██ ░██        ░██    ░██  ░███████  ░██░██    ░██ 
 ░██         ░██   ░██  ░███  ░██   ░██ ░██    ░██ ░██   ░██  ░██░██    ░██ 
░█████████ ░██████  ░█████░█   ░██████  ░██    ░██  ░█████░██ ░██░██    ░██ 
                                                                            
                                                                            
                                                                            

Welcome to the ZIGChain node launcher (macOS)
BANNER

  local macos_version arch
  macos_version=$(sw_vers -productVersion 2>/dev/null || echo "unknown")
  arch=$(uname -m 2>/dev/null || echo "unknown")

  echo "Detected macOS: ${macos_version} | Architecture: ${arch}" 
  echo
  echo "Please choose a network to start:"
  echo "  1) Mainnet"
  echo "  2) Testnet"
  echo "  3) Local setup (development)"
  echo
}

ensure_macos() {
  if [[ "$(uname)" != "Darwin" ]]; then
    echo "This launcher is for macOS only. Detected: $(uname)" >&2
    exit 1
  fi
}

trap 'echo; echo "Received termination signal."' INT TERM

ensure_macos
show_banner
read -r -p "Enter choice [1-3]: " USER_CHOICE

ARCH=$(uname -m)

detect_arch_tag() {
  case "$ARCH" in
    arm64|aarch64) echo "arm";;
    x86_64) echo "amd";;
    *) echo "amd";;
  esac
}

ensure_cli() {
  # Check for required tools first
  local missing_tools=()
  command -v curl >/dev/null 2>&1 || missing_tools+=("curl")
  command -v jq >/dev/null 2>&1 || missing_tools+=("jq")
  
  # Only check for Homebrew if we need to install missing tools
  if [[ ${#missing_tools[@]} -gt 0 ]]; then
    echo "⚠️  The following tools are required but not installed: ${missing_tools[*]}"
    
    # Check for Homebrew and ask for permission to install
    if ! command -v brew >/dev/null 2>&1; then
      echo "⚠️  Homebrew is not installed and is required to install missing tools."
      read -p "Do you want to install Homebrew? (y/N): " -n 1 -r; echo
      if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo "❌ Setup cancelled. Please install Homebrew manually or install the required tools another way." >&2
        exit 1
      fi
      echo "📦 Installing Homebrew..."
      /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    fi
    
    read -p "Do you want to install the missing tools using Homebrew? (y/N): " -n 1 -r; echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
      echo "❌ Setup cancelled. Please install the required tools manually." >&2
      exit 1
    fi
    brew install "${missing_tools[@]}" || true
  fi
  
  # Fetch latest version from repository
  LATEST_VERSION_FULL=$(curl -sSf "${NETWORKS_MAIN_BRANCH}/zig-test-2/version.txt" | tr -d '\r\n')
  if [[ -z "$LATEST_VERSION_FULL" || "$LATEST_VERSION_FULL" == "null" ]]; then
    echo "❌ Failed to fetch latest version" >&2
    exit 1
  fi
  
  # Extract base version (vx.x.x) from full version (e.g., v1.2.2-patch-2 -> v1.2.2)
  LATEST_VERSION=$(echo "$LATEST_VERSION_FULL" | grep -oE 'v[0-9]+\.[0-9]+\.[0-9]+' || true)
  if [[ -z "$LATEST_VERSION" ]]; then
    echo "❌ Invalid version format: $LATEST_VERSION_FULL" >&2
    exit 1
  fi
  
  # Check if binary exists and compare versions
  local needs_install=true
  if command -v zigchaind >/dev/null 2>&1; then
    # Extract version number (with or without 'v' prefix)
    CURRENT_VERSION_RAW=$(zigchaind version 2>/dev/null | grep -oE '[0-9]+\.[0-9]+\.[0-9]+' | head -n 1 || true)
    if [[ -n "$CURRENT_VERSION_RAW" ]]; then
      # Add 'v' prefix for comparison
      CURRENT_VERSION="v${CURRENT_VERSION_RAW}"
      echo "📦 Current version: $CURRENT_VERSION"
      echo "📦 Latest version: $LATEST_VERSION"
      
      if [[ "$CURRENT_VERSION" == "$LATEST_VERSION" ]]; then
        echo "✅ zigchaind is already up to date"
        return
      else
        echo "🔄 Updating zigchaind from $CURRENT_VERSION to $LATEST_VERSION..."
      fi
    else
      echo "⚠️  Could not determine current version, proceeding with installation..."
    fi
  else
    echo "📦 Installing zigchaind binary for ${ARCH}..."
  fi
  
  # Download and install binary
  tmpdir=$(mktemp -d); pushd "$tmpdir" >/dev/null
  if [[ "$ARCH" == "arm64" || "$ARCH" == "aarch64" ]]; then
    TARBALL="zigchaind-${LATEST_VERSION}-darwin-arm64.tar.gz"
  else
    TARBALL="zigchaind-${LATEST_VERSION}-darwin-amd64.tar.gz"
  fi
  
  echo "📥 Downloading ${TARBALL}..."
  if ! curl -sSfL "${NETWORKS_MAIN_BRANCH}/zig-test-2/binaries/${TARBALL}" -o "${TARBALL}"; then
    echo "❌ Failed to download binary tarball" >&2
    popd >/dev/null; rm -rf "$tmpdir"
    exit 1
  fi
  
  if [[ ! -f "${TARBALL}" || ! -s "${TARBALL}" ]]; then
    echo "❌ Downloaded tarball is missing or empty" >&2
    popd >/dev/null; rm -rf "$tmpdir"
    exit 1
  fi
  
  echo "📥 Downloading checksum file..."
  local checksum_list="SHA256SUMS-${LATEST_VERSION}.txt"
  if ! curl -sSfL "${NETWORKS_MAIN_BRANCH}/zig-test-2/binaries/${checksum_list}" -o "${checksum_list}"; then
    echo "❌ Failed to download checksum file" >&2
    popd >/dev/null; rm -rf "$tmpdir"
    exit 1
  fi
  
  if [[ ! -f "${checksum_list}" || ! -s "${checksum_list}" ]]; then
    echo "❌ Downloaded checksum file is missing or empty" >&2
    popd >/dev/null; rm -rf "$tmpdir"
    exit 1
  fi
  
  echo "🔐 Verifying checksum..."
  local expected_hash
  expected_hash=$(grep "$TARBALL" "$checksum_list" | awk '{print $1}' | tr -d '\r')
  if [[ -z "$expected_hash" ]]; then
    echo "❌ Failed to read expected checksum from file" >&2
    popd >/dev/null; rm -rf "$tmpdir"
    exit 1
  fi
  
  local actual_hash
  if command -v shasum >/dev/null 2>&1; then
    actual_hash=$(shasum -a 256 "$TARBALL" | awk '{print $1}')
  elif command -v sha256sum >/dev/null 2>&1; then
    actual_hash=$(sha256sum "$TARBALL" | awk '{print $1}')
  else
    echo "❌ Neither shasum nor sha256sum is available for checksum verification." >&2
    popd >/dev/null; rm -rf "$tmpdir"
    exit 1
  fi
  
  expected_hash=${expected_hash,,}
  actual_hash=${actual_hash,,}
  if [[ "$expected_hash" != "$actual_hash" ]]; then
    echo "❌ Checksum mismatch. Expected ${expected_hash}, got ${actual_hash}." >&2
    popd >/dev/null; rm -rf "$tmpdir"
    exit 1
  fi
  echo "✅ Checksum verified"
  
  rm -f "$checksum_list"
  echo "📦 Extracting binary..."
  tar -zxf "$TARBALL"
  
  # folder name matches tarball minus .tar.gz
  EXTRACT_DIR=${TARBALL%.tar.gz}
  if [[ ! -f "$EXTRACT_DIR/zigchaind" ]]; then
    echo "❌ Binary not found in extracted archive" >&2
    popd >/dev/null; rm -rf "$tmpdir"
    exit 1
  fi
  
  mkdir -p "$HOME/.local/bin"
  mv "$EXTRACT_DIR/zigchaind" "$HOME/.local/bin/zigchaind"
  chmod +x "$HOME/.local/bin/zigchaind"
  popd >/dev/null; rm -rf "$tmpdir"
  export PATH="$HOME/.local/bin:$PATH"
  echo "✅ zigchaind installed successfully (version: $LATEST_VERSION)"
}

init_and_configure() {
  local network="$1"; shift
  local chain_id genesis_url snap_rpc seeds_url rpc_nodes_url chain_id_url
  
  if [[ "$network" == "mainnet" ]]; then
    chain_id_url="${NETWORKS_MAIN_BRANCH}/zigchain-1/chain-id.txt"
    genesis_url="${NETWORKS_HEAD_MAIN}/zigchain-1/genesis.json"
    rpc_nodes_url="${NETWORKS_MAIN_BRANCH}/zigchain-1/rpc-nodes.txt"
    seeds_url="${NETWORKS_MAIN_BRANCH}/zigchain-1/seed-nodes.txt"
  else
    chain_id_url="${NETWORKS_MAIN_BRANCH}/zig-test-2/chain-id.txt"
    genesis_url="${NETWORKS_HEAD_MAIN}/zig-test-2/genesis.json"
    rpc_nodes_url="${NETWORKS_MAIN_BRANCH}/zig-test-2/rpc-nodes.txt"
    seeds_url="${NETWORKS_MAIN_BRANCH}/zig-test-2/seed-nodes.txt"
  fi
  
  # Fetch chain-id from repository
  chain_id=$(curl -sSf "$chain_id_url" | tr -d '\r\n')
  if [[ -z "$chain_id" ]]; then
    echo "❌ Failed to fetch chain-id from repository" >&2
    exit 1
  fi
  
  # Fetch RPC URL from repository
  snap_rpc=$(curl -s "$rpc_nodes_url" | head -n 1 | tr -d '\r\n')
  if [[ -z "$snap_rpc" ]]; then
    echo "Failed to fetch RPC URL from repository" >&2
    exit 1
  fi

  # Home dir selection behavior from per-network scripts
  if [ -d "$HOME/.zigchain" ]; then
    echo "⚠️  Existing .zigchain found at $HOME/.zigchain"
    read -p "Do you want to delete it and start fresh? (y/N): " -n 1 -r; echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
      rm -rf "$HOME/.zigchain"; ZIGCHAIN_HOME="$HOME/.zigchain"
    else
      ZIGCHAIN_HOME="$HOME/.zigchain-${network}"
      if [ -d "$ZIGCHAIN_HOME" ]; then
        echo "⚠️  ${network} directory already exists at $ZIGCHAIN_HOME"
        read -p "Delete existing ${network} directory and start fresh? (y/N): " -n 1 -r; echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then rm -rf "$ZIGCHAIN_HOME"; else echo "❌ Setup cancelled."; exit 1; fi
      fi
    fi
  else
    ZIGCHAIN_HOME="$HOME/.zigchain"
  fi
  echo "📁 Setting up ${network} node in: $ZIGCHAIN_HOME"

  ensure_cli

  echo "🔧 Initializing ${network} node..."
  local NODE_NAME
  while true; do
    read -p "Enter node name (default: mynode): " NODE_NAME
    NODE_NAME=${NODE_NAME:-mynode}
    if [[ "$NODE_NAME" =~ ^[a-zA-Z0-9_-]+$ ]]; then
      break
    fi
    echo "❌ Invalid node name. Use only alphanumeric, dash, underscore."
    echo
  done
  zigchaind init "$NODE_NAME" --chain-id "$chain_id" --home "$ZIGCHAIN_HOME" --overwrite

  echo "📥 Downloading genesis file..."
  curl -sS -o "$ZIGCHAIN_HOME/config/genesis.json" "$genesis_url"
  echo "✅ Genesis file downloaded"

  echo "🔄 Configuring state sync..."
  echo "Using RPC endpoint: $snap_rpc"
  
  snap_rpc="${snap_rpc%/}"
  
  # Fetch latest block height with error handling
  RPC_RESPONSE=$(curl -sSf "$snap_rpc/block" 2>&1)
  if [[ $? -ne 0 ]]; then
    echo "❌ Failed to connect to RPC endpoint: $snap_rpc/block" >&2
    echo "Error: $RPC_RESPONSE" >&2
    exit 1
  fi
  
  if ! echo "$RPC_RESPONSE" | jq -e .result.block.header.height >/dev/null 2>&1; then
    echo "❌ Invalid JSON response from RPC endpoint" >&2
    echo "Response: $RPC_RESPONSE" >&2
    exit 1
  fi
  
  LATEST_HEIGHT=$(echo "$RPC_RESPONSE" | jq -r .result.block.header.height)
  if [[ -z "$LATEST_HEIGHT" || "$LATEST_HEIGHT" == "null" ]]; then
    echo "❌ Failed to fetch latest block height" >&2
    exit 1
  fi
  
  BLOCK_HEIGHT=$((LATEST_HEIGHT - 5000))
  
  # Fetch trust hash with error handling
  TRUST_RESPONSE=$(curl -sSf "$snap_rpc/block?height=$BLOCK_HEIGHT" 2>&1)
  if [[ $? -ne 0 ]]; then
    echo "❌ Failed to fetch block at height $BLOCK_HEIGHT" >&2
    echo "Error: $TRUST_RESPONSE" >&2
    exit 1
  fi
  
  if ! echo "$TRUST_RESPONSE" | jq -e .result.block_id.hash >/dev/null 2>&1; then
    echo "❌ Invalid JSON response when fetching trust hash" >&2
    echo "Response: $TRUST_RESPONSE" >&2
    exit 1
  fi
  
  TRUST_HASH=$(echo "$TRUST_RESPONSE" | jq -r .result.block_id.hash)
  if [[ -z "$TRUST_HASH" || "$TRUST_HASH" == "null" ]]; then
    echo "❌ Failed to fetch trust hash" >&2
    exit 1
  fi

  cfg="$ZIGCHAIN_HOME/config/config.toml"
  sed -i.bak -E \
    "s|^(enable[[:space:]]*=[[:space:]]*).*$|\\1true|; \
     s|^(rpc_servers[[:space:]]*=[[:space:]]*).*$|\\1\"$snap_rpc,$snap_rpc\"|; \
     s|^(trust_height[[:space:]]*=[[:space:]]*).*$|\\1$BLOCK_HEIGHT|; \
     s|^(trust_hash[[:space:]]*=[[:space:]]*).*$|\\1\"$TRUST_HASH\"|" \
    "$cfg"
  rm -f "${cfg}.bak"
  echo "✅ State sync configured"

  echo "🌐 Configuring peers..."
  SEED_FILE="$ZIGCHAIN_HOME/config/seed-nodes.txt"
  curl -sS -o "$SEED_FILE" "$seeds_url"; SEEDS=$(paste -sd, "$SEED_FILE")
  sed -i.bak -E "s|^(persistent_peers[[:space:]]*=[[:space:]]*).*|\\1\"$SEEDS\"|" "$cfg"
  rm -f "${cfg}.bak"
  echo "✅ Peers configured"

  echo "⛽ Setting minimum gas price..."
  appcfg="$ZIGCHAIN_HOME/config/app.toml"
  sed -i.bak 's/^minimum-gas-prices *=.*/minimum-gas-prices = "0.0025uzig"/' "$appcfg"
  rm -f "${appcfg}.bak"
  echo "✅ Minimum gas price set to 0.0025uzig"

  echo "\n🎉 Setup completed successfully!"
  if [[ "$ZIGCHAIN_HOME" == "$HOME/.zigchain" ]]; then
    echo "To start your ${network} node, run: zigchaind start"
  else
    echo "To start your ${network} node, run: zigchaind start --home $ZIGCHAIN_HOME"
  fi
  echo ""
  echo "✅ All steps completed successfully."
}

run_local() {
  ARCH_MSG=$([[ "$ARCH" == arm64 || "$ARCH" == aarch64 ]] && echo "ARM64" || echo "x86_64")
  echo "✅ Detected ${ARCH_MSG} architecture"
  ZIGCHAIN_HOME="$HOME/.zigchain"
  if [ -d "$HOME/.zigchain" ]; then
    echo "⚠️  Existing .zigchain directory found at $HOME/.zigchain"
    read -p "Do you want to delete it and start fresh? (y/N): " -n 1 -r; echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then rm -rf "$HOME/.zigchain"; else echo "❌ Setup cancelled."; exit 1; fi
  fi
  echo "📁 Setting up local node in: $ZIGCHAIN_HOME"
  ensure_cli
  
  # Check for jq and ask for permission to install
  if ! command -v jq >/dev/null 2>&1; then
    echo "⚠️  jq is required but not installed."
    read -p "Do you want to install it using Homebrew? (y/N): " -n 1 -r; echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
      echo "❌ Setup cancelled. Please install jq manually." >&2
      exit 1
    fi
    echo "📦 Installing jq..."
    brew install jq
  fi
  echo "🔧 Running local setup script..."
  cd /tmp/
  echo "📥 Downloading local setup script..."
  if ! curl -sSf -O "${DOCS_REPO_BASE}/scripts/zigchain_local_setup.sh"; then
    echo "❌ Failed to download local setup script. Please check your internet connection." >&2
    exit 1
  fi
  if [[ ! -f zigchain_local_setup.sh ]]; then
    echo "❌ Setup script was not downloaded successfully." >&2
    exit 1
  fi
  chmod +x zigchain_local_setup.sh
  export ZIGCHAIN_HOME="$ZIGCHAIN_HOME"
  ./zigchain_local_setup.sh
  appcfg="$ZIGCHAIN_HOME/config/app.toml"
  if [ -f "$appcfg" ]; then
    sed -i.bak 's/^minimum-gas-prices *=.*/minimum-gas-prices = "0.0025uzig"/' "$appcfg"
    rm -f "${appcfg}.bak"
  fi
  echo "🎉 Local setup completed successfully!"
  echo "To start your local node, run: zigchaind start"
  echo ""
  echo "✅ All steps completed successfully."
}

case "$USER_CHOICE" in
  1) init_and_configure mainnet ;;
  2) init_and_configure testnet ;;
  3) run_local ;;
  *) echo "Invalid choice" >&2; exit 1 ;;
esac


