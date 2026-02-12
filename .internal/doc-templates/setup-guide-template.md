# Setup Guide Template

**Template Name**: `setup-guide-template`
**Version**: 1.0
**Last Updated**: 2026-01-28
**Purpose**: Detailed instructions for configuring infrastructure, validators, nodes, or development environments.

---

## Purpose

Setup guides provide detailed instructions for configuring infrastructure, validators, nodes, or development environments.

**Use this template when:**
- Setting up validators or nodes
- Configuring infrastructure
- Detailed installation and configuration procedures
- Post-setup management and maintenance

**Do NOT use this template for:**
- Quick installation guides (use `quick-start-template`)
- Feature explanations (use `user-guide-template`)
- Simple step-by-step procedures (use `step-by-step-guide-template`)

---

## Frontmatter

### Required Keys

- `title` (string): The main title (e.g., "Set Up a ZIGChain Validator")
- `description` (string): Comprehensive description mentioning all aspects covered
- `keywords` (array): Array of relevant keywords
- `sidebar_position` (number): Position in the sidebar

### Optional Keys

- `tags` (array): Additional tags
- `relatedDocs` (array): Links to related documentation

### Example

```yaml
---
title: Set Up a ZIGChain Validator
description: Comprehensive guide to setting up a validator on ZIGChain including prerequisites, validator creation, key management, staking configuration, and post-creation management.
keywords:
  [
    ZIGChain validator setup,
    ZIGChain validator,
    ZIGChain active validators,
    ZIGChain validator requirements,
  ]
sidebar_position: 5
tags:
  - validator
  - setup
  - infrastructure
relatedDocs:
  - ./validators-faq.md
  - ./validators-quick-sheet.md
---
```

---

## Content Structure

### Required Sections (in order)

1. **Main Title** (`# [Title]`)
   - Must match the `title` in frontmatter

2. **Brief Introduction**
   - What this guide covers
   - Who it's for
   - Link to quick reference if available

3. **Requirements Section** (`## [Component] Requirements`)
   - Prerequisites
   - Hardware requirements
   - Software requirements
   - Account/token requirements

4. **Steps to [Action]** (`## Steps to [Action]`)
   - Numbered steps (1, 2, 3, etc.)
   - Sub-steps as needed
   - Network-specific commands in tabs

5. **Management/Maintenance Section** (`## [Management/Maintenance]`)
   - Post-setup tasks
   - Ongoing management
   - Monitoring and maintenance

### Optional Sections

- Troubleshooting
- Best Practices
- Security Considerations
- References
- Additional Resources

---

## Patterns and Conventions

### Tabs

- **When to use**: Network-specific commands (Mainnet, Testnet, Local)
- **groupId**: `"network"`
- **Common values**: `"Mainnet"`, `"Testnet"`, `"Local"`
- **Example**:
  ```markdown
  <Tabs groupId="network">
    <TabItem value="Mainnet" label="Mainnet" default>
    ```bash
    zigchaind tx staking create-validator ... \
    --chain-id zigchain-1 \
    --node https://public-zigchain-rpc.numia.xyz
    ```
    </TabItem>
    <TabItem value="Testnet" label="Testnet">
    ```bash
    zigchaind tx staking create-validator ... \
    --chain-id zig-test-2 \
    --node https://public-zigchain-testnet-rpc.numia.xyz
    ```
    </TabItem>
  </Tabs>
  ```

### Code Blocks

- **When to use**: CLI commands, configuration examples, JSON files
- **Language tags**: `bash`, `sh`, `yaml`, `json`
- **Format**: Include comments explaining commands

### Spacers

- **When to use**: Between major sections
- **Format**: `<div class="spacer"></div>`

### Images

- **When to use**: Screenshots, diagrams, architecture diagrams
- **Format**: `![Description](./path/to/image.png)`

### Tables

- **When to use**: Requirements lists, parameter tables, comparison tables
- **Format**: Standard markdown tables

### Alerts

- **When to use**: Important warnings, prerequisites, critical information
- **Types**: `:::warning`, `:::info`, `:::tip`, `:::danger`
- **Example**:
  ```markdown
  :::warning Important
  `commission-max-rate` and `commission-max-change-rate` cannot be changed after validator creation.
  :::
  ```

---

## Example Outline

```markdown
# Set Up a ZIGChain Validator

This guide provides step-by-step instructions for setting up a validator on ZIGChain. It covers prerequisites, key commands, validator parameters, and post-creation validator management.

If you need quick commands for validator creation, refer to the [Validator Quick Sheet](./validators-quick-sheet).

<div class="spacer"></div>

## Validator Requirements

Before creating a validator, ensure you meet the following requirements:

### Validator Hardware Requirements

To run a validator reliably, the following specifications are recommended:

- **CPU:** 8 vCPUs (4 physical cores)
- **Memory:** 64 GB RAM
- **Storage:** 500 GB – 1 TB SSD
- **Network:** Stable, high-bandwidth, low-latency connection

### Supported Binary Architectures

The zigchaind binary is available for the following architectures:

- **linux-amd64** — Linux servers (Intel/AMD) (recommended for production)
- **darwin-arm64** — macOS on Apple Silicon (testing only)
- **darwin-amd64** — macOS on Intel (testing only)

### Other Requirements

1. **A Running Node**
   - Ensure you have a dedicated node without any other validators operating on it.
   - Follow the [Node Setup Guide](./setup-node.md) if needed.

2. **A ZIGChain Account**
   - The account must not already own a validator.

3. **ZIG Tokens**
   - You will need to self-delegate tokens to your new validator.

<div class="spacer"></div>

## Steps to Create a Validator

### 1. Get your node validator pubkey

Run the following command to retrieve your **validator's public key**:

```bash
zigchaind tendermint show-validator
```

Example output:

```json
{
  "@type": "/cosmos.crypto.ed25519.PubKey",
  "key": "YYOjubD+2Z5Ytu66JnN0IkJ5BAAApd07Dfj7EF+QQaA="
}
```

### 2. Define your validator

Create a JSON file containing your **validator information**:

```bash
PUBKEY=$(zigchaind tendermint show-validator)
bash -c "cat > /tmp/your_validator.txt" << EOM
{
    "pubkey": $PUBKEY,
    "amount": "1000000uzig",
    "moniker": "validator's name",
    "commission-rate": "0.1",
    "commission-max-rate": "0.2",
    "commission-max-change-rate": "0.01",
    "min-self-delegation": "10"
}
EOM
```

:::warning Important
`commission-max-rate` and `commission-max-change-rate` cannot be changed after the validator is created.
:::

### 3. Create your validator

Run the following command to create your validator:

<Tabs groupId="network">
  <TabItem value="Mainnet" label="Mainnet" default>

```bash
zigchaind tx staking create-validator /tmp/your_validator.txt \
--from $ACCOUNT \
--chain-id zigchain-1 \
--node https://public-zigchain-rpc.numia.xyz \
--gas "auto" \
--gas-prices "0.0025uzig" \
--gas-adjustment=1.5
```

  </TabItem>
  <TabItem value="Testnet" label="Testnet">

```bash
zigchaind tx staking create-validator /tmp/your_validator.txt \
--from $ACCOUNT \
--chain-id zig-test-2 \
--node https://public-zigchain-testnet-rpc.numia.xyz \
--gas "auto" \
--gas-prices "0.0025uzig" \
--gas-adjustment=1.5
```

  </TabItem>
</Tabs>

<div class="spacer"></div>

## Manage your Validator

As a validator, you can perform several management tasks, including:

- Updating validator information
- Checking jail status
- Unjailing validators
- Withdrawing earned commissions

### Retrieve your validator addresses

Run the following command to retrieve your validator operator address:

```bash
zigchaind keys show <key-name> --bech val --address
```

### Check if your validator is in the active set

<Tabs groupId="network">
  <TabItem value="Mainnet" label="Mainnet" default>

```bash
zigchaind query tendermint-validator-set \
--chain-id zigchain-1 --node https://public-zigchain-rpc.numia.xyz \
| grep "$(zigchaind tendermint show-address)"
```

  </TabItem>
</Tabs>
```

---

## Best Practices

1. **Comprehensive requirements**: List all prerequisites clearly
2. **Numbered steps**: Use clear numbering for sequential steps
3. **Network tabs**: Always provide network-specific commands in tabs
4. **Verification**: Include how to verify each step completed successfully
5. **Troubleshooting**: Address common issues
6. **Management section**: Include post-setup management tasks

## Common Mistakes to Avoid

1. **Missing prerequisites**: Not listing all requirements upfront
2. **No verification steps**: Not showing how to verify setup worked
3. **Missing network options**: Only providing one network option
4. **Unclear steps**: Vague or ambiguous instructions
5. **No management section**: Not covering post-setup tasks
6. **Missing warnings**: Not highlighting irreversible actions

---

## Sample Documents

Best examples of this template:
- `docs/nodes-and-validators/setup-validator.md`
- `docs/nodes-and-validators/setup-node.md`
- `docs/users/wallet-setup/zigchain-wallet.md`
- `docs/users/wallet-setup/ledger.md`
- `docs/nodes-and-validators/multivalidator-setup.md`
