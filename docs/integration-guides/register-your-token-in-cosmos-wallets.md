---
title: Register Your Token in Cosmos Wallets
description: Step-by-step guide to registering tokens in Cosmos chain registries for display in Keplr, Leap, and other Cosmos-compatible wallets with proper metadata.
keywords:
  [
    token registration,
    Cosmos chain registry,
    Keplr registry,
    wallet token display,
    token metadata,
    asset registration,
    chain registry,
    token visibility,
  ]
sidebar_position: 8
---

# Register Your Token in Cosmos Wallets

To make your dApp token nicely visible in wallets like Keplr, Leap, and other Cosmos-compatible wallets, they must be registered in the official chain registries for Testnet and Mainnet.

Without registration, wallets can’t display your token’s name, symbol, decimals, or logo — users will only see the raw factory denomination (e.g. coin.zig1abcd...xyz.panda). Registering your token ensures a professional user experience, increases trust, and allows your asset to be recognized across the Cosmos ecosystem.

<div class="spacer"></div>

## Chain Registries

The dApp token need to be added to two main registries:

1. **Keplr Chain Registry** - Used by Keplr wallet and other wallet applications
2. **Cosmos Chain Registry** - Used by various Cosmos ecosystem applications and tools

<div class="spacer"></div>

## Cosmos Chain Registry

The [Cosmos Chain Registry](https://github.com/cosmos/chain-registry) is the standard registry used by the broader Cosmos ecosystem. It provides comprehensive chain and asset metadata in a structured format.

### Registry URLs

#### Testnet

- **Repository**: [cosmos/chain-registry](https://github.com/cosmos/chain-registry)
- **Directory**: [testnets/zigchaintestnet](https://github.com/cosmos/chain-registry/tree/master/testnets/zigchaintestnet)
- **Asset List**: [testnets/zigchaintestnet/assetlist.json](https://github.com/cosmos/chain-registry/blob/master/testnets/zigchaintestnet/assetlist.json)

#### Mainnet

- **Repository**: [cosmos/chain-registry](https://github.com/cosmos/chain-registry)
- **Directory**: [zigchain](https://github.com/cosmos/chain-registry/tree/master/zigchain)
- **Asset List**: [zigchain/assetlist.json](https://github.com/cosmos/chain-registry/blob/master/zigchain/assetlist.json)

### Structure and Requirements

Assets are defined in `assetlist.json` files. Here's an example of a generic native token configuration:

```json
{
  "description": "Short Description about dApp Token",
  "denom_units": [
    {
      "denom": "coin.zig1abcdefghijklmnopqrstuvwxyz1234567890abcdef.dapptoken",
      "exponent": 0
    },
    {
      "denom": "millidapp",
      "exponent": 3,
      "aliases": ["mdapp"]
    },
    {
      "denom": "dapp",
      "exponent": 6
    }
  ],
  "base": "coin.zig1abcdefghijklmnopqrstuvwxyz1234567890abcdef.dapptoken",
  "name": "dApp Token",
  "display": "dapp",
  "symbol": "DAPP",
  "coingecko_id": "dapp-protocol",
  "keywords": [
    "dapp",
    "utility",
    "protocol",
    "governance",
    "defi",
    "ecosystem"
  ],
  "logo_URIs": {
    "png": "https://raw.githubusercontent.com/cosmos/chain-registry/master/testnets/dapptestnet/images/dapp.png",
    "svg": "https://raw.githubusercontent.com/cosmos/chain-registry/master/testnets/dapptestnet/images/dapp.svg"
  },
  "images": [
    {
      "png": "https://raw.githubusercontent.com/cosmos/chain-registry/master/testnets/dapptestnet/images/dapp.png",
      "svg": "https://raw.githubusercontent.com/cosmos/chain-registry/master/testnets/dapptestnet/images/dapp.svg"
    }
  ],
  "type_asset": "sdk.coin",
  "socials": {
    "website": "https://dappprotocol.io/",
    "twitter": "https://twitter.com/dappprotocol",
    "telegram": "https://t.me/dappprotocol",
    "discord": "https://discord.gg/dappprotocol",
    "medium": "https://medium.com/dappprotocol"
  }
}
```

### Key Fields

- **description**: Brief description of the asset
- **denom_units**: Array defining denomination conversions with exponents and aliases
- **type_asset**: Asset type (e.g., "sdk.coin" for native tokens, "ics20" for IBC tokens)
- **base**: Base denomination identifier
- **name**: Full asset name
- **display**: Display denomination
- **symbol**: Asset symbol/ticker
- **coingecko_id**: (Optional) CoinGecko identifier
- **keywords**: (Optional) Array of relevant keywords for the asset
- **logo_URIs**: URLs to asset logos in different formats (png, svg)
- **images**: Image metadata with logo URLs
- **socials**: (Optional) Social media and website links
- **traces**: (For IBC tokens) Array of transfer traces showing asset origin

<div class="spacer"></div>

## Keplr Chain Registry

The [Keplr Chain Registry](https://github.com/chainapsis/keplr-chain-registry) is specifically designed for Keplr wallet and other Cosmos-compatible wallets. It uses JSON configuration files that define chain parameters and token information.

### Registry URLs

#### Testnet

- **Repository**: [chainapsis/keplr-chain-registry](https://github.com/chainapsis/keplr-chain-registry)
- **File**: [cosmos/zig-test.json](https://github.com/chainapsis/keplr-chain-registry/blob/main/cosmos/zig-test.json)

#### Mainnet

- **Repository**: [chainapsis/keplr-chain-registry](https://github.com/chainapsis/keplr-chain-registry)
- **File**: [cosmos/zigchain.json](https://github.com/chainapsis/keplr-chain-registry/blob/main/cosmos/zigchain.json)

### Structure and Requirements

Here's an example of a generic token configuration for Keplr:

```json
{
  "coinDenom": "DAPP",
  "coinMinimalDenom": "coin.zig1abcdefghijklmnopqrstuvwxyz1234567890abcdef.dapptoken",
  "coinDecimals": 6,
  "coinImageUrl": "https://raw.githubusercontent.com/chainapsis/keplr-chain-registry/main/images/dapp-test/dapptoken.png"
}
```

### Key Fields

- **coinDenom**: Display name of the token (e.g., "DAPP")
- **coinMinimalDenom**: Minimal denomination used in transactions (e.g., "coin.zig1abcdefghijklmnopqrstuvwxyz1234567890abcdef.dapptoken")
- **coinDecimals**: Number of decimal places (e.g., 6)
- **coinImageUrl**: URL to the token's image file
- **coinGeckoId**: (Optional) CoinGecko identifier for price data

<div class="spacer"></div>

## Important Notes

⚠️ **Critical**: Before making any changes to the registry files, always verify the current state of the files and use only the existing, verified information. Do not add fields or values that are not already present in the registries unless you have confirmed they are required and correct.

The configurations provided above show the generic structure and should be used as references for the required fields. The examples demonstrate the native token structure for both Keplr and Cosmos registries.

<div class="spacer"></div>

## Implementation Process

### 1. Fork and Clone Repositories

Fork both registry repositories and clone your forks locally.

### 2. Update Registry Files

#### Keplr Chain Registry

Update the following files with the token configuration:

- `cosmos/zig-test.json` (testnet)
- `cosmos/zigchain.json` (mainnet)

Use the structure from the "Registry Structure and Requirements" section above.

#### Cosmos Chain Registry

Update the following files with the dApp token in the assets array:

- `testnets/zigchaintestnet/assetlist.json` (testnet)
- `zigchain/assetlist.json` (mainnet)

Use the structure and fields described in the "Registry Structure and Requirements" section above.

### 3. Submit Pull Requests

Commit your changes and submit pull requests to both repositories with a clear description of the token configuration and its purpose.

<div class="spacer"></div>

## Verification

Once the pull requests are merged, the token details should be visible on compatible wallets and Cosmos ecosystem applications.

---

✅ Following this guide ensures that dApp tokens will be properly displayed across all compatible wallet applications and Cosmos ecosystem tools.

<div class="spacer"></div>

## References

- [Cosmos Chain Registry - README](https://github.com/cosmos/chain-registry/blob/master/README.md)
- [Keplr Chain Registry - README](https://github.com/chainapsis/keplr-chain-registry/blob/main/README.md)
