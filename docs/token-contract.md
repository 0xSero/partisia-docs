
# Develop your first contract

If you are here you should already have familiarised yourself with the prerequisites.
You have an account and have your Linux terminal and Rust environment up and running.
For price see [Transaction fees](transactions.md).

## Step 1

Go to the [Archive](rust-contract-sdk-rc5.zip). Download the zip-archive containing the Rust project
files and the ABI generator. The ABI generator
allows you to customize the functions of the contract in accordance with your own imagination. The
project contains the rust contract. If you are working with a WSL shell on Windows
you need to extract the archive to `\\wsl$\Ubuntu\tmp\pbc-rust-wasm\`.
To compile run the following commands after changing directory to the  token-contract folder:
```` bash
cargo build --target wasm32-unknown-unknown --release
````
Now you will find a .wasm-file in called *token_contract.wasm* in: `\\wsl$\Ubuntu\tmp\pbc-rust-wasm\token-contract\target\wasm32-unknown-unknown\release\`

The resulting wasm contract and ABI should be equivalent to this: [wasm and abi](WASMandABI_tokenContract.zip)

## Step 2

If you look at lib.rs file in your IDE, you will see the contract utilizes several functions denoted with the initial *fn*. Three of these functions are actions that allow you to perform the basic operations needed for a transfer. The functions are *initialize*, *mint*, and *transfer*. After deployment, you can call the functions from the dashboard. When you perform an action it changes the contract state. If you inspect the contract you can see the serialized data showing the contract state. You can make sense of the data and see the actual contract state by applying the reader function `fn read_from` from the contract to the datastream.

## Step 3

Open the wallet in the [dashboard](https://dashboard.partisiablockchain.com/wallet/upload_wasm). Select the `token_contract.wasm` and the `token_contract.abi`. In the Init field you put the number of tokens you want minted for total supply of the contract from the moment of deployment. After you send the contract to the chain a box appears below. You are provided with the following information fields *Execution status*, *Hash*, *Invocation* and *Deployed at*.
You are now ready to interact with the contract. Copy the address of deployment and paste it into the menu *Interact Wasm Contract*. Now you can mint and transfer your tokens.

[DemoVid](https://youtu.be/qV2grtWDxUE)


Congratulations! You have now created an active smart-contract on the Partisa Blockchain. You can add your personalized functions according to your wishes.  

