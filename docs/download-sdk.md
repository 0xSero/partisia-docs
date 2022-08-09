# Download the software development kit

## Prerequisites

To develop and compile contracts for the Partisia Blockchain, you need to install Rust 1.56 along with the wasm32 target. To install Rust for you platform follow the instructions on https://rustup.rs/.

Now install rust 1.56 and add the wasm32 target and set 1.56 to be the default toolchain:

```bash
rustup update
rustup target add --toolchain 1.56 wasm32-unknown-unknown
```

If you need to develop zero-knowledge contracts then you will also need to install Java 17 to run the zk-compiler.

If Working from a Windows machine you must either:   

- [Get Visual Studio with C++  build tools](https://visualstudio.microsoft.com/downloads/) - In Visual Studio Installer choose *Desktop development with C++*.   
- [Install Linux Subsystem for Windows](https://docs.microsoft.com/en-us/windows/wsl/install)    

### 2) Download Partisia Contract SDK

[![button](Download.png)](LINK_TO_RUST_CONTRACT_SDK)

The archive contains the SDK, the cargo `partisia-contract` tool for building contracts, the zk-compiler, as well as a number of example contracts.

If you are working with a WSL shell on Windows you can locate files within WSL in the folder named `\\wsl$\Ubuntu\`.
From now on we assume you have extracted the archive to `/tmp/pbc-rust-wasm`.  
Open a terminal and go to the `/tmp/pbc-rust-wasm` folder: `cd /tmp/pbc-rust-wasm`.

### 3) Installing the cargo `partisia-contract` command

```bash 
cd cargo-partisia-contract
cargo install --path .
```

Test that it worked by executing: `cargo partisia-contract --version`. This should print the version of the command.

