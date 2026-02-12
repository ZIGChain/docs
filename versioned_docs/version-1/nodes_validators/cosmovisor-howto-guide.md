---
title: Cosmovisor How-To Guide
description: Complete guide to setting up and using Cosmovisor for automated binary management and upgrades on ZIGChain validator nodes, including installation, configuration, and best practices.
keywords:
  [
    ZIGChain Cosmovisor,
    ZIGChain validator upgrades,
    ZIGChain node management,
    ZIGChain chain upgrades,
    ZIGChain validator setup,
    ZIGChain node configuration,
    ZIGChain automated upgrades,
    run ZIGChain node,
  ]
sidebar_position: 8
---

import Tabs from '@theme/Tabs';
import TabItem from '@theme/TabItem';

# Cosmovisor How-To Guide

## Introduction

Cosmovisor is a process manager for Cosmos SDK application binaries like `zigchaind` that automates binary switches during chain upgrades. This guide provides practical tips for adding Cosmovisor to your ZIGChain node's upgrade process.

For detailed documentation, see the [official Cosmos SDK documentation](https://docs.cosmos.network/sdk/v0.53/build/tooling/cosmovisor).

## Prerequisites and Warnings

⚠️ **Important**: Test this procedure on non-production environments before deploying to production. We disclaim any responsibility for damage caused by applying this procedure on production servers.

---

## Cosmovisor Setup

### Why Not Use Go on Production Nodes?

While the Cosmovisor documentation suggests using `go install`, it's better practice to avoid installing Go on production validator and sentry nodes:

- **Reduced attack surface** – Fewer tools available if compromised
- **Cleaner environment** – Only essential components for running the node
- **Smaller footprint** – Less disk space and fewer dependencies

### Installation

Download and extract the Cosmovisor binary:

<Tabs groupId="os">
<TabItem value="linux" label="Linux" default>

```bash
COSMOVISOR_VERSION="v1.7.1"
curl -sL "https://github.com/cosmos/cosmos-sdk/releases/download/cosmovisor%2F${COSMOVISOR_VERSION}/cosmovisor-${COSMOVISOR_VERSION}-linux-amd64.tar.gz" -o /tmp/cosmovisor-${COSMOVISOR_VERSION}-linux-amd64.tar.gz
tar -xzf /tmp/cosmovisor-${COSMOVISOR_VERSION}-linux-amd64.tar.gz -C /tmp/
```

Move the binary to a system location:

```bash
sudo mv /tmp/cosmovisor /usr/local/bin/
sudo chmod +x /usr/local/bin/cosmovisor
```

**Note:** The `cosmovisor version` command requires environment variables to be set (see [Initialization](#initialization) section below). The verification commands below don't require environment variables and can be run immediately after installation.

Verify the installation:

```bash
which cosmovisor
/usr/local/bin/cosmovisor --help
```

</TabItem>
<TabItem value="macos-arm" label="macOS ARM">

```bash
COSMOVISOR_VERSION="v1.7.1"
curl -sL "https://github.com/cosmos/cosmos-sdk/releases/download/cosmovisor%2F${COSMOVISOR_VERSION}/cosmovisor-${COSMOVISOR_VERSION}-darwin-amd64.tar.gz" -o /tmp/cosmovisor-${COSMOVISOR_VERSION}-darwin-amd64.tar.gz
tar -xzf /tmp/cosmovisor-${COSMOVISOR_VERSION}-darwin-amd64.tar.gz -C /tmp/
```

Move the binary to a system location:

```bash
sudo mv /tmp/cosmovisor /usr/local/bin/
sudo chmod +x /usr/local/bin/cosmovisor
```

**Note:** The `cosmovisor version` command requires environment variables to be set (see [Initialization](#initialization) section below). The verification commands below don't require environment variables and can be run immediately after installation.

Verify the installation:

```bash
which cosmovisor
/usr/local/bin/cosmovisor --help
```

</TabItem>
<TabItem value="macos-amd" label="macOS AMD">

```bash
COSMOVISOR_VERSION="v1.7.1"
curl -sL "https://github.com/cosmos/cosmos-sdk/releases/download/cosmovisor%2F${COSMOVISOR_VERSION}/cosmovisor-${COSMOVISOR_VERSION}-darwin-amd64.tar.gz" -o /tmp/cosmovisor-${COSMOVISOR_VERSION}-darwin-amd64.tar.gz
tar -xzf /tmp/cosmovisor-${COSMOVISOR_VERSION}-darwin-amd64.tar.gz -C /tmp/
```

Move the binary to a system location:

```bash
sudo mv /tmp/cosmovisor /usr/local/bin/
sudo chmod +x /usr/local/bin/cosmovisor
```

**Note:** The `cosmovisor version` command requires environment variables to be set (see [Initialization](#initialization) section below). The verification commands below don't require environment variables and can be run immediately after installation.

Verify the installation:

```bash
which cosmovisor
/usr/local/bin/cosmovisor --help
```

</TabItem>
</Tabs>

### Initialization

<Tabs groupId="os">
<TabItem value="linux" label="Linux" default>

Set required environment variables:

```bash
cat << 'EOF' >> $HOME/.bashrc

export DAEMON_NAME=zigchaind
export DAEMON_HOME=$HOME/.zigchain
EOF
source $HOME/.bashrc
```

Locate the `zigchaind` binary and save the path to a variable:

```bash
DAEMON_BINARY=$(which zigchaind)
```

Initialize the Cosmovisor directory structure and create the configuration file:

```bash
cosmovisor init $DAEMON_BINARY
```

</TabItem>
<TabItem value="macos-arm" label="macOS ARM">

Set required environment variables:

```bash
cat << 'EOF' >> $HOME/.zshrc

export DAEMON_NAME=zigchaind
export DAEMON_HOME=$HOME/.zigchain
EOF
source $HOME/.zshrc
```

Locate the `zigchaind` binary and save the path to a variable:

```bash
DAEMON_BINARY=$(which zigchaind)
```

Initialize the Cosmovisor directory structure and create the configuration file:

```bash
cosmovisor init $DAEMON_BINARY
```

</TabItem>
<TabItem value="macos-amd" label="macOS AMD">

Set required environment variables:

```bash
cat << 'EOF' >> $HOME/.zshrc

export DAEMON_NAME=zigchaind
export DAEMON_HOME=$HOME/.zigchain
EOF
source $HOME/.zshrc
```

Locate the `zigchaind` binary and save the path to a variable:

```bash
DAEMON_BINARY=$(which zigchaind)
```

Initialize the Cosmovisor directory structure and create the configuration file:

```bash
cosmovisor init $DAEMON_BINARY
```

</TabItem>
</Tabs>

**What this creates:**

```
$HOME/.zigchain/cosmovisor/
├── config.toml          # Configuration file
├── current -> genesis   # Symlink to active version
└── genesis/
    └── bin/
        └── zigchaind
```

The `config.toml` file contains all Cosmovisor configuration parameters with their default values.

Verify the configuration:

```bash
cosmovisor config --cosmovisor-config $HOME/.zigchain/cosmovisor/config.toml
```

### Configuration File vs Environment Variables

Cosmovisor can be configured in two ways:

1. **Config file** (recommended): `--cosmovisor-config /path/to/config.toml`
2. **Environment variables**: Set in systemd service or shell

**Important**: Environment variables take precedence over config file values if both are present.

### Editing the Configuration File

The generated `config.toml` looks like this:

```toml
daemon_home = '/home/admin/.zigchain'
daemon_name = 'zigchaind'
daemon_allow_download_binaries = true
daemon_download_must_have_checksum = false
daemon_restart_after_upgrade = true
daemon_restart_delay = 0
daemon_shutdown_grace = 0
daemon_poll_interval = 300000000
unsafe_skip_backup = false
daemon_data_backup_dir = '/home/admin/.zigchain'
daemon_preupgrade_max_retries = 0
daemon_grpc_address = 'localhost:9090'
cosmovisor_disable_logs = false
cosmovisor_color_logs = true
cosmovisor_timeformat_logs = 'kitchen'
cosmovisor_custom_preupgrade = ''
cosmovisor_disable_recase = false
```

Edit values as needed:

```bash
nano $HOME/.zigchain/cosmovisor/config.toml
```

**Recommended changes:**

- `daemon_shutdown_grace = '30s'` – recommended for graceful shutdowns
- `unsafe_skip_backup` – adjust based on node type (see [Configuration Best Practices](#configuration-best-practices))
- `daemon_poll_interval = '1s'` - poll once per second

**Note**: Throughout this guide, we'll use the default backup directory. Cosmovisor will create backups in a directory called data-backup-yyyymmdd under `$DAEMON_HOME` unless you modify `daemon_data_backup_dir` in your config.

---

## Running Cosmovisor as a Service

<Tabs groupId="os">
<TabItem value="linux" label="Linux" default>

### Create a systemd service unit

Create a systemd service unit. Replace `<USERNAME>` with your Linux username:

```bash
ZUSER="<USERNAME>"
cat << EOF | sudo tee /tmp/zigchaind-cosmovisor.service
[Unit]
Description=Zigchain with Cosmovisor
After=network-online.target
Wants=network-online.target

[Service]
User=$ZUSER
ExecStart=/usr/local/bin/cosmovisor --cosmovisor-config /home/$ZUSER/.zigchain/cosmovisor/config.toml run start --home=/home/$ZUSER/.zigchain
WorkingDirectory=/home/$ZUSER/.zigchain/

Type=simple

[Install]
WantedBy=multi-user.target
EOF
```

**Key points:**

- Configuration is read from `config.toml` via `--cosmovisor-config` flag
- No environment variables needed in the service file when using config file

Validate the service file:

```bash
sudo systemd-analyze verify /tmp/zigchaind-cosmovisor.service
```

Install and enable the service:

```bash
sudo mv /tmp/zigchaind-cosmovisor.service /etc/systemd/system/zigchaind-cosmovisor.service
sudo systemctl daemon-reload
sudo systemctl enable zigchaind-cosmovisor.service
```

### Starting the Service

If `zigchaind` is currently running as a systemd service, stop and disable it:

```bash
sudo systemctl stop zigchaind.service
sudo systemctl disable zigchaind.service
```

Start the new Cosmovisor service:

```bash
sudo systemctl start zigchaind-cosmovisor.service
```

Check the status:

```bash
sudo systemctl status zigchaind-cosmovisor.service
```

Check logs in real-time:

```bash
sudo journalctl -u zigchaind-cosmovisor.service -f -o cat
```

</TabItem>
<TabItem value="macos-arm" label="macOS ARM">

### Create a LaunchDaemon plist file

Create a Launch Daemon configuration file for Cosmovisor. Replace `<USERNAME>` with your macOS username:

```bash
ZUSER="<USERNAME>"
sudo bash -c "cat > /Library/LaunchDaemons/com.zigchain.cosmovisor.plist" << EOM
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>Label</key>
    <string>com.zigchain.cosmovisor</string>
    <key>ProgramArguments</key>
    <array>
        <string>/usr/local/bin/cosmovisor</string>
        <string>--cosmovisor-config</string>
        <string>/Users/$ZUSER/.zigchain/cosmovisor/config.toml</string>
        <string>run</string>
        <string>start</string>
        <string>--home=/Users/$ZUSER/.zigchain</string>
    </array>
    <key>WorkingDirectory</key>
    <string>/Users/$ZUSER/.zigchain/</string>
    <key>StandardOutPath</key>
    <string>/usr/local/var/log/zigchaind/main.log</string>
    <key>StandardErrorPath</key>
    <string>/usr/local/var/log/zigchaind/error.log</string>
    <key>KeepAlive</key>
    <true/>
    <key>RunAtLoad</key>
    <true/>
    <key>UserName</key>
    <string>$ZUSER</string>
</dict>
</plist>
EOM
```

Create log directories:

```bash
sudo mkdir -p /usr/local/var/log/zigchaind
sudo touch /usr/local/var/log/zigchaind/main.log
sudo touch /usr/local/var/log/zigchaind/error.log
sudo chown -R ${ZUSER}:staff /usr/local/var/log/zigchaind
```

### Starting the Service

If `zigchaind` is currently running as a LaunchDaemon, stop and unload it:

```bash
sudo launchctl stop com.zigchain.zigchaind
sudo launchctl unload /Library/LaunchDaemons/com.zigchain.zigchaind.plist
```

Load and start the Cosmovisor service:

```bash
sudo launchctl load /Library/LaunchDaemons/com.zigchain.cosmovisor.plist
sudo launchctl start com.zigchain.cosmovisor
```

Check the status:

```bash
sudo launchctl list | grep zigchain
```

View the logs:

```bash
tail -f /usr/local/var/log/zigchaind/main.log
```

</TabItem>
<TabItem value="macos-amd" label="macOS AMD">

### Create a LaunchDaemon plist file

Create a Launch Daemon configuration file for Cosmovisor. Replace `<USERNAME>` with your macOS username:

```bash
ZUSER="<USERNAME>"
sudo bash -c "cat > /Library/LaunchDaemons/com.zigchain.cosmovisor.plist" << EOM
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>Label</key>
    <string>com.zigchain.cosmovisor</string>
    <key>ProgramArguments</key>
    <array>
        <string>/usr/local/bin/cosmovisor</string>
        <string>--cosmovisor-config</string>
        <string>/Users/$ZUSER/.zigchain/cosmovisor/config.toml</string>
        <string>run</string>
        <string>start</string>
        <string>--home=/Users/$ZUSER/.zigchain</string>
    </array>
    <key>WorkingDirectory</key>
    <string>/Users/$ZUSER/.zigchain/</string>
    <key>StandardOutPath</key>
    <string>/usr/local/var/log/zigchaind/main.log</string>
    <key>StandardErrorPath</key>
    <string>/usr/local/var/log/zigchaind/error.log</string>
    <key>KeepAlive</key>
    <true/>
    <key>RunAtLoad</key>
    <true/>
    <key>UserName</key>
    <string>$ZUSER</string>
</dict>
</plist>
EOM
```

Create log directories:

```bash
sudo mkdir -p /usr/local/var/log/zigchaind
sudo touch /usr/local/var/log/zigchaind/main.log
sudo touch /usr/local/var/log/zigchaind/error.log
sudo chown -R ${ZUSER}:staff /usr/local/var/log/zigchaind
```

### Starting the Service

If `zigchaind` is currently running as a LaunchDaemon, stop and unload it:

```bash
sudo launchctl stop com.zigchain.zigchaind
sudo launchctl unload /Library/LaunchDaemons/com.zigchain.zigchaind.plist
```

Load and start the Cosmovisor service:

```bash
sudo launchctl load /Library/LaunchDaemons/com.zigchain.cosmovisor.plist
sudo launchctl start com.zigchain.cosmovisor
```

Check the status:

```bash
sudo launchctl list | grep zigchain
```

View the logs:

```bash
tail -f /usr/local/var/log/zigchaind/main.log
```

</TabItem>
</Tabs>

Your node is now running with Cosmovisor:

- ✅ No Go installation required on the server
- ✅ Cosmovisor wrapping `zigchaind`
- ✅ Running as a service (systemd on Linux, LaunchDaemon on macOS)
- ✅ Configured via `config.toml` file
- ✅ Ready for automated upgrades

---

## Upgrade Execution Procedures

Cosmovisor automates chain upgrades by detecting approved governance proposals and switching binaries at the specified upgrade height. While other upgrade scenarios are supported (such as manual upgrades without governance), this guide covers the two most common production approaches: **prepare-upgrade** and **auto-download**.

### Prepare-Upgrade (Recommended for Validators)

The `prepare-upgrade` command provides the best balance between automation and control. While manual binary placement is possible, using `prepare-upgrade` reduces human error while still allowing validation before the upgrade height. Detailed information can be found [here](https://docs.cosmos.network/sdk/v0.53/build/tooling/cosmovisor#preparing-for-an-upgrade).

**Process:**

1. Governance proposal passes with upgrade details (name, height, binary info)
2. Administrator runs `cosmovisor prepare-upgrade` after voting passes
3. Cosmovisor downloads and validates the binary
4. Administrator verifies the preparation was successful
5. At upgrade height, Cosmovisor automatically switches to the new binary

**Prerequisites:**

- gRPC must be enabled in your `zigchaind` configuration
- The gRPC endpoint is configured in `$HOME/.zigchain/config/app.toml`:

```toml
[grpc]
enable = true
address = "localhost:9090"
```

This gRPC server provides upgrade plan information that `prepare-upgrade` uses to download and validate the new binary.

**Checking the Upgrade Plan:**

Before running `prepare-upgrade`, verify the upgrade plan details:

<Tabs>
<TabItem value="Mainnet" label="Mainnet" default>

```bash
zigchaind query upgrade plan --node https://public-zigchain-rpc.numia.xyz
```

</TabItem>
<TabItem value="Testnet" label="Testnet">

```bash
zigchaind query upgrade plan --node https://public-zigchain-testnet-rpc.numia.xyz
```

</TabItem>
<TabItem value="Local" label="Local">

```bash
zigchaind query upgrade plan --node http://localhost:26657
```

</TabItem>
</Tabs>

**Running Prepare-Upgrade:**

For validators, we recommend requiring checksum validation. Create a specific config for `prepare-upgrade`:

<Tabs groupId="os">
<TabItem value="linux" label="Linux" default>

```bash
cp $HOME/.zigchain/cosmovisor/config.toml $HOME/.zigchain/cosmovisor/prepare-upgrade-config.toml

sed -i 's/daemon_download_must_have_checksum = false/daemon_download_must_have_checksum = true/' $HOME/.zigchain/cosmovisor/prepare-upgrade-config.toml

cosmovisor prepare-upgrade --cosmovisor-config $HOME/.zigchain/cosmovisor/prepare-upgrade-config.toml
```

</TabItem>
<TabItem value="macos-arm" label="macOS ARM">

```bash
cp $HOME/.zigchain/cosmovisor/config.toml $HOME/.zigchain/cosmovisor/prepare-upgrade-config.toml

sed -i '' 's/daemon_download_must_have_checksum = false/daemon_download_must_have_checksum = true/' $HOME/.zigchain/cosmovisor/prepare-upgrade-config.toml

cosmovisor prepare-upgrade --cosmovisor-config $HOME/.zigchain/cosmovisor/prepare-upgrade-config.toml
```

</TabItem>
<TabItem value="macos-amd" label="macOS AMD">

```bash
cp $HOME/.zigchain/cosmovisor/config.toml $HOME/.zigchain/cosmovisor/prepare-upgrade-config.toml

sed -i '' 's/daemon_download_must_have_checksum = false/daemon_download_must_have_checksum = true/' $HOME/.zigchain/cosmovisor/prepare-upgrade-config.toml

cosmovisor prepare-upgrade --cosmovisor-config $HOME/.zigchain/cosmovisor/prepare-upgrade-config.toml
```

</TabItem>
</Tabs>

**What this does:**

- Queries the gRPC endpoint for the upgrade plan
- Downloads the new binary from the URL specified in the governance proposal
- Verifies the checksum matches the one in the proposal
- Copies the binary to `$DAEMON_HOME/cosmovisor/upgrades/<UPGRADE_NAME>/bin/`
- Prepares Cosmovisor to switch at the upgrade height

**Verification:**

After running `prepare-upgrade`, verify it worked correctly:

```bash
ls -la $HOME/.zigchain/cosmovisor/upgrades/

$HOME/.zigchain/cosmovisor/upgrades/<UPGRADE_NAME>/bin/zigchaind version
```

**Advantages:**

- Automated download and checksum verification
- Reduces manual errors in binary placement
- Still allows validation before upgrade height
- Recommended for validators due to good balance of security and convenience

### Auto-Download (Optional for Full Nodes)

Auto-download allows Cosmovisor to automatically run `prepare-upgrade` at the upgrade height.

**⚠️ Important**: Cosmos SDK does **not recommend** this for validators because:

- No advance verification that the binary is available
- If download fails, Cosmovisor stops and won't restart (potential chain halt)
- Less control over the upgrade process

**To enable auto-download**, edit your `config.toml`:

<Tabs groupId="os">
<TabItem value="linux" label="Linux" default>

```bash
sed -i 's/daemon_allow_download_binaries = false/daemon_allow_download_binaries = true/' $HOME/.zigchain/cosmovisor/config.toml
```

</TabItem>
<TabItem value="macos-arm" label="macOS ARM">

```bash
sed -i '' 's/daemon_allow_download_binaries = false/daemon_allow_download_binaries = true/' $HOME/.zigchain/cosmovisor/config.toml
```

</TabItem>
<TabItem value="macos-amd" label="macOS AMD">

```bash
sed -i '' 's/daemon_allow_download_binaries = false/daemon_allow_download_binaries = true/' $HOME/.zigchain/cosmovisor/config.toml
```

</TabItem>
</Tabs>

Then restart the service:

<Tabs groupId="os">
<TabItem value="linux" label="Linux" default>

```bash
sudo systemctl restart zigchaind-cosmovisor.service
```

</TabItem>
<TabItem value="macos-arm" label="macOS ARM">

```bash
sudo launchctl stop com.zigchain.cosmovisor
sudo launchctl start com.zigchain.cosmovisor
```

</TabItem>
<TabItem value="macos-amd" label="macOS AMD">

```bash
sudo launchctl stop com.zigchain.cosmovisor
sudo launchctl start com.zigchain.cosmovisor
```

</TabItem>
</Tabs>

---

## Configuration Best Practices

**Note**: The Cosmos SDK team recommends:

- **Auto-download** (`daemon_allow_download_binaries`): Use only on full nodes, not validators. This feature is disabled by default for security reasons—if the binary download fails or is compromised, your validator could halt.
- **Backups** (`unsafe_skip_backup`): Keep enabled (set to `false`). Backups allow quick rollback if an upgrade fails, which is critical for validator uptime.

### Key Configuration Parameters

| Parameter                            | Default | Description                         |
| ------------------------------------ | ------- | ----------------------------------- |
| `daemon_restart_after_upgrade`       | `true`  | Automatically restart after upgrade |
| `unsafe_skip_backup`                 | `false` | Skip data backup before upgrade     |
| `daemon_allow_download_binaries`     | `false` | Enable auto-download of binaries    |
| `daemon_shutdown_grace`              | `0s`    | Grace period for clean shutdown     |
| `daemon_download_must_have_checksum` | `false` | Require checksums for downloads     |
| `daemon_poll_interval`               | `300ms` | How often to check for upgrades     |

### Configuration for Validators

**Recommended `config.toml` settings:**

```toml
daemon_allow_download_binaries = false
daemon_download_must_have_checksum = false
daemon_shutdown_grace = '30s'
unsafe_skip_backup = false
```

**Upgrade procedure:**

- Use `prepare-upgrade` with a separate config that has `daemon_download_must_have_checksum = true`
- Verify binaries after preparation
- Test on testnet first
- Data backups enabled (important for rollback capability)

**Considerations:**

- Validators typically use pruning, so backups are smaller and faster
- **Critical consideration**: The backup creates a complete copy of your data directory. Backup time increases with data size, and your validator will be unable to sign blocks throughout this process. Test backup duration on testnet to estimate mainnet timing
- Ensure adequate disk space for backups
- Using `prepare-upgrade` reduces human error while maintaining control

### Configuration for Full Nodes

**`config.toml` settings:**

```toml
daemon_allow_download_binaries = true
daemon_download_must_have_checksum = true
unsafe_skip_backup = false
```

- Auto-download enabled
- Backups enabled as recommended, but administrators should assess the impact on upgrade timing and storage capacity
- **Only consider disabling backups if:**
  - Archive data is replicated elsewhere
  - Disk space is insufficient for backups
  - Downtime risk is acceptable

**Important**: Archive nodes can have hundreds of GB of data. Evaluate:

- Backup time impact on upgrade timing
- Available disk space for backups
- Replication/snapshot strategies

### Updating Configuration

When you change the `config.toml` file, restart the service to apply changes:

<Tabs groupId="os">
<TabItem value="linux" label="Linux" default>

```bash
sudo systemctl restart zigchaind-cosmovisor.service
```

</TabItem>
<TabItem value="macos-arm" label="macOS ARM">

```bash
sudo launchctl stop com.zigchain.cosmovisor
sudo launchctl start com.zigchain.cosmovisor
```

</TabItem>
<TabItem value="macos-amd" label="macOS AMD">

```bash
sudo launchctl stop com.zigchain.cosmovisor
sudo launchctl start com.zigchain.cosmovisor
```

</TabItem>
</Tabs>

To verify current configuration:

```bash
cosmovisor config --cosmovisor-config $HOME/.zigchain/cosmovisor/config.toml
```

---

## Troubleshooting

### Verify Cosmovisor Configuration

Check your current configuration:

```bash
cosmovisor config --cosmovisor-config $HOME/.zigchain/cosmovisor/config.toml
```

### Check Cosmovisor Directory Structure

```bash
tree $HOME/.zigchain/cosmovisor
```

Expected structure:

```
cosmovisor/
├── config.toml
├── current -> genesis (or upgrades/<n> after upgrade)
├── genesis/
│   └── bin/
│       └── zigchaind
└── upgrades/
    └── <upgrade-name>/
        └── bin/
            └── zigchaind
```

### Common Issues

**Problem:** `prepare-upgrade` fails with connection error

- **Solution:** Verify gRPC is enabled and accessible:

  ```bash
  grpcurl -plaintext localhost:9090 list

  grep -A 3 "\[grpc\]" $HOME/.zigchain/config/app.toml
  ```

- Ensure `enable = true` and `address = "localhost:9090"` in app.toml

**Problem:** Configuration changes not taking effect

- **Solution:** Restart the service after editing `config.toml`:

  <Tabs groupId="os">
  <TabItem value="linux" label="Linux" default>

  ```bash
  sudo systemctl restart zigchaind-cosmovisor.service
  ```

  </TabItem>
  <TabItem value="macos-arm" label="macOS ARM">

  ```bash
  sudo launchctl stop com.zigchain.cosmovisor
  sudo launchctl start com.zigchain.cosmovisor
  ```

  </TabItem>
  <TabItem value="macos-amd" label="macOS AMD">

  ```bash
  sudo launchctl stop com.zigchain.cosmovisor
  sudo launchctl start com.zigchain.cosmovisor
  ```

  </TabItem>
  </Tabs>

**Problem:** Cosmovisor doesn't switch binaries at upgrade height

- **Solution:** Verify the upgrade was prepared correctly:

  ```bash
  ls -la $HOME/.zigchain/cosmovisor/upgrades/
  ```

- Check the upgrade name matches exactly (case-sensitive)
- Run the binary manually to verify it works:

  ```bash
  $HOME/.zigchain/cosmovisor/upgrades/<UPGRADE_NAME>/bin/zigchaind version
  ```

**Problem:** Service fails to start

- **Solution:** Check logs:

  <Tabs groupId="os">
  <TabItem value="linux" label="Linux" default>

  ```bash
  sudo journalctl -u zigchaind-cosmovisor.service -f -o cat
  tail -f /var/log/zigchaind/error.log
  ```

  </TabItem>
  <TabItem value="macos-arm" label="macOS ARM">

  ```bash
  tail -f /usr/local/var/log/zigchaind/main.log
  tail -f /usr/local/var/log/zigchaind/error.log
  ```

  </TabItem>
  <TabItem value="macos-amd" label="macOS AMD">

  ```bash
  tail -f /usr/local/var/log/zigchaind/main.log
  tail -f /usr/local/var/log/zigchaind/error.log
  ```

  </TabItem>
  </Tabs>

- Verify the `--cosmovisor-config` path is correct in the service file (systemd) or plist file (LaunchDaemon)

**Problem:** Config file not found

- **Solution:** Ensure `cosmovisor init` was run successfully:

  ```bash
  ls -la $HOME/.zigchain/cosmovisor/config.toml
  ```

- If missing, run init again

**Problem:** Node doesn't restart after upgrade

- **Solution:** Check `daemon_restart_after_upgrade = true` in `config.toml`

**Problem:** `prepare-upgrade` fails with checksum error

- **Solution:** This is actually a security feature working correctly
- The binary's checksum doesn't match what's in the governance proposal
- Do NOT bypass this - investigate why the checksum differs
- Verify you're using the correct upgrade proposal and binary source

### Monitoring Upgrades

Watch logs during an upgrade:

<Tabs groupId="os">
<TabItem value="linux" label="Linux" default>

```bash
sudo journalctl -u zigchaind-cosmovisor.service -f -o cat

tail -f /var/log/zigchaind/main.log
```

</TabItem>
<TabItem value="macos-arm" label="macOS ARM">

```bash
tail -f /usr/local/var/log/zigchaind/main.log
tail -f /usr/local/var/log/zigchaind/error.log
```

</TabItem>
<TabItem value="macos-amd" label="macOS AMD">

```bash
tail -f /usr/local/var/log/zigchaind/main.log
tail -f /usr/local/var/log/zigchaind/error.log
```

</TabItem>
</Tabs>

Look for messages like:

```bash
upgrade "<upgrade-name>" needed at height: <height>
```

### Manual Recovery

If an upgrade fails, you can manually intervene:

<Tabs groupId="os">
<TabItem value="linux" label="Linux" default>

```bash
sudo systemctl stop zigchaind-cosmovisor.service

ls -la $HOME/.zigchain/cosmovisor/current

cd $HOME/.zigchain/cosmovisor
ln -sfn genesis current

sudo systemctl start zigchaind-cosmovisor.service
```

</TabItem>
<TabItem value="macos-arm" label="macOS ARM">

```bash
sudo launchctl stop com.zigchain.cosmovisor

ls -la $HOME/.zigchain/cosmovisor/current

cd $HOME/.zigchain/cosmovisor
ln -sfn genesis current

sudo launchctl start com.zigchain.cosmovisor
```

</TabItem>
<TabItem value="macos-amd" label="macOS AMD">

```bash
sudo launchctl stop com.zigchain.cosmovisor

ls -la $HOME/.zigchain/cosmovisor/current

cd $HOME/.zigchain/cosmovisor
ln -sfn genesis current

sudo launchctl start com.zigchain.cosmovisor
```

</TabItem>
</Tabs>

---

## Additional Resources

- [Cosmovisor Official Documentation](https://docs.cosmos.network/sdk/v0.53/build/tooling/cosmovisor)
- [Cosmos SDK Upgrade Guide](https://docs.cosmos.network/sdk/v0.53/build/migrations/upgrade-guide)

---
