import type { SidebarsConfig } from "@docusaurus/plugin-content-docs";

const sidebars: SidebarsConfig = {
  nodesSidebar: [
    "index",
    {
      type: "category",
      label: "Run a Node",
      items: ["setup-node", "state-sync", "reset_os_keyring_passphrase"],
    },
    {
      type: "category",
      label: "Run a Validator",
      items: [
        "validators",
        "setup-validator",
        "validators-faq",
        "validators-quick-sheet",
        "cosmovisor-howto-guide",
        "upgrade-node",
        "multivalidator-setup",
      ],
    },
    {
      type: "category",
      label: "Key Management",
      items: ["tmkms-setup"],
    },
    {
      type: "category",
      label: "Validator Security",
      items: [
        "zigchain_monitoring_overview",
        "validator-security-checklist",
        "sna-guide",
      ],
    },
  ],
};

export default sidebars;
