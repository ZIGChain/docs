# Quick Reference Template

**Template Name**: `quick-reference-template`
**Version**: 1.0
**Last Updated**: 2026-01-28
**Purpose**: Quick reference sheets and cheat sheets with commands, parameters, or quick lookup information.

---

## Purpose

Quick reference sheets provide fast lookup for commands, parameters, and essential information.

**Use this template when:**
- Creating command cheat sheets
- Providing quick lookup for parameters
- Documenting essential commands
- Creating reference cards for common operations

**Do NOT use this template for:**
- Detailed explanations (use `user-guide-template`)
- Step-by-step procedures (use `step-by-step-guide-template`)
- Setup instructions (use `setup-guide-template`)

---

## Frontmatter

### Required Keys

- `title` (string): Quick sheet title (typically "[Topic] Quick Sheet" or "[Topic] Quick Reference")
- `description` (string): Brief description mentioning it's a quick reference
- `keywords` (array): Array of relevant keywords including "quick reference" or "cheat sheet"
- `sidebar_position` (number): Position in the sidebar

### Optional Keys

- `tags` (array): Additional tags (e.g., `["quick-reference", "commands", "validators"]`)

### Example

```yaml
---
title: Validator Quick Sheet
description: Quick reference sheet with essential ZIGChain validator commands including setup, status checks, reward management, and operational commands.
keywords:
  [
    validator commands,
    validator quick reference,
    validator CLI,
    validator status,
    validator rewards,
    validator management,
    operational commands,
  ]
sidebar_position: 3
tags:
  - quick-reference
  - validators
  - commands
---
```

---

## Content Structure

### Required Sections (in order)

1. **Main Title** (`# [Title]`)
   - Quick sheet title
   - Must match the `title` in frontmatter

2. **Brief Description**
   - What this quick sheet covers
   - Who it's for

3. **Visual Separator**
   - `<div class="spacer"></div>` after description

4. **Command Categories** (`## [Category]`)
   - H2 headings for each category of commands
   - Logical grouping (e.g., "Quick Commands", "Status Checks", "Management")

5. **Individual Commands** (`### [Command Name]`)
   - H3 headings for each command or command group
   - Descriptive names

6. **Code Blocks with Commands**
   - Commands in code blocks
   - Network-specific commands in tabs

### Optional Sections

- Additional Categories
- Notes
- Tips

---

## Patterns and Conventions

### Code Blocks

- **Essential for this template**: Commands are the primary content
- **Language tags**: `sh`, `bash`, `yaml`, `json`
- **Format**: Clean, executable commands
- **Comments**: Optional brief comments explaining commands

### Tabs

- **When to use**: Network-specific commands (Mainnet, Testnet, Local)
- **groupId**: `"network"`
- **Common values**: `"Mainnet"`, `"Testnet"`, `"Local"`
- **Example**:
  ```markdown
  <Tabs groupId="network">
    <TabItem value="Mainnet" label="Mainnet" default>
    ```sh
    zigchaind query staking validator $VALIDATOR_OP_ADDRESS \
    --chain-id zigchain-1 --node https://public-zigchain-rpc.numia.xyz
    ```
    </TabItem>
    <TabItem value="Testnet" label="Testnet">
    ```sh
    zigchaind query staking validator $VALIDATOR_OP_ADDRESS \
    --chain-id zig-test-2 --node https://public-zigchain-testnet-rpc.numia.xyz
    ```
    </TabItem>
  </Tabs>
  ```

### Spacers

- **When to use**: Between categories
- **Format**: `<div class="spacer"></div>`
- **Purpose**: Visual separation between command groups

### Minimal Prose

- **Focus**: Commands, not explanations
- **Format**: Brief descriptions only
- **Avoid**: Long explanations (link to detailed guides instead)

---

## Example Outline

```markdown
# Validator Quick Sheet

This quick sheet provides essential commands for managing validators on ZIGChain, including setup, status checks, and reward management.

<div class="spacer"></div>

## Quick Commands

### Get your node validator pub key

```sh
zigchaind tendermint show-validator
```

### Create a file with your validator info

```sh
PUBKEY=$(zigchaind tendermint show-validator)
bash -c "cat > /tmp/your_validator.txt" << EOM
{
    "pubkey": $PUBKEY,
    "amount": "1000000uzig",
    "moniker": "validator's name",
    "identity": "optional identity signature (ex. UPort or Keybase)",
    "website": "validator's (optional) website",
    "security": "validator's (optional) security contact email",
    "details": "validator's (optional) details",
    "commission-rate": "0.1",
    "commission-max-rate": "0.2",
    "commission-max-change-rate": "0.01",
    "min-self-delegation": "10"
}
EOM
```

### Create your validator

<Tabs groupId="network">
  <TabItem value="Mainnet" label="Mainnet" default>

```sh
zigchaind tx staking create-validator /tmp/your_validator.txt \
--from $ACCOUNT \
--chain-id zigchain-1 --node https://public-zigchain-rpc.numia.xyz \
--gas "auto" \
--gas-prices "0.0025uzig" \
--gas-adjustment 1.5
```

  </TabItem>
  <TabItem value="Testnet" label="Testnet">

```sh
zigchaind tx staking create-validator /tmp/your_validator.txt \
--from $ACCOUNT \
--chain-id zig-test-2 --node https://public-zigchain-testnet-rpc.numia.xyz \
--gas "auto" \
--gas-prices "0.0025uzig" \
--gas-adjustment 1.5
```

  </TabItem>
  <TabItem value="Local" label="Local">

```sh
zigchaind tx staking create-validator /tmp/your_validator.txt \
--from zuser1 \
--chain-id zigchain-1 --node http://localhost:26657 \
--gas "auto" \
--gas-prices "0.0025uzig" \
--gas-adjustment 1.5
```

  </TabItem>
</Tabs>

<div class="spacer"></div>

## Status Checks

### Check your validator status

<Tabs groupId="network">
  <TabItem value="Mainnet" label="Mainnet" default>

```sh
zigchaind query staking validator $VALIDATOR_OP_ADDRESS \
--chain-id zigchain-1 --node https://public-zigchain-rpc.numia.xyz
```

  </TabItem>
  <TabItem value="Testnet" label="Testnet">

```sh
zigchaind query staking validator $VALIDATOR_OP_ADDRESS \
--chain-id zig-test-2 --node https://public-zigchain-testnet-rpc.numia.xyz
```

  </TabItem>
  <TabItem value="Local" label="Local">

```sh
zigchaind query staking validator $VALIDATOR_OP_ADDRESS \
--chain-id zigchain-1 --node http://localhost:26657
```

  </TabItem>
</Tabs>

### Check if the validator is part of the active set

<Tabs groupId="network">
  <TabItem value="Mainnet" label="Mainnet" default>

```sh
zigchaind query tendermint-validator-set \
--chain-id zigchain-1 --node https://public-zigchain-rpc.numia.xyz \
| grep "$(zigchaind tendermint show-address)"
```

  </TabItem>
</Tabs>

<div class="spacer"></div>

## Reward Management

### Get your validator's rewards

<Tabs groupId="network">
  <TabItem value="Mainnet" label="Mainnet" default>

```sh
zigchaind query distribution commission $VALIDATOR_OP_ADDRESS \
--chain-id zigchain-1 --node https://public-zigchain-rpc.numia.xyz
```

  </TabItem>
</Tabs>

### Withdraw your rewards

<Tabs groupId="network">
  <TabItem value="Mainnet" label="Mainnet" default>

```sh
zigchaind tx distribution withdraw-rewards $VALIDATOR_OP_ADDRESS \
--chain-id zigchain-1 --node https://public-zigchain-rpc.numia.xyz \
--from $ACCOUNT \
--gas-adjustment=1.5 \
--gas auto \
--gas-prices="0.0025uzig"
```

  </TabItem>
</Tabs>
```

---

## Best Practices

1. **Focus on commands**: Keep explanations minimal, focus on executable commands
2. **Logical grouping**: Group commands by category or workflow
3. **Network tabs**: Provide network-specific commands in tabs
4. **Clean formatting**: Use consistent code block formatting
5. **Link to details**: Link to detailed guides for explanations
6. **Keep current**: Update commands when APIs change

## Common Mistakes to Avoid

1. **Too much explanation**: Including long explanations instead of focusing on commands
2. **Missing network options**: Only providing commands for one network
3. **Unclear organization**: Random order instead of logical grouping
4. **Outdated commands**: Not keeping commands current with latest APIs
5. **Missing context**: Not including variable definitions (e.g., `$VALIDATOR_OP_ADDRESS`)
6. **No links**: Not linking to detailed documentation for context

---

## Sample Documents

Best examples of this template:
- `docs/nodes-and-validators/validators-quick-sheet.md`
