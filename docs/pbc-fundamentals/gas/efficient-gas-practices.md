# Efficient gas practices

When developing smart contracts, it is crucial to consider gas usage, which measures the computational cost of executing transactions on a blockchain. Gas is a unit of computational effort on blockchain networks. It serves as a measure of the resources consumed during contract execution. Each operation in a smart contract, such as reading or writing data, executing computations, or interacting with other contracts, consumes a specific amount of gas. Minimizing gas usage is essential to ensure cost-effectiveness and optimal performance. In this article we have collected some of our best tips and strategies for handling gas optimization.

## Working with large amounts of data
When working with a large amount of data it can quickly grow to cost a lot of gas. Whenever you work with many instructions we recommend you to always use a Vec<> with fix sized elements inside. If you use a struct its the same premis, when having a lot of entries fix sized variables is the way to go. 

Table of fix sized elements

| Type                                                                                                                  | Bit size  | Byte size | Number range               |
|-----------------------------------------------------------------------------------------------------------------------|-----------|-----------|----------------------------|
| [Address](https://partisiablockchain.gitlab.io/language/contract-sdk/pbc_contract_common/address/struct.Address.html) | 168       | 21        | -                          |
| [Hash](https://partisiablockchain.gitlab.io/language/contract-sdk/pbc_contract_common/struct.Hash.html)               | 256          | 32        | -                          |
| bool                                                                                                                  | 8         | 1         | 0 - 1                      |
| u8                                                                                                                    | 8         | 1         | 0 - 255                    |
| u16                                                                                                                   | 32        | 4         | 0 - 65,535                 |
| u32                                                                                                                   | 64        | 8         | 0 - 4,294,967,295          |
| u64                                                                                                                   | 128       | 16        | 0 - 2e19                   |
| u128                                                                                                                  | 128       | 16        | $0 -  2^{128}-1$           |
| i8                                                                                                                    | 8         | 1         | -128 - 127                 |
| i16                                                                                                                   | 16        | 4         | -32,768 - 32,767           |
| i32                                                                                                                   | 32        | 8         | -2,147,483,648 - 2,147,483,647 |
| i64                                                                                                                   | 64        | 16        | -1e19 - 1e19               |


impl CreateTypeSpec for u8
source
impl CreateTypeSpec for u16
source
impl CreateTypeSpec for u32
source
impl CreateTypeSpec for u64
source
impl CreateTypeSpec for u128
source
impl CreateTypeSpec for i8
source
impl CreateTypeSpec for i16
source
impl CreateTypeSpec for i32
source
impl CreateTypeSpec for i64
source
impl CreateTypeSpec for i128
source
impl CreateTypeSpec for String
source
impl CreateTypeSpec for bool
source
impl CreateTypeSpec for Sbi8
source
impl CreateTypeSpec for Sbi16
source
impl CreateTypeSpec for Sbi32
source
impl CreateTypeSpec for Sbi64
source
impl CreateTypeSpec for Sbi128
source
impl<T: CreateTypeSpec> CreateTypeSpec for Vec<T>
source
impl<T: CreateTypeSpec> CreateTypeSpec for VecDeque<T>
source
impl<V: CreateTypeSpec> CreateTypeSpec for BTreeSet<V>
source
impl<T: CreateTypeSpec> CreateTypeSpec for Option<T>
source
impl<const LEN: usize> CreateTypeSpec for [u8; LEN]
Implementors
impl CreateTypeSpec for Address
impl CreateTypeSpec for Signature
impl<K: CreateTypeSpec, V: CreateTypeSpec> CreateTypeSpec for SortedVecMap<K, V>
impl CreateTypeSpec for SecretVarId
impl CreateTypeSpec for Hash
impl CreateTypeSpec for PublicKey
impl CreateTypeSpec for BlsPublicKey
impl CreateTypeSpec for BlsSignature
impl CreateTypeSpec for U256

## Impact of Contract State Size on CPU Cost:
The size of the contract state directly affects the CPU cost, primarily due to the serialization and deserialization processes. As the contract state grows larger, the gas cost for both serialization and deserialization increases. This is because larger state sizes require more computational resources to transform the state between its serialized and deserialized representations.

## Avoiding Excessive Serialization/Deserialization Cost:
To mitigate the impact of growing serialization and deserialization costs as the state size increases, developers can employ several techniques:

**Efficient Data Structures:** Designing smart contracts with efficient data structures can minimize the overall size of the contract state. Using compact data representations and optimizing data storage can help reduce the serialization and deserialization overhead.

**State Segmentation:** If the contract's state can be divided into distinct segments, developers can selectively deserialize and process only the necessary parts of the state. This approach can reduce the computational resources required for state manipulation and minimize serialization and deserialization costs.

**Off-chain Processing:** Certain operations or computations that don't require immediate on-chain execution can be offloaded to off-chain systems or side-chains. By performing these operations off-chain and updating the contract state with the final results, developers can minimize the serialization and deserialization costs incurred on the main blockchain.



## Serializing the correct formats
One optimization technique that can enhance gas efficiency is serialization by copy. This is a deep dive on how to effectively use serialization by copy in smart contract development, there will be references directly to the traits and methods defined in the pbc_traits::ReadWriteState which you can read more in the [rust docs](https://partisiablockchain.gitlab.io/language/contract-sdk/pbc_traits/trait.ReadWriteState.html).

Serialization is the process of converting complex data structures into a format suitable for storage or transmission. In smart contracts, serialization is often necessary when interacting with external systems, storing data on-chain, or passing parameters between functions. Efficient serialization can significantly impact gas usage and overall contract efficiency.

### Serialization_by_Copy and pbc_traits::ReadWriteState:
Serialization_by_copy involves creating a copy of the data in memory before serializing it. This approach can offer gas efficiency benefits over other serialization methods. The pbc_traits::ReadWriteState trait, marks implementations of the State serialization format. It provides methods and associated constants to support efficient serialization by copy.

#### Understanding Serialization Invariants:
The serialization invariants defined in the pbc_traits::ReadWriteState trait specify the expected behavior of serialization and deserialization operations. These invariants ensure consistency and correctness in the serialized data. They include:

Serialization Consistency: The serialization of a value, represented as b, should be deserializable to a value v2 that is identical to the original value v1. Deserialization Consistency: If a buffer b1 is deserializable to a value v, then the serialization of v, represented as b2, should be equal to b1.

#### Efficient Serialization by Copy Techniques:
To achieve efficient gas usage when using serialization by copy in smart contract development, consider the following techniques:

**Optimize Data Structures**: Design data structures to minimize memory usage, avoiding unnecessary nesting and choosing appropriate data types.

**Batch Operations**: Batch serialization operations to reduce gas costs. Combining multiple serialization steps into a single operation is more efficient than serializing each structure separately.

**Test and Iterate**: Thoroughly test and benchmark gas usage for different serialization approaches and data structures. Iterate on your implementation to achieve optimal gas efficiency.

### Convert to the most simple serialized format as possible. 


Gas usage optimization is crucial when developing smart contracts on blockchain platforms. By employing efficient serialization techniques like serialization by copy, developers can minimize gas costs and enhance contract performance. Understanding gas usage patterns, experimenting with different serialization approaches, and following best practices are key to developing gas-efficient smart contracts. Testing your contract on the testnet is the most precise way of understanding what the actual gas cost is of your operations.