# Gas Pricing

<div class="dot-navigation">
    <a class="dot-navigation__item dot-navigation__item--active" href="gas-pricing.html"></a>
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

## Calculation of Gas Cost for a Transaction:
The gas cost for deploying a contract in Partisia blockchain is determined by considering three main factors: network, CPU and [storage](storage-gas-price.md). Storage is explained [in this article](storage-gas-price.md). 

**Network Cost:** The network cost is associated with the transmission of the transaction across the blockchain network. It takes into account the bandwidth and other networking resources utilized during the transaction's propagation.

**CPU Cost:** The CPU cost reflects the computational resources consumed during the execution of a smart contract transaction. It consists of three primary stages: deserializing the contract state, performing the required work or computations, and serializing the updated contract state.

## The cost for using the blockchain

Gas on Partisia Blockchain is fixed, you pay for what you use. Gas units are pegged to the USD. The fixed ratio is 100,000 gas units to 1 USD.

The price for different services on the blockchain has been decided in [the yellow paper](https://drive.google.com/file/d/1OX7ljrLY4IgEA1O3t3fKNH1qSO60_Qbw/view)(Page 16) to tentatively match the following prices in USD:



By considering the above gas pricing properties, Partisia blockchain empowers developers to estimate and manage the gas costs associated with smart contract transactions. You should visit our article about [efficient gas practices](efficient-gas-practices.md) to understand how to optimize contracts gas usage. 