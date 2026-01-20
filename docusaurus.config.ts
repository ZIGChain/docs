import type * as Preset from "@docusaurus/preset-classic";
import type { Config } from "@docusaurus/types";
import { themes as prismThemes } from "prism-react-renderer";

// This runs in Node.js - Don't use client-side code here (browser APIs, JSX...)

const config: Config = {
  title: "ZIGChain",
  tagline:
    "ZIGChain is a Layer 1 blockchain focused on unlocking financial opportunities for everyone - regardless of their income, location, or level of knowledge.",
  favicon: "img/favicon.ico",

  // Set the production url of your site here
  url: "https://docs.zigchain.com/",
  // Set the /<baseUrl>/ pathname under which your site is served
  // For GitHub pages deployment, it is often '/<projectName>/'
  baseUrl: "/",
  deploymentBranch: "gh-pages",

  // GitHub pages deployment config.
  // If you aren't using GitHub pages, you don't need these.
  organizationName: "ZIGChain", // Usually your GitHub org/user name.
  projectName: "docs", // Usually your repo name.

  onBrokenLinks: "throw",
  onBrokenMarkdownLinks: "warn",

  // Even if you don't use internationalization, you can use this field to set
  // useful metadata like html lang. For example, if your site is Chinese, you
  // may want to replace "en" with "zh-Hans".
  i18n: {
    defaultLocale: "en",
    locales: ["en"],
  },

  presets: [
    [
      "classic",
      {
        docs: {
          path: "docs/landing",
          sidebarPath: false,
          routeBasePath: "/", // Serve the docs at the site's root
          lastVersion: "current",
          versions: {
            current: {
              label: "v2",
            },
            "1": {
              label: "v1",
              path: "v1",
            },
            "0": {
              label: "v0",
              path: "v0",
            },
          },
        },
        theme: {
          customCss: "./src/css/custom.css",
        },
        blog: false,
      } satisfies Preset.Options,
    ],
  ],
  plugins: [
    [
      "@docusaurus/plugin-content-docs",
      {
        id: "about",
        path: "docs/about-zigchain",
        routeBasePath: "about-zigchain",
        sidebarPath: require.resolve("./sidebars/aboutSidebar.ts"),
      },
    ],
    [
      "@docusaurus/plugin-content-docs",
      {
        id: "users",
        path: "docs/users",
        routeBasePath: "users",
        sidebarPath: require.resolve("./sidebars/usersSidebar.ts"),
      },
    ],
    [
      "@docusaurus/plugin-content-docs",
      {
        id: "integration",
        path: "docs/integration-guides",
        routeBasePath: "integration-guides",
        sidebarPath: require.resolve("./sidebars/integrationSidebar.ts"),
      },
    ],
    [
      "@docusaurus/plugin-content-docs",
      {
        id: "nodes",
        path: "docs/nodes-and-validators",
        routeBasePath: "nodes-and-validators",
        sidebarPath: require.resolve("./sidebars/nodesSidebar.ts"),
      },
    ],
    [
      "@docusaurus/plugin-content-docs",
      {
        id: "build",
        path: "docs/builders",
        routeBasePath: "builders",
        sidebarPath: require.resolve("./sidebars/buildSidebar.ts"),
      },
    ],
    [
      "@docusaurus/plugin-content-docs",
      {
        id: "wealth",
        path: "docs/wealth-management-engine",
        routeBasePath: "wealth-management-engine",
        sidebarPath: require.resolve("./sidebars/wealthSidebar.ts"),
      },
    ],
  ],

  themeConfig: {
    colorMode: {
      defaultMode: "dark",
      disableSwitch: false,
      respectPrefersColorScheme: false,
    },
    // Replace with your project's social card
    image: "img/zigchain-social-card.png",
    navbar: {
      title: "",
      logo: {
        alt: "ZIGChain Logo",
        src: "img/zigchain-light.png",
        srcDark: "img/zigchain-dark.png",
      },
      items: [
        {
          position: "left",
          label: "About ZIGChain",
          to: "/about-zigchain/",
        },
        {
          position: "left",
          label: "Users",
          to: "/users/",
        },
        {
          position: "left",
          label: "Integration Guides",
          to: "/integration-guides/",
        },
        {
          position: "left",
          label: "Nodes and Validators",
          to: "/nodes-and-validators/",
        },
        {
          position: "left",
          label: "Builders",
          to: "/builders/",
        },
        {
          position: "left",
          label: "Wealth Management Engine",
          to: "/wealth-management-engine/",
          className: "navbar-item-hidden",
        },
        {
          type: "dropdown",
          label: "Resources",
          position: "right",
          items: [
            {
              label: "Discord",
              href: "https://discord.zignaly.com/",
              className: "discord-menu-item",
            },
            {
              label: "GitHub",
              href: "https://github.com/ZIGChain",
              className: "github-menu-item",
            },
            {
              label: "Keplr Wallet",
              href: "https://www.keplr.app/",
              className: "keplr-menu-item",
            },
            {
              label: "Leap Wallet",
              href: "https://www.leapwallet.io/",
              className: "leap-menu-item",
            },
            {
              label: "Range App Explorer",
              href: "https://app.range.org/",
              className: "range-menu-item",
            },
            {
              label: "ZIGChain",
              href: "https://zigchain.com/",
              className: "zigchain-menu-item",
            },
          ],
        },
        {
          type: "docsVersionDropdown",
          position: "right",
          dropdownActiveClassDisabled: true,
        },
      ],
    },
    footer: {
      style: "dark",
      links: [
        {
          title: "Tools",
          items: [
            {
              label: "Range Explorer",
              href: "https://app.range.org/",
            },
            {
              label: "Leap Wallet",
              href: "https://www.leapwallet.io/",
            },
          ],
        },
        {
          title: "Products",
          items: [
            {
              label: "Launch Hub",
              href: "https://hub.zigchain.com/",
            },
            {
              label: "Bridge",
              href: "https://hub.zigchain.com/bridge/",
            },
            {
              label: "Staking",
              href: "https://hub.zigchain.com/staking",
            },
            {
              label: "Governance",
              href: "https://hub.zigchain.com/proposals/",
            },
          ],
        },
        {
          title: "Community",
          items: [
            {
              label: "Discord",
              href: "https://discord.zignaly.com/",
            },
            {
              label: "Medium",
              href: "https://medium.com/@zignaly",
            },
            {
              label: "X",
              href: "https://x.com/zigchain",
            },
          ],
        },
        {
          title: "ZIG",
          items: [
            {
              label: "CMC",
              href: "https://coinmarketcap.com/currencies/zigcoin",
            },
            {
              label: "Coingecko",
              href: "https://www.coingecko.com/en/coins/zignaly",
            },
            {
              label: "DefiLlama",
              href: "https://defillama.com/chain/ZIGChain",
            },
          ],
        },
      ],
      copyright: `
      <div style="font-size: 12px;">
      <br />
      <b>ZIGCHAIN FOUNDATION</b>, Incorporated 25 April 2025 under Registration Number # 420931. Address: Citrus Grove, Ground Floor, 106 Goring, Avenue, George Town, PO Box; 31489, Grand Cayman KY1-1206 Cayman Islands.
      <br />
      Website Intellectual Property and Use Disclosure - ©️ <b>[2026]</b> ZIGCHAIN FOUNDATION All rights reserved. Our <a href="https://zigchain.com/legal/terms-and-conditions">Terms & Conditions</a>.
      </div>`,
    },
    prism: {
      theme: prismThemes.github,
      darkTheme: prismThemes.dracula,
    },
    algolia: {
      // The application ID provided by Algolia
      appId: "6714JZHQCL",

      // Public API key: it is safe to commit it
      apiKey: "d09b96590725865c24305e7de17ac5d8",

      indexName: "zigchain",

      // Optional: see doc section below
      contextualSearch: true,

      // Optional: Specify domains where the navigation should occur through window.location instead on history.push. Useful when our Algolia config crawls multiple documentation sites and we want to navigate with window.location.href to them.
      externalUrlRegex: "external\\.com|domain\\.com",

      // Optional: Replace parts of the item URLs from Algolia. Useful when using the same search index for multiple deployments using a different baseUrl. You can use regexp or string in the `from` param. For example: localhost:3000 vs myCompany.com/docs
      replaceSearchResultPathname: {
        from: "/docs/", // or as RegExp: /\/docs\//
        to: "/",
      },

      // Optional: Algolia search parameters
      searchParameters: {},

      // Optional: path for search page that enabled by default (`false` to disable it)
      searchPagePath: "search",

      // Optional: whether the insights feature is enabled or not on Docsearch (`false` by default)
      insights: false,

      //... other Algolia params
    },
  } satisfies Preset.ThemeConfig,
};

export default config;
