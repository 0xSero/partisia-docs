# Run a price oracle node

Price oracles monitor prices of the BYOC. They do not rely on a random selection process. Any node with sufficient tokens associated to the large oracle contract can register as a price oracle. Price oracles monitor prices of the BYOC. They do not rely on a random selection process. Any node with sufficient tokens associated to the large oracle contract can register as a price oracle.

## Join a price oracle


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
