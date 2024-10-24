# Access and use the testnet

The [testnet](https://browser.testnet.partisiablockchain.com/transactions) is a cost free version of Partisia Blockchain
mainnet. The governing principles of the testnet are the same as for mainnet. The only differences is that the gas on
the testnet is paid with a TEST_COIN [that you can follow this article to get some of](gas/how-to-get-testnet-gas.md).

## How do I use the testnet for smart contract development

You can deploy and test both public and private smart contracts on the testnet for free. All you need to get started is
the following:

- A PBC [account](../pbc-fundamentals/create-an-account.md), you can create an account with
  the [PBC wallet extension](https://chrome.google.com/webstore/detail/partisia-wallet/gjkdbeaiifkpoencioahhcilildpjhgh).
- Get [testnet gas](gas/how-to-get-testnet-gas.md)
- [Download the PBC example smart contracts](https://gitlab.com/partisiablockchain/language/example-contracts)
  and [try to deploy a contract on the testnet](compile-and-deploy-contracts.md).

## How to deploy contracts on the testnet

- Use your private key to sign in (click icon in upper right corner)
- open the dashboard [wallet](https://testnet.partisiablockchain.com/wallet/upload_wasm)
  or [the browser](https://browser.partisiablockchain.com/contracts/deploy)
- For public smart contracts you upload a WASM-file as contract file and an ABI-file, but for private contract using ZK
  computation you upload a ZKWA-file as contract file and an ABI-file. Keep in mind that you need to add enough gas for
  your contract to run.
  You need to compile your rust contract to get access to these
  files, [you can see here how to do that](compile-and-deploy-contracts.md)
