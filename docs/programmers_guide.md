# Partisia Blockchain SDK (Software Development Kit) Programmer's Guide

This page is a quick overview of the software development kit for Partisia
Blockchain.

## Smart Contract Overview

A smart contract on Partisia Blockchain consists of, on a surface level, some
state, and some actions defined to either operate on the state and/or to
interact other contracts.

Consider for example a basic public voting contract:

> State:

> - What are we voting on? (if applicable)
> - Who are allowed to vote?
> - Deadline (if applicable)
> - Who have voted?
> - Are we done yet?
> - What is the result if we are done?

> Actions:

> - Voters should be able to vote.
> - Anybody should be able to retrieve how many votes have been cast, and
>   whether the vote is complete yet.
> - Anybody should be able to retrieve the result of the vote.

> Initializer:

> - Vote subject, Voters and Deadline are all permanent attributes of the vote,
>   and so should be set in the initializer.

Contracts' state and actions must be declared in an [Contract ABI file](abiv_latest.md#ABI Binary Format);
a concise description of the contract's interface and internal state
representation, that must be uploaded together with the contract code when
initializing the contract.  Without an ABI file, it might be impossible for the
dashboard and other contracts to interact with your contract.

The PBC SDK is capable of automatically producing an ABI for your contract, along
with state and RPC serialization code for your actions.

## Macros

Smart contract elements can be declared using these macros:

- `#[state]` declares how the contract represents its state.
- `#[action]` declares an endpoint that the contract can be interacted with by.
- `#[init]` declares the code run when the contract is initialized.

### `#[state]`

Declares that the annotated struct is the top level of the contract state. This
macro must occur exactly once in any given contract.

Example:

```rust
#[state]
pub struct VotingContractState {
    proposal_id: u64,
    mp_addresses: Vec<Address>,
    votes: BTreeMap<Address, u8>,
    closed: u8,
}
```

This macro implicitly derives the [ReadWriteState trait](#ReadWriteState) for the
struct. The `ReadWriteState` derive may fail if any of the state struct's fields
aren't `impl ReadWriteState`.

Further reading: [state macro documentation](https://privacyblockchain.gitlab.io/language/rust-contract-sdk/pbc_contract_codegen/attr.state.html)

### `#[action]`

Declares that the annotated function is an contract action that can be called
from other contracts and dashboard. Must have a signature of the following format:

```rust
#[action]
pub fn action_internal_name(
  context: ContractContext,
  state: ContractState,
  ... // RPC arguments.
) -> (ContractState, Vec<EventGroup>)
```

The action receives the previous state, along with a context, and the declared
arguments, and must return the new state, along with a vector of
[EventGroup](#EventGroup); a list of interactions with other contracts.

Example:

```rust
#[action]
pub fn vote(
    context: ContractContext,
    state: VotingContractState,
    vote: u8,
) -> (VotingContractState, Vec<EventGroup>) {
  // Code...
}
```

Further reading: [action macro documentation](https://privacyblockchain.gitlab.io/language/rust-contract-sdk/pbc_contract_codegen/attr.action.html)

#### A note on functional contracts

Contracts are _functional_: Each interaction point, whether `init` or `action` take some input, and return some output. Interactions cannot produce side effects, visible or not. The state will thus not be changed should a transaction fail while running the contract code, whether due to panics or insufficient gas.

Of further interest here, is that the entire contract is essentially "reset" after every interaction. Any [`static mut` items](https://doc.rust-lang.org/reference/items/static-items.html) will possess their initial value, once again. The only state your contract can possess is the state returned from interactions.

### `#[init]`

Similar to `#[action]` macro, but declares how the contract can be initialized.

```rust
#[init]
pub fn initialize(
    context: ContractContext,
    ... // Initialization arguments
) -> (VotingContractState, Vec<EventGroup>) {
  // Code...
}
```

Note that there are no previous context when initializing, in contrast to the
`action` macro. All arguments will be required during initialization. This
macro must occur exactly once in any given contract. If the initializer fails
the contract will not be created.

Example:

```rust
#[init]
pub fn initialize(
    context: ContractContext,
    proposal_id: u64,
    mp_addresses: Vec<Address>,
) -> (VotingContractState, Vec<EventGroup>) {
  // Code...
}
```

Further reading: [init macro documentation](https://privacyblockchain.gitlab.io/language/rust-contract-sdk/pbc_contract_codegen/attr.init.html)

## Traits

The SDK exposes traits that provides serialization methods. These traits are
important for the operation of PBC contracts, but should rarely be implemented
manually; prefer using the built-in derive methods.

- ReadWriteState: Serialization for [State serialization format](abiv_latest.md#State Binary Format).
- ReadWriteRPC: Serialization for [RPC argument serialization format](abiv_latest.md#RPC Binary Format).
- CreateTypeSpec: Serialization for [ABI serialization format](abiv_latest.md#ABI Binary Format).

Further reading: [`pbc_traits` crate documentation](https://privacyblockchain.gitlab.io/language/rust-contract-sdk/pbc_traits/index.html)

## Data Structures

### Address

`Address` represents an address on the blockchain; it has a subfield indicating
the type of the address (account, system contract, public contract or zk contract.)

Further reading: [Address struct documentation](https://privacyblockchain.gitlab.io/language/rust-contract-sdk/pbc_contract_common/address/struct.Address.html)

### ContractContext

`ContractContext` is available from every action, and contains some useful
context information for the current transaction:

- `Address` of the contract itself and the caller; the person or contract that caused the interaction.
- The current block number, and time since some epoche.
- Hashes of both the current transaction and the previous transaction.

Further reading: [ContractContext struct documentation](https://privacyblockchain.gitlab.io/language/rust-contract-sdk/pbc_contract_common/context/struct.ContractContext.html)

### Events

Partisia Blockchain's contract interaction model sandboxes each contract, and allows RPC
calls as the primary form of interaction. As each transaction is entirely isolated, RPCs can
only occur "between" action calls.

For example:

- Zeno calls Alice in transaction 1: Alice determines she needs some information from Bob, and exits
  while telling the blockchain: "Call Bob for me, I want a reply, and let me pay for the reply"
- Alice calls Bob in transaction 2: Bob performs it's computation, and exists
  with "Here's the reply to Alice, she said she'd pay for this reply".
- Bob calls Alice in transaction 3: Alice finally got the necessary information to perform her own
  computation...

To accommodate this model, the SDK requires each `action` annotated function to
return a (possibly empty) `Vec` of `EventGroup`s, which represents the "Call X for me" information.

Each `EventGroup` consists of one or more interactions (representing "Call
X for me",) with the possibility of callbacks (representing "I want a reply".)
All interactions in an `EventGroup` shares gas costs uniformly.

Further reading: [events module documentation](https://privacyblockchain.gitlab.io/language/rust-contract-sdk/pbc_contract_common/events/index.html)

## State serialization gas considerations

Contracts with a lot of state should prefer `Vec<T>` to `BTreeSet<T>` or `BTreeMap<T>`, as `Vec<T>` (specifically for [CopySerializable](abiv_latest.md#CopySerializable) `T`) are more efficiently (de)serialized, both in terms of gas and computation time. Remember that (de)serialization gas costs must be paid for _every_ action, even ones that never handle state.

If quick lookups are required, and the data structure rarely changes, it might be feasible to maintain a sorted `Vec` in state, and use [`[T]::binary_search_by_key`](https://doc.rust-lang.org/std/primitive.slice.html#method.binary_search_by_key) for lookups, essentially creating your own map structure.

Ensure you [depend upon and link against the `pbc_lib` crate](https://privacyblockchain.gitlab.io/language/rust-contract-sdk/pbc_lib/index.html). This _should_ automatically lower gas costs.

### Cheap memcpy (or _why_ you should definitely link `pbc_lib`)

The SDK exposes cheaper (in terms of gas) versions of the `memcpy` and `memmove` functions. These functions are commonly used for copying bytes around directly, but are (thankfully) rarely manually used in Rust, though they may still occur in compiled programs due to lower-level libraries and compiler optimizations. Your compiled contracts will be using `memcpy` for (de)serialization, hence why the SDK defines these alternatives.

The `pbc_lib` crate overwrites these functions with versions that directly interact with the PBC WASM Interpreter to trigger the interpreter's built-in support for quickly copying data around.

Further reading: [`pbc_lib` crate documentation](https://privacyblockchain.gitlab.io/language/rust-contract-sdk/pbc_lib/index.html)
