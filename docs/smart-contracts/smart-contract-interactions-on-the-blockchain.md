Developing smart contracts on Partisia Blockchain involves several key understandings. Here's a mental model of the
interactions available when developing smart contracts on PBC.

## Definition of interactions

Smart contracts has four types of interaction on Partisia Blockchain:
`Init`
`Action`
`Event`
`Callback`

**Contracts are asynchronous**: A contract can be placed on any given shard of
the [multiple shards](../pbc-fundamentals/sharding.md) on Partisia Blockchain. This means that all actions take place in
an order you can define as a developer, but the time it takes to complete an action can be dependent on what shard the
contract is on and the geolocation of the node. This becomes much more relevant when looking at contract-to-contract
actions.

Even though state is not an interaction its important to understand what state is as a developer. Simply written a state
is a distributed record, where each action can be perceived as a change in the record. This is part of both the
functional and the asynchronous desing of PBC.

**Contracts are functional**: Each interaction point, whether init or action take some input, and return some output.
Interactions cannot produce side effects, visible or not. The state will thus not be changed should a transaction,
action or event fail while running the contract code, whether due to panics or insufficient gas.

Of further interest here, is that the entire contract is essentially "reset" after every interaction. Any `static mut`
items will possess their initial value, once again. The only state your contract can possess is the state returned from
interactions.

## Simple interaction model

A user can sign a transaction, a transaction creates an event (dotted line) which spawns an action. This action is what
programmatically is written into a given smart contract. An action always changes the state if its successful, even if
there is no writing to the state of the contract as part of the action. The change in such a case will be to note that
the action has happened on the state.

![SmartContractMentalModelSimple.svg](mental-models/SmartContractMentalModelSimple.svg)

## Contract-to-contract interaction model.

When interacting with another contract the system creates an event which creates the action. The smart contract 2 in the
example, has its own state and
can be interacted with at any given time. Smart contract 1 knows when the interaction is sent but is not expecting a
callback. The asynchronous way of creating contract-to-contract interaction becomes more
cluttered with every contract you wish to call from that point. In another example the smart contract 2 can even create
new actions for more and more smart contracts on the blockchain. The tricky part becomes handling gas and callbacks for
a system with many contract-to-contract interactions, you can
visit [our article on handling gas on a contract-to-contract basis](gas/contract-to-contract-gas-estimation.md).

![SmartContractMentalModelcontract-to-contract.svg](mental-models%2FSmartContractMentalModelcontract-to-contract.svg)

## Contract-to-contract with callback

Working with callbacks expands the mental model to include another event that is made from the action of the secondary contract. When a user signs a transaction, its creates and action. This action is made with a callback which simply creates the first event as if it was a contract-to-contract interaction with instructions to create a callback after. The callback is first produced after the action is made in Smart contract 2. The callback will always have a success or failure indikation along with whatever else is packed into the callback itself. This callback event creates a callback action. The example highlights that on smart contract 1 there are three state changes, often the actual state would not change after the first action, but presumably only after the callback has happened. 

![SmartContractMentalModelWithCallback.svg](mental-models%2FSmartContractMentalModelWithCallback.svg)

## Contract-to-two-contracts with one callback. 

![SmartContractMentalModelTwoActionsOneCallback.svg](mental-models%2FSmartContractMentalModelTwoActionsOneCallback.svg)

Understanding PBC's Unique Features:
Partisia Blockchain allows you to add a privacy layer alongside the immutable ledger.
You can allocate nodes in the blockchain for Zero Knowledge computation, ensuring data privacy.
This combination of privacy and a public record replaces the need for a traditional trustee in binding transactions.

Contract Types on PBC:
There are three types of smart contracts on PBC:
System Smart Contracts: These maintain the PBC Ecosystem and perform essential tasks like deploying and destroying
public and private smart contracts, block producer orchestration, and data preprocessing for zero knowledge contracts.
Public Smart Contracts: Written in the PBC contract language (based on Rust), these contracts have a state that can be
modified through defined actions. They can also interact with other public smart contracts.
Private Smart Contracts: Similar to public smart contracts but with some actions performed on the private layer of PBC,
particularly Zero Knowledge computations using secure multiparty computation (MPC).

Smart Contract Overview:
A PBC smart contract consists of state and actions.
State represents the variables subject to change, while actions define how the contract operates on the state and
interacts with other contracts.
Contracts should be described in a Contract ABI file, which outlines their interface and state representation.
PBC compiler can generate the ABI, state, and RPC serialization code automatically.

Macros:
Contracts and their elements are declared using macros:4
#[state]: Declares the top-level state of the contract.
#[action]: Declares an endpoint that can be interacted with.
#[init]: Declares the code to run when the contract is initialized.
#[callback]: Declares the code to run after a corresponding action has been called.

Traits:
PBC compiler exposes traits for serialization:
ReadWriteState: Serialization for state.
ReadWriteRPC: Serialization for RPC arguments.
CreateTypeSpec: Serialization for ABI.

Data Structures:
Address: Represents blockchain addresses.
ContractContext: Provides context information for transactions.
Events and EventGroup: Used to manage interactions between contracts.
CallbackContext: Provides information about callback events.

State Serialization Gas Considerations:
Use Vec<T> for state with a lot of data for efficient serialization.
Consider maintaining sorted Vec for quick lookups.
Link against the pbc_lib crate to lower gas costs, as it provides optimized memcpy functions.

Development Steps:
Define the contract's state using #[state] and actions using #[action] and #[init].
Ensure proper serialization by relying on derived traits.
Use event groups to manage interactions and callbacks.
Implement callback functions for post-action execution logic.
Consider gas costs and optimization using Vec<T> for large state.

Testing and Deployment:
Test your smart contract thoroughly in a development environment.
Deploy the contract on the Partisia Blockchain.

Interacting with Other Contracts:
Contracts interact through RPC calls.
Use event groups to request actions from other contracts.
Implement callback functions to handle responses.

This mental model provides an overview of the key concepts and steps involved in developing smart contracts on Partisia
Blockchain, highlighting the unique features and considerations specific to PBC.