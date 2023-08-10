# Bridging BYOC by sending transactions



This guide explains how to use transactions to bridge liquid cryptocurrencies recognized by PBC (generally referred to as BYOC bring your own coin) from and to outside chains. 

For a guide to the bridging of BYOC with the bridge's UI see [here](byoc-and-gas.md)

A Partisia Blockchain [account](create-an-account.md) holds the necessary information enabling the user to perform transactions. Among other fields the account state includes a balance of BYOC. Users can transfer BYOC between accounts internally on PBC, we call this BYOC transfer. However, it is also possible to transfer BYOC from and to other chains, we call this action bridging.

## How does the bridge work

The basic idea behind the bridge is double bookkeeping, always maintaining a record of the BYOC funds both on PBC and on the coin's native chain. To use the bridge you must have an account on PBC and on the chain which coins you want to deposit or withdraw. You must have a wallet to sign transactions on both chains that you are interacting with. In the following examples we will assume, that you are trying to bridge ETH. The method used for other BYOCs is the same. Currently, BYOCs include ETH, Matic, Binance Coin and USDC.

### Make a deposit

1. Deposit x ETH to the BYOC smart contract on Ethereum (_contract address_)
- You invoke the contract action _deposit_, the action take an account address and the transferred amount
2. The deposit oracle on PBC reads and signs the deposit
3. x BYOC twins are minted on PBC

### Make a withdrawal






    - How to Send the Transaction to Foreign Chains when bridging

    - How to Send the Transaction on PBC when Bridging

