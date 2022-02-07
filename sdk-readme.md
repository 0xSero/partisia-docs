# Partisia Rust contract SDK

This README is for SDK version RUST_SDK_VERSION.
You can always find the newest documentation and SDK on the main site: https://partisiablockchain.gitlab.io/documentation


## Prerequisites

To develop and compile contracts for the Partisia blockchain, you need to install Rust 1.56 along with the wasm32 target.
To install Rust for you platform follow the instructions on https://rustup.rs/.

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

## How to write your own contract
