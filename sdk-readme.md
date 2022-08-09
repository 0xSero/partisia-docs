# Partisia Rust contract SDK

This README is for SDK version RUST_SDK_VERSION.
You can always find the newest documentation and SDK on the [main site](https://partisiablockchain.gitlab.io/documentation).


## Prerequisites

To develop and compile contracts for the Partisia Blockchain, you need to install Rust 1.56 along with the wasm32 target. To install Rust for you platform follow the instructions on https://rustup.rs/.

Now install rust 1.56 and add the wasm32 target and set 1.56 to be the default toolchain:

```bash
rustup update
rustup target add --toolchain 1.56 wasm32-unknown-unknown
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
To compile a zero-knowledge contract you will first need to compile the contract using the `partisia-contract` 
cargo command similarly to a normal contract. Afterward the zk-computation can be compiled using the included `zk-compiler.jar`:

```bash
java -jar [path to zk_compute.rs] --link [path to .wasm file]
```

This creates the linked byte file with the zk bytecode as well as the wasm file.

## Included example contracts

There are contracts included in the zip as well as zero knowledge contracts.

The included normal contracts are:

1. An ERC20 token contract located in `contracts/example-token-contract`
2. A general purpose voting contract located in `contracts/example-voting-contract`
3. An auction contract that sells ERC20 tokens of one type for another located in `contracts/example-auction-contract`
4. An NFT contract located in `contracts/example-nft-contract`

The included zk-contracts are:

1. A secret voting contract located in `contracts/example-secret-voting`
2. An average salary contract located in `contracts/example-zk-average-salary`
3. A second price auction contract located in `contracts/example-zk-second-price-auction`

Multiple of the examples are described in great detail on the [main site](https://partisiablockchain.gitlab.io/documentation).

## How to write your own contract

For writing your own contract refer to the documentation on the [main site](https://partisiablockchain.gitlab.io/documentation).