---
sidebar_position: 2
---

# How to Add ZIGChain Manually to Your Wallet

This guide will walk you through the process of manually adding ZIGChain to your wallet. If you are using Leap wallet, follow the steps below. Choose the appropriate tab (`localnet`, `testnet`, or `mainnet`) based on the network you're working with.

---

import Tabs from '@theme/Tabs';
import TabItem from '@theme/TabItem';

## Network Details by Environment

<Tabs>
  <TabItem value="localnet" label="Localnet" default>

```bash
Network Name: ZIGChain Localnet
Chain ID: zigchain-localnet
RPC Endpoint: http://localhost:26657
REST Endpoint: http://localhost:1317
Currency Symbol: ZIG
Currency Denom: uzig
Currency Decimals: 6
```

  </TabItem>
  <TabItem value="testnet" label="Testnet">

```bash
Network Name: ZIGChain Testnet
Chain ID: zigchain-testnet
RPC Endpoint: https://rpc.testnet.zigchain.com
REST Endpoint: https://api.testnet.zigchain.com
Currency Symbol: ZIG
Currency Denom: uzig
Currency Decimals: 6
```

  </TabItem>
  <TabItem value="mainnet" label="Mainnet">

```bash
Network Name: ZIGChain
Chain ID: zigchain-1
RPC Endpoint: https://rpc.zigchain.com
REST Endpoint: https://api.zigchain.com
Currency Symbol: ZIG
Currency Denom: uzig
Currency Decimals: 6
```

  </TabItem>
</Tabs>

---

## Adding ZIGChain to Your Wallet

### Leap Wallet

Leap Wallet is a popular wallet for managing Cosmos-based assets. Follow these steps to add ZIGChain manually:

1. Open the **Leap Wallet** app or browser extension.
2. In the top right corner click on the **Network** icon, then click on **+** button.
3. Enter the appropriate details based on your network. Use the tabs above to find the correct information for `localnet`, `testnet`, or `mainnet`.
4. Confirm the details and click **Add chain**.

Once saved, ZIGChain will appear in your Leap Wallet, and you can start interacting with it.

---

## Verifying Your Wallet Configuration

To confirm that ZIGChain has been added successfully:

- Open your wallet and navigate to the list of available chains.
- Look for **ZIGChain** (or ZIGChain Localnet/Testnet) in the list.
- Ensure the RPC and REST endpoints match the provided details.
- If you've already deposited funds, check your wallet for the correct ZIG balance.

---

## Troubleshooting

If you encounter issues while adding ZIGChain:

1. **Double-Check Details**: Verify the network information for accuracy.
2. **Ensure Connectivity**: Ensure your internet connection is active and your wallet is updated to the latest version.
3. **Reach Out for Help**: Contact the [ZIGChain Support Team](mailto:) for assistance.

---

## Additional Resources

- [ZIGChain Official Documentation](https://docs.zigchain.network)
- [ZIGChain Explorer](https://explorer.zigchain.network)
- [Leap Wallet](https://www.leapwallet.io)
