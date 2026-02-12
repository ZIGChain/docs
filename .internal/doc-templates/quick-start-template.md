# Quick Start Template

**Template Name**: `quick-start-template`
**Version**: 1.0
**Last Updated**: 2026-01-28
**Purpose**: Step-by-step guides to get users up and running with ZIGChain as quickly as possible.

---

## Purpose

Quick start guides help users get up and running with ZIGChain as quickly as possible, focusing on essential setup steps.

**Use this template when:**
- Providing installation instructions
- Setting up development environments
- Getting users started with a tool or feature quickly
- Creating "first steps" documentation

**Do NOT use this template for:**
- Comprehensive feature explanations (use `user-guide-template`)
- Detailed configuration guides (use `setup-guide-template`)
- API or SDK introductions (use `sdk-introduction-template`)

---

## Frontmatter

### Required Keys

- `title` (string): The main title (typically "Quick Start Guide" or similar)
- `description` (string): Brief description mentioning platforms supported
- `keywords` (array): Array of relevant keywords including platform names
- `sidebar_position` (number): Position in the sidebar (often 1 for quick starts)

### Optional Keys

- `tags` (array): Additional tags (e.g., `["quick-start", "installation"]`)

### Example

```yaml
---
title: Quick Start Guide
description: Step-by-step guide to installing and setting up zigchaind CLI tool for ZIGChain development on Linux, Mac, and Windows (WSL).
keywords:
  [
    zigchaind CLI,
    ZIGChain build guide,
    ZIGChain developers,
    ZIGChain node setup,
    ZIGChain SDK quick start,
  ]
sidebar_position: 1
---
```

---

## Content Structure

### Required Sections (in order)

1. **Main Title** (`# [Title]`)
   - Must match the `title` in frontmatter

2. **Brief Description**
   - What the guide covers
   - What users will accomplish

3. **Platform-Specific Sections with Tabs**
   - Use Tabs component for different platforms
   - Common platforms: Windows (WSL), Linux, Mac (ARM), Mac (AMD)

4. **Installation Steps**
   - Clear, numbered or bulleted steps
   - Platform-specific instructions in tabs

5. **Verification Steps**
   - How to verify the installation worked
   - Test commands or checks

6. **Basic Usage Examples**
   - Simple examples to get started
   - "Hello World" equivalent

### Optional Sections

- Troubleshooting
- Next Steps
- Additional Resources
- Common Issues

---

## Patterns and Conventions

### Tabs

- **Essential for this template**: Platform-specific instructions
- **groupId**: `"platform"`
- **Common values**: `"Linux"`, `"Mac ARM"`, `"Mac AMD"`, `"Windows"`
- **Example**:
  ```markdown
  <Tabs groupId="platform">
    <TabItem value="Linux" label="Linux" default>
    ```sh
    # Linux installation commands
    ```
    </TabItem>
    <TabItem value="Mac ARM" label="Mac ARM">
    ```sh
    # Mac ARM installation commands
    ```
    </TabItem>
  </Tabs>
  ```

### Code Blocks

- **When to use**: Installation commands, verification commands, configuration
- **Language tags**: Use `sh`, `bash`, `yaml`, `json` as appropriate
- **Format**: Include comments explaining what each command does

### Spacers

- **When to use**: Between major sections
- **Format**: `<div class="spacer"></div>`

### Images

- **When to use**: Screenshots of installation process, terminal output
- **Format**: `![Description](./path/to/image.png)`

### Alerts

- **When to use**: Important warnings, prerequisites, tips
- **Types**: `:::info`, `:::warning`, `:::tip`
- **Example**:
  ```markdown
  :::info Windows Users
  We recommend using Windows Subsystem for Linux (WSL) to run Linux commands.
  :::
  ```

---

## Example Outline

```markdown
# Quick Start Guide

`zigchaind` is the ZIGChain CLI. It is a command line tool that allows you to interact with the ZIGChain network.

<div class="spacer"></div>

## Windows (WSL)

:::info Windows Users
We recommend using Windows Subsystem for Linux (WSL) to run the Linux commands on your Windows machine.
:::

### Setting Up WSL (for Windows users)

1. **Enable WSL**
   Open PowerShell as Administrator and run:
   ```bash
   wsl --install
   ```

<div class="spacer"></div>

## Automated Setup Scripts

You can use our automated setup scripts to quickly install and configure your ZIGChain node.

**Supported platforms**
- Linux (x86)
- Mac (Apple Silicon)
- Mac (Intel)

<Tabs groupId="platform">
  <TabItem value="Linux" label="Linux" default>
  ```bash
  curl -O https://raw.githubusercontent.com/ZIGChain/docs/main/scripts/start-linux.sh
  chmod +x start-linux.sh
  ./start-linux.sh
  ```
  </TabItem>
  <TabItem value="Mac ARM" label="Mac ARM">
  ```bash
  curl -O https://raw.githubusercontent.com/ZIGChain/docs/main/scripts/start-macos.sh
  chmod +x start-macos.sh
  ./start-macos.sh
  ```
  </TabItem>
</Tabs>

<div class="spacer"></div>

## Quick Start on a Local Machine

The following steps guide you through installing ZIGChain manually.

### Install ZIGChain Binary

<Tabs groupId="platform">
  <TabItem value="Linux" label="Linux" default>
  ```sh
  cd /tmp/
  LATEST_VERSION=$(curl -s https://raw.githubusercontent.com/ZIGChain/networks/refs/heads/main/zig-test-2/version.txt)
  wget "https://raw.githubusercontent.com/ZIGChain/networks/refs/heads/main/zig-test-2/binaries/zigchaind-${LATEST_VERSION}-linux-amd64.tar.gz"
  tar -zxvf "zigchaind-${LATEST_VERSION}-linux-amd64.tar.gz"
  cd zigchaind-${LATEST_VERSION}-linux-amd64
  mkdir -p $HOME/.local/bin
  mv ./zigchaind $HOME/.local/bin/zigchaind
  ```
  </TabItem>
</Tabs>

### Verify Installation

Check that it works by running:

```sh
zigchaind --help
```

<div class="spacer"></div>

## Troubleshooting

### Handling "failed to initialize database: resource temporarily unavailable"

If you encounter this error, a `zigchaind` process is already running.

#### Step 1: Check Running Processes

```bash
ps -ef | grep zigchaind
```

#### Step 2: Kill the Process

```bash
kill -9 [PROCESS_ID]
```
```

---

## Best Practices

1. **Platform coverage**: Always include instructions for all supported platforms
2. **Verification steps**: Always include how to verify the installation worked
3. **Troubleshooting**: Include common issues and solutions
4. **Clear steps**: Number or bullet steps for clarity
5. **Prerequisites**: List prerequisites early (WSL for Windows, etc.)
6. **Next steps**: Guide users to what they should do after completing the quick start

## Common Mistakes to Avoid

1. **Missing platform support**: Only providing instructions for one platform
2. **No verification**: Not showing how to verify the installation
3. **Assumed knowledge**: Assuming users know prerequisites
4. **Unclear steps**: Vague or ambiguous instructions
5. **Missing troubleshooting**: Not addressing common issues
6. **Too much detail**: Including advanced configuration in a quick start

---

## Sample Documents

Best examples of this template:
- `docs/builders/quick-start.md`
- `docs/.tutorials/add-zigchain-to-wallet.md`
- `docs/.tutorials/token-factory.md`
