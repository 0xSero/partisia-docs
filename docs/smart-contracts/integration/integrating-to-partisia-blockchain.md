# Integrating to Partisia Blockchain

We have collected articles that help you integrate your application with the rest of Partisia Blockchain in this
section.
There are different ways of integrating with the Partisia Blockchain and figuring out what tool to use is explained in
the next sets of articles. If you cant find what you need, feel free to engage with the
dev-community [on our discord](../../get-support-from-pbc-community.md).

## Rest endpoint examples and libraries

Blockchain nodes, including reader nodes gives access to blocks, transactions, contract state and more through
REST endpoints. A REST endpoint can be any node which allows for you to access through their endpoint. Most often the
endpoint is a [reader node](../../node-operations/what-is-a-node-operator.md) which allows you to read blocks, state and
transactions and makes it possible for you to send
transactions. We have created libraries to help you
create such transactions for the blockchain and help you use the rest endpoints available. Below is a collection
of commonly used rest endpoints. If you are in need of access to a rest server without running your own reader node, the best way would be
to ask in the [Discord of the community](../../get-support-from-pbc-community.md). 

In our [rest server source repo](https://gitlab.com/partisiablockchain/core/server), you can find different endpoints
and what data types they return.

If you want to look for specific transactions on a shard, we have an endpoint that helps you get the latest
transactions. Click the link to see a live example.

[`https://reader.partisiablockchain.com/shards/[Shard that you want the lastest transaction from]/blockchain/transaction/latest/10/2018112`](https://reader.partisiablockchain.com/shards/Shard0/blockchain/transaction/latest/10/2018112)

If you need to look at a specific transaction on a shard you can use this endpoint for finding the transaction. You can
click the below link to see a live example.

[`https://reader.partisiablockchain.com/shards/[Shard that your transaction is on]/blockchain/transaction/[YOUR TRANSACTION HASH]`](https://reader.partisiablockchain.com/shards/Shard1/blockchain/transaction/11d09178b39c10520aec717200a4a5cd229e948bc15c4a87e65d682008f86db5)

If you need to get information about a smart contract with the ABI and current state:
[`https://node1.testnet.partisiablockchain.com/shards/[Shard that your transaction is on]/blockchain/contracts/[YOUR CONTRACT HASH]?requireContractState=true`](https://node1.testnet.partisiablockchain.com/shards/Shard2/blockchain/contracts/0296b935f95dbf30d0921ee23686099027b9759480?requireContractState=true)

To integrate and help you create transactions onto the blockchain we have a big collection
of [libraries](../smart-contract-tools-overview.md#libraries).

[The ABI that is used for deserializing fundamental transaction & event structures](https://gitlab.com/partisiablockchain/language/abi/abi-client/-/tree/main/client/src/main/resources?ref_type=heads).