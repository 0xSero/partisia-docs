# Integrating to Partisia Blockchain

An important part of working with the blockchain is being able to use the blockchain in other systems. Here we have
collected multiple links to help you navigate how you can access REST endpoints and work with transactions and articles
to give understandings of standard contract interfaces or how to use other systems with PBC
REST Server

Blockchain nodes, including reader nodes gives access to blocks, transactions, contract state and more through suitable
REST endpoints. We have collected the most important examples below:

https://gitlab.com/partisiablockchain/core/server The REST server source where you can find the different endpoints and
data types returned

https://reader.partisiablockchain.com/shards/Shard0/blockchain/transaction/latest/10/2018112 Example of the endpoint for
traversing transactions on a shard.

https://reader.partisiablockchain.com/shards/Shard1/blockchain/transaction/11d09178b39c10520aec717200a4a5cd229e948bc15c4a87e65d682008f86db5
Example of the endpoint for looking at a single specific transaction on a shard.

https://node1.testnet.partisiablockchain.com/shards/Shard2/blockchain/contracts/0296b935f95dbf30d0921ee23686099027b9759480?requireContractState=true
Example
of the endpoint giving information about a smart contract including the ABI and current state.

### Libraries

[Client library](../smart-conract-tools-overview.md#client) for fetching information from the node REST server, and
for submitting transactions.

[Abi-client](../smart-conract-tools-overview.md#abi-client) Library for deserializing & serializing binary data
from ABI's. This can be used both for deserializing the fundamental transaction & event structures -
and [RPC](../smart-contract-binary-formats.md#rpc-binary-format) send to
smart contracts.

https://gitlab.com/partisiablockchain/language/abi/abi-client/-/tree/main/client/src/main/resources?ref_type=heads
The ABI that is used for deserializing fundamental transaction & event structures.

