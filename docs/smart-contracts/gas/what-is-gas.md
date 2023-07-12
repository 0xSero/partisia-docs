# What is Gas?
<div class="dot-navigation">
    <a class="dot-navigation__item dot-navigation__item--active" href="what-is-gas.html"></a>
    <a class="dot-navigation__item" href="transaction-gas-prices.html"></a>
    <a class="dot-navigation__item" href="storage-gas-price.html"></a>
    <a class="dot-navigation__item" href="zk-computation-gas-fees.html"></a>
    <a class="dot-navigation__item" href="how-to-get-testnet-gas.html"></a>
    <a class="dot-navigation__item" href="efficient-gas-practices.html"></a>
    <a class="dot-navigation__item" href="contract-to-contract-gas-estimation.html"></a>
    <!-- Repeat above for more dots -->
</div>

Gas is a unit of computational effort on blockchain networks. It serves as a measure of the resources consumed during contract execution. Each operation in a smart contract, such as reading or writing data, executing computations, or interacting with other contracts, consumes a specific amount of gas. The gas cost for deploying a contract in Partisia blockchain is determined by considering three main factors: network, CPU and [storage](storage-gas-price.md). You can read [the pricing for CPU and network here](transaction-gas-prices.md) and [the pricing for storage here](storage-gas-price.md).

To be more efficient with gas consumption you can visit [our best practice article](efficient-gas-practices.md) and keep in mind to reduce the effort of the cpu and use less network traffic when working on smart contracts. In general the CPU cost is the most expensive consumer in terms of gas usage compared to network traffic and storage fees. 

### CPU Cost in Gas Pricing: Understanding the Three CPU Stages to optimization
The CPU cost reflects the computational resources consumed during the execution of a smart contract transaction. It consists of three primary stages: deserializing the contract state, performing the required work or computations, and serializing the updated contract state.

**1. Deserialize State:** Before executing a smart contract, the contract's current state needs to be deserialized. This process involves converting the serialized contract state into a data structure that can be manipulated and processed by the blockchain's virtual machine. The gas cost associated with this step depends on the size and complexity of the contract state or transaction.

**2. Perform Work:** Once the contract state is deserialized, the required computations or work specified by the smart contract are performed. This work may involve various operations such as calculations, data manipulation, and interactions with other contracts or external systems. The gas cost for this stage depends on the complexity and intensity of the computations involved.

**3. Serialize State:** After the work is completed, the contract state is serialized back into a format suitable for storage on the blockchain. The gas cost associated with serialization depends on the size and complexity of the updated contract state.

It's a good practice to consider your gas consumption during the architecture and design of smart contracts. By implementing these strategies, optimizing gas usage and improving the efficiency of smart contracts can be achieved. You can find more best practice on our article of [efficient gas practices](efficient-gas-practices.md)

### Network cost
The network cost is associated with the transmission of the transaction across the blockchain network. It takes into account the bandwidth and other networking resources utilized during the transaction's propagation.