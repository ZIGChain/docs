---
title: TMKMS Setup Guide
description: Comprehensive guide to installing, configuring, and troubleshooting TMKMS (Tendermint Key Management System) for secure validator key management on ZIGChain with remote signing.
keywords:
  [
    TMKMS,
    Tendermint Key Management System,
    validator keys,
    remote signing,
    key security,
    hardware security module,
    HSM,
    validator security,
  ]
sidebar_position: 8
---

# TMKMS Setup Guide

This comprehensive guide covers the installation, configuration, and troubleshooting of [Tendermint Key Management System (TMKMS)](https://github.com/iqlusioninc/tmkms) for securely managing the private validator key of a ZIGChain validator.

## Prerequisites and Warnings

⚠️ **Important**: Test this procedure on non-production environments before deploying to production. We disclaim any responsibility for damage caused by applying this procedure on production servers.

## Installation

This section covers installing TMKMS on a server. Adapt these steps to your deployment environment, whether you're using cloud infrastructure, on-premises servers, or containerized deployments.

### System Requirements

Set up a server with the following characteristics:

- A Linux distribution (Debian 12 or similar is recommended)
- Sufficient storage for logs and configuration files
- Network connectivity to your validator node
- Appropriate security measures for your environment (firewalls, access controls, etc.)

The TMKMS server should be isolated from the validator node and configured according to your security requirements.

### Install Rust, GCC, and Dependencies

Install the Rust toolchain (compiler + Cargo):

```
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
source $HOME/.cargo/env
```

Verify that `gcc` is installed:

```
gcc --version
```

Expected output example:

```
gcc (Debian 12.2.0-14) 12.2.0
Copyright (C) 2022 Free Software Foundation, Inc.
```

Install required packages using your system's package manager. For Debian/Ubuntu (this will install `gcc` via `build-essential` if not already present):

```
sudo apt update
sudo apt install git build-essential curl jq --yes
```

Install `libusb` (required for hardware key support, if needed):

```
sudo apt install libusb-1.0-0-dev
```

Set the `RUSTFLAGS` environment variable for x86_64 optimizations, as suggested in the [Tendermint KMS installation instructions](https://github.com/iqlusioninc/tmkms?tab=readme-ov-file#installation):

```
export RUSTFLAGS=-Ctarget-feature=+aes,+ssse3
```

### Install TMKMS

Use Cargo to build and install TMKMS with the `softsign` feature. While `softsign` means the validator key is stored unencrypted, it still provides isolation from the validator node and may improve security in some deployment models.

```
cd $HOME
git clone https://github.com/iqlusioninc/tmkms.git
cd tmkms/
cargo install tmkms --features=softsign
tmkms init config
tmkms softsign keygen ./config/secrets/secret_connection_key
```

### Configure Logging, Log Rotation, and systemd Service

Create a dedicated directory for TMKMS logs. Replace `USERNAME` with the user account that will run TMKMS:

```
USER=USERNAME
sudo mkdir -p /var/log/tmkms
sudo touch /var/log/tmkms/main_tmkms.log
sudo touch /var/log/tmkms/err_tmkms.log
sudo chown -R $USER:$USER /var/log/tmkms
```

Create a systemd service for TMKMS. Adjust paths and usernames to match your environment:

```
sudo vi /etc/systemd/system/tmkms.service
```

Example systemd service configuration (replace `USERNAME` and paths as needed):

```
[Unit]
Description=TMKMS Custom Service
After=network-online.target

[Service]
ExecStart=/home/USERNAME/.cargo/bin/tmkms start -c /home/USERNAME/tmkms/config/tmkms.toml
StandardOutput=append:/var/log/tmkms/main_tmkms.log
StandardError=append:/var/log/tmkms/err_tmkms.log
Restart=always
User=USERNAME

[Install]
WantedBy=multi-user.target
```

Install and configure log rotation. On Debian/Ubuntu:

```
sudo apt update
sudo apt install logrotate
```

Create a log rotation configuration:

```
sudo vi /etc/logrotate.d/tmkms
```

Example log rotation configuration:

```
/var/log/tmkms/*_tmkms.log {
  daily
  rotate 7
  compress
  missingok
  notifempty
  copytruncate
}
```

## Set Up TMKMS for a Validator

### Import the Validator Key into TMKMS

Copy the validator key from the validator node to the TMKMS server. Ensure that secure access is configured between the two systems and that firewall rules allow the necessary traffic. Adjust the following command to match your environment:

```
scp USER@VALIDATOR_IP:~/.zigchain/config/priv_validator_key.json ~/tmkms/config/secrets/
```

Example:

```
scp zigadmin@10.10.21.10:~/.zigchain/config/priv_validator_key.json ~/tmkms/config/secrets/
```

Then, import the key into TMKMS and delete the original key file:

```
tmkms softsign import ~/tmkms/config/secrets/priv_validator_key.json ~/tmkms/config/secrets/priv_validator_key
rm ~/tmkms/config/secrets/priv_validator_key.json
```

The resulting file `$HOME/tmkms/config/secrets/priv_validator_key` is the one that TMKMS will use for signing.

### Configure and Start TMKMS

Before configuring TMKMS, gather the following information:

- User account running zigchaind on the validator
- Validator IP address or hostname
- Validator port for priv_validator (default: `26659`)
- `chain_id`: Found by running `grep chain_id ~/.zigchain/config/genesis.json` on the validator
- `account_key_prefix`: Defined in the chain's code (e.g., `zigpub`)
- `consensus_key_prefix`: Defined in the chain's code (e.g., `zigvalconspub`)

Edit the TMKMS config file:

```
vi ~/tmkms/config/tmkms.toml
```

Replace the default values with your setup. Example configuration (adjust paths, chain_id, and addresses to match your environment):

```
# Tendermint KMS configuration file

## Chain Configuration

[[chain]]
id = "your-chain-id"
key_format = { type = "bech32", account_key_prefix = "zigpub", consensus_key_prefix = "zigvalconspub" }
state_file = "/home/USERNAME/tmkms/config/state/priv_validator_state.json"

## Signing Provider Configuration

[[providers.softsign]]
chain_ids = ["your-chain-id"]
key_type = "consensus"
path = "/home/USERNAME/tmkms/config/secrets/priv_validator_key"

## Validator Configuration

[[validator]]
chain_id = "your-chain-id"
addr = "tcp://VALIDATOR_IP:26659"
secret_key = "/home/USERNAME/tmkms/config/secrets/secret_connection_key"
protocol_version = "v0.34"
reconnect = true
```

Start the TMKMS service:

```
sudo systemctl daemon-reload
sudo systemctl start tmkms.service
systemctl status tmkms.service
tail -f /var/log/tmkms/main_tmkms.log
```

Leave the `tail -f` running to monitor the validator connection.

### Reconfigure and Restart the Validator

On the validator node, edit the `config.toml` file to:

- Enable priv_validator to listening on port 26659.
- Comment out the `priv_validator_key_file` line.
- Comment out the `priv_validator_state_file` line.

```
vi ~/.zigchain/config/config.toml
```

The corresponding section should look like this:

```
# Path to the JSON file containing the private key to use as a validator in the consensus protocol
#priv_validator_key_file = "config/priv_validator_key.json"

# Path to the JSON file containing the last sign state of a validator
#priv_validator_state_file = "data/priv_validator_state.json"

# TCP or UNIX socket address for CometBFT to listen on for
# connections from an external PrivValidator process
priv_validator_laddr = "tcp://0.0.0.0:26659"
```

⚠️ **Warning**: Restarting zigchaind with these changes will modify validator behavior. Ensure you have tested this procedure in a non-production environment first.

Restart zigchaind and check the logs:

```
sudo systemctl restart zigchaind.service
tail -f /var/log/zigchaind/main.log
```

### Verify Operation

If everything is working correctly, the TMKMS logs should show output indicating successful connection and signing operations:

```
INFO tmkms::connection::tcp: KMS node ID: xxxxxxxxxxxxxxxxxxxxxxxxxxx
INFO tmkms::session: [chain-id@tcp://validator-ip:26659] connected to validator successfully
INFO tmkms::session: [chain-id@tcp://validator-ip:26659] signed Prevote:... at h/r/s .../0/1 (0 ms)
INFO tmkms::session: [chain-id@tcp://validator-ip:26659] signed Precommit:... at h/r/s .../0/2 (0 ms)
INFO tmkms::session: [chain-id@tcp://validator-ip:26659] signed Proposal:... at h/r/s .../0/0 (0 ms)
```

Note: Initial connection refused errors are normal as TMKMS may start before the validator is ready.

Once the operation has been successfully confirmed, the validator key can be removed from the validator server for security. Do this only if the key is kept in an alternate safe place apart from the TMKMS node. To achieve secure wiping, use `shred -u`:

```
shred -u ~/.zigchain/config/priv_validator_key.json
```

### Enable the Service and Test a Reboot

Enable the service to run at boot:

```
sudo systemctl enable tmkms.service
systemctl status tmkms.service
```

Reboot the server to verify the service starts automatically:

```
sudo shutdown -r now
```

After boot, check the service status and the logs:

```
systemctl status tmkms.service
tail -f /var/log/tmkms/main_tmkms.log
```

## Configuration Best Practices

### Security Considerations

1. **Key Isolation**: The primary security benefit of TMKMS is isolating the validator key from the validator node. Even with `softsign` (unencrypted storage), this separation provides protection against validator node compromises.

2. **Network Security**: Ensure that:

   - Secure access is properly configured between validator and TMKMS servers
   - Firewall rules and network security policies allow communication on port 26659
   - TMKMS servers are not unnecessarily exposed to public networks
   - Network traffic between validator and TMKMS is restricted to necessary ports only

3. **Key Management**:

   - Always keep a secure backup of the validator key in a location separate from both the validator and TMKMS nodes
   - Use secure deletion (`shred -u`) when removing keys from the validator node
   - Only delete the key from the validator node after confirming TMKMS is operating correctly

4. **Infrastructure Security**: Apply appropriate security measures for your deployment environment, such as disk encryption, access controls, and network segmentation.

### Service Configuration

1. **Logging**: The configured log rotation ensures logs are:

   - Rotated daily
   - Kept for 7 days
   - Compressed to save space
   - Truncated rather than moved (using `copytruncate`) to avoid service interruption

2. **Service Reliability**: The systemd service is configured with:

   - `Restart=always` to automatically restart on failure
   - Proper dependency on `network-online.target`
   - Separate log files for standard output and errors

3. **Resource Optimization**: The `RUSTFLAGS` environment variable enables hardware-accelerated cryptographic operations (`+aes,+ssse3`) for better performance.

### Configuration File Best Practices

1. **Path Consistency**: Ensure all file paths in `tmkms.toml` use absolute paths and match the actual user's home directory.

2. **Chain Configuration**:

   - Verify `chain_id` matches exactly (case-sensitive)
   - Confirm `account_key_prefix` and `consensus_key_prefix` match the chain's configuration
   - Use the correct `protocol_version` (typically `v0.34` for CometBFT)

3. **Validator Connection**:

   - Use the correct validator IP address and port (default 26659)
   - Enable `reconnect = true` for automatic reconnection on network issues
   - Verify the `secret_connection_key` path is correct

4. **State File Management**: The `state_file` path should point to a location where TMKMS can maintain validator state. This is critical for preventing double-signing.

## Troubleshooting

### Connection Issues

If the communication fails, check that:

1. **Firewall Rules**: Ensure firewall rules and network security policies are configured correctly. The validator must allow inbound connections on port 26659 from the TMKMS server.

2. **Network Connectivity**: Verify network connectivity between the TMKMS server and the validator. Replace `VALIDATOR_IP` with your validator's address:

   ```
   telnet VALIDATOR_IP 26659
   ```

   or use `nc`:

   ```
   nc -zv VALIDATOR_IP 26659
   ```

3. **Service Status**: Check that both services are running:

   ```
   systemctl status tmkms.service
   systemctl status zigchaind.service
   ```

4. **Configuration Verification**: Verify the validator's `config.toml` has:
   - `priv_validator_laddr = "tcp://0.0.0.0:26659"` uncommented
   - `priv_validator_key_file` commented out
   - `priv_validator_state_file` commented out

### Log Analysis

Monitor the TMKMS logs for common issues:

1. **Connection Refused**: Initial connection refused errors are normal as TMKMS may start before the validator is ready. Persistent errors indicate network or configuration issues.

2. **Unverified Validator Peer ID Warning**: The warning `unverified validator peer ID!` is informational and does not prevent operation. For production, consider implementing peer ID verification.

3. **Signing Errors**: If signing operations fail, check:
   - The validator key file exists and has correct permissions
   - The key format matches the chain configuration
   - The chain_id in the config matches the actual chain

### Handling Chain Migrations

If zigchaind goes through an init on the validator (for instance, when testnet moved from `zig-test-1` to `zig-test-2`), follow these steps:

1. Stop the TMKMS service:

   ```
   sudo systemctl stop tmkms.service
   ```

2. Save the config file:

   ```
   mv ~/tmkms/config/tmkms.toml /tmp
   ```

3. Remove the config directory:

   ```
   cd ~/tmkms
   rm -rf config/
   ```

4. Reinitialize the config:

   ```
   cd ~/tmkms
   tmkms init config
   tmkms softsign keygen ./config/secrets/secret_connection_key
   ```

5. Import the validator key again (adjust the command to match your environment):

   ```
   scp USER@VALIDATOR_IP:~/.zigchain/config/priv_validator_key.json ~/tmkms/config/secrets/
   tmkms softsign import ~/tmkms/config/secrets/priv_validator_key.json ~/tmkms/config/secrets/priv_validator_key
   rm ~/tmkms/config/secrets/priv_validator_key.json
   ```

6. Restore and update the config file:

   ```
   mv /tmp/tmkms.toml ~/tmkms/config/
   vi ~/tmkms/config/tmkms.toml
   ```

   Update any parameters that may have changed (chain_id, prefixes, etc.).

7. Restart both services:
   ```
   sudo systemctl start tmkms.service
   # On the validator node:
   sudo systemctl restart zigchaind.service
   ```

### Service Not Starting After Reboot

If the TMKMS service does not start after reboot:

1. Check if the service is enabled:

   ```
   systemctl is-enabled tmkms.service
   ```

2. If not enabled, enable it:

   ```
   sudo systemctl enable tmkms.service
   ```

3. Check service logs for errors:

   ```
   journalctl -u tmkms.service -n 50
   ```

4. Verify file permissions on the key files and the config directory:
   ```
   ls -la ~/tmkms/config/secrets/
   ```

### Performance Issues

If signing operations are slow:

1. Verify `RUSTFLAGS` is set correctly in the environment where TMKMS runs
2. Check system resources (CPU, memory)
3. Review network latency between TMKMS and validator servers
4. Ensure the server has adequate resources (CPU, memory) for the workload
