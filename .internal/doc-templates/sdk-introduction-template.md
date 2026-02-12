# SDK Introduction Template

**Template Name**: `sdk-introduction-template`
**Version**: 1.0
**Last Updated**: 2026-01-28
**Purpose**: Introduction documents for SDKs, APIs, or developer tools.

---

## Purpose

SDK introduction documents explain what an SDK is, why to use it, how to choose between options, and how to get started.

**Use this template when:**
- Introducing a new SDK or API
- Explaining SDK features and benefits
- Comparing multiple SDK options
- Providing SDK installation and basic usage

**Do NOT use this template for:**
- Detailed API reference (use API reference template)
- Step-by-step tutorials (use `step-by-step-guide-template`)
- Quick installation only (use `quick-start-template`)

---

## Frontmatter

### Required Keys

- `title` (string): SDK name (e.g., "ZIGChain React SDK")
- `description` (string): Brief description mentioning it's an SDK introduction
- `keywords` (array): Array of relevant keywords including SDK name
- `sidebar_position` (number): Position in the sidebar (often 1 for introductions)

### Optional Keys

- `tags` (array): Additional tags (e.g., `["sdk", "react", "frontend"]`)

### Example

```yaml
---
title: ZIGChain React SDK
description: Introduction to ZIGChain React SDK for building frontend applications. Learn about features, installation, network support, and when to use React SDK vs JS SDK.
keywords:
  [
    ZIGChain SDK,
    React SDK,
    frontend SDK,
    Cosmos Kit,
    dApp development,
    blockchain SDK,
  ]
sidebar_position: 1
---
```

---

## Content Structure

### Required Sections (in order)

1. **Main Title** (`# [Title]`)
   - SDK name
   - Must match the `title` in frontmatter

2. **Welcome/Introduction Paragraph**
   - What the SDK is
   - What it enables developers to do
   - Brief overview of capabilities

3. **Why Use [SDK Name]?** (`## Why Use [SDK Name]?`)
   - Benefits and use cases
   - Key features
   - Advantages over alternatives

4. **Choosing Between [Options]** (`## Choosing Between [Options]`)
   - Comparison if multiple SDKs exist
   - When to use each option
   - Feature comparison table

5. **Prerequisites** (`## Prerequisites`)
   - Requirements before installation
   - Authentication setup if needed
   - Account or access requirements

6. **Installation** (`## Installation`)
   - Installation steps
   - Package manager commands
   - Configuration if needed

### Optional Sections

- Quick Start
- Examples
- API Reference Links
- Network Support
- Common Use Cases

---

## Patterns and Conventions

### Tables

- **When to use**: Feature comparisons, SDK comparisons
- **Format**: Standard markdown tables
- **Example**:
  ```markdown
  | Feature             | ZIGChain SDK | ZIGChain SDK JS |
  | ------------------- | ------------ | --------------- |
  | Description         | Frontend SDK | Lightweight SDK |
  | Best for            | Rapid dev    | Flexibility     |
  | Frontend/Backend    | Frontend     | Frontend/Backend|
  ```

### Code Blocks

- **When to use**: Installation commands, configuration, examples
- **Language tags**: `bash`, `sh`, `json`, `javascript`, `typescript`
- **Format**: Include comments explaining commands

### Alerts

- **When to use**: Important information, authentication requirements, warnings
- **Types**: `:::info`, `:::warning`, `:::tip`
- **Example**:
  ```markdown
  :::info Getting Your Authentication Token
  To obtain your authentication token, please contact the ZIGChain team through our official channels.
  :::
  ```

### Links

- **When to use**: Links to detailed documentation, API references, examples
- **Format**: Internal relative links and external URLs

### Spacers

- **When to use**: Between major sections
- **Format**: `<div class="spacer"></div>`

---

## Example Outline

```markdown
# ZIGChain React SDK

Welcome to the **ZIGChain SDK**! This SDK allows developers to seamlessly interact with the ZIGChain blockchain, providing tools for querying data, managing wallets, and performing blockchain transactions in your JavaScript or TypeScript applications.

## Why Use ZIGChain SDK?

- **Easy to Use**: Simplifies interaction with the ZIGChain blockchain by providing convenient methods and abstractions.
- **Comprehensive**: Supports querying token data, pools, balances, and metadata, as well as performing complex operations such as swaps.
- **Network Flexibility**: Supports different networks such as `mainnet` and `testnet`, and allows custom configurations for private or custom blockchain networks.
- **Modular**: Built to be modular and flexible, it integrates with other Cosmos-based chains and wallets seamlessly.

---

## Choosing Between ZIGChain SDK and ZIGChain SDK JS

ZIGChain provides two Software Development Kits (SDKs) for building applications on its blockchain: ZIGChain SDK and ZIGChain SDK JS

Below is a comparison to help you choose the right SDK based on their project requirements:

| Feature             | ZIGChain SDK                                                  | ZIGChain SDK JS                                                |
| ------------------- | ------------------------------------------------------------- | -------------------------------------------------------------- |
| Description         | Frontend (FE) SDK leveraging Cosmos Kit, adapted for ZIGChain | Lightweight SDK suitable for both frontend and backend (FE/BE) |
| Best for            | Rapid development with minimal customization                  | Greater flexibility and customization options                  |
| Frontend/Backend    | Frontend                                                      | Frontend and Backend                                           |
| Other requirements? | Standalone usage                                              | Combine it with Cosmos Kit                                     |
| Expertise level     | Beginner-friendly                                             | Best for advanced users or complex architectures/designs       |

### When to use ZIGChain SDK or ZIGChain SDK JS?

Use **ZIGChain SDK** if:

- ✅ Best for frontend applications that need quick and simple blockchain integration.
- ✅ Built-in wallet management via Cosmos Kit, with minimal setup required.
- ✅ Ideal for querying balances, pools, and executing swaps without deep blockchain knowledge.

**Example Use Case:**
A token factory frontend that enables users to create new tokens, check their balances, and manage supply directly from the UI with minimal configuration.

Use **ZIGChain SDK JS** if:

- ✅ Works for both frontend and backend, enabling full-stack blockchain interactions.
- ✅ Together with Cosmos Kit, provides a powerful set that offers flexibility to build any type of product.
- ✅ Gives maximum flexibility for composing, signing, and broadcasting blockchain messages.

---

## Prerequisites: Authentication Setup

Before installing the ZIGChain SDK, you need to configure authentication to access the package repository. The ZIGChain SDK is hosted on GitHub Packages and requires an authentication token.

Create a `.npmrc` file in the root directory of your project with the following content:

```
//npm.pkg.github.com/:_authToken=AUTH_TOKEN
@zigchain:registry=https://npm.pkg.github.com
always-auth=true
```

Replace `AUTH_TOKEN` with the authentication token provided by ZIGChain.

:::info Getting Your Authentication Token
To obtain your authentication token, please contact the ZIGChain team through our official channels:

- **[Discord](https://discord.com/channels/486954374845956097/)** - Join our community and reach out for support
- **[Telegram](https://t.me/ZignalyHQ)** - Connect with the team directly

For additional support channels, visit our [Community & Support](../../about-zigchain/community-support) page.

This token is required to access and install ZIGChain packages from the GitHub registry.
:::

---

## Installation

To get started with the ZIGChain SDK, you need to install it in your project. Use your preferred package manager to install the SDK:

```bash
npm install @zigchain/react-sdk
```

Or with yarn:

```bash
yarn add @zigchain/react-sdk
```

Or with pnpm:

```bash
pnpm add @zigchain/react-sdk
```
```

---

## Best Practices

1. **Clear value proposition**: Explain why developers should use this SDK
2. **Comparison tables**: Use tables to compare SDK options clearly
3. **Prerequisites first**: List all requirements before installation
4. **Examples**: Include simple examples to show SDK usage
5. **Link to details**: Link to detailed API documentation
6. **Use cases**: Provide concrete use cases for the SDK

## Common Mistakes to Avoid

1. **Too technical**: Starting with implementation details before explaining value
2. **Missing comparison**: Not comparing when multiple SDKs exist
3. **No prerequisites**: Not listing authentication or setup requirements
4. **Missing examples**: Not showing basic usage examples
5. **No links**: Not linking to detailed documentation
6. **Vague benefits**: Not clearly explaining why to use the SDK

---

## Sample Documents

Best examples of this template:
- `docs/builders/react-sdk/introduction.md`
- `docs/builders/js-sdk/introduction.md`
