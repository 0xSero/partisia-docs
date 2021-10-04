# Sharding 


Sharding has a big effect on your experience of interacting with Partisia Blockchain. Sharding ensures scalability of blockchain services. The chain can support an arbitrarily large number of shards. Transactions can be settled parallel and each shard can process around a 1000 transactions per second. Therefore the only practical limitation to  the number of transactions that PBC can perform is the network capacity between the nodes.
But, there are more good news. When you interact with the blockchain via smart contracts you do not have to take any measures to utilize the sharding in execution of transactions. The contracts you develop can be coded with no regard for the sharding. You harvest all the benefits in terms of speed and scalability, but none of the downside in form of complication of the contract development you see on other blockchains using sharding.

## How it works 


PBC is a blockchain that has the state, contracts and accounts distributed across multiple groups of nodes. These groups are called *shards*. Each shard has its own independent block time and it's own block producer which  enables parallel execution of transactions that do not depend on the same state. Every account and every contract live on a specific shard.

Shards have their own consensus and the current proposer/block time can drift freely between the shards. 
Shards operate independently of each other and can thus process transactions in parallel. If the chain has `n` shards then the chain can process `n` blocks simultaneously. 

When an account holder sends a transaction he/she does so to the shard his/her account lives on. The transaction spawns an event transaction that is then routed to the relevant shard and executed. If the destination contract lives on the same shard, the event is executed inline, otherwise it is flooded through the network to a node on the relevant shard. To ensure the validity of the propagated transaction the source shard adds a finalization proof to the sent event. This is needed because the destination shard cannot verify the validity of the transaction without the PoF since the destination shard does not have direct access to the state of the source shard. For more details on the proofs see [FastTrack consensus](consensus.md).