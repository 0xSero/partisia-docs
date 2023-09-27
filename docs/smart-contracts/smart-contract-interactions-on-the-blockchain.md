Developing smart contracts on Partisia Blockchain involves several key understandings. Here's a mental model of the
interactions available when developing smart contracts on PBC.

## Definition of interactions

**Contracts are asynchronous**: A contract can be placed on any given shard of
the [multiple shards](../pbc-fundamentals/sharding.md) on Partisia Blockchain. This means that all actions take place in
an order you can define as a developer, but the time it takes to complete an action can be dependent on what shard the
contract is on and the geolocation of the node. This becomes much more relevant when looking at contract-to-contract
actions.

Even though state is not an interaction its important to understand what state is as a developer. Simply written a state
is a distributed record, where each action can be perceived as a change in the record. This is part of both the
functional and the asynchronous desing of PBC.

**Contracts atomic interaction**: Each atomic interaction point, whether init or action take some input, and return some output.
Atomic interactions cannot produce side effects, visible or not. The state will not be changed should a transaction,
action or event fail while running the contract code, whether due to panics or insufficient gas. 

## Simple interaction model

A user can sign a transaction, a transaction creates an event (dotted line) which spawns an action. This action is what
programmatically is written into a given smart contract. An action always changes the state if its successful, even if
there is no writing to the state of the contract as part of the action. The change in such a case will be to note that
the action has happened on the state. 

This example could also have been a model with no before state and the signed transaction
would be the [init bytes(RPC)](smart-contract-binary-formats.md#rpc-binary-format) required to deploy a smart contract on Partisia Blockchain.

![SmartContractMentalModelSimple.svg](mental-models/SmartContractMentalModelSimple.svg)















_______________________________________________
for keepsake dont mind this part
## Contract-to-contract interaction model.

When interacting with another contract, the first contracts action creates an event which creates the action for smart
contract 2. The smart contract 2 in the
example, has its own state and
can be interacted with at any given time. Smart contract 1 knows when the interaction is sent but is not expecting a
callback. The asynchronous way of creating contract-to-contract interaction becomes more
cluttered with every contract you wish to call from that point. In another example the smart contract 2 can even create
new actions for more and more smart contracts on the blockchain. The tricky part becomes handling gas and callbacks for
a system with many contract-to-contract interactions, you can
visit [our article on handling gas on a contract-to-contract basis](gas/contract-to-contract-gas-estimation.md).

![SmartContractMentalModelcontract-to-contract.svg](mental-models%2FSmartContractMentalModelcontract-to-contract.svg)

## Contract-to-contract with callback

Working with callbacks expands the mental model to include another event that is made from the action of the secondary
contract. When a user signs a transaction, its creates an action. This action is made with a callback, a callback is a
future event that creates a new action for the same contract with the wanted responses and failure/success statuses.

In the example below the callback is first produced after the action is made in Smart contract 2. The callback will
always have a success or
failure indication along with whatever else is packed into the callback itself. This callback event creates a callback
action on smart contract 1. In smart contract 1 there are three state changes, often the actual state would not
change after the first action, but presumably only after the callback has happened.

![SmartContractMentalModelWithCallback.svg](mental-models%2FSmartContractMentalModelWithCallback.svg)

## Contract-to-two-contracts with one callback.

A contract can have multiple events spawning multiple actions to multiple contracts. They can share the same callback if
they are all created from the same action. The callback can collect and include all statuses and responses from the
callbacks from the different
contracts. Simply put, contract 1 creates an event that creates an action in contract 2 and 3. The callbacks from
contract 2 and 3 are collected into one event which is then returned to contract 1. This creates the possibility of
error handling specific use cases on the chain without needing to re-trigger the full event chain, thus helping with gas
efficiency.

![SmartContractMentalModelTwoActionsOneCallback.svg](mental-models%2FSmartContractMentalModelTwoActionsOneCallback.svg)
