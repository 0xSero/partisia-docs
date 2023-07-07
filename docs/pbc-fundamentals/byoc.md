# BYOC
In this article we will explain what byoc is, how to bring your own coins to the mainnet and the testnet.

### What is BYOC and gas

BYOC means bring your own coin. The idea is that you can bring other cryptocurrencies onto PBC. Any coin you bring onto PBC stays as a reference to the coin you brought in. You can convert your BYOC [to gas](../smart-contracts/gas/gas-pricing.md). 
You need BYOC to convert to gas to interact with a contract on the blockchain.

BYOC is needed to cover the payment of the node operators which are providing the services enabling the transactions to take place. You pay for interactions with gas that is converted from coins you have brought onto the chain, you can see the explained [gas fees here](../smart-contracts/gas/gas-pricing.md). 

### How does it work

To be able to spend and transfer your coins, you will need to transfer your own liquid cryptocurrency using [the PBC Token Bridge](https://bridge.mpcexplorer.com/). This will move your ETH to a contract and mint a PBC version of the coin you brought. This new PBC based version of your coin can interact with the payment scheme of PBC. In essence you can deposit, withdraw and transfer ETH or other cryptocurrencies with your PBC wallet.
Right now PBC has a bridge to Ethereum and Polygon.

The cost of bringing your own coin

**BYOC (tentative):**
0,1% of the value transferred with a threshold of 25 USD as minimum transfer (equal to a minimum BYOC fee of 2,5 USD cents).


### How to get started

To make a deposit of ETH you can use the [PBC Token Bridge](https://bridge.mpcexplorer.com).

In practice you can follow these steps:
1. Install the [Partisa Wallet Extension](https://chrome.google.com/webstore/detail/partisia-wallet/gjkdbeaiifkpoencioahhcilildpjhgh).
2. Make a [Partisia Account](../pbc-fundamentals/create-an-account.md) with the wallet (or use the one you have already). You can use the Partisia Wallet to make additional accounts.
3. Install Metamask [app](https://metamask.io/) or [extension](https://chrome.google.com/webstore/detail/metamask/nkbihfbeogaeaoehlefnkodbefgpgknn).
4. Make an Ethereum account, you can use Metamask to do it. (This is different from your Partisia Account)
5. Set the network in Metamask to Ethereum Mainnet in upper right corner.
6. You can use Metamask to buy ETH. You can add funds with card or Apple Pay.
7. Use the [PBC Token bridge](https://bridge.mpcexplorer.com/) to transfer ETH from the Ethereum account into the PBC account.

You get a confirmation as seen below if the deposit is successful. 

<img alt="Deposit" src="bridge-transfer-confirmation.png" width="350"/>

The confirmation also includes a link to the [mpc explorer](https://mpcexplorer.com/) where you can see the executed transaction. After the confirmed transfer your gas balance in the wallet should be positive. This means that you can deploy or interact with smart contracts on the blockchain and pay for those interactions with the coins to have sent over. Read more about smart contracts [here](../smart-contracts/what-is-a-smart-contract.md).

### How to test BYOC?
You need some value from [GoerliETH](https://goerli.etherscan.io/address/0x4818370f9d55fb34de93e200076533696c4531f3)), we recommend you to find a faucet. This can be found using a simple web search. 

To see the GoerliETH in Metamask you need to change the network to the Goerli Test Network. After having deposited GoerliETH to your Metamask account you can use the [bridge from test ETH GOERLI](https://testnet-bridge.mpcexplorer.com/) to get gas on the testnet. You can verify that you have test_coins on your account on the testnet after the succesful bridging [here](https://testnet.partisiablockchain.com/info/account) which will end.