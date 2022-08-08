# Contract compilation and deployment

In the following sections we focus on the example token contract included in the SDK archive.
The contract utilizes several functions. Three of these functions are actions that allow you to 
perform the basic operations needed for a transfer. The functions are *initialize*, *mint*, and *transfer*.
After deployment, you can call the functions from the dashboard. When you perform an action it
changes the contract state. If you inspect the contract you can see the serialized data showing
the contract state.

## 1) Compile a contract example

The token contract can be found in SDK archive: `contracts/example-token-contract`.
The following will compile it and generate an ABI for it:

```` bash
cd contracts/example-token-contract
cargo partisia-contract build --release
````

Now you will find a .wasm-file and a .abi-file in: 
`/tmp/pbc-rust-wasm/contracts/example-token-contract/target/wasm32-unknown-unknown/release`.

### Compiling Zero-Knowledge contracts

As an example of compiling a zk-contract we will make use of the second-price auction contract. The
contract can be found in the SDK archive at: `contracts/example-zk-second-price-auction`.

The zk-contracts consist of two main parts. The contract itself as well as a zero-knowledge computation.
To compile a zero-knowledge contract you will first need to compile the contract using the partisia-contract
cargo command similarly to a normal contract. Afterward the zk-computation can be compiled using the included `zk-compiler.jar`:

```bash
java -jar [path to zk_compute.rs] --link [path to .wasm file]
```

This creates the linked byte file with the zk bytecode as well as the wasm file. This file is used for deployment
instead of the normal .wasm file.

## 2) Upload the contract to the blockchain

To deploy a smart contract you need an [account](accounts.md) with [gas](byoc.md) to cover transaction costs. 
Open the wallet in the [Dashboard](https://dashboard.partisiablockchain.com/wallet/upload_wasm) 
or use [Partisia Blockchain Explorer](https://mpcexplorer.com/deploy-contract) 
Select the `token_contract.wasm` and the `token_contract.abi`. 
The dashboard will then render a form for the initialization function. If you look at lib.rs file in your IDE, 
you will see that this matches the *initialize* function. 
The other three actions will be available after successful deployment.

In the *total_supply* field you put the number of tokens you want minted for total supply of the contract 
from the moment of deployment. 
The *decimals* field indicates placement of decimal point in total supply. 
E.g. total supply: 1050 decimals: 3 will mint supply of 1.050 token. After you send the contract to 
the chain a box appears below. You are provided with the following information fields 
*Execution status*, *Hash*, *Invocation* and *Deployed at*.  
Successful deployment will look like
this:

![deployment](deployment.png)

You are now ready to interact with the contract. Copy the address of deployment and paste it into the menu *Interact Wasm Contract* in the dashboard. Now you can mint and transfer your tokens.

<div class="embed-video-wrapper">
<iframe width="711" height="400" src="https://www.youtube.com/embed/qV2grtWDxUE" title="YouTube video player" frameborder="0" allowfullscreen></iframe>
</div>

Congratulations! You have now created an active smart-contract on the Partisia Blockchain.  
