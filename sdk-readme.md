# Partisia Rust contract SDK

This README is for SDK version RUST_SDK_VERSION.
You can always find the newest documentation and SDK on the main site: https://partisiablockchain.gitlab.io/documentation


## Prerequisites

To develop and compile contracts for the Partisia Blockchain, you need to install Rust 1.56 along with the wasm32 target. To install Rust for you platform follow the instructions on https://rustup.rs/.

Now install rust 1.56 and add the wasm32 target and set 1.56 to be the default toolchain:

```bash
rustup update
rustup install 1.56
rustup target add --toolchain 1.56 wasm32-unknown-unknown
rustup default 1.56
```
 
## Compile and install the cargo `partisia-contract` command

In this zip  there is a folder called `cargo-partisia-contract`. 
This is a small application that helps you compile a contract. 
You to compile it and install it using cargo:

```bash
cd cargo-partisia-contract
cargo install --path .
```
Test that it worked by executing: `cargo partisia-contract --version`. This should print the version of the command.

To compile a contract you simply write: `cargo partisia-contract build`

To compile a contract in release mode you include the `--release` flag: `cargo partisia-contract build --release`

## Included example contracts

There are two contracts included in the zip:

1. An ERC20 token contract located in `examples/rust-example-token-contract`
2. A general purpose voting contract located in `examples/rust-example-voting-contract`

Both examples are described in great detail on the main site: https://partisiablockchain.gitlab.io/documentation

## How to write your own contract

The easiest way to get started is to take a look at the included examples.

You need:

1. A `Cargo.toml` that has the same dependencies as the example contracts
2. A `Cargo.toml` that has a feature called `abi`, which enables the `abi` feature in the dependencies
3. Your contract `lib.rs`

The contracts have three basic building blocks:

1. The state of the contract
2. One contract initializer function
3. A number of actions


### The state struct

The state is a struct annotated with `#[state]` (see rustdoc for more details on what this implies). 
This also does some validation of the types used in the fields of the struct. The macro generates
serialization code for the struct along with metadata that helps with the ABI. 

### The initializer

The initializer is marked with an `#[init]` macro. For the initializer to work the first parameter must
be a `ContractContext`. The rest of the parameters are considered the payload and are deserialized
using derived code. All parameters must derive `CreateTypeSpec`. The initializer must be a bare function
and must return a 2-tuple of `(State, Vec<EventGroup>)`.

### Actions

Every action is marked with an `#[action]` macro. This generates ABI helpers and serialization code. 
All the parameters must derive `CreateTypeSpec` for the macro to work properly. 

For actions to work properly the first two parameters must be a `ContractContext` and the struct marked
with a `#[state]` macro. The actions must be bare functions and must return a 2-tuple of `(State, Vec<EventGroup>)`.


### Events

A contract initializer/actions can send events to itself or to other contracts. 
These are returned as a part of the result, wrapped in a struct called an `EventGroup`. 
For more details on the usage of the event system consult the main documentation and the rustdocs for `EventGroup`.
