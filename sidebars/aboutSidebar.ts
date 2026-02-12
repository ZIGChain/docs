import type { SidebarsConfig } from "@docusaurus/plugin-content-docs";

const sidebars: SidebarsConfig = {
  aboutSidebar: [
    "index",
    {
      type: "category",
      label: "Foundational Concepts",
      items: ["zigchain", "zig", "accounts", "fees", "glossary"],
    },
    {
      type: "category",
      label: "Community",
      items: ["community-support"],
    },
  ],
};

export default sidebars;
