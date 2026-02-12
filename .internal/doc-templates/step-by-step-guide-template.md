# Step-by-Step Guide Template

**Template Name**: `step-by-step-guide-template`
**Version**: 1.0
**Last Updated**: 2026-01-28
**Purpose**: Detailed procedural guides with numbered steps and sub-steps.

---

## Purpose

Step-by-step guides provide detailed procedural instructions with numbered steps and sub-steps.

**Use this template when:**
- Providing detailed procedural instructions
- Walking users through a specific process
- Creating tutorials with numbered steps
- Documenting workflows that must be followed in order

**Do NOT use this template for:**
- Quick installation (use `quick-start-template`)
- Infrastructure setup (use `setup-guide-template`)
- Feature explanations (use `user-guide-template`)

---

## Frontmatter

### Required Keys

- `title` (string): The main title (often includes "Guide" or "Step-by-Step")
- `description` (string): Brief description mentioning it's a step-by-step guide
- `keywords` (array): Array of relevant keywords
- `sidebar_position` (number): Position in the sidebar

### Optional Keys

- `tags` (array): Additional tags
- `relatedDocs` (array): Links to related documentation

### Example

```yaml
---
title: Governance Proposal Submission Guide
description: Step-by-step guide to creating and submitting governance proposals on ZIGChain, including proposal drafting, metadata creation, transaction submission, and best practices.
keywords:
  [
    governance proposal,
    submit proposal,
    proposal guide,
    on-chain proposal,
    proposal metadata,
  ]
sidebar_position: 2
tags:
  - governance
  - step-by-step
relatedDocs:
  - ../governance/index.md
---
```

---

## Content Structure

### Required Sections (in order)

1. **Main Title** (`# [Title]`)
   - Must match the `title` in frontmatter

2. **Context and Introduction**
   - What this guide covers
   - Prerequisites or background needed
   - Link to related concepts if needed

3. **Detailed Steps Section** (`## Detailed Steps for [Action]`)
   - Main section containing all steps

4. **Numbered Steps** (`### 1️⃣ [Step Name]`)
   - Use emoji indicators (1️⃣, 2️⃣, 3️⃣, etc.)
   - Clear step names

5. **Sub-steps** (`**1.1 [Sub-step]**`)
   - Bold sub-step headings
   - Detailed instructions within each step

### Optional Sections

- Prerequisites
- Troubleshooting
- Best Practices
- References
- Additional Notes

---

## Patterns and Conventions

### Numbered Steps

- **Format**: Use emoji indicators (1️⃣, 2️⃣, 3️⃣, etc.) in H3 headings
- **Example**: `### 1️⃣ Draft a Proposal`
- **Purpose**: Visual indicators make steps easy to scan

### Sub-steps

- **Format**: Bold text with numbering (`**1.1 [Sub-step]**`)
- **Example**: `**1.1 Run the Draft Command**`
- **Purpose**: Break down complex steps into smaller actions

### Code Blocks

- **When to use**: Commands, examples, configuration
- **Language tags**: `bash`, `sh`, `yaml`, `json`
- **Format**: Include context before code blocks

### Images

- **When to use**: Screenshots of UI, process diagrams
- **Format**: `![Description](./path/to/image.png)`
- **Placement**: After relevant text explaining the step

### Tabs

- **When to use**: Different options or methods for a step
- **groupId**: Context-specific (e.g., `"method"`, `"option"`)
- **Example**:
  ```markdown
  <Tabs groupId="method">
    <TabItem value="CLI" label="CLI" default>
    [CLI method]
    </TabItem>
    <TabItem value="UI" label="Web UI">
    [Web UI method]
    </TabItem>
  </Tabs>
  ```

### Alerts

- **When to use**: Important notes, warnings, tips
- **Types**: `:::info`, `:::warning`, `:::tip`
- **Example**:
  ```markdown
  :::tip Pro Tip
  Use the arrow keys to navigate and Enter to select.
  :::
  ```

### Spacers

- **When to use**: Between major sections
- **Format**: `<div class="spacer"></div>`

---

## Example Outline

```markdown
# Governance Proposal Submission Guide

ZIGChain governance is the backbone of the network's decentralized decision-making. Through governance, ZIG holders who have staked their tokens with active validators can influence the future of the protocol.

If you're new to governance, we recommend first reading the [Governance](../governance) documentation for better understanding of the proposal lifecycle and components, voting rules, and special cases.

Once you're familiar with the concepts, this guide will help you take the next step: actually creating and submitting a proposal on-chain.

In this guide, we focus on the practical side of governance — walking through each step from drafting a proposal to submitting it on-chain. By the end, you'll know how to transform an idea into a formal proposal ready for the community to review and vote on.

<div class="spacer"></div>

## Detailed Steps for Submitting a Proposal

### 1️⃣ Draft a Proposal

To draft a proposal, follow these steps:

**1.1 Run the Draft Command**

Use the following command to start the proposal draft process:

```sh
zigchaind tx gov draft-proposal
```

---

**1.2 Select Proposal Type**

You'll be prompted to select the type of proposal. The interface displays common options such as:

```
? Select proposal type:
  ▸ text
    community-pool-spend
    software-upgrade
    cancel-software-upgrade
    other
```

:::tip Pro Tip
Use the arrow keys to navigate and **Enter** to select.
:::

![Draft Proposal](./img/proposal_guide/draft_proposal.png)

If the type of proposal you need is not listed (for example, if you are modifying module parameters), select `other`.

---

**1.3 Provide Metadata**

After selecting, you'll be asked to fill in the required fields, such as:

- Title
- Summary
- Description
- Other fields (As requested by the interface.)

![Provide Metadata](./img/proposal_guide/metadata.png)

<div class="spacer"></div>

### 2️⃣ Review and Submit

**2.1 Review Your Proposal**

[Content]

**2.2 Submit the Transaction**

[Content]
```

---

## Best Practices

1. **Clear numbering**: Use emoji indicators for visual clarity
2. **Break down steps**: Use sub-steps for complex actions
3. **Include context**: Explain why each step is needed
4. **Visual aids**: Use screenshots for UI-based steps
5. **Verification**: Show how to verify each step completed
6. **Error handling**: Address what to do if a step fails

## Common Mistakes to Avoid

1. **Unclear steps**: Vague or ambiguous instructions
2. **Missing context**: Not explaining why a step is needed
3. **No verification**: Not showing how to verify steps completed
4. **Too many sub-steps**: Over-complicating simple actions
5. **Missing prerequisites**: Not listing what's needed before starting
6. **No troubleshooting**: Not addressing common issues

---

## Sample Documents

Best examples of this template:
- `docs/users/governance/proposal-guide.md`
- `docs/users/staking/how-to-claim-bsc-zig-rewards.md`
- `docs/users/staking/how-to-unstake-from-old-staking-program.md`
