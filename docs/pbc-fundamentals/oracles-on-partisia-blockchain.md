# Oracles on Partisia Blockchain

This text covers the types roles and selection processes for oracles on the chain. There are two types of oracles on Partisia Blockchain: A small oracle, and a large oracle. The large oracle is synonymous with the committee, and is responsible for settling disputes related to the actions of the small oracle. The large oracle consists of all the nodes in the current committee. Each node holds a keyshare that allows it to cast a vote on oracle decisions. Votes are decided by a 2/3s majority.
There are oracles handling tasks related to [BYOC](byoc-and-gas.md), these oracles are referred to as small oracles. The small oracles facilitate bridging of liquid cryptocurrencies to and from the chain as well as price monitoring.

## Large and Small oracles

The rules governing the large oracle are directed by the large oracle contract. Node operators can associate tokens to this contract. The tokens can be used as a stake to be eligible for a job in a specific small oracle. To be eligible for selection to a deposit or withdrawal oracle a node must associate 250K MPC tokens to the large oracle contract. To be eligible for a price oracle the price is 5K MPC tokens.
Deposit and withdrawal oracles are selected at random from the pool of eligible nodes. Chosen nodes serve in the oracle until the deposit or withdrawal limit has been met. Then three new nodes are selected. After serving a term the tokens associated to the large oracle contract will be locked in a pending status until a new oracle is selected. This allows for accountability in case of a dispute on the oracle that was just replaced. Nodes can serve repeatedly in the same oracle, if they have enough tokens (excluding the ones pending) associated to the large oracle contract to meet the conditions for eligibility. It is also possible to serve in more than one small oracle if enough tokens are available.

## Leaving a deposit or withdrawal oracle

It is possible to leave the oracle before the deposit or withdrawal limit has been met. If a node chooses to leave, then 3 new nodes will be selected to form the oracle. The tokens associated with a specific oracle will get pending status when a node leaves an oracle. However, the leaver can be chosen for the new oracle if they have enough tokens. For that reason it is advised to first disassociate unused tokens from the large oracle contract before attempting to leave an oracle.
Currently, there are deposit and withdrawal oracles for ETH, BNB, USDC and Matic.

## Price oracles

[Price oracles](oracles-on-partisia-blockchain.md) monitor prices of the BYOC. They do not rely on a random selection process. Any node with sufficient tokens associated to the large oracle contract can register as a price oracle.
To leave the price oracle one simply needs to invoke deregistration at the price oracle contract. 
