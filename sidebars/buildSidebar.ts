import type { SidebarsConfig } from "@docusaurus/plugin-content-docs";

const sidebars: SidebarsConfig = {
  buildSidebar: [
    "index",
    "quick-start",
    {
      type: "category",
      label: "Chain Development (Go)",
      items: [
        "modules",
        {
          type: "category",
          label: "Modules",
          items: [
            "consensus-module",
            "distribution-module",
            "governance-module",
            "mint-module",
            "slashing-module",
            "staking-module",
            { type: "doc", id: "dex", label: "ZIGChain Module - DEX" },
            {
              type: "doc",
              id: "factory",
              label: "ZIGChain Module - Token Factory",
            },
            {
              type: "doc",
              id: "token-wrapper-module",
              label: "ZIGChain Module - Token Wrapper",
            },
          ],
        },
      ],
    },
    {
      type: "category",
      label: "Smart Contracts",
      items: ["cosmwasm-module", "cosmwasm-whitelisting"],
    },
    {
      type: "category",
      label: "React SDK",
      items: [
        "react-sdk/introduction",
        "react-sdk/provider",
        {
          type: "category",
          label: "Hooks",
          items: [
            "react-sdk/hooks/useZigchain",
            "react-sdk/hooks/useZigchainClient",
            "react-sdk/hooks/useAddChain",
            "react-sdk/hooks/useBalances",
            "react-sdk/hooks/useCreateToken",
            "react-sdk/hooks/usePoolId",
            "react-sdk/hooks/usePools",
            "react-sdk/hooks/useQuery",
            "react-sdk/hooks/useTokenMetadata",
            "react-sdk/hooks/useTokenTableData",
            "react-sdk/hooks/useTx",
          ],
        },
        {
          type: "category",
          label: "UI Components",
          items: ["react-sdk/ui-components/ZigchainAddressAvatar"],
        },
        {
          type: "category",
          label: "Utils",
          items: ["react-sdk/utils/shortenAddress"],
        },
      ],
    },
    {
      type: "category",
      label: "ZIGChain JS SDK",
      items: ["js-sdk/introduction"],
    },
    {
      type: "category",
      label: "Developer Tools",
      items: ["developer-tools/developer-resources"],
    },
    {
      type: "link",
      label: "Testnet Faucet",
      href: "https://faucet.zigchain.com",
    },
  ],
};

export default sidebars;
