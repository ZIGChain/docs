---
title: ZIGChain Modules
description: Comprehensive guide to ZIGChain modules including Cosmos SDK modules (consensus, distribution, governance, mint, slashing, staking) and ZIGChain modules (DEX, Factory, Token Wrapper, CosmWasm).
keywords:
  [
    ZIGChain modules,
    Cosmos SDK modules,
    ZIGChain staking module,
    ZIGChain governance module,
    ZIGChain distribution module,
    ZIGChain consensus module,
    ZIGChain minting module,
    ZIGChain slashing module,
    ZIGChain validator set,
    ZIGChain module parameters,
    ZIGChain state machine,
    ZIGChain DEX module,
    decentralized exchange ZIGChain,
    liquidity pools ZIGChain,
    trade tokens ZIGChain,
    ZIGChain CosmWasm,
    ZIGChain smart contracts,
    CosmWasm whitelisting,
    deploy CosmWasm contract ZIGChain,
    ZIGChain wasm module,
    ZIGChain contract verification,
  ]
sidebar_position: 2
---

# ZIGChain Modules

ZIGChain is built on the modular architecture of the Cosmos SDK. Modules serve as the building blocks, enabling both core functionalities and custom features tailored to its ecosystem. This article delves into the key modules powering ZIGChain, from essential Cosmos SDK components to its unique, network-specific additions.

<div class="spacer"></div>

## What Are Modules?

Modules are reusable components within ZIGChain, built on the Cosmos SDK, that streamline blockchain development by offering pre-built functionalities like staking, slashing, and governance. Acting as plug-and-play tools, these modules empower developers to focus on creating innovative, custom features for their blockchain while leveraging the flexibility and interoperability of the Cosmos ecosystem.

<div class="spacer"></div>

## Cosmos Modules in ZIGChain

ZIGChain incorporates several essential modules from the Cosmos SDK:

1. **[Consensus](./consensus-module.md):** This module ensures block validation and agreement among validators, forming the foundation of ZIGChain's Proof-of-Stake (PoS) mechanism.
2. **[Distribution](./distribution-module.md):** This module manages the allocation of staking rewards to validators and delegators while maintaining the community pool for ecosystem development.
3. **[Governance](./governance-module.md):** The governance module allows stakeholders to propose and vote on changes to the network, ensuring decentralized decision-making and adaptability.
4. **[Mint](./mint-module.md):** The mint module regulates the issuance of ZIG tokens to ensure a sustainable token economy through controlled inflation and supply management.
5. **[Slashing](./slashing-module.md):** The slashing module enforces network security by penalizing validators for misconduct, such as double-signing or prolonged downtime.
6. **[Staking](./staking-module.md):** The staking module enables validators to lock ZIG tokens for network security and earn rewards through ZIGChain's PoS system.

<div class="spacer"></div>

## ZIGChain Modules

1. **[Factory](./factory.md):** Facilitates the creation and management of custom tokens.
2. **[DEX (Decentralized Exchange)](./dex.md):** Powers on-chain token swaps and liquidity pools.
3. **[Token Wrapper](./token-wrapper-module.md):** Last step for obtaining native ZIG on ZIGChain.
4. **Wealth Management Engine:** Also known as Profit Sharing 3.5, the Wealth Management Engine is the centerpiece of ZIGChain's mission to democratize wealth generation. This module transforms complex investment strategies into tokens that fluctuate based on strategy performance, allowing token holders to participate and share in both returns and risks.

<div class="spacer"></div>

## References

- [Cosmos SDK - Modules](https://docs.cosmos.network/main/build/building-modules/intro)
