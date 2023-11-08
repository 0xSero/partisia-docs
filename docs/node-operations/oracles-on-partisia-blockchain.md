# Oracles on Partisia Blockchain

This text explains the essentials that a node operator should know about oracles on the chain. This includes: 

- The different types of oracles and what kind of work they do
- Joining and leaving an oracle i.e. the selection processes and formal conditions regulating node operators when joining and leaving an oracle



## What is a large oracle

The large oracle is synonymous with the current committee, and is responsible for settling disputes related to the actions of the small oracle. The large oracle consists of all the nodes in the current committee. Each node holds a keyshare that allows it to cast a vote on oracle decisions. Votes are decided by a 2/3s majority. The rules governing the large oracle are directed by the [large oracle contract](https://browser.partisiablockchain.com/contracts/04f1ab744630e57fb9cfcd42e6ccbf386977680014). Node operators can associate tokens to this contract. The tokens can be used as a stake to be eligible for a job in a specific small oracle.

## What is a small oracle

There are oracles handling tasks related to [BYOC](../pbc-fundamentals/byoc.md), these oracles are referred to as small oracles. The small oracles facilitate bridging of liquid cryptocurrencies to and from the chain as well as price monitoring. Small oracles include [deposit oracles](../pbc-fundamentals/bridging-byoc-by-sending-transactions.md#how-to-make-a-deposit), [withdrawal oracles](../pbc-fundamentals/bridging-byoc-by-sending-transactions.md#how-to-make-a-withdrawal) and [price oracles](../pbc-fundamentals/dictionary.md#price-oracle). 

