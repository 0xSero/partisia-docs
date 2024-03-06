# Consensus

Below we give a brief introduction to the consensus mechanism used by [PBC](../pbc-fundamentals/dictionary.md#pbc).

However, before discussing the concrete consensus mechanism, let us first provide some intuition for why a consensus mechanism is needed and the functionality such mechanism provides. 

## Why a consensus mechanism is needed

## What is a consensus mechanism

## FastTrack: The consensus mechanism of PBC
Partisia Blockchain uses a tailor-made consensus mechanism called *FastTrack*. 

The FastTrack consensus protocol is an optimistic protocol with built-in failure recovery. When running optimistically a single block producer (proposer) continuously produces new blocks whilst the rest of the committee verify the validity of said blocks. After a fixed number of blocks have been proposed by a single producer a new proposer is chosen by the rules of the protocol. As long as the proposer is honest and produces what are by the committee deemed as valid blocks, transactions can be executed eagerly allowing for a high transaction throughput.

If the proposer fails to produce valid blocks, either by losing network connectivity or malicious intent, the protocol enters what is called the *Shutdown state*. In this state the entire committee votes on which block is the newest. Once the committee has agreed on a block the next block proposer is chosen. To distinquish connectivity loss and a slow day on the chain, an empty heartbeat block is produced every 30 seconds if no transactions are received.

Consensus is achieved using Proof-of-Justification (PoJ) and Proof-of-Finalization (PoF). Let $n$ be the number of committee members in the current committee. A PoJ is then a list of at least $\lfloor n\cdot \frac{2}{3}\rfloor + 1$ or more signatures confirming the validity of a block. This PoJ then becomes PoF for the previous block. Since the validity of the current block depends on the state of the previous, the previous block is considered final. 

Only Baker nodes run the ledger with a FastTrack plugin enabled and they communicate with the other Baker nodes for their specific shard. Since a separate consensus protocol runs for each available shard, cross-shard communication requires the propagation of the PoF from one shard to another. This effectively means that an event spawned on shard $A$ at block time $t_A = i$ is only valid when $i$ is finalized, which is at $t_A = i + 1$.


### Properties of the FastTrack protocol

### Details of the FastTrack protocol
