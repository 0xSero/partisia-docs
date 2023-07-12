# How to get testnet gas

<div class="dot-navigation">
    <a class="dot-navigation__item" href="what-is-gas.html"></a>
    <a class="dot-navigation__item" href="transaction-gas-prices.html"></a>
    <a class="dot-navigation__item" href="storage-gas-price.html"></a>
    <a class="dot-navigation__item" href="zk-computation-gas-fees.html"></a>
    <a class="dot-navigation__item dot-navigation__item--active" href="how-to-get-testnet-gas.html"></a>
    <a class="dot-navigation__item" href="efficient-gas-practices.html"></a>
    <a class="dot-navigation__item" href="contract-to-contract-gas-estimation.html"></a>
    <!-- Repeat above for more dots -->
</div>

When working with smart contracts, the testnet is the best way to upload your smart contracts and estimate their gas cost. To test a smart contract you need gas, this article is here to get you started on getting gas on the testnet. By testing your contract on the testnet and verify its cost on the blockchain you can implement exact costs when doing contract-to-contract or system-to-contract transactions. 

### How to see your gas balance
We recommend using the testnet through either the [dashboard](https://testnet.partisiablockchain.com/) or the [browser](https://browser.testnet.partisiablockchain.com). To see your testnet gas balance you can log into the dashboard or the browser. Under your account you can see how many TEST_COINs you have. If you are logged into browser you can simply [click here to see your account balance](https://browser.testnet.partisiablockchain.com/account?tab=byoc).


### How to get gas on the testnet
If you do not have any gas yet, we recommend you to visit [our faucet to get the first amount of TEST_COINS](https://testnet.mpcfaucet.com/).

To get even more gas you can do the following: 
- Sign in to the [testnet dashboard](https://testnet.partisiablockchain.com/) (Icon in upper right corner).
- Follow this [link](https://testnet.partisiablockchain.com/info/contract/02c14c29b2697f3c983ada0ee7fac83f8a937e2ecd) to the Feed Me contract
- The contract action takes an account address as receiver of our test coin (A [BYOC](../../pbc-fundamentals/byoc.md) that only exists on the testnet). You should use your own public key as the account address. You can find your public key in your account, it's a 21 character address with mixed numbers and letters.
- By default, the dashboard sets the transaction cost to 100k gas which is excessive for this transaction. The transaction should take approximately 60000 gas.
- Execute the transaction - the specified account should now have gained approximately 1,000,000,000 gas which has a value of 10,000 TEST_COIN.


You have now successfully learned how to acquire gas on the testnet and see your account balance. By utilizing the testnet, you can safely experiment with your contracts without incurring any real costs or affecting the main blockchain network.