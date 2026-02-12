# AI QA Instructions for ZIGChain

Use this file together with `@.internal/technical-questions` and `@docs` when answering questions about ZIGChain. Follow the rules below for every answer.

---

## Sources

- Use **`.internal/technical-questions`** and **`docs`** to answer.
- Prefer **technical-questions** for canonical answers.
- Use **docs** for deeper context and for building customer-facing documentation links.

---

## Answer Format (Two Parts)

Every answer must have **two parts**:

1. **Internal**

   - Where the information was found (file and section or Q&A title).
   - A short, general explanation.

2. **Customer facing**
   - One or two short, direct, clear sentences that can be shared with customers as-is.

**Example:**

- **Internal:** Found in `.internal/technical-questions/01-chain-fundamentals-and-consensus.md` under "Does ZIGChain use a UTXO or account-based model?". ZIGChain uses the Cosmos SDK account model.
- **Customer facing:** ZIGChain uses an account-based model (like Ethereum), not a UTXO model. Your balance is stored per account and you send transactions from that account.

---

## Missing Questions

If **no answer** exists in technical-questions (and the answer is not reasonably derivable from docs):

1. **Append** the question to **`.internal/technical-questions/Missing Questions.md`** (same folder as `01-...`, `02-...`).
2. In your reply, you may state that the question was added to Missing Questions for later coverage.

---

## Duplicates

If **more than one** Q&A covers the same or a very similar question:

- **Merge** into the broader or more relevant entry.
- **Remove** the narrower or less relevant entry.
- Keep the **more relevant or broader** answer.

---

## Doc URLs

When referring to any article under **`docs/`**:

- **Base URL:** `https://docs.zigchain.com/`
- **Rule:** For a file under repo `docs/`, the URL is:  
  `https://docs.zigchain.com/` + path with the `docs/` prefix removed and the `.md` extension removed.

**Examples:**

| Repo path                                    | URL                                                          |
| -------------------------------------------- | ------------------------------------------------------------ |
| `docs/builders/dex.md`                       | https://docs.zigchain.com/builders/dex                       |
| `docs/users/wallet-setup/zigchain-wallet.md` | https://docs.zigchain.com/users/wallet-setup/zigchain-wallet |
| `docs/about-zigchain/fees.md`                | https://docs.zigchain.com/about-zigchain/fees                |
| `docs/nodes-and-validators/setup-node.md`    | https://docs.zigchain.com/nodes-and-validators/setup-node    |
| `docs/integration-guides/endpoints.md`       | https://docs.zigchain.com/integration-guides/endpoints       |

**Route mapping** (from Docusaurus): `docs/about-zigchain` → `/about-zigchain/`, `docs/users` → `/users/`, `docs/integration-guides` → `/integration-guides/`, `docs/nodes-and-validators` → `/nodes-and-validators/`, `docs/builders` → `/builders/`, `docs/wealth-management-engine` → `/wealth-management-engine/`.
