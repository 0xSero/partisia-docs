# Consensus

Below we give a brief introduction to the consensus mechanism used by [PBC](./dictionary.md#pbc).

However, before discussing the concrete consensus mechanism, let us first provide some intuition for why a consensus mechanism is needed and the functionality such mechanism provides. 

## Why a consensus mechanism is needed

As described in the [Introduction to the fundamentals](./introduction-to-the-fundamentals.md#what-is-a-blockchain) the core functionality of a blockchain is that it is decentralized database. The fact that it is *decentralized* simply means that no single note controls the access to the database. That is, multiple nodes have a copy of the database (in fact any party that would like to have a copy of the database are free to obtain it) and all these copies must be *consistent*.

To gain some intuition for what this entails let us consider a simple example of a naive (inconsistent) implementation of decentralized data base. In our example, we will consider a database that is supposed to contain non-overdraft bank account balances at two nodes $N_1$ and $N_2$, where the nodes simply executes transactions as soon as they receive them. Additionally, let us consider 3 parties that each have a bank account in the decentralized data base: Alice, Bob, and Charlie. For our example, let the initial state of the database at both $N_1$ and $N_2$ be:

| Account | Balance |
|---------|---------|
| Alice   | 50 \$   |
| Bob     | 0 \$    |
| Charlie | 0 \$    |

Now, Alice would like to buy two services that each cost 50 \$: one from Bob and one from Charlie. However, she only has 50 \$ available, so how could she still obtain both services?

Alice could first buy a service from Bob by making a transaction $T_{AB}$ in which she sends the 50 \$ to Bob, send it only to $N_1$, and convince Bob to check his account balance at $N_1$ which would then show: 

| Account | Balance |
|---------|---------|
| Alice   | 0  \$   |
| Bob     | 50 \$   |
| Charlie | 0 \$    |

Swiftly after (before the transaction $T_{AB}$ reaches $N_2$), she could then buy the service from Charlie by making a transaction $T_{AC}$ in which she sends 50 \$ to Charlie, send the transaction to $N_2$, and convince Bob to check his balance at $N_2$ which would then show: 

| Account | Balance |
|---------|---------|
| Alice   | 0  \$   |
| Bob     | 0 \$    |
| Charlie | 50 \$    |


That is, the databases are in an inconsistent state and the non-overdraft policy of the system was not enforced as the protocol allowed Alice to *double-spend* her savings.

To prevent such scenario it is *crucial* ensure that decentralized databases are consistent by ensuring that *all transactions are executed in the same order* at all nodes holding a copy of the database.

## What is a consensus mechanism
A consensus mechanism is a protocol that ensures that all nodes that participate in the mechanism executes all transactions in the same order. That is, it provides a *total order on input transactions*. 

Here, we will not go into the technical definition of what it means that that transactions are totally ordered but instead refer the interested reader to [Details of the FastTrack protocol](#details-of-the-fasttrack-protocol), where a precise characterization of this is given. 


## FastTrack: The consensus mechanism of PBC
Partisia Blockchain uses a tailor-made consensus mechanism called *FastTrack*. 

The FastTrack consensus protocol is an optimistic protocol with built-in failure recovery. When running optimistically a single block producer (proposer) continuously produces new blocks whilst the rest of the committee verify the validity of said blocks. After a fixed number of blocks have been proposed by a single producer a new proposer is chosen by the rules of the protocol. As long as the proposer is honest and produces what are by the committee deemed as valid blocks, transactions can be executed eagerly allowing for a high transaction throughput.

If the proposer fails to produce valid blocks, either by losing network connectivity or malicious intent, the protocol enters what is called the *Shutdown state*. In this state the entire committee votes on which block is the newest. Once the committee has agreed on a block the next block proposer is chosen. To distinquish connectivity loss and a slow day on the chain, an empty heartbeat block is produced every 30 seconds if no transactions are received.

Consensus is achieved using Proof-of-Justification (PoJ) and Proof-of-Finalization (PoF). Let $n$ be the number of committee members in the current committee. A PoJ is then a list of at least $\lfloor n\cdot \frac{2}{3}\rfloor + 1$ or more signatures confirming the validity of a block. This PoJ then becomes PoF for the previous block. Since the validity of the current block depends on the state of the previous, the previous block is considered final. 

Only Baker nodes run the ledger with a FastTrack plugin enabled and they communicate with the other Baker nodes for their specific shard. Since a separate consensus protocol runs for each available shard, cross-shard communication requires the propagation of the PoF from one shard to another. This effectively means that an event spawned on shard $A$ at block time $t_A = i$ is only valid when $i$ is finalized, which is at $t_A = i + 1$.


### Properties of the FastTrack protocol

### Details of the FastTrack protocol
