# Run a deposit or withdrawal oracle

Below you see how to make your node eligible for serving in a deposit or
withdrawal [oracle](../pbc-fundamentals/dictionary.md#oracle-node), and how to deregister if you want to stop providing
the service. The transfer of cryptocurrencies to and from PBC is facilitated by deposit and withdrawal oracles each 
consisting of three nodes.

!!! Warning " You must complete these requirements before you can continue"    

    - [Run baker node](run-a-baker-node.md) ([is my baker node running?](node-health-and-maintenance.md#is-your-baker-node-working))    
    - [Stake 275 K MPC tokens](https://browser.partisiablockchain.com/node-operation) (this includes the 25 K for running a
    baker)
    - You have working BYOC endpoints in your `config.json` - [see how to confirm this](node-health-and-maintenance.md#confirm-that-your-byoc-endpoints-are-working)



## How to join a deposit or withdrawal oracle

1. Find
   the [large oracle contract](https://browser.partisiablockchain.com/contracts/04f1ab744630e57fb9cfcd42e6ccbf386977680014/associateTokensToContract)
   with the address `04f1ab744630e57fb9cfcd42e6ccbf386977680014`
2. Sign in (upper right corner)
3. Invoke the contract action _AssociateTokenstoContract_ with a minimum amount of 250K MPC token
4. Submit transaction

Deposit and withdrawal oracles are randomly selected form nodes 250K unused MPC tokens associated to the [large oracle](../pbc-fundamentals/governance-system-smart-contracts-overview.md#node-operation)
contract. When the deposit or withdrawal limit has been met, 3 new nodes will be selected. The tokens of the 3 nodes
associated with a specific oracle will get pending status for 28 days. Your node can serve in more than one oracle and be
reselected to same oracle if you have enough tokens associated to
the [large oracle contract](https://browser.partisiablockchain.com/contracts/04f1ab744630e57fb9cfcd42e6ccbf386977680014/associateTokensToContract)
.

## How to leave a deposit or withdrawal oracle

If you cannot wait for the deposit or withdrawal limit has been met, or if your node has to be shut down for
maintenance. You can request a new oracle. This will end the [epoch](../pbc-fundamentals/dictionary.md#epoch) of the
oracle. 3 new nodes will be selected. The tokens of the 3 nodes associated with a specific oracle will get pending
status for 28 days. If you have enough tokens available the node can be reselected for the same oracle. Avoid that by
[disassociating](https://browser.partisiablockchain.com/contracts/04f1ab744630e57fb9cfcd42e6ccbf386977680014/disassociateTokensFromContract)
unused tokens in the large oracle contract.

### How to find out which oracle your node serves

If you know which price oracle your node is serving, you should skip ahead to Request new oracle

1. Open the [large oracle contract state](https://browser.partisiablockchain.com/contracts/04f1ab744630e57fb9cfcd42e6ccbf386977680014?tab=state)
2. Open the map `stakedTokens`
3. Search for your blockchain address `CTRL+f`
4. Open the struct next to your blockchain address
5. Open the map `lockedToOracle`
6. You can see the addresses of the oracles your node serve and MPC tokens staked to them
7. Copy the address of the oracle you want to leave (you can distinguish the price oracles from deposit and withdrawal oracles by looking at the amount of MPC tokes they have "locked", price oracles have 5000, deposit and withdrawal oracles 250,000)
8. Paste the address to the search field of the browser, to navigate to the contract

### Request new oracle   

- Invoke the contract action _requestNewOracle_ [List of oracle contracts](../pbc-fundamentals/byoc/bridging-byoc-by-sending-transactions.md#bridgeable-coins-on-mainnet) (you must be logged in to perform this action)   
 

!!! note "Note"
    You can only invoke this action if you are serving in the oracle and
    28 days have passed since the oracle was last changed, confirm this in the contract state by checking the unix
    timestamp in the field named `"oracleTimestamp"`
    
