# Efficient gas practices

<div class="dot-navigation">
    <a class="dot-navigation__item" href="what-is-gas.html"></a>
    <a class="dot-navigation__item" href="gas-pricing.html"></a>
    <a class="dot-navigation__item" href="storage-gas-price.html"></a>
    <a class="dot-navigation__item" href="zk-computation-gas-fees.html"></a>
    <a class="dot-navigation__item" href="how-to-get-testnet-gas.html"></a>
    <a class="dot-navigation__item dot-navigation__item--active" href="efficient-gas-practices.html"></a>
    <a class="dot-navigation__item" href="contract-to-contract-gas-estimation.html"></a>
    <!-- Repeat above for more dots -->
</div>
Minimizing gas usage is essential to ensure cost-effectiveness and optimal performance on the blockchain. In this article we have collected our best practice for handling gas optimization.

The size of the contract state directly affects the CPU cost, particularly during serialization and deserialization processes. As the contract state grows larger, both serialization and deserialization require more computational resources, resulting in increased gas costs. It is important to be aware of this impact and optimize gas usage accordingly when creating smart contracts.

## Working with large amounts of data
When working with a large amount of data it can quickly grow to cost a lot of gas. It takes a lot of computation to calculate over large amounts of data, the expensive part is for the cpu to understand and figure out the different types of variables being used. To reduce the workload we can use data that has a fixed size, the blockchain can then understand and immediately serialize these by knowing the different lengths of the variables without looking at the actual data within. 

Whenever you work with many instructions we recommend you to always use a Vec<> with fix sized elements inside. If you use a struct it's the same premise, when having a lot of entries, fix sized variables will save you the most amount of gas when used as part of either vec maps or structs. We have created a [table of all fix sized elements](table-of-fixed-size-elements.md) on PBC you can freely refer to as a guide when choosing what variable to use in your contracts. 

In conclusion, efficient gas practices involve minimizing gas usage when working with large data, optimizing CPU costs based on contract state size, and employing strategies to enhance gas efficiency. By incorporating these practices, developers can create smart contracts that are more cost-effective and performant on the blockchain.

