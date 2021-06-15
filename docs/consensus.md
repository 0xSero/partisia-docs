# The FastTrack consensus

The FastTrack consensus protocol is an optimistic protocol with built-in failure recovery. When running optimistically a single block producer (proposer) continuously produces new blocks whilst the rest of the committee verify the validity of said blocks. After a fixed number of blocks have been proposed by a single producer a new proposer is chosen by the rules of the protocol.  As long as the proposer is honest and produces what are by the committee deemed as valid blocks, transactions can be executed eagerly allowing for a high transaction throughput.

If the proposer fails to produce valid blocks, either by losing network connectivity or malicious intent, the protocol enters what is called the *Shutdown state*. In this state the entire committee votes on which block is the newest. Once the committee has agreed on a block the next block proposer is chosen. To distinquish connectivity loss and a slow day on the chain, an empty heartbeat block every 30 seconds if no transactions are received.

Consensus is achieved using Proof-of-Justification (PoJ) and Proof-of-Finalization (PoF). PoJ is a list of 2/3 or more signatures confirming the validity of a block. This PoJ then becomes PoF for the previous block. Since the validity of the current block depends on the state of the previous, the previous block is considered final. This proof indirect and therefore is not flooded. It can be derived by any node that has access to the chain state.

Only Baker nodes run the ledger with a FastTrack plugin enabled and they communicate with the other Baker nodes for their specific [shard](shards.md). A separate consensus protocol runs for each available shard.
