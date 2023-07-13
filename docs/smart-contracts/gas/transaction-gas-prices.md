# Transaction gas prices

<div class="dot-navigation">
    <a class="dot-navigation__item" href="what-is-gas.html"></a>
    <a class="dot-navigation__item dot-navigation__item--active" href="transaction-gas-prices.html"></a>
    <a class="dot-navigation__item" href="storage-gas-price.html"></a>
    <a class="dot-navigation__item" href="zk-computation-gas-fees.html"></a>
    <a class="dot-navigation__item" href="how-to-get-testnet-gas.html"></a>
    <a class="dot-navigation__item" href="efficient-gas-practices.html"></a>
    <a class="dot-navigation__item" href="contract-to-contract-gas-estimation.html"></a>
    <!-- Repeat above for more dots -->
</div>
!!! info inline end "Basic fees"
    **Network fee:** 5 USD cents/kb.
    **CPU fee:** 5 USD cents per 1000 instructions.

Here, we will explore the factors that determine the gas cost for deploying a contract in the Partisia blockchain. By considering the network, CPU, and storage aspects, developers can effectively estimate and manage the gas costs associated with their smart contract transactions to understand the specifics of gas pricing. 

When a transaction is sent, the transaction needs to have enough gas to cover all resource usage. Otherwise the transaction will fail and the gas will go to waste. When developing a smart contract the developer should keep in mind that the best practice is to have your solution suggest the needed gas amount for the users of your smart contract. This should be as close to the bottom limit of the resource cost as to not have too expensive contracts on the blockchain. 

## The cost for using the blockchain

Gas on Partisia Blockchain is fixed, you pay for what you use. Gas units are pegged to the USD. The fixed ratio is 100,000 gas units to 1 USD.

The price for different services on the blockchain has been decided in [the yellow paper](https://drive.google.com/file/d/1OX7ljrLY4IgEA1O3t3fKNH1qSO60_Qbw/view)(Page 16) to tentatively match the following prices in USD:



By considering the above gas pricing properties, Partisia blockchain empowers developers to estimate and manage the gas costs associated with smart contract transactions. You should visit our article about [efficient gas practices](efficient-gas-practices.md) to understand how to optimize contracts gas usage. 