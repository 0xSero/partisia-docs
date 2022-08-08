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

If you need to develop zero-knowledge contracts then you will also need to install Java 17 to run the zk-compiler.

**NB.** You must acquire *C++ build tools for Windows*, if you work in Git Bash or PowerShell:  
[Download Visual Studio with C++](https://visualstudio.microsoft.com/downloads/) In Visual Studio Installer choose *Desktop development with C++*.  

## Compile and install the cargo `partisia-contract` command

In this zip  there is a folder called `cargo-partisia-contract`.
This is a small application that helps you compile a contract.
To compile it and install it using cargo run:

```bash
cd cargo-partisia-contract
cargo install --path .
```
Test that it worked by executing: `cargo partisia-contract --version`. This should print the version of the command.

## Compiling a contract

To compile a contract you simply change directory to one of the rust-example-contracts and compile: 
```bash
cd ..
cd contracts/example-token-contract/
cargo partisia-contract build
```

To compile a contract in release mode you include the `--release` flag: `cargo partisia-contract build --release`

### Zero-Knowledge contracts
The zk-contracts consist of two main parts. The contract itself as well as a zero-knowledge computation. 
To compile a zero-knowledge contract you will first need to compile the contract using the partisia-contract 
cargo command similarly to a normal contract. Afterward the zk-computation can be compiled using the included `zk-compiler.jar`:

```bash
java -jar [path to zk_compute.rs] --link [path to .wasm file]
```

This creates the linked byte file with the zk bytecode as well as the wasm file.

## Included example contracts

There are four contracts included in the zip as well as three zero knowledge contracts:

1. An ERC20 token contract located in `contracts/example-token-contract`
2. A general purpose voting contract located in `contracts/example-voting-contract`
3. An auction contract that sells ERC20 tokens of one type for another located in `contracts/example-auction-contract`
4. An NFT contract located in `contracts/example-nft-contract`

The included zk-contracts are as follows:

1. A secret voting contract located in `contracts/example-secret-voting`
2. An average salary contract located in `contracts/example-average-salary`
3. A second price auction contract located in `contracts/example-second-price-auction`

Multiple of the examples are described in great detail on the main site: https://partisiablockchain.gitlab.io/documentation

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
and must return a `State`.

### Actions

Every action is marked with an `#[action]` macro. This generates ABI helpers and serialization code. 
All the parameters must derive `CreateTypeSpec` for the macro to work properly. 

For actions to work properly the first two parameters must be a `ContractContext` and the struct marked
with a `#[state]` macro. The actions must be bare functions and must return a `State`.


### Events

A contract initializer/actions can send events to itself or to other contracts. 
These are returned as a part of the result, wrapped in a struct called an `EventGroup`. 
For more details on the usage of the event system consult the main documentation and the rustdocs for `EventGroup`.
