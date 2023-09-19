



REST Server

Blockchain nodes, including reader nodes gives access to blocks, transactions, contract state and more through suitable REST endpoints

https://gitlab.com/partisiablockchain/core/serverThe REST server source where you can find the different endpoints and data types returned

https://reader.partisiablockchain.com/shards/Shard0/blockchain/transaction/latest/10/2018112Example of the endpoint for traversing transactions on a shard.

https://reader.partisiablockchain.com/shards/Shard1/blockchain/transaction/11d09178b39c10520aec717200a4a5cd229e948bc15c4a87e65d682008f86db5Example of the endpoint for looking at a single specific transaction on a shard.

https://node1.testnet.partisiablockchain.com/shards/Shard2/blockchain/contracts/0296b935f95dbf30d0921ee23686099027b9759480?requireContractState=trueExample of the endpoint giving information about a smart contract including the ABI and current state.

Libraries

https://gitlab.com/partisiablockchain/core/clientJava library for fetching information from the node REST server, and for submitting transactions.

https://gitlab.com/partisiablockchain/language/abi/abi-clientJava library for deserializing & serializing binary data from ABI's. This can be used both for deserializing the fundamental transaction & event structures - and RPC send to smart contracts.

https://gitlab.com/partisiablockchain/language/abi/abi-client-tsTypeScript version of the library for deserializing & serializing binary data from ABI's.

https://gitlab.com/partisiablockchain/language/abi/abi-client/-/tree/main/client/src/main/resources?ref_type=headsThe ABI that is used for deserializing fundamental transaction & event structures.

