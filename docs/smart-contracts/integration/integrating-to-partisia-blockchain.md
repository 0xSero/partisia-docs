# Integrating to Partisia Blockchain

We have collected articles that help you integrate your application with the rest of Partisia Blockchain in this section. 
There are different ways of integrating with the Partisia Blockchain and figuring out what tool to use is explained in the next couple of pages. If you need help with the integration feel free to engage with the dev-community [on our discord](../../get-support-from-pbc-community.md)
This page is a collection of links to help you navigate how you can access REST endpoints and work with transactions.
The next set of articles aims to explain how to do on-chain / off-chain interactions, how to understand our standard contract
interfaces to recognize NFTs or tokens as part of your application. Lastly there are individual articles which specifies specific integration topics to help you work with the blockchain from your own application. 


## Rest endpoint examples
Blockchain nodes, including reader nodes gives access to blocks, transactions, contract state and more through suitable
REST endpoints. We have collected the most important examples below:

[A rest server source where you can find different endpoints and data types returned](https://gitlab.com/partisiablockchain/core/server).

If you want to look for specific transactions on a shard, we have an endpoint that helps you get [the latest transactions](https://reader.partisiablockchain.com/shards/Shard0/blockchain/transaction/latest/10/2018112).

[Endpoint for looking at a single specific transaction on a shard](https://reader.partisiablockchain.com/shards/Shard1/blockchain/transaction/11d09178b39c10520aec717200a4a5cd229e948bc15c4a87e65d682008f86db5).

[Endpoint giving information about a smart contract including the ABI and current state](https://node1.testnet.partisiablockchain.com/shards/Shard2/blockchain/contracts/0296b935f95dbf30d0921ee23686099027b9759480?requireContractState=true).

[Libraries](../smart-conract-tools-overview.md#libraries)

[The ABI that is used for deserializing fundamental transaction & event structures](https://gitlab.com/partisiablockchain/language/abi/abi-client/-/tree/main/client/src/main/resources?ref_type=heads).