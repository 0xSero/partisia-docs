# How to get testnet gas

The new testnet will be using [ETH from Goerli testnet](https://goerli.etherscan.io/address/0x4818370f9d55fb34de93e200076533696c4531f3). To see your testnet gas balance you will need to switch the network, at which your Partisia wallet is pointing to testnet.

There are two ways to get gas on the testnet:  
A) using the [bridge from test ETH GOERLI](https://testnet-bridge.mpcexplorer.com/)  
B) Using a Gas Faucet contract that mints BYOC

### Method A

This mechanism for getting gas is similar to the old testnet and current mainnet (see above). To get GoerliETH you need to find a faucet. This can be found using a simple web search. To see the GoerliETH in Metamask you need to change the network to the Goerli Test Network. After having deposited GoerliETH to your Metamask account you can use the [bridge from test ETH GOERLI](https://testnet-bridge.mpcexplorer.com/) to get gas on the testnet. The mpc explorer for the testnet can be found [here](https://testnet.mpcexplorer.com/).

### Method B

This method requires you to already have an account with a small amount of gas on the testnet. So, you need to be bootstrapped either through Method A or by having another user with gas send you some gas using this Gas Faucet contract.

- Sign in to the [testnet dashboard](https://testnet.partisiablockchain.com/) (Icon in upper right corner) Your private key can be recovered in the Partisia Wallet under Account Backup.
- Follow this [link](https://testnet.partisiablockchain.com/info/contract/02d7c791bd9dd31a4a1a9fdaa99df7cc8414fd333e) to the Faucet contract
- The contract action takes an account address as receiver of test ETH.
- By default, the dashboard sets the transaction cost to 100k gas which is excessive for this transaction. The transaction should take approximately 7k-10k gas.
- Execute the transaction - the specified account should now have gained approximately 1,000,000 gas (1M - TX cost).