## Develop your first contract

### Step 1: Install Rust
To develop and compile contracts for the Partisia Blockchain, you need to install Rust 1.56 along with the wasm32 target. To install Rust for you platform follow the instructions on https://rustup.rs/.

Now install rust 1.56 and add the wasm32 target and set 1.56 to be the default toolchain:

```bash
rustup update
rustup install 1.56
rustup target add --toolchain 1.56 wasm32-unknown-unknown
rustup default 1.56
```
If Working from a Windows machine you must either:
- [Get Visual Studio with C++  build tools](https://visualstudio.microsoft.com/downloads/) - In Visual Studio Installer choose *Desktop development with C++*.
- [Install Linux Subsystem for Windows](https://docs.microsoft.com/en-us/windows/wsl/install)

### Step 2: Download Partisia Contract SDK

[Download Partisia Contract SDK](LINK_TO_RUST_CONTRACT_SDK) - The archive contains the Rust project.
files and the SDK. The archive contains the `partisia-contract` tool, the SDK and some example contracts.
If you are working with a WSL shell on Windows you can locate files within WSL in the folder named `\\wsl$\Ubuntu\`.
From now on we assume you have extracted the archive to `/tmp/pbc-rust-wasm`.  
Open a terminal and go to the `/tmp/pbc-rust-wasm` folder: `cd /tmp/pbc-rust-wasm`.

### Step 3: Install the cargo `partisia-contract` command

```bash 
cd cargo-partisia-contract
cargo install --path .
```

Test that it worked by executing: `cargo partisia-contract --version`. This should print the version of the command.

### Step 4: Compile the token contract example

The token contract can be found ind `examples/rust-example-token-contract`.
The following will compile it and generate an ABI for it:

```` bash
cd examples/rust-example-token-contract
cargo partisia-contract build --release
````

Now you will find a .wasm-file in called *token_contract.wasm* in: `/tmp/pbc-rust-wasm/examples/rust-example-token-contract/target/wasm32-unknown-unknown/release`.  
If you look at lib.rs file in your IDE, you will see the contract utilizes several functions denoted with the initial *fn*. Three of these functions are actions that allow you to perform the basic operations needed for a transfer. The functions are *initialize*, *mint*, and *transfer*. After deployment, you can call the functions from the dashboard. When you perform an action it changes the contract state. If you inspect the contract you can see the serialized data showing the contract state. Contract state can be revealed as a `.json`.

## Step 5: Upload the contract to the blockchain

Open the wallet in the [Dashboard](https://dashboard.partisiablockchain.com/wallet/upload_wasm) or use [Partisia Blockchain Explorer](https://mpcexplorer.com/deploy-contract) Select the `token_contract.wasm` and the `token_contract.abi`. In the *total_supply* field you put the number of tokens you want minted for total supply of the contract from the moment of deployment. The *decimals* field indicates placement of decimal point in total supply. E.g. total supply: 1050 decimals: 3 will mint supply of 1.050 token. After you send the contract to the chain a box appears below. You are provided with the following information fields *Execution status*, *Hash*, *Invocation* and *Deployed at*.  Successful deployment will look like
this:

![deployment](deployment.png)

You are now ready to interact with the contract. Copy the address of deployment and paste it into the menu *Interact Wasm Contract* in the dashboard. Now you can mint and transfer your tokens.

<div class="embed-video-wrapper">
<iframe width="711" height="400" src="https://www.youtube.com/embed/qV2grtWDxUE" title="YouTube video player" frameborder="0" allowfullscreen></iframe>
</div>

Congratulations! You have now created an active smart-contract on the Partisia Blockchain.  
