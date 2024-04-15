# Run a price oracle node

This page teaches you to register your baker node for the additional service of price oracle, and how to deregister from
the service in case you want to use the tokens for something else.

Price oracles monitor and report prices of the [BYOC](../pbc-fundamentals/byoc/introduction-to-byoc.md).
Any node with sufficient tokens associated to the large oracle contract can register as a price oracle.   
You can learn
more about the price oracles [here](../pbc-fundamentals/dictionary.md#price-oracle).

!!! Warning " You must complete these requirements before you can continue"

    1. [Run a baker node](run-a-baker-node.md)
    2. [Stake 5 K MPC tokens](https://browser.partisiablockchain.com/node-operation). You need a total staking balance of
    30K for both price oracle and baker node.

## Register as a price oracle

Becoming a price oracle requires a stake of 5000 MPC associated to the large oracle contract and a _Register_ transaction
at one of the price oracles:

1. Find
   the [large oracle contract](https://browser.partisiablockchain.com/contracts/04f1ab744630e57fb9cfcd42e6ccbf386977680014/associateTokensToContract)
   with the address `04f1ab744630e57fb9cfcd42e6ccbf386977680014`
2. Sign in (upper right corner)
3. Invoke the contract
   action [AssociateTokenstoContract](https://browser.partisiablockchain.com/contracts/04f1ab744630e57fb9cfcd42e6ccbf386977680014/associateTokensToContract)
   with a minimum amount of 5000 MPC tokens. You need 5000 tokens per price oracle you register for.
4. Go to
   [ETH Price Oracle contract](https://browser.partisiablockchain.com/contracts/0485010babcdb7aa56a0da57a840d81e2ea5f5705d/register),
   [BNB Price Oracle contract](https://browser.partisiablockchain.com/contracts/049abfc6e763e8115e886fd1f7811944f43b533c39/register)
   or
   [MATIC Price Oracle contract](https://browser.partisiablockchain.com/contracts/042a9dcb0c96b9875f529e3a51ddc02473c1a78d33/register)
   and invoke the action _Register_



## Steps to deregister as a price oracle

The first step to deregister is to verify which price oracle the node serves. If known,
skip to [deregistration](#deregister-from-a-price-oracle).

It is important to identify the time window, where you can
deregister. The time window available to deregister can be very short, because the node is responsible for the prices it
has reported. You have a short time from the finalized price to the next price your node reports.

### Verify which price oracle your node serves 

1. Open
   the [large oracle contract state](https://browser.partisiablockchain.com/contracts/04f1ab744630e57fb9cfcd42e6ccbf386977680014?tab=state)
2. Open the map `stakedTokens`
3. Search for your blockchain address `CTRL+f`
4. Open the struct next to your blockchain address
5. Open the map `lockedToOracle`
6. You can see the addresses of the oracles your node serve and MPC tokens staked to them
7. Copy the address of the oracle you want to leave (you can distinguish the price oracles from deposit and withdrawal
   oracles by looking at the amount of MPC tokes they have "locked", price oracles have 5000, deposit and withdrawal
   oracles 250000)
8. Paste the address to the search field of the browser, to navigate to the contract

### Deregister from a price oracle   

To leave the price oracle, invoke the action _Deregister_ at the price oracle contract where you registered.

You cannot deregister in the `challengePeriod` lasting one hour from the starting time `startedAt`. The starting time is given as a [unix timestamp](https://www.unixtimestamp.com/).

1. Go to the contract of the price oracle your node serves:
    - [Deregister from ETH Price Oracle Contract](https://browser.partisiablockchain.com/contracts/0485010babcdb7aa56a0da57a840d81e2ea5f5705d?tab=state)
    - [Deregister BNB Price Oracle Contract](https://browser.partisiablockchain.com/contracts/049abfc6e763e8115e886fd1f7811944f43b533c39?tab=state)
    - [Deregister MATIC Price Oracle contract](https://browser.partisiablockchain.com/contracts/042a9dcb0c96b9875f529e3a51ddc02473c1a78d33?tab=state)
2. Check the timestamp of the `challengePeriod` called `startedAt`  
3. Sign in to the browser   
4. Invoke the contract action _Deregister_ at exactly one hour after the time stamp   

If your node has already reported a price in the current round your invocation of _Deregister_ will result in an error
saying 

```Cannot deregister an oracle node that has notified a price update on an ongoing round```

This error means your attempt to deregister failed. Note the start time of the challenge period you have entered, and
wait an hour to try again. Send the contract interaction as close as possible to the passing of the one-hour-mark.

If you are planning to deregister from all node services, you should deregister in
the [block producer orchestration contract](https://browser.partisiablockchain.com/contracts/04203b77743ad0ca831df9430a6be515195733ad91/removeBp)
first.
