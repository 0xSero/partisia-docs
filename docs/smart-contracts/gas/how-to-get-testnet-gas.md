# How to get testnet gas

<div class="dot-navigation">
    <a class="dot-navigation__item" href="gas-pricing.html"></a>
    <a class="dot-navigation__item" href="storage-gas-price.html"></a>
    <a class="dot-navigation__item" href="zk-computation-gas-fees.html"></a>
    <a class="dot-navigation__item dot-navigation__item--active" href="how-to-get-testnet-gas.html"></a>
    <a class="dot-navigation__item" href="efficient-gas-practices.html"></a>
    <a class="dot-navigation__item" href="contract-to-contract-gas-estimation.html"></a>
    <!-- Repeat above for more dots -->
</div>
When working with smart contracts, the testnet is the best way to test your smart contracts and estimate their gas cost. To test a smart contract you need gas, this article is here to get you started on getting gas. 

We recommend using the testnet through either the [dashboard](https://testnet.partisiablockchain.com/) or the [browser](https://browser.testnet.partisiablockchain.com).

To see your testnet gas balance you will need to switch the network, at which your Partisia wallet is pointing to testnet.

To get gas on the testnet we recommend you to do the following: 
Use our Gas Faucet contract that mints BYOC for you and then keep minting on the mint contract: 

This method requires you to already have an account with a small amount of gas on the testnet. So, you need to be bootstrapped by [either visiting our faucet](https://testnet.mpcfaucet.com/) or by having another user with gas send you some gas using this Gas Faucet contract.

- Sign in to the [testnet dashboard](https://testnet.partisiablockchain.com/) (Icon in upper right corner) Your private key can be recovered in the Partisia Wallet under Account Backup.
- Follow this [link](https://testnet.partisiablockchain.com/info/contract/02d7c791bd9dd31a4a1a9fdaa99df7cc8414fd333e) to the Faucet contract
- The contract action takes an account address as receiver of test ETH.
- By default, the dashboard sets the transaction cost to 100k gas which is excessive for this transaction. The transaction should take approximately 7k-10k gas.
- Execute the transaction - the specified account should now have gained approximately 1,000,000 gas (1M - TX cost).

### Test your contract on the testnet
Remember to use the testnet as it is the best way to exactly understand how much gas your contract is using. By testing your contract on the testnet and verify its cost on the blockchain you can implement exact costs when doing contract-to-contract or system-to-contract transactions. Developers can enhance gas cost with precision by using the testnet to understand exactly what it costs to use the testnet. 