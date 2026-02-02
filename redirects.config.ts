/**
 * Old paths (v1/v0) → current v2 routes.
 * Filter REDIRECT_ENTRIES by version.docs in components for reverse lookup.
 */

export type RedirectEntry = { from: string; to: string };

const bulk = (pairs: [string, string][]): RedirectEntry[] =>
  pairs.map(([from, to]) => ({ from, to }));

export const REDIRECT_ENTRIES: RedirectEntry[] = [
  ...bulk([
    ["/general/zig", "/about-zigchain/zig"],
    ["/general/zigchain", "/about-zigchain/zigchain"],
    ["/general/accounts", "/about-zigchain/accounts"],
    ["/general/fees", "/about-zigchain/fees"],
    ["/general/glossary", "/about-zigchain/glossary"],
    ["/general/community-support", "/about-zigchain/community-support"],
    ["/general/delegators_faq", "/users/governance/delegators_faq"],
    ["/general/zigchain-wallet", "/users/wallet-setup/zigchain-wallet"],
    ["/general/add-testnet", "/users/wallet-setup/zigchain-wallet"],
    ["/general/ledger", "/users/wallet-setup/ledger"],
    ["/general/governance/governance", "/users/governance/"],
    ["/general/governance/proposal-guide", "/users/governance/proposal-guide"],
    ["/general/governance/delegators_faq", "/users/governance/delegators_faq"],
    [
      "/general/multisig-transactions",
      "/users/governance/multisig-transactions",
    ],
    [
      "/general/how-to-claim-bsc-zig-rewards",
      "/users/staking/how-to-claim-bsc-zig-rewards",
    ],
    [
      "/general/how-to-unstake-from-old-staking-program",
      "/users/staking/how-to-unstake-from-old-staking-program",
    ],
    ["/general/staking", "/users/staking/"],
    ["/general/staking/staking", "/users/staking/"],
    ["/general/staking/staking-apr", "/users/staking/staking-apr"],
    [
      "/general/staking/staking-redelegation",
      "/users/staking/staking-redelegation",
    ],
    ["/resources/community-support", "/about-zigchain/community-support"],
  ]),
  ...bulk([
    ["/build/quick-start", "/builders/quick-start"],
    ["/build/modules", "/builders/modules"],
    ["/build/consensus-module", "/builders/consensus-module"],
    ["/build/distribution-module", "/builders/distribution-module"],
    ["/build/governance-module", "/builders/governance-module"],
    ["/build/mint-module", "/builders/mint-module"],
    ["/build/slashing-module", "/builders/slashing-module"],
    ["/build/staking-module", "/builders/staking-module"],
    ["/build/dex", "/builders/dex"],
    ["/build/factory", "/builders/factory"],
    ["/build/token-wrapper-module", "/builders/token-wrapper-module"],
    ["/build/cosmwasm-module", "/builders/cosmwasm-module"],
    ["/build/cosmwasm-whitelisting", "/builders/cosmwasm-whitelisting"],
    ["/build/endpoints", "/integration-guides/endpoints"],
    ["/build/ibc-channel-list", "/integration-guides/ibc-channel-list"],
    [
      "/build/display-tokens-on-wallets",
      "/integration-guides/register-your-token-in-cosmos-wallets",
    ],
    [
      "/build/multivalidator-setup",
      "/nodes-and-validators/multivalidator-setup",
    ],
  ]),
  ...bulk([
    ["/nodes_validators/setup-node", "/nodes-and-validators/setup-node"],
    [
      "/nodes_validators/setup-validator",
      "/nodes-and-validators/setup-validator",
    ],
    ["/nodes_validators/validators", "/nodes-and-validators/validators"],
    [
      "/nodes_validators/validators-faq",
      "/nodes-and-validators/validators-faq",
    ],
    [
      "/nodes_validators/validators-quick-sheet",
      "/nodes-and-validators/validators-quick-sheet",
    ],
    [
      "/nodes_validators/cosmovisor-howto-guide",
      "/nodes-and-validators/cosmovisor-howto-guide",
    ],
    [
      "/nodes_validators/reset_os_keyring_passphrase",
      "/nodes-and-validators/reset_os_keyring_passphrase",
    ],
    ["/nodes_validators/tmkms-setup", "/nodes-and-validators/tmkms-setup"],
    ["/nodes_validators/state-sync", "/nodes-and-validators/state-sync"],
    ["/nodes_validators/sna-guide", "/nodes-and-validators/sna-guide"],
    [
      "/nodes_validators/validator-security-checklist",
      "/nodes-and-validators/validator-security-checklist",
    ],
    [
      "/nodes_validators/zigchain_monitoring_overview",
      "/nodes-and-validators/zigchain_monitoring_overview",
    ],
  ]),
  ...bulk([
    ["/zigchain_hub", "/users/hub/"],
    ["/zigchain_hub/index", "/users/hub/"],
    ["/zigchain_hub/staking", "/users/hub/staking"],
    ["/zigchain_hub/proposals", "/users/hub/proposals"],
    ["/zigchain_hub/bridge", "/users/hub/bridge"],
    ["/zigchain_hub/claim-rewards", "/users/hub/claim-rewards"],
  ]),
  ...bulk([
    ["/resources/block-explorers", "/users/tools/block-explorers"],
    ["/resources/staking-platform", "/users/tools/staking-platform"],
    [
      "/resources/developer-resources",
      "/builders/developer-tools/developer-resources",
    ],
    ["/resources/hub", "/users/hub/"],
    ["/resources/faucet", "/builders/quick-start"],
    ["/resources/wallets", "/users/wallet-setup/zigchain-wallet"],
  ]),
  ...bulk([
    ["/zigchain-sdk", "/builders/react-sdk/introduction"],
    ["/zigchain-sdk/introduction", "/builders/react-sdk/introduction"],
    ["/zigchain-sdk/provider", "/builders/react-sdk/provider"],
    [
      "/zigchain-sdk/hooks/useAddChain",
      "/builders/react-sdk/hooks/useAddChain",
    ],
    [
      "/zigchain-sdk/hooks/useBalances",
      "/builders/react-sdk/hooks/useBalances",
    ],
    [
      "/zigchain-sdk/hooks/useCreateToken",
      "/builders/react-sdk/hooks/useCreateToken",
    ],
    ["/zigchain-sdk/hooks/usePoolId", "/builders/react-sdk/hooks/usePoolId"],
    ["/zigchain-sdk/hooks/usePools", "/builders/react-sdk/hooks/usePools"],
    ["/zigchain-sdk/hooks/useQuery", "/builders/react-sdk/hooks/useQuery"],
    [
      "/zigchain-sdk/hooks/useTokenMetadata",
      "/builders/react-sdk/hooks/useTokenMetadata",
    ],
    [
      "/zigchain-sdk/hooks/useTokenTableData",
      "/builders/react-sdk/hooks/useTokenTableData",
    ],
    ["/zigchain-sdk/hooks/useTx", "/builders/react-sdk/hooks/useTx"],
    [
      "/zigchain-sdk/hooks/useZigchain",
      "/builders/react-sdk/hooks/useZigchain",
    ],
    [
      "/zigchain-sdk/hooks/useZigchainClient",
      "/builders/react-sdk/hooks/useZigchainClient",
    ],
    [
      "/zigchain-sdk/ui-components/ZigchainAddressAvatar",
      "/builders/react-sdk/ui-components/ZigchainAddressAvatar",
    ],
    [
      "/zigchain-sdk/utils/shortenAddress",
      "/builders/react-sdk/utils/shortenAddress",
    ],
  ]),
  ...bulk([
    ["/category/zigchain-overview", "/about-zigchain/"],
    ["/category/builders", "/builders/"],
    ["/intro", "/"],
    ["/zigchainjs", "/builders/js-sdk/introduction"],
    ["/zigchainjs/introduction", "/builders/js-sdk/introduction"],
  ]),
  ...bulk([
    ["/tutorials", "/"],
    ["/tutorials/tutorials", "/"],
    [
      "/tutorials/add-zigchain-to-wallet",
      "/users/wallet-setup/zigchain-wallet",
    ],
    ["/tutorials/faucet", "/builders/quick-start"],
    ["/tutorials/token-factory", "/builders/factory"],
  ]),
];

export const REDIRECT_MAP: Record<string, string> = Object.fromEntries(
  REDIRECT_ENTRIES.map((e) => [e.from, e.to]),
);
