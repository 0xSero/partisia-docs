# Install the smart contract compiler

## Prerequisites

To develop and compile contracts for the Partisia Blockchain, you need to install Rust.
To install Rust for you platform follow the instructions on <https://rustup.rs/>.

The newest version of Rust comes with a wasm target preinstalled.
If you run an older version the target needs to be added manually, by running:
```bash
rustup target add wasm32-unknown-unknown
```

To compile contracts you will also need to install [Git](https://git-scm.com/downloads).

If you need to develop zero-knowledge contracts then you will also need to install [Java 17](https://openjdk.org/) to run the zk-compiler.


If Working from a Windows machine you must [get Visual Studio with C++  build tools](https://visualstudio.microsoft.com/downloads/) - In Visual Studio Installer choose *Desktop development with C++*.
* We recommend you make sure these optionals are marked:
  * MSVC x64/x86 build tools
  * Windows 11 SDK 
  * C++ CMake tools for Windows
  * Testing tools core features 
  * Build Tools
  * C++ AddressSanitizer

### 2) Installing the cargo `partisia-contract` command

The partisia-contract tool is a small application that helps you compile a contract.
To compile it and install it using cargo run:

```bash
cargo install cargo-partisia-contract
```

Test that it worked by executing: `cargo partisia-contract --version`. This should print the version of the tool.

### 3) Download Example Contracts

We supply a small archive with example contracts which can be compiled using the tooling from above.
The example contracts are [available here](combi-innovation.md).

