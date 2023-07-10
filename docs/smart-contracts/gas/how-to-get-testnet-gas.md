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
When working with smart contracts, the testnet is the best way to upload your smart contracts and estimate their gas cost. To test a smart contract you need gas, this article is here to get you started on getting gas on the testnet. 

We recommend using the testnet through either the [dashboard](https://testnet.partisiablockchain.com/) or the [browser](https://browser.testnet.partisiablockchain.com). To see your testnet gas balance you can log into the dashboard or the browser. Under your account you can see how many test_coins you have. 

If you do not have any gas yet, we recommend you to visit [our faucet to get the first amount of test_coins](https://testnet.mpcfaucet.com/)

To get even more gas you can do the following: 
- Sign in to the [testnet dashboard](https://testnet.partisiablockchain.com/) (Icon in upper right corner) Your private key can be recovered in the Partisia Wallet under Account Backup or you can directly use your private key.
- Follow this [link](https://testnet.partisiablockchain.com/info/contract/02c14c29b2697f3c983ada0ee7fac83f8a937e2ecd) to the Faucet contract
- The contract action takes an account address as receiver of test ETH. You should use your own public key as the account address. You can find this in info.
- By default, the dashboard sets the transaction cost to 100k gas which is excessive for this transaction. The transaction should take approximately 60000 gas.
- Execute the transaction - the specified account should now have gained approximately 100.000.000 gas (1M - TX cost).

### Test your contract on the testnet
Remember to use the testnet as it is the best way to exactly understand how much gas your contract is using. By testing your contract on the testnet and verify its cost on the blockchain you can implement exact costs when doing contract-to-contract or system-to-contract transactions. Developers can enhance gas cost with precision by using the testnet to understand exactly what it costs to use the testnet. 