## Download the software development kit and develop your first contract

### 1) Install Rust
To develop and compile contracts for the Partisia Blockchain, you need to install Rust along with the wasm32 target. To install Rust for you platform follow the instructions on https://rustup.rs/.

Now add the wasm32 target:

```bash
rustup update
rustup target add wasm32-unknown-unknown
```
If Working from a Windows machine you must either:   
- [Get Visual Studio with C++  build tools](https://visualstudio.microsoft.com/downloads/) - In Visual Studio Installer choose *Desktop development with C++*.   
- [Install Linux Subsystem for Windows](https://docs.microsoft.com/en-us/windows/wsl/install)   

### 2) Download Partisia Contract SDK

[![button](Download.png)](LINK_TO_RUST_CONTRACT_SDK)

The archive contains the Rust project files and the SDK. The archive contains the `partisia-contract` tool, the SDK and some example contracts.
If you are working with a WSL shell on Windows you can locate files within WSL in the folder named `\\wsl$\Ubuntu\`.
From now on we assume you have extracted the archive to `/tmp/pbc-rust-wasm`.  
Open a terminal and go to the `/tmp/pbc-rust-wasm` folder: `cd /tmp/pbc-rust-wasm`.

### 3) Install the cargo `partisia-contract` command

```bash 
cd cargo-partisia-contract
cargo install --path .
```

Test that it worked by executing: `cargo partisia-contract --version`. This should print the version of the command.

