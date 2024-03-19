# Run a price oracle node

This page teaches you to register your baker node for the additional service of price oracle, and how to deregister from
the service in case you want to use the tokens for something else.

Price oracles monitor and report prices of the [BYOC](../pbc-fundamentals/byoc/introduction-to-byoc.md) (You can learn more about the price oracles [here](../pbc-fundamentals/dictionary.md#price-oracle)). Any node with
sufficient tokens associated to the large oracle contract can register as a price oracle.

!!! Warning " You must complete these requirements before you can continue"    
    - [Stake 30 K MPC tokens](https://browser.partisiablockchain.com/node-operation) (including the 25 K for baker service)     
    - [Run a baker node](run-a-baker-node.md)    


## Register as a price oracle

Becoming a price oracle require a stake of 5000 MPC associated to the large oracle contract and a _Register_ transaction at one of the price oracles:

1. Find
   the [large oracle contract](https://browser.partisiablockchain.com/contracts/04f1ab744630e57fb9cfcd42e6ccbf386977680014/associateTokensToContract)
   with the address `04f1ab744630e57fb9cfcd42e6ccbf386977680014`
2. Sign in (upper right corner)
3. Invoke the contract action [AssociateTokenstoContract](https://browser.partisiablockchain.com/contracts/04f1ab744630e57fb9cfcd42e6ccbf386977680014/associateTokensToContract) with a minimum amount of 5000 MPC tokens
4. Go to
   the [ETH Price Oracle Contract](https://browser.partisiablockchain.com/contracts/0485010babcdb7aa56a0da57a840d81e2ea5f5705d/register)
   or [BNB Price Oracle Contract](https://browser.partisiablockchain.com/contracts/049abfc6e763e8115e886fd1f7811944f43b533c39/register)
   and invoke the action _Register_



## How to deregister as a price oracle

To leave the price oracle, invoke the action _Deregister_ at the price oracle contract where you registered.

### Find out which price oracle your node serves (If you know already skip ahead to deregistration)   

1. Open the [large oracle contract state](https://browser.partisiablockchain.com/contracts/04f1ab744630e57fb9cfcd42e6ccbf386977680014?tab=state)   
2. Open the map `stakedTokens`   
3. Search for your blockchain address `CTRL+f`   
4. Open the struct next to your blockchain address   
5. Open the map `lockedToOracle`   
6. You can see the addresses of the oracles your node serve and MPC tokens staked to them   
7. Copy the address of the oracle you want to leave (you can distinguish the price oracles from deposit and withdrawal oracles by looking at the amount of MPC tokes they have "locked", price oracles have 5000, deposit and withdrawal oracles 250000)
8. Paste the address to the search field of the browser, to navigate to the contract   

### Deregister from a price oracle   

The state of a price oracle contract has something called a `challengePeriod`. You cannot deregister in the challenge period lasting one hour from the starting time `startedAt`. The starting time is given as a [unix timestamp](https://www.unixtimestamp.com/).

1. Go to the contract of the price oracle your node serves
2. Check the timestamp
3. Invoke the contract action _Deregister_ at exactly one hour after the time stamp (be sure to be logged in and hit the time exactly)

If your node has already reported a price in the current round your invocation of _Deregister_ will result in an error
saying `Cannot derigister an oracle node that has notified a price update on an ongoing round`
The time window available to deregister can be very short, because you are responsible for any price you have reported,
and then you have a short time from the finalized price to the next price your node report. If you fail in your attempt
to deregister you can note the start time of the challenge period you have entered, and wait an hour to try again. Try
to hit the tx as close as possible to the passing on the one-hour-mark.

If you are planning to deregister from all node services, you should deregister in
the [block producer orchestration contract](https://browser.partisiablockchain.com/contracts/04203b77743ad0ca831df9430a6be515195733ad91/removeBp)
first.
