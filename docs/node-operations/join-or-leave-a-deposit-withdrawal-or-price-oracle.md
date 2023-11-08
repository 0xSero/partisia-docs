# Join or leave a deposit, withdrawal or price oracle

## How to join a deposit or withdrawal oracle

To be eligible for selection to a deposit or withdrawal oracle a node must associate 250K MPC tokens to the large oracle contract. Deposit and withdrawal oracles are selected at random from the pool of eligible nodes. Chosen nodes serve in the oracle until the deposit or withdrawal limit has been met. Then three new nodes are selected. After serving a term the tokens associated to the large oracle contract will be locked in a pending status until a new oracle is selected. This allows for accountability in case of a dispute on the oracle that was just replaced. Nodes can serve repeatedly in the same oracle, if they have enough tokens (excluding the ones pending) associated to the large oracle contract to meet the conditions for eligibility. It is also possible to serve in more than one small oracle if enough tokens are available.

1. Find the [large oracle contract](https://browser.partisiablockchain.com/contracts/04f1ab744630e57fb9cfcd42e6ccbf386977680014/associateTokensToContract) with the address 04f1ab744630e57fb9cfcd42e6ccbf386977680014
2. Sign in (upper right corner)
3. Invoke the contract action _AssociateTokenstoContract_ with a minimum amount of 250K MPC token
4. Submit transaction

## How to leave a deposit or withdrawal oracle

It is possible to leave the oracle before the deposit or withdrawal limit has been met. If a node chooses to leave, then 3 new nodes will be selected to form the oracle. The tokens associated with a specific oracle will get pending status when a node leaves an oracle. However, the leaver can be chosen for the new oracle if they have enough tokens. For that reason it is advised to first disassociate unused tokens from the large oracle contract before attempting to leave an oracle.
Currently, there are deposit and withdrawal oracles for ETH, BNB, USDC and Matic.

1. Find the [large oracle contract](https://browser.partisiablockchain.com/contracts/04f1ab744630e57fb9cfcd42e6ccbf386977680014/disassociateTokensFromContract) with the address 04f1ab744630e57fb9cfcd42e6ccbf386977680014
2. Sign in (upper right corner)
3. Invoke the contract action _DisassociateTokensFromContract_
4. Match amount to the tokens not used by a specific oracle job
5. Submit transaction
6. Open the contract state
7. Search for your blockchain address to find the address of the deposit or withdrawal oracle in which your node serves
8. Go to the contract of the oracle your node is working in
9. Invoke the contract action _requestNewOracle_ (you can only invoke this action if you are serving in the oracle and 28 days have passed since the oracle was last changed, confirm this in the contract state by checking the unix timestamp in the field named _"oracleTimestamp"_)
10. Submit transaction

## How to join a price oracle

Price oracles monitor prices of the BYOC. They do not rely on a random selection process. Any node with sufficient tokens associated to the large oracle contract can register as a price oracle. To be eligible for a price oracle the price is 5K MPC tokens.

1. Find the [large oracle contract](https://browser.partisiablockchain.com/contracts/04f1ab744630e57fb9cfcd42e6ccbf386977680014/associateTokensToContract)
2. Sign in (upper right corner)
3. Invoke the contract action _AssociateTokenstoContract_ with a minimum amount of 5000 MPC tokens
4. Go to the [ETH Price Oracle Contract](https://browser.partisiablockchain.com/contracts/0485010babcdb7aa56a0da57a840d81e2ea5f5705d/register) or [BNB Price Oracle Contract](https://browser.partisiablockchain.com/contracts/049abfc6e763e8115e886fd1f7811944f43b533c39/register) and invoke the action _Register_

You can learn more about the price oracles [here](../pbc-fundamentals/dictionary.md#price-oracle)


## How to leave a price oracle

To leave the price oracle one simply needs to invoke deregistration at the contract the specific price oracle that your node is working for.

1. Find the [large oracle contract](https://browser.partisiablockchain.com/contracts/04f1ab744630e57fb9cfcd42e6ccbf386977680014) with the address 04f1ab744630e57fb9cfcd42e6ccbf386977680014
2. Open the contract state
3. Search for your blockchain address to find the address of the price oracle in which your node serves
4. Go to the contract of the price oracle your node is working in
5. Sign in (upper right corner)
6. Invoke the contract action _Deregister_
7. Submit transaction
