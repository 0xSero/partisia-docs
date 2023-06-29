# Efficient gas practices

When developing smart contracts, it is crucial to consider gas usage, which measures the computational cost of executing transactions on a blockchain. Gas is a unit of computational effort on blockchain networks. It serves as a measure of the resources consumed during contract execution. Each operation in a smart contract, such as reading or writing data, executing computations, or interacting with other contracts, consumes a specific amount of gas. Minimizing gas usage is essential to ensure cost-effectiveness and optimal performance. In this article we have collected our best tips and strategies for handling gas optimization.

## Impact of Contract State Size on CPU Cost:
The size of the contract state directly affects the CPU cost, primarily due to the serialization and deserialization processes. As the contract state grows larger, the gas cost for both serialization and deserialization increases. This is because larger state sizes require more computational resources to transform the state between its serialized and deserialized representations.

### Working with large amounts of data
When working with a large amount of data it can quickly grow to cost a lot of gas. Whenever you work with many instructions we recommend you to always use a Vec<> with fix sized elements inside. If you use a struct its the same premise, when having a lot of entries, fix sized variables will save you the most amount of gas when used as part of either vec maps or structs..  

### Table of fix sized elements on PBC

| Type                                                                                                                  | Bit size  | Byte size | Number range                    |
|-----------------------------------------------------------------------------------------------------------------------|-----------|-----------|---------------------------------|
| [Address](https://partisiablockchain.gitlab.io/language/contract-sdk/pbc_contract_common/address/struct.Address.html) | 168       | 21        | -                               |
| [Hash](https://partisiablockchain.gitlab.io/language/contract-sdk/pbc_contract_common/struct.Hash.html)               | 256          | 32        | -                               |
| [bool](https://doc.rust-lang.org/stable/std/primitive.bool.html)                                                      | 8         | 1         | 0 to 1                          |
| [u8](https://doc.rust-lang.org/stable/std/primitive.u8.html)                                                          | 8         | 1         | 0 to 255                        |
| [u16](https://doc.rust-lang.org/stable/std/primitive.u16.html)                                                        | 32        | 4         | 0 to 65,535                     |
| [u32](https://doc.rust-lang.org/stable/std/primitive.u32.html)                                                        | 64        | 8         | 0 to 4,294,967,295              |
| [u64](https://doc.rust-lang.org/stable/std/primitive.u64.html)                                                        | 128       | 16        | 0 to $2^{64}−1$                 |
| [u128](https://doc.rust-lang.org/stable/std/primitive.u128.html)                                                      | 128       | 16        | 0 to  $2^{128}-1$               |
| [i8](https://doc.rust-lang.org/stable/std/primitive.i8.html)                                                          | 8         | 1         | -128 to 127                     |
| [i16](https://doc.rust-lang.org/stable/std/primitive.i16.html)                                                        | 16        | 4         | -32,768 to 32,767               |
| [i32](https://doc.rust-lang.org/stable/std/primitive.i32.html)                                                        | 32        | 8         | -2,147,483,648 to 2,147,483,647 |
| [i64](https://doc.rust-lang.org/stable/std/primitive.i64.html)                                                        | 64        | 16        | $−2^{63}$ to  $2^{63}-1$        |
| [i128](https://doc.rust-lang.org/stable/std/primitive.i128.html)                                                      | 128       | 16        | $−2^{127}$ to  $2^{127}-1$      |


When working with large amounts of data, it is essential to consider the gas costs associated with various data structures. Using Vec<> with fixed-sized elements or structs with fixed-sized variables can significantly reduce gas consumption. By employing these strategies, developers can optimize gas usage and improve the efficiency of their smart contracts. The best way to exactly understand how much gas your contract is using is testing your contract on the testnet and verify its cost on the blockchain. By implementing these strategies, developers can enhance gas optimization and improve the efficiency of their smart contracts.