# Gas pricing 

Gas pricing plays a crucial role in the Partisia blockchain ecosystem, aiming to assist developers in creating and deploying smart contracts successfully. Partisia gas pricing mechanism ensures predictability of gas costs for transactions, even as the amount of data handled by the contract grows. This predictability empowers developers to estimate and manage the computational resources required for their smart contract operations effectively.

## The cost for using the blockchain

Gas on Partisia Blockchain is fixed, you pay for what you use. Gas units are pegged to the USD. The fixed ratio is 100,000 gas units to 1 USD.

The price for different services on the blockchain has been decided in [the yellow paper](https://drive.google.com/file/d/1OX7ljrLY4IgEA1O3t3fKNH1qSO60_Qbw/view)(Page 16) to tentatively match the following prices in USD:

**Basic fees:**

- Network fee: 5 USD cents/kb.
- CPU fee: 5 USD cents per 1000 instructions.
- Storage fee: 1 USD cent/kb per year.

## Calculation of Gas Cost for a Transaction:
The gas cost for a transaction in Partisia blockchain is determined by considering three main factors: network, storage, and CPU.

**Network Cost:** The network cost is associated with the transmission of the transaction across the blockchain network. It takes into account the bandwidth and other networking resources utilized during the transaction's propagation.

**Storage Cost:** The storage cost represents the gas required to store data on the blockchain. It includes the cost of writing data to the blockchain's storage and maintaining its integrity over time.

**CPU Cost:** The CPU cost reflects the computational resources consumed during the execution of a smart contract transaction. It consists of three primary stages: deserializing the contract state, performing the required work or computations, and serializing the updated contract state.

## CPU Cost and its Operation:
The CPU cost is a crucial aspect of gas pricing and is divided into three distinct stages:

**Deserialize State:** Before executing a smart contract, the contract's current state needs to be deserialized. This process involves converting the serialized contract state into a data structure that can be manipulated and processed by the blockchain's virtual machine. The gas cost associated with this step depends on the size and complexity of the contract state.

**Perform Work:** Once the contract state is deserialized, the required computations or work specified by the smart contract are performed. This work may involve various operations such as calculations, data manipulation, and interactions with other contracts or external systems. The gas cost for this stage depends on the complexity and intensity of the computations involved.

**Serialize State:** After the work is completed, the contract state is serialized back into a format suitable for storage on the blockchain. This step ensures that the updated state can be stored and accessed efficiently. The gas cost associated with serialization depends on the size and complexity of the updated contract state.


## Impact of Contract State Size on CPU Cost:
The size of the contract state directly affects the CPU cost, primarily due to the serialization and deserialization processes. As the contract state grows larger, the gas cost for both serialization and deserialization increases. This is because larger state sizes require more computational resources to transform the state between its serialized and deserialized representations.

## Avoiding Excessive Serialization/Deserialization Cost:
To mitigate the impact of growing serialization and deserialization costs as the state size increases, developers can employ several techniques:

**Efficient Data Structures:** Designing smart contracts with efficient data structures can minimize the overall size of the contract state. Using compact data representations and optimizing data storage can help reduce the serialization and deserialization overhead.

**State Segmentation:** If the contract's state can be divided into distinct segments, developers can selectively deserialize and process only the necessary parts of the state. This approach can reduce the computational resources required for state manipulation and minimize serialization and deserialization costs.

**Off-chain Processing:** Certain operations or computations that don't require immediate on-chain execution can be offloaded to off-chain systems or side-chains. By performing these operations off-chain and updating the contract state with the final results, developers can minimize the serialization and deserialization costs incurred on the main blockchain.

By considering the above gas pricing properties, Partisia blockchain empowers developers to estimate and manage the gas costs associated with smart contract transactions. This predictability facilitates successful deployment of smart contracts, even as the data handled by the contract grows, promoting a more