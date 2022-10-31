# Install the smart contract compiler

## Prerequisites

To develop and compile contracts for the Partisia Blockchain, you need to install Rust along with the wasm32 target. 
To install Rust for you platform follow the instructions on https://rustup.rs/.

Now install the wasm32 target:

```bash
rustup target add wasm32-unknown-unknown
```

If you need to develop zero-knowledge contracts then you will also need to install Java 17 to run the zk-compiler.

If Working from a Windows machine you must [Get Visual Studio with C++  build tools](https://visualstudio.microsoft.com/downloads/) 
- In Visual Studio Installer choose *Desktop development with C++*.
 

### 2) Installing the cargo `partisia-contract` command

The partisia-contract tool is a small application that helps you compile a contract.
To compile it and install it using cargo run:

```bash
cargo install cargo-partisia-contract
```

Test that it worked by executing: `cargo partisia-contract --version`. This should print the version of the tool.

### 3) Download Example Contracts

We supply a small archive with example contracts which can be compiled using the tooling from above.

[![](alt_button.drawio.png)](LINK_TO_RUST_EXAMPLE_CONTRACTS).

