import type { SidebarsConfig } from "@docusaurus/plugin-content-docs";

const sidebars: SidebarsConfig = {
  usersSidebar: [
    "index",
    {
      type: "category",
      label: "Wallet Setup",
      items: ["wallet-setup/zigchain-wallet", "wallet-setup/ledger"],
    },
    {
      type: "category",
      label: "Staking",
      items: [
        "staking/staking",
        "staking/staking-apr",
        "staking/staking-redelegation",
        "staking/how-to-unstake-from-old-staking-program",
        "staking/how-to-claim-bsc-zig-rewards",
      ],
    },
    {
      type: "category",
      label: "Governance",
      items: [
        "governance/index",
        "governance/proposal-guide",
        "governance/delegators_faq",
        "governance/multisig-transactions",
      ],
    },
    {
      type: "category",
      label: "ZIGChain Hub",
      items: [
        "hub/index",
        "hub/bridge",
        "hub/claim-rewards",
        "hub/proposals",
        "hub/staking",
      ],
    },
    {
      type: "category",
      label: "User Tools",
      items: ["tools/block-explorers", "tools/staking-platform"],
    },
  ],
};

export default sidebars;
