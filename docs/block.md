# Block

A block is the basic component of the blockchain ledger. Each block contains a batch of valid [transactions](transactions.md) and [events](events.md) that have been executed at a given *block time*. The block time is incremental. The chain is started with a genesis block that defines the initial state of the blockchain. Each block has a reference to its parent block thus forming a chain all the way back to the genesis block.

A block is produced by a block producer. When a block is produced the transactions and events are executed and the resulting state is stored as the current state. The produced block is then validated by  the committee according to the currently running [consensus protocol](consensus.md).
