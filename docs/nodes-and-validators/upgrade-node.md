---
title: How to Upgrade Your ZIGChain Node
description: Guide to upgrading ZIGChain nodes covering governance upgrades, coordinated blockchain halts, and asynchronous patches.
keywords:
  [
    ZIGChain node upgrade,
    ZIGChain validator upgrade,
    ZIGChain chain upgrade,
    ZIGChain binary upgrade,
    ZIGChain governance upgrade,
    ZIGChain emergency upgrade,
    ZIGChain patch,
    ZIGChain Cosmovisor upgrade,
  ]
sidebar_position: 8
---

import Tabs from '@theme/Tabs';
import TabItem from '@theme/TabItem';

# How to Upgrade Your ZIGChain Node

This guide covers the three types of upgrades you may encounter as a ZIGChain node operator or validator.

<div class="spacer"></div>

## Upgrade Types Overview

| Upgrade Type                         | State-Breaking | Coordination                   | When Used                                             |
| ------------------------------------ | -------------- | ------------------------------ | ----------------------------------------------------- |
| **Governance**                       | Yes            | Governance proposal            | Regular planned upgrades                              |
| **Non-Governance - Blockchain Halt** | Yes            | Coordinated at specific height | Critical/emergency situations                         |
| **Non-Governance - Patch**           | No             | Asynchronous                   | Bug fixes, security patches, performance improvements |

:::warning Security Upgrades
Critical security upgrades will be coordinated through non-governance approaches to protect the chain before public disclosure. Validators should be prepared to respond to urgent communications from the ZIGChain team for coordinated halts or emergency patches. For security-related upgrades, binaries may be shared privately with validators before public release.
:::

<div class="spacer"></div>

## Governance Upgrades

Governance upgrades are state-breaking changes that go through an on-chain software upgrade proposal. Your node will automatically halt at the upgrade height specified in the proposal.

### Manual Binary Upgrade

1. **Build or download** the binary for the release you are upgrading to from the [ZIGChain Networks Repository](https://github.com/ZIGChain/networks).

2. **Wait for the node to stop** at the upgrade height. The log will display something like this:

   ```
   ERR UPGRADE "v1.3.0" NEEDED at height: 5432100: upgrade to v1.3.0 and applying upgrade "v1.3.0" at height:5432100
   ```

3. **Stop the node service** if it remains active:

<Tabs groupId="os">
<TabItem value="Linux" label="Linux" default>

```bash
sudo systemctl stop zigchaind.service
```

</TabItem>
<TabItem value="Mac ARM" label="Mac ARM">

```bash
sudo launchctl stop com.zigchain.zigchaind
```

</TabItem>
<TabItem value="Mac AMD" label="Mac AMD">

```bash
sudo launchctl stop com.zigchain.zigchaind
```

</TabItem>
</Tabs>

4. **Replace the binary** with the new release:

```bash
sudo cp /path/to/new/zigchaind $(which zigchaind)
sudo chmod +x $(which zigchaind)
```

5. **Restart the node service**:

<Tabs groupId="os">
<TabItem value="Linux" label="Linux" default>

```bash
sudo systemctl start zigchaind.service
```

</TabItem>
<TabItem value="Mac ARM" label="Mac ARM">

```bash
sudo launchctl start com.zigchain.zigchaind
```

</TabItem>
<TabItem value="Mac AMD" label="Mac AMD">

```bash
sudo launchctl start com.zigchain.zigchaind
```

</TabItem>
</Tabs>

### Cosmovisor Upgrade

If you are using Cosmovisor, the upgrade process is automated. See the [Cosmovisor How-To Guide](./cosmovisor-howto-guide.md) for detailed setup and the `prepare-upgrade` command.

**Summary:**

1. After the governance proposal passes, run `cosmovisor prepare-upgrade` to download and validate the new binary.
2. Verify the binary was prepared correctly:

   ```bash
   ls -la $HOME/.zigchain/cosmovisor/upgrades/
   $HOME/.zigchain/cosmovisor/upgrades/<UPGRADE_NAME>/bin/zigchaind version
   ```

3. At the upgrade height, Cosmovisor automatically switches to the new binary and restarts the node.

<div class="spacer"></div>

## Non-Governance - Blockchain Halts

Non-governance blockchain halts are used for critical or emergency upgrades that require a coordinated halt at a specific block height without going through a governance proposal.

**When used:**

- Critical security vulnerabilities
- Consensus failures
- State-breaking issues requiring urgent resolution

:::note
For these upgrades, you **must** stop your node at the relevant height and replace the binary before starting it again. Monitor your logs carefully when the halt height is about to be reached.
:::

### Manual Binary Upgrade

1. **Build or download** the binary for the release you are upgrading to.

2. **Update `app.toml`** to set the halt height. Open the configuration file:

```bash
vim ~/.zigchain/config/app.toml
```

Find the `halt-height` variable and set it to the agreed upgrade height:

```toml
halt-height = 24666000
```

3. **Restart the node** to apply the configuration:

<Tabs groupId="os">
<TabItem value="Linux" label="Linux" default>

```bash
sudo systemctl restart zigchaind.service
```

</TabItem>
<TabItem value="Mac ARM" label="Mac ARM">

```bash
sudo launchctl stop com.zigchain.zigchaind
sudo launchctl start com.zigchain.zigchaind
```

</TabItem>
<TabItem value="Mac AMD" label="Mac AMD">

```bash
sudo launchctl stop com.zigchain.zigchaind
sudo launchctl start com.zigchain.zigchaind
```

</TabItem>
</Tabs>

4. **Wait for the halt height**. The log will display something like this:

   ```
   ERR CONSENSUS FAILURE!!! err="failed to apply block; error halt per configuration height 24666000 time 0"
   ```

5. **Stop the node service**:

<Tabs groupId="os">
<TabItem value="Linux" label="Linux" default>

```bash
sudo systemctl stop zigchaind.service
```

</TabItem>
<TabItem value="Mac ARM" label="Mac ARM">

```bash
sudo launchctl stop com.zigchain.zigchaind
```

</TabItem>
<TabItem value="Mac AMD" label="Mac AMD">

```bash
sudo launchctl stop com.zigchain.zigchaind
```

</TabItem>
</Tabs>

6. **Replace the binary** with the new release:

```bash
sudo cp /path/to/new/zigchaind $(which zigchaind)
sudo chmod +x $(which zigchaind)
```

7. **Reset `halt-height`** back to 0 in `app.toml`:

```toml
halt-height = 0
```

8. **Start the node service**:

<Tabs groupId="os">
<TabItem value="Linux" label="Linux" default>

```bash
sudo systemctl start zigchaind.service
```

</TabItem>
<TabItem value="Mac ARM" label="Mac ARM">

```bash
sudo launchctl start com.zigchain.zigchaind
```

</TabItem>
<TabItem value="Mac AMD" label="Mac AMD">

```bash
sudo launchctl start com.zigchain.zigchaind
```

</TabItem>
</Tabs>

9. **Monitor the logs** to ensure the node starts correctly and resumes consensus:

<Tabs groupId="os">
<TabItem value="Linux" label="Linux" default>

```bash
sudo journalctl -u zigchaind.service -f -o cat
tail -f /var/log/zigchaind/main.log
```

</TabItem>
<TabItem value="Mac ARM" label="Mac ARM">

```bash
tail -f /usr/local/var/log/zigchaind/main.log
```

</TabItem>
<TabItem value="Mac AMD" label="Mac AMD">

```bash
tail -f /usr/local/var/log/zigchaind/main.log
```

</TabItem>
</Tabs>

### Cosmovisor Upgrade

:::warning
There are reported issues with using Cosmovisor for non-governance upgrades: the instructions below may result in unexpected behaviour, such as an immediate upgrade or failure to stop at the specified height.
:::

If you are using Cosmovisor, you can use the `add-upgrade` command to register the upgrade with a specific halt height.

1. **Download or build** the new binary and place it in a temporary location.

2. **Register the upgrade** using `cosmovisor add-upgrade`:

   ```bash
   cosmovisor add-upgrade <UPGRADE_NAME> /path/to/new/zigchaind --upgrade-height <HALT_HEIGHT>
   ```

   For example:

   ```bash
   cosmovisor add-upgrade v3 /tmp/zigchaind-v3/zigchaind --upgrade-height 24666000
   ```

   :::note
   The `<UPGRADE_NAME>` will be provided by the ZIGChain team. Upgrade names cannot be reused, so ensure you use the exact name specified in the upgrade announcement.
   :::

3. **Verify the upgrade was registered**:

   ```bash
   ls -la $HOME/.zigchain/cosmovisor/upgrades/
   $HOME/.zigchain/cosmovisor/upgrades/<UPGRADE_NAME>/bin/zigchaind version
   ```

4. At the specified halt height, Cosmovisor will automatically switch to the new binary and restart the node.

5. **Monitor the logs** to ensure the upgrade proceeds correctly:

<Tabs groupId="os">
<TabItem value="Linux" label="Linux" default>

```bash
sudo journalctl -u zigchaind-cosmovisor.service -f -o cat
```

</TabItem>
<TabItem value="Mac ARM" label="Mac ARM">

```bash
tail -f /usr/local/var/log/zigchaind/main.log
```

</TabItem>
<TabItem value="Mac AMD" label="Mac AMD">

```bash
tail -f /usr/local/var/log/zigchaind/main.log
```

</TabItem>
</Tabs>

<div class="spacer"></div>

## Non-Governance - Patch

Non-governance patches are non-state-breaking updates where validators can upgrade asynchronously without a coordinated chain halt.

**When used:**

- Bug fixes
- Performance improvements
- Security patches that don't require state migration
- Security-related upgrades that are non-state-breaking

**Recommendation:** Use a progressive rollout approach - upgrade 1-2 nodes first, monitor for stability, then upgrade the remaining nodes.

### Manual Binary Upgrade

1. **Stop the node service**:

<Tabs groupId="os">
<TabItem value="Linux" label="Linux" default>

```bash
sudo systemctl stop zigchaind.service
```

</TabItem>
<TabItem value="Mac ARM" label="Mac ARM">

```bash
sudo launchctl stop com.zigchain.zigchaind
```

</TabItem>
<TabItem value="Mac AMD" label="Mac AMD">

```bash
sudo launchctl stop com.zigchain.zigchaind
```

</TabItem>
</Tabs>

2. **Replace the binary** with the new release:

```bash
sudo cp /path/to/new/zigchaind $(which zigchaind)
sudo chmod +x $(which zigchaind)
```

3. **Start the node service**:

<Tabs groupId="os">
<TabItem value="Linux" label="Linux" default>

```bash
sudo systemctl start zigchaind.service
```

</TabItem>
<TabItem value="Mac ARM" label="Mac ARM">

```bash
sudo launchctl start com.zigchain.zigchaind
```

</TabItem>
<TabItem value="Mac AMD" label="Mac AMD">

```bash
sudo launchctl start com.zigchain.zigchaind
```

</TabItem>
</Tabs>

### Cosmovisor Upgrade

:::warning
There are reported issues with using Cosmovisor for non-governance upgrades: the instructions below may result in unexpected behaviour, such as an immediate upgrade or failure to stop at the specified height.
:::

If you are using Cosmovisor, you can use the `add-upgrade` command to register the patch without a halt height.

1. **Download or build** the new binary and place it in a temporary location.

2. **Register the upgrade** using `cosmovisor add-upgrade`:

   ```bash
   cosmovisor add-upgrade <UPGRADE_NAME> /path/to/new/zigchaind --upgrade-height <HEIGHT>
   ```

   For example:

   ```bash
   cosmovisor add-upgrade v3.0.1-patch /tmp/zigchaind-v3.0.1/zigchaind --upgrade-height 24680000
   ```

   :::note
   The `<UPGRADE_NAME>` will be provided by the ZIGChain team. Upgrade names cannot be reused, so ensure you use the exact name specified in the upgrade announcement.
   :::

3. **Verify the upgrade was registered**:

   ```bash
   ls -la $HOME/.zigchain/cosmovisor/upgrades/
   $HOME/.zigchain/cosmovisor/upgrades/<UPGRADE_NAME>/bin/zigchaind version
   ```

4. Cosmovisor will automatically switch to the new binary.

5. **Monitor the logs** to ensure the node is running correctly:

<Tabs groupId="os">
<TabItem value="Linux" label="Linux" default>

```bash
sudo journalctl -u zigchaind-cosmovisor.service -f -o cat
```

</TabItem>
<TabItem value="Mac ARM" label="Mac ARM">

```bash
tail -f /usr/local/var/log/zigchaind/main.log
```

</TabItem>
<TabItem value="Mac AMD" label="Mac AMD">

```bash
tail -f /usr/local/var/log/zigchaind/main.log
```

</TabItem>
</Tabs>

<div class="spacer"></div>

## Verification Steps

After any upgrade, verify your node is running correctly:

**Check node status:**

```bash
curl -s localhost:26657/status | jq '.result.sync_info'
```

**Verify the new version:**

```bash
zigchaind version --long
$HOME/.zigchain/cosmovisor/current/bin/zigchaind version --long
```

**Check logs for errors:**

<Tabs groupId="os">
<TabItem value="Linux" label="Linux" default>

```bash
sudo journalctl -u zigchaind.service -f -o cat
sudo journalctl -u zigchaind-cosmovisor.service -f -o cat
```

</TabItem>
<TabItem value="Mac ARM" label="Mac ARM">

```bash
tail -f /usr/local/var/log/zigchaind/main.log
```

</TabItem>
<TabItem value="Mac AMD" label="Mac AMD">

```bash
tail -f /usr/local/var/log/zigchaind/main.log
```

</TabItem>
</Tabs>

**Key indicators of a successful upgrade:**

1. **Node is synced:** The `catching_up` field should be `false`. Check with:

   ```bash
   curl -s localhost:26657/status | jq '.result.sync_info.catching_up'
   ```

   Expected output: `false`

2. **Correct version:** Verify the new version is running:

   ```bash
   zigchaind version
   $HOME/.zigchain/cosmovisor/current/bin/zigchaind version
   ```

3. **No consensus errors:** Logs should show normal block production without `ERR` messages related to consensus.

4. **Blocks being produced:** The `latest_block_height` should be increasing:

   ```bash
   curl -s localhost:26657/status | jq '.result.sync_info.latest_block_height'
   ```

<div class="spacer"></div>

## References

- [Cosmovisor How-To Guide](./cosmovisor-howto-guide.md) - Detailed Cosmovisor setup and configuration
- [Set Up a ZIGChain Node](./setup-node.md) - Node setup and systemd/LaunchDaemon configuration
- [ZIGChain Networks Repository](https://github.com/ZIGChain/networks) - Official binaries and checksums
