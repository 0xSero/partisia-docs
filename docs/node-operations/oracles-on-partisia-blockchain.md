# Oracles on Partisia Blockchain

This text explains the essentials that a node operator should know about oracles on the chain. This includes: 

- The different types of oracles and what kind of work they do
- Joining and leaving an oracle i.e. the selection processes and formal conditions regulating node operators when joining and leaving an oracle



## What is a large oracle

The large oracle is synonymous with the current committee, and is responsible for settling disputes related to the actions of the small oracle. The large oracle consists of all the nodes in the current committee. Each node holds a keyshare that allows it to cast a vote on oracle decisions. Votes are decided by a 2/3s majority. The rules governing the large oracle are directed by the [large oracle contract](https://dashboard.partisiablockchain.com/info/contract/04f1ab744630e57fb9cfcd42e6ccbf386977680014). Node operators can associate tokens to this contract. The tokens can be used as a stake to be eligible for a job in a specific small oracle.

## What is a small oracle

There are oracles handling tasks related to [BYOC](../pbc-fundamentals/byoc-and-gas.md), these oracles are referred to as small oracles. The small oracles facilitate bridging of liquid cryptocurrencies to and from the chain as well as price monitoring. Small oracles include deposit oracles, withdrawal oracles and price oracles. 

## How to join a deposit or withdrawal oracle

To be eligible for selection to a deposit or withdrawal oracle a node must associate 250K MPC tokens to the large oracle contract. Deposit and withdrawal oracles are selected at random from the pool of eligible nodes. Chosen nodes serve in the oracle until the deposit or withdrawal limit has been met. Then three new nodes are selected. After serving a term the tokens associated to the large oracle contract will be locked in a pending status until a new oracle is selected. This allows for accountability in case of a dispute on the oracle that was just replaced. Nodes can serve repeatedly in the same oracle, if they have enough tokens (excluding the ones pending) associated to the large oracle contract to meet the conditions for eligibility. It is also possible to serve in more than one small oracle if enough tokens are available.

1. Sign in to the [Dashboard](https://dashboard.partisiablockchain.com/) or your preferred PBC browser
2. Find the [large oracle contract](https://dashboard.partisiablockchain.com/info/contract/04f1ab744630e57fb9cfcd42e6ccbf386977680014) with the address 04f1ab744630e57fb9cfcd42e6ccbf386977680014
3. Invoke the contract action _ASSOCIATETOKENSTOCONTRACT_
4. Choose an amount (minimum 250K MPC tokens)
5. Submit transaction

## How to leave a deposit or withdrawal oracle

It is possible to leave the oracle before the deposit or withdrawal limit has been met. If a node chooses to leave, then 3 new nodes will be selected to form the oracle. The tokens associated with a specific oracle will get pending status when a node leaves an oracle. However, the leaver can be chosen for the new oracle if they have enough tokens. For that reason it is advised to first disassociate unused tokens from the large oracle contract before attempting to leave an oracle.
Currently, there are deposit and withdrawal oracles for ETH, BNB, USDC and Matic.

1. Sign in to the [Dashboard](https://dashboard.partisiablockchain.com/) or your preferred PBC browser
2. Find the [large oracle contract](https://dashboard.partisiablockchain.com/info/contract/04f1ab744630e57fb9cfcd42e6ccbf386977680014) with the address 04f1ab744630e57fb9cfcd42e6ccbf386977680014
3. Invoke the contract action _DISASSOCIATETOKENSTOCONTRACT_
4. Match amount to the tokens not used by a specific oracle job
5. Submit transaction
6. Open the contract state
7. Search for your blockchain address to find the address of the deposit or withdrawal oracle in which your node serves
8. Go to the contract of the oracle your node is working in
9. Invoke the contract action _DEREGISTER_
10. Submit transaction

## How to join a price oracle

Price oracles monitor prices of the BYOC. They do not rely on a random selection process. Any node with sufficient tokens associated to the large oracle contract can register as a price oracle. To be eligible for a price oracle the price is 5K MPC tokens.

1. Go to the [Dashboard](https://dashboard.partisiablockchain.com/) and log in
2. Associate 5000 MPC tokens to the [Large Oracle Contract](https://dashboard.partisiablockchain.com/info/contract/04f1ab744630e57fb9cfcd42e6ccbf386977680014) by clicking the contract interaction button named "ASSOCIATETOKENSTOCONTRACT" (Skip this step if you have 5000 or more unused tokens already asociated with this contract)
3. Go to the [ETH Price Oracle Contract](https://dashboard.partisiablockchain.com/info/contract/0485010babcdb7aa56a0da57a840d81e2ea5f5705d) or [BNB Price Oracle Contract](https://dashboard.partisiablockchain.com/info/contract/049abfc6e763e8115e886fd1f7811944f43b533c39) and register by clicking the contract interaction button named "REGISTER"

You can learn more about the price oracles [here](price-oracle.md) 

## How to leave a price oracle

To leave the price oracle one simply needs to invoke deregistration at the contract the specific price oracle that your node is working for.

1. Sign in to the [Dashboard](https://dashboard.partisiablockchain.com/) or your preferred PBC browser
2. Find the [large oracle contract](https://dashboard.partisiablockchain.com/info/contract/04f1ab744630e57fb9cfcd42e6ccbf386977680014) with the address 04f1ab744630e57fb9cfcd42e6ccbf386977680014
3. Open the contract state
4. Search for your blockchain address to find the address of the price oracle in which your node serves
5. Go to the contract of the price oracle your node is working in 
6. Invoke the contract action _DEREGISTER_
7. Submit transaction
