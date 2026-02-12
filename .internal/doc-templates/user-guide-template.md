# User Guide Template

**Template Name**: `user-guide-template`
**Version**: 1.0
**Last Updated**: 2026-01-28
**Purpose**: Comprehensive guides explaining ZIGChain features, concepts, and functionality for end users.

---

## Purpose

User guides provide comprehensive explanations of ZIGChain features, concepts, and functionality. They are designed to help users understand and use ZIGChain effectively.

**Use this template when:**
- Explaining a feature or concept to end users
- Providing overviews of ZIGChain functionality
- Documenting user-facing features
- Creating guides that help users understand "what" and "why" before "how"

**Do NOT use this template for:**
- Step-by-step installation or setup procedures (use `quick-start-template` or `setup-guide-template`)
- API or SDK documentation (use `sdk-introduction-template`)
- Quick command references (use `quick-reference-template`)

---

## Frontmatter

### Required Keys

- `title` (string): The main title of the guide
- `description` (string): Brief description for SEO and previews
- `keywords` (array): Array of relevant keywords for SEO
- `sidebar_position` (number): Position in the sidebar navigation

### Optional Keys

- `tags` (array): Additional tags for categorization
- `relatedDocs` (array): Links to related documentation

### Example

```yaml
---
title: Staking on ZIGChain
description: Learn about staking on ZIGChain, including how to delegate ZIG tokens to validators, earn rewards, participate in governance, and understand validator and delegator roles.
keywords:
  [
    ZIGChain staking,
    stake ZIG token,
    ZIGChain validator delegation,
    staking rewards ZIGChain,
    unbonding period ZIGChain,
  ]
sidebar_position: 9
tags:
  - staking
  - user-guide
relatedDocs:
  - ../governance/delegators_faq.md
---
```

---

## Content Structure

### Required Sections (in order)

1. **Main Title** (`# [Title]`)
   - Must match the `title` in frontmatter
   - Single H1 heading

2. **Introduction Paragraph**
   - 2-4 sentences explaining what the guide covers
   - Context for why the user should read this guide

3. **Visual Separator**
   - `<div class="spacer"></div>` after introduction

4. **Main Content Sections** (`## [Key Concept/Component]`)
   - H2 headings for major topics
   - Use H3 for sub-topics within each section
   - Explain key concepts, components, or features

5. **How It Works Section** (`## How [Feature] Works`)
   - Explanation of functionality
   - Step-by-step overview (not detailed steps)

6. **Additional Topics**
   - Related topics as needed
   - Security measures, best practices, etc.

### Optional Sections

- Security Measures
- Best Practices
- References
- Related Links
- Troubleshooting (if applicable)

---

## Patterns and Conventions

### Tabs

- **When to use**: Platform-specific or network-specific content
- **groupId values**:
  - `"platform"` for OS-specific content (Linux, Mac, Windows)
  - `"network"` for network-specific content (Mainnet, Testnet, Local)
- **Example**:
  ```markdown
  <Tabs groupId="platform">
    <TabItem value="Linux" label="Linux" default>
    [Linux-specific content]
    </TabItem>
    <TabItem value="Mac" label="Mac">
    [Mac-specific content]
    </TabItem>
  </Tabs>
  ```

### Code Blocks

- **When to use**: CLI commands, examples, configuration snippets
- **Language tags**: Use appropriate language tags (`bash`, `sh`, `yaml`, `json`, etc.)
- **Format**: Include context before code blocks explaining what the command does

### Spacers

- **When to use**: Between major sections for visual separation
- **Format**: `<div class="spacer"></div>`
- **Placement**: After introduction, between major H2 sections

### Images

- **When to use**: Screenshots, diagrams, flowcharts
- **Format**: Use markdown image syntax `![Alt text](./path/to/image.png)`
- **Placement**: After relevant text, not before

### Alerts

- **When to use**: Important notes, warnings, tips
- **Types**:
  - `:::info` - General information
  - `:::warning` - Warnings
  - `:::tip` - Tips and best practices
  - `:::danger` - Critical warnings
- **Example**:
  ```markdown
  :::info Getting Your Authentication Token
  To obtain your authentication token, please contact the ZIGChain team.
  :::
  ```

### Links

- **Internal links**: Use relative paths `[Link text](./relative/path.md)`
- **External links**: Use full URLs `[Link text](https://example.com)`
- **Avoid**: "See above" or "as mentioned earlier" - use explicit links

---

## Example Outline

```markdown
# Staking on ZIGChain

ZIGChain Staking is a decentralized process that enables users to **enhance the network's security** and **governance** by delegating their ZIG tokens to validators. In return, **participants earn rewards** for their contributions.

<div class="spacer"></div>

## Key Components of Staking on ZIGChain

Staking on ZIGChain revolves around two key participants:

### Validators

Validators are node operators who:
- Validate transactions, create new blocks, and secure the network
- Maintain secure, highly available infrastructure
- Earn rewards from transaction fees and block rewards

### Delegators

Delegators are ZIG holders who:
- Participate in network security without operating validator infrastructure
- Contribute to decentralization by delegating tokens to validators
- Earn a portion of block rewards and transaction fees

<div class="spacer"></div>

## How Staking Works on ZIGChain

Staking on ZIGChain follows these steps:

1. **Select a Validator**: Choose from available validators
2. **Delegate ZIG Tokens**: Delegate your tokens using CLI or wallet
3. **Earn Rewards**: Rewards are distributed automatically
4. **Unstake**: Withdraw tokens after unbonding period

<div class="spacer"></div>

## Security Measures: Slashing and Penalties

While staking on ZIGChain is rewarding, it also comes with inherent risks due to slashing mechanisms.

### Types of Slashing Events

- **Double Signing**: Severe penalty (5% slash)
- **Downtime**: Minor penalty (0.01% slash)

<div class="spacer"></div>
```

---

## Best Practices

1. **Start with context**: Always provide context about why the feature exists and who it's for
2. **Use clear headings**: H2 for major topics, H3 for sub-topics
3. **Include examples**: Real-world examples help users understand concepts
4. **Link to related docs**: Use `relatedDocs` in frontmatter and inline links
5. **Use visual separators**: Spacers help break up long content
6. **Keep it scannable**: Use lists, short paragraphs, and clear headings

## Common Mistakes to Avoid

1. **Mixing templates**: Don't include detailed setup steps in a user guide (use setup-guide-template)
2. **Missing spacers**: Long walls of text without visual breaks
3. **Inconsistent heading levels**: Jumping from H2 to H4 without H3
4. **Vague links**: Using "see above" instead of explicit links
5. **Too much detail**: User guides should explain concepts, not provide exhaustive technical details
6. **Missing context**: Starting with technical details before explaining what the feature is

---

## Sample Documents

Best examples of this template:
- `docs/users/staking/staking.md`
- `docs/about-zigchain/zigchain.md`
- `docs/users/hub/staking.md`
- `docs/users/hub/bridge.md`
- `docs/about-zigchain/accounts.md`
