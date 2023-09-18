# Compile and deploy contracts

In the following sections we focus on the example token contract included in the example contract archive.
The contract utilizes several functions. The main functions are _initialize_, and _transfer_ that
allow you to perform the basic operations needed for a transfer.
After deployment the contract actions can be called from the dashboard. When you perform an action it
changes the contract state. If you inspect the contract you can see the serialized data showing
the contract state.

## 1) Compile a contract example

The token contract can be found in the [example contract archive](https://gitlab.com/partisiablockchain/language/example-contracts/-/tree/main/token?ref_type=heads)
The following will compile it and generate an ABI for it:

```bash
cd contracts/example-token-contract
cargo partisia-contract build --release
```

Now you will find a .wasm-file and a .abi-file in:
`/target/wasm32-unknown-unknown/release`.

## 2) Upload the contract to the blockchain

To deploy a smart contract you need an [account](../pbc-fundamentals/create-an-account.md) with [gas](gas/what-is-gas.md) to cover transaction costs.

To deploy a contract you can visit the [Partisia Blockchain browser](https://browser.partisiablockchain.com/contracts/deploy).
Ensure that you have some gas, if you want to try for free you can get som testnet gas here and deploy through [the testnet](https://browser.testnet.partisiablockchain.com/contracts/deploy). 

Select the `token_contract.wasm` and the `token_contract.abi`.
The dashboard will then render a form for the initialization function. If you look at `lib.rs` file in your IDE,
you will see that this matches the _initialize_ function.
The other three actions will be available after successful deployment.

In the _total_supply_ field you put the number of tokens you want minted for total supply of the contract
from the moment of deployment.
The _decimals_ field indicates placement of decimal point in total supply.
E.g. total supply: 1050 decimals: 3 will mint supply of 1.050 token. 

It should look like this before deployment: 

![compile-and-deploy-contracts-before-deploy.png](compile-and-deploy-contracts-before-deploy.png)

After you send the contract to
the chain a box appears below. You are provided with the following information fields
_Execution status_, _Hash_, _Invocation_ and _Deployed at_.  
Successful deployment will look like
this:

![compile-and-deploy-contracts-after-deploy.png](compile-and-deploy-contracts-after-deploy.png)

You are now ready to interact with the contract. Copy the address of deployment and paste it into the menu _Interact Wasm Contract_ in the dashboard. Now you can mint and transfer your tokens.

<div class="embed-video-wrapper">
<iframe width="711" height="400" src="https://www.youtube.com/embed/qV2grtWDxUE" title="YouTube video player" frameborder="0" allowfullscreen></iframe>
</div>

Congratulations! You have now created an active smart-contract on the Partisia Blockchain.
