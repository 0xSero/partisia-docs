# How to create a WASM smart contract


## What is a smart contract?

Creating a smart contract is one of the basic ways you can utilize the Partisia Blockchain. A smart contract is a program you run on the blockchain. The conditions of the contract are present across the blockchain. This ensures that actions of the smart contract will happen only once, are trackable and irreversible. In this way a smart contract works independently, without any need for outside authority to facilitate the change in state. So, you do not need a bank or a lawyer to set up a binding agreement anymore, since you have ultimate control over the conditions necessary to make the change happen. Smart contracts are the tool for you if you need to buy, sell, facilitate auctions or administrate portfolios of diverse assets.

## Why should you use the Partisia Blockchain for your smart contracts?

What makes the smart contract on Partisia Blockchain different from contracts on other blockchains is that we allow you to add a privacy layer parallel with the immutable ledger. This means that you through your contract will allocate nodes in the blockchain to handle Zero Knowledge computation. If you for example want to make an auction, you can keep the identity of the current bidder and account information secret and off the record, while the identity of the winner and seller will be added to the immutable record. This will secure a record of change in ownership while at the same time preserving the privacy of all interested parties that don’t give the winning bid. This principle of a combination of a privacy layer and a public record means that the Patisia Blockchain effectively can replace the trustee in binding transactions.

## Develop your first contract
 
If you are here you should already have familiarised yourself with the prerequisites. 
You have an account and have your Linux terminal and Rust environment up and running.
For price see [Transaction fees](transactions.md).

## Step 1

Go to [Archive](TransferContractv3.zip)
Download the zip-archive containing the Rust project files and the ABI. The project contains a basic contract template for minting and transferring your own token. If you are working with a linux shell from Windows or Mac you need to extract the archive in `\\wsl$\Ubuntu\tmp\pbc-rust-wasm\`
To compile run the following commands after changing directory to the  token-contract folder:
```` bash
cargo build --target wasm32-unknown-unknown --release
````
Now you will find a .wasm-file in called *token_contract.wasm* in: `\\wsl$\Ubuntu\tmp\pbc-rust-wasm\token-contract\target\wasm32-unknown-unknown\release\`

## Step 2

If you look at lib.rs file in your IDE, you will see the contract utilizes several functions denoted with the initial *fn*. Three of these functions are actions that allow you to perform the basic operations needed for a transfer. The functions are *initialize*, *mint*, and *transfer*. After deployment, you can call the functions from the dashboard. When you perform an action it changes the contract state. If you inspect the contract you can see the serialized data showing the contract state. You can make sense of the data and see the actual contract state by applying the reader function `fn read_from` from the contract to the datastream.

## Step 3

Open the wallet in the [dashboard](https://dashboard.partisiablockchain.com/wallet/upload_wasm). Select the `token_contract.wasm` and the `token_contract.abi`. In the Init field you put the number of tokens you want minted for total supply of the contract from the moment of deployment. After you send the contract to the chain a box appears below. You are provided with the following information fields *Execution status*, *Hash*, *Invocation* and **Deployed at*
You are now ready to interact with the contract. Copy the address of deployment and pate it into the menu *Interact Wasm Contract*. Now you can mint and transfer your tokens.

[DemoVid](https://youtu.be/qV2grtWDxUE)


Congratulations! You have now created an active smart-contract on the Partisa Blockchain. You can add your personalized functions according to your wishes.  

