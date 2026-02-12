# FAQ Template

**Template Name**: `faq-template`
**Version**: 1.0
**Last Updated**: 2026-01-28
**Purpose**: Frequently asked questions documents organized in question-answer format.

---

## Purpose

FAQ documents answer common questions in a clear question-answer format.

**Use this template when:**
- Answering frequently asked questions
- Providing quick answers to common queries
- Creating reference documents for common topics
- Documenting common concerns or issues

**Do NOT use this template for:**
- Detailed guides (use `user-guide-template` or `setup-guide-template`)
- Step-by-step procedures (use `step-by-step-guide-template`)
- Quick command references (use `quick-reference-template`)

---

## Frontmatter

### Required Keys

- `title` (string): FAQ title (typically "[Topic] FAQ")
- `description` (string): Brief description mentioning it's an FAQ
- `keywords` (array): Array of relevant keywords including "FAQ"
- `sidebar_position` (number): Position in the sidebar

### Optional Keys

- `tags` (array): Additional tags (e.g., `["faq", "validators", "staking"]`)

### Example

```yaml
---
title: Validators FAQ
description: Frequently asked questions about ZIGChain validators including validator selection, staking requirements, rewards, slashing risks, commission rates, and operational best practices.
keywords:
  [
    ZIGChain validators FAQ,
    ZIGChain validator,
    ZIGChain active validators,
    ZIGChain validator requirements,
    ZIGChain validator selection,
  ]
sidebar_position: 2
tags:
  - faq
  - validators
---
```

---

## Content Structure

### Required Sections (in order)

1. **Main Title** (`# [Title]`)
   - FAQ title
   - Must match the `title` in frontmatter

2. **Questions as H2 Headings** (`## [Question]`)
   - Each question is an H2 heading
   - Questions should be clear and specific
   - Use question format (ending with "?")

3. **Answer Paragraphs**
   - Answer follows each question heading
   - Can be multiple paragraphs
   - Use lists, code blocks, or tables as needed

### Optional Sections

- Related Topics
- Additional Resources
- See Also

---

## Patterns and Conventions

### Questions as H2

- **Format**: Clear question format ending with "?"
- **Example**: `## What is a Validator?`
- **Purpose**: Makes questions easy to scan and find

### Code Blocks

- **When to use**: Command examples in answers
- **Language tags**: `bash`, `sh`, `json`
- **Format**: Include context explaining the command

### Tabs

- **When to use**: Different scenarios or networks in answers
- **groupId**: Context-specific (e.g., `"network"`, `"scenario"`)
- **Example**:
  ```markdown
  <Tabs groupId="network">
    <TabItem value="Mainnet" label="Mainnet" default>
    [Mainnet-specific answer]
    </TabItem>
    <TabItem value="Testnet" label="Testnet">
    [Testnet-specific answer]
    </TabItem>
  </Tabs>
  ```

### Lists

- **When to use**: Multiple points in answers
- **Format**: Bulleted or numbered lists
- **Example**:
  ```markdown
  Validators can exist in three states:

  1. **Unbonded**: Not in the Active Set
  2. **Bonded**: In the Active Set
  3. **Unbonding**: Transitioning out of Active Set
  ```

### Links

- **When to use**: Links to related documentation
- **Format**: Internal relative links
- **Example**: `For more details, see the [Validator Setup Guide](./setup-validator.md)`

### Spacers

- **When to use**: Between major question sections (optional)
- **Format**: `<div class="spacer"></div>`

---

## Example Outline

```markdown
# Validators FAQ

## What is a Validator?

A validator is a full node in the ZIGChain blockchain that participates in the consensus process by proposing new blocks and validating transactions. ZIGChain operates under a Proof-of-Stake (PoS) consensus mechanism, where validators are selected based on their staked tokens — either their own tokens or those delegated by other participants.

**Active Validators** are the network's top token holders responsible for **securing and processing** transactions on the blockchain. Their ranking depends on the **total stake**, including their **self-stake and delegated tokens**.

## How Validators Are Selected

ZIGChain selects its active validators based on the **total staked ZIG tokens**, which includes both self-delegated and delegated tokens. The top `N` validators with the highest total stake form the **Active Validator Set** — these validators are responsible for proposing blocks and earning rewards.

To be eligible for selection, a validator must meet the **minimum self-delegation requirement**, which currently stands at **100,000 ZIG**. This bond acts as a commitment mechanism and is enforced on-chain. Validators who do not meet this threshold will not be considered for the active set.

- The maximum number of active validators is defined by the `max_validators` chain parameter.
- Only active validators participate in consensus and earn block rewards.
- The minimum bond threshold and `max_validators` value can be updated through governance proposals.

### How Validator Selection Works

Validator selection is dynamic and happens at the end of every block, following the [Cosmos SDK v0.50 staking module](https://docs.cosmos.network/v0.50/build/modules/staking#end-block) logic. This means the active set may change block by block based on stake changes.

#### The process is as follows:

1. Fetch the maximum validator count from the `max_validators` parameter — for example, 4.
2. Sort all validators by their total staked power (both self and delegated), using `LastTotalPower` and `LastValidatorPower` values.
3. Select the top N validators as the new Active Validator Set.
4. Update validator statuses:
   - Validators entering the top N are marked as Bonded.
   - Validators leaving the top N are transitioned to Unbonding.

## Validator Unbonding

Delegators who choose to unstake their ZIG tokens must wait for a fixed unbonding period before their tokens become transferable. On ZIGChain, the standard unbonding period is **21 days**.

To maintain economic stability and avoid mass unbonding events, ZIGChain enforces a per-validator unbonding limit per block. This means only a portion of a validator's total delegations can be unbonded in a single block, ensuring gradual and secure exits.

## Validators Keys

Validators handle the following keys:

1. **Tendermint Consensus Key** (also known as the CometBFT key)
   - Purpose: Used to sign blocks.
   - Address prefix: `zigvalcons`
   - Public key prefix: `zigvalconspub`
   - Key type: `ed25519` (can be stored in Key Management System (KMS)).
   - Generated during: `zigchaind init process`.

2. **Validator Operator Application key**
   - Purpose: Used to create transactions that create or modify validator parameters.
   - Address prefix: `zigvaloper`.

3. **Validator Owner Key**
   - Purpose: Used to manage the validator and handle auto stake.
   - Address prefix: `zig`.

## Validator Statuses

Validators can exist in three states:

1. **Unbonded**:
   - Not in the Active Set
   - Cannot sign blocks
   - Earns no rewards
   - Can still receive delegations.

2. **Bonded**:
   - In the Active Set
   - Can sign blocks
   - Earns rewards
   - Can receive delegations.

3. **Unbonding**:
   - Transitioning out of the Active Set
   - Cannot sign blocks
   - Earns no rewards
   - Cannot receive new delegations
   - Must wait for unbonding period to complete.
```

---

## Best Practices

1. **Clear questions**: Use specific, clear questions that users would actually ask
2. **Comprehensive answers**: Provide complete answers, not just brief responses
3. **Logical order**: Organize questions by topic or workflow
4. **Use formatting**: Use lists, code blocks, and tables to make answers scannable
5. **Link to details**: Link to detailed guides when answers are brief
6. **Update regularly**: Keep FAQs current with common questions

## Common Mistakes to Avoid

1. **Vague questions**: Using generic questions that don't match user queries
2. **Incomplete answers**: Providing brief answers that don't fully address the question
3. **No organization**: Random order instead of logical grouping
4. **Missing context**: Not providing enough context in answers
5. **Outdated information**: Not keeping FAQs current
6. **No links**: Not linking to detailed documentation for complex topics

---

## Sample Documents

Best examples of this template:
- `docs/nodes-and-validators/validators-faq.md`
- `docs/users/governance/delegators_faq.md`
- `docs/about-zigchain/delegators_faq.md`
