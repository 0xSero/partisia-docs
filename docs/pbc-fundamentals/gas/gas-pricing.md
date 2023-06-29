# Gas Pricing

Gas pricing plays a crucial role in the Partisia blockchain ecosystem, aiming to assist developers in creating and deploying smart contracts successfully. Partisia gas pricing mechanism ensures predictability of gas costs for transactions, even as the amount of data handled by the contract grows. This predictability empowers developers to estimate and manage the computational resources required for their smart contract operations effectively and help them not have any unintended consequences when working with their smart contracts on the Partisia blockchain.

## Calculation of Gas Cost for a Transaction:
The gas cost for deploying a contract in Partisia blockchain is determined by considering three main factors: network, CPU and [storage](storage-gas-price.md). Storage is explained [in this article](storage-gas-price.md). 

**Network Cost:** The network cost is associated with the transmission of the transaction across the blockchain network. It takes into account the bandwidth and other networking resources utilized during the transaction's propagation.

**CPU Cost:** The CPU cost reflects the computational resources consumed during the execution of a smart contract transaction. It consists of three primary stages: deserializing the contract state, performing the required work or computations, and serializing the updated contract state.

## The cost for using the blockchain

Gas on Partisia Blockchain is fixed, you pay for what you use. Gas units are pegged to the USD. The fixed ratio is 100,000 gas units to 1 USD.

The price for different services on the blockchain has been decided in [the yellow paper](https://drive.google.com/file/d/1OX7ljrLY4IgEA1O3t3fKNH1qSO60_Qbw/view)(Page 16) to tentatively match the following prices in USD:

**Basic fees:**

- Network fee: 5 USD cents/kb.
- CPU fee: 5 USD cents per 1000 instructions.
- Storage fee: 1 USD cent/kb per year.

By considering the above gas pricing properties, Partisia blockchain empowers developers to estimate and manage the gas costs associated with smart contract transactions. This predictability facilitates successful deployment of smart contracts, even as the data handled by the contract grows. You should visit our article about [efficient gas practices](efficient-gas-practices.md) to understand how to optimize contracts gas usage. 