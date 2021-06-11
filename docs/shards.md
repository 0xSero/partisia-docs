# Shards

PBC is a blockchain that has the state, contracts and accounts distributed across mutliple groups of nodes. These groups are called *shards*. Each shard has it's own independent block time and it's own block producer which  enables parallel execution of transactions that do not depend on the same state.

Every account and contract live on a specific shard.  Cross-shard communication happens with [events](events.md) that can be spawned by any transaction.
