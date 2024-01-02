# Run a deposit or withdrawal oracle

Below you see how to make your node eligible for serving in a deposit or
withdrawal [oracle](../pbc-fundamentals/dictionary.md#oracle-node), and how to deregister if you want to stop providing
the service. The transfer of cryptocurrencies to and from PBC is facilitated by deposit and withdrawal oracles each 
consisting of three nodes.

!!! Warning " You must complete these requirements before you can continue"    
    - [Run baker node](run-a-baker-node.md) ([is my baker node running?](node-health-and-maintenance.md#is-your-baker-node-working))    
    - [Stake 275 K MPC tokens](https://browser.partisiablockchain.com/node-operation) (this includes the 25 K for running a
baker) [See if your baker is running correctly](node-health-and-maintenance.md#is-your-baker-node-working)

## How to join a deposit or withdrawal oracle

To be eligible for serving a deposit or withdrawal oracle the node account must associate 250,000 MPC tokens to
the [large oracle](../pbc-fundamentals/dictionary.md#large-oracle)
contract. Deposit and withdrawal oracles are selected at random from the pool of eligible nodes. Chosen nodes serve in
the oracle until the deposit or withdrawal limit is reached. Then three new nodes are selected. After serving a term the
tokens associated to the large oracle contract will be locked in a pending status until a new oracle is selected. This
allows for accountability in case of a dispute on the oracle that was just replaced. Nodes can serve repeatedly in the
same oracle, if they have enough tokens (excluding the ones pending) associated to the large oracle contract. It is also
possible to serve in more than one small oracle if enough tokens are available.

1. Find
   the [large oracle contract](https://browser.partisiablockchain.com/contracts/04f1ab744630e57fb9cfcd42e6ccbf386977680014/associateTokensToContract)
   with the address `04f1ab744630e57fb9cfcd42e6ccbf386977680014`
2. Sign in (upper right corner)
3. Invoke the contract action _AssociateTokenstoContract_ with a minimum amount of 250K MPC token
4. Submit transaction

## How to leave a deposit or withdrawal oracle

It is possible to leave the oracle before the deposit or withdrawal limit has been met by requesting a new oracle. If a node chooses to leave, then
3 new nodes will be selected to form the oracle. The tokens associated with a specific oracle will get pending status
when a node leaves an oracle. However, the leaver can be chosen for the new oracle if they have enough tokens. For that
reason it is advised to first disassociate unused tokens from the large oracle contract before attempting to leave an
oracle. Currently, there are deposit and withdrawal oracles for ETH, BNB, USDC and Matic.

### How to find out which price oracle your node serves

If you know which price oracle your node is serving, you should skip ahead to Request new oracle

1. Open the [large oracle contract state](https://browser.partisiablockchain.com/contracts/04f1ab744630e57fb9cfcd42e6ccbf386977680014?tab=state)
2. Open the map `stakedTokens`
3. Search for your blockchain address `CTRL+f`
4. Open the struct next to your blockchain address
5. Open the map `lockedToOracle`
6. You can see the addresses of the oracles your node serve and MPC tokens staked to them
7. Copy the address of the oracle you want to leave (you can distinguish the price oracles from deposit and withdrawal oracles by looking at the amount of MPC tokes they have "locked", price oracles have 5000, deposit and withdrawal oracles 250,000)
8. Paste the address to the search field of the browser, to navigate to the contract

**Request new oracle:**   

- Invoke the contract action _requestNewOracle_ (you must by logged in to perform this action)   
 

!!! note "Note"
    You can only invoke this action if you are serving in the oracle and
    28 days have passed since the oracle was last changed, confirm this in the contract state by checking the unix
    timestamp in the field named `"oracleTimestamp"`
    
