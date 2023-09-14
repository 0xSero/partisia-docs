Developing smart contracts on Partisia Blockchain involves several key understandings. Here's a mental model of the interactions available when developing smart contracts on PBC:

# Standard interaction

![SmartContractMentalModelSimple.svg](mental-models/SmartContractMentalModelSimple.svg)



Understanding PBC's Unique Features:
Partisia Blockchain allows you to add a privacy layer alongside the immutable ledger.
You can allocate nodes in the blockchain for Zero Knowledge computation, ensuring data privacy.
This combination of privacy and a public record replaces the need for a traditional trustee in binding transactions.

Contract Types on PBC:
There are three types of smart contracts on PBC:
    System Smart Contracts: These maintain the PBC Ecosystem and perform essential tasks like deploying and destroying public and private smart contracts, block producer orchestration, and data preprocessing for zero knowledge contracts.
    Public Smart Contracts: Written in the PBC contract language (based on Rust), these contracts have a state that can be modified through defined actions. They can also interact with other public smart contracts.
    Private Smart Contracts: Similar to public smart contracts but with some actions performed on the private layer of PBC, particularly Zero Knowledge computations using secure multiparty computation (MPC).

Smart Contract Overview:
A PBC smart contract consists of state and actions.
State represents the variables subject to change, while actions define how the contract operates on the state and interacts with other contracts.
Contracts should be described in a Contract ABI file, which outlines their interface and state representation.
PBC compiler can generate the ABI, state, and RPC serialization code automatically.

Macros:
Contracts and their elements are declared using macros:
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

This mental model provides an overview of the key concepts and steps involved in developing smart contracts on Partisia Blockchain, highlighting the unique features and considerations specific to PBC.