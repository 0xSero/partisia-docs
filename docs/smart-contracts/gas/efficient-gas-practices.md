# Efficient gas practices

<div class="dot-navigation">
    <a class="dot-navigation__item" href="gas-pricing.html"></a>
    <a class="dot-navigation__item" href="storage-gas-price.html"></a>
    <a class="dot-navigation__item" href="zk-computation-gas-fees.html"></a>
    <a class="dot-navigation__item" href="how-to-get-testnet-gas.html"></a>
    <a class="dot-navigation__item dot-navigation__item--active" href="efficient-gas-practices.html"></a>
    <a class="dot-navigation__item" href="contract-to-contract-gas-estimation.html"></a>
    <!-- Repeat above for more dots -->
</div>

When developing smart contracts, it is crucial to consider gas usage, which measures the computational cost of executing transactions on a blockchain. Gas is a unit of computational effort on blockchain networks. It serves as a measure of the resources consumed during contract execution. Each operation in a smart contract, such as reading or writing data, executing computations, or interacting with other contracts, consumes a specific amount of gas. Minimizing gas usage is essential to ensure cost-effectiveness and optimal performance. In this article we have collected our best tips and strategies for handling gas optimization.

## Working with large amounts of data
When working with a large amount of data it can quickly grow to cost a lot of gas. Whenever you work with many instructions we recommend you to always use a Vec<> with fix sized elements inside. If you use a struct its the same premise, when having a lot of entries, fix sized variables will save you the most amount of gas when used as part of either vec maps or structs..  

### Table of fix sized elements on PBC

| Type                                                                                                                  | Bit size  | Byte size | Number range                   |
|-----------------------------------------------------------------------------------------------------------------------|-----------|-----------|--------------------------------|
| [Address](https://partisiablockchain.gitlab.io/language/contract-sdk/pbc_contract_common/address/struct.Address.html) | 168       | 21        | -                              |
| [Hash](https://partisiablockchain.gitlab.io/language/contract-sdk/pbc_contract_common/struct.Hash.html)               | 256          | 32        | -                              |
| [bool](https://doc.rust-lang.org/stable/std/primitive.bool.html)                                                      | 8         | 1         | 0 to 1                         |
| [u8](https://doc.rust-lang.org/stable/std/primitive.u8.html)                                                          | 8         | 1         | 0 to 255                       |
| [u16](https://doc.rust-lang.org/stable/std/primitive.u16.html)                                                        | 32        | 4         | 0 to 65,535                    |
| [u32](https://doc.rust-lang.org/stable/std/primitive.u32.html)                                                        | 64        | 8         | 0 to 4,294,967,295             |
| [u64](https://doc.rust-lang.org/stable/std/primitive.u64.html)                                                        | 128       | 16        | 0 to 2^64^−1                   |
| [u128](https://doc.rust-lang.org/stable/std/primitive.u128.html)                                                      | 128       | 16        | 0 to  2^128^-1                 |
| [i8](https://doc.rust-lang.org/stable/std/primitive.i8.html)                                                          | 8         | 1         | -128 to 127                    |
| [i16](https://doc.rust-lang.org/stable/std/primitive.i16.html)                                                        | 16        | 4         | -32,768 to 32,767              |
| [i32](https://doc.rust-lang.org/stable/std/primitive.i32.html)                                                        | 32        | 8         | -2,147,483,648 to 2,147,483,647 |
| [i64](https://doc.rust-lang.org/stable/std/primitive.i64.html)                                                        | 64        | 16        | −2^63^ to  2^63^-1             |
| [i128](https://doc.rust-lang.org/stable/std/primitive.i128.html)                                                      | 128       | 16        | −2^127^ to  2^127^-1           |


When handling large data volumes, it is essential to carefully consider the gas costs associated with different data structures. By leveraging fixed-sized elements in Vec<> or structs, you can minimize gas consumption significantly.


## Impact of Contract State Size on CPU Cost:
The size of the contract state directly affects the CPU cost, particularly during serialization and deserialization processes. As the contract state grows larger, both serialization and deserialization require more computational resources, resulting in increased gas costs. It is crucial to be aware of this impact and optimize gas usage accordingly when creating smart contracts.

### CPU Cost and its Operation:
The CPU cost plays a vital role in gas pricing and is divided into three key stages, where implementing the best approach to handle CPU can have a significant impact on gas efficiency:

**1. Deserialize State:** Before executing a smart contract, the contract's current state needs to be deserialized. This process involves converting the serialized contract state into a data structure that can be manipulated and processed by the blockchain's virtual machine. The gas cost associated with this step depends on the size and complexity of the contract state or transaction.

**2. Perform Work:** Once the contract state is deserialized, the required computations or work specified by the smart contract are performed. This work may involve various operations such as calculations, data manipulation, and interactions with other contracts or external systems. The gas cost for this stage depends on the complexity and intensity of the computations involved.

**3. Serialize State:** After the work is completed, the contract state is serialized back into a format suitable for storage on the blockchain. The gas cost associated with serialization depends on the size and complexity of the updated contract state.

It is essential for developers to consider gas consumption during the architecture and design of contracts. By implementing these strategies, optimizing gas usage and improving the efficiency of smart contracts can be achieved.

In conclusion, efficient gas practices involve minimizing gas usage when working with large data, optimizing CPU costs based on contract state size, and employing strategies to enhance gas efficiency. By incorporating these practices, developers can create smart contracts that are more cost-effective and performant on the blockchain.