# Access and use the testnet

The [testnet](https://testnet.partisiablockchain.com/) is a cost free version of Partisia Blockchain mainnet. The governing principles of the testnet are the same as for mainnet. The only differences is that the gas on the testnet is Goerli testnet ETH instead of Ethereum mainnet ETH which is used for gas on Partisia Blockchain mainnet.


## How do I use the testnet for smart contract development

You can deploy and test both public and private smart contracts on the testnet for free. All you need to get started is the following:

- A PBC [account](../pbc-fundamentals/accounts.md), you can create an account with the [PBC wallet extension](https://chrome.google.com/webstore/detail/partisia-wallet/gjkdbeaiifkpoencioahhcilildpjhgh).   
- Get [testnet gas](../pbc-fundamentals/byoc.md)   
    - You can easily get your first testnet gas from the [official faucet](https://testnet.mpcfaucet.com/)
- [Download the PBC example smart contracts](LINK_TO_RUST_EXAMPLE_CONTRACTS) containing examples of both public and private smart contracts, they are described on [this page](../smart-contracts/SC-examples.md).

## How to deploy contracts on the testnet   

- Use your private key to sign in (click icon in upper right corner)
- open the dashboard [wallet](https://testnet.partisiablockchain.com/wallet/upload_wasm)   
- For public smart contracts you upload a WASM-file as contract file and an ABI-file, but for private contract using ZK computation you upload a ZKWA-file as contract file and an ABI-file. Keep in mind that you need to add enough gas for your contract to run.   
