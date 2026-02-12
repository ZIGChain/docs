# Index Template

**Template Name**: `index-template`
**Version**: 1.0
**Last Updated**: 2026-01-28
**Purpose**: Landing pages and index documents that organize documentation sections and provide navigation.

---

## Purpose

Index and landing pages organize documentation sections and provide navigation to related content.

**Use this template when:**
- Creating section landing pages
- Organizing related documentation
- Providing navigation to multiple related documents
- Creating table of contents for a section

**Do NOT use this template for:**
- Feature documentation (use `user-guide-template`)
- Setup instructions (use `setup-guide-template`)
- Detailed guides (use other templates)

---

## Frontmatter

### Required Keys

- `title` (string): The section title
- `description` (string): Brief description of the section
- `keywords` (array): Array of relevant keywords
- `sidebar_position` (number): Position in the sidebar (often 1 for index pages)

### Optional Keys

- `tags` (array): Additional tags

### Example

```yaml
---
title: About ZIGChain
description: Foundational guides to understand ZIGChain, a Layer 1 blockchain focused on unlocking financial opportunities. Learn about the ZIG token, accounts, fees, and core concepts.
keywords:
  [
    ZIGChain,
    ZIGChain blockchain,
    ZIGChain L1 blockchain,
    ZIG token,
    ZIGChain accounts,
  ]
sidebar_position: 1
---
```

---

## Content Structure

### Required Sections (in order)

1. **Main Title** (`# [Title]`)
   - Must match the `title` in frontmatter
   - Section name

2. **Brief Description Paragraph**
   - 1-3 sentences describing what this section covers
   - Context for the section

3. **Category Headings** (`## [Category Name]`)
   - H2 headings for each category of documents
   - Logical grouping of related documents

4. **Bulleted Lists of Links**
   - Links to related documents
   - Use descriptive link text
   - Relative paths to documents

### Optional Sections

- Additional categories
- Related Resources
- Quick Links

---

## Patterns and Conventions

### Links

- **Internal links**: Use relative paths `[Link text](./relative/path.md)`
- **External links**: Use full URLs `[Link text](https://example.com)`
- **Format**: Descriptive link text that explains what the document covers
- **Example**:
  ```markdown
  - [Set Up a ZIGChain Wallet](./wallet-setup/zigchain-wallet.md)
  - [Set Up Ledger Wallet for ZIGChain](./wallet-setup/ledger.md)
  ```

### Lists

- **Format**: Bulleted lists (`-`) for document links
- **Organization**: Group related documents together
- **Order**: Logical order (alphabetical, by importance, or by workflow)

### Minimal Elements

- **Code blocks**: Rarely used in index pages
- **Tabs**: Not typically used
- **Images**: Only if needed for visual organization
- **Spacers**: Not typically needed due to short content

---

## Example Outline

```markdown
# About ZIGChain

ZIGChain is a Layer 1 blockchain focused on unlocking financial opportunities for everyone. This section provides foundational guides to help you understand the protocol, its core concepts, and the ZIG token.

## Foundational Concepts

- [ZIGChain – What and Why?](./zigchain.md)
- [The ZIG Token](./zig.md)
- [ZIGChain Accounts](./accounts.md)
- [Gas Fees on ZIGChain](./fees.md)
- [ZIGChain Glossary](./glossary.md)

## Community

- [Community & Support](./community-support.md)
```

---

## Best Practices

1. **Clear organization**: Group related documents logically
2. **Descriptive links**: Use link text that explains what each document covers
3. **Brief descriptions**: Keep the introduction short and focused
4. **Logical order**: Order documents by importance or workflow
5. **Consistent formatting**: Use consistent list formatting
6. **Complete coverage**: Include all major documents in the section

## Common Mistakes to Avoid

1. **Too much content**: Index pages should be brief, not comprehensive guides
2. **Missing documents**: Not including all relevant documents in the section
3. **Vague link text**: Using generic text like "Click here" instead of descriptive text
4. **No organization**: Random order instead of logical grouping
5. **Broken links**: Not maintaining links when documents are moved
6. **Too many categories**: Over-organizing with too many sub-categories

---

## Sample Documents

Best examples of this template:
- `docs/about-zigchain/index.md`
- `docs/users/index.md`
- `docs/builders/index.md`
- `docs/nodes-and-validators/index.md`
- `docs/users/hub/index.md`
