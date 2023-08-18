# Bridging BYOC by sending transactions



This guide explains how to use transactions to bridge liquid cryptocurrencies recognized by PBC (generally referred to as BYOC bring your own coin) from and to outside chains. 

For a guide to the bridging of BYOC with the bridge's UI see [here](byoc-and-gas.md)

A Partisia Blockchain [account](create-an-account.md) holds the necessary information enabling the user to perform transactions. Among other fields the account state includes a balance of BYOC. Users can transfer BYOC between accounts internally on PBC, we call this BYOC transfer. However, it is also possible to transfer BYOC from and to other chains, we call this action bridging.

## How does the bridge work

The basic idea behind the bridge is double bookkeeping, always maintaining a record of the BYOC funds both on PBC and on the coin's native chain. To use the bridge you must have an account on PBC and on the chain which coins you want to deposit or withdraw. You must have a wallet to sign transactions on both chains that you are interacting with. In the following examples we will assume, that you are trying to bridge ETH. The method used for other BYOCs is the same. Currently, BYOCs include ETH, Matic, Binance Coin and USDC.

### Make a deposit

**Deposit X ETH from ETH account A to PBC account B**
1. Invoke the contract action _deposit_:
```SOL
deposit(bytes21 destination, uint amount)
``` 
on the BYOC smart contract on Ethereum (_contract address_)
2. The deposit oracle on PBC reads and signs the deposit
3. x BYOC twins are minted on PBC by the deposit oracle contract
4. x ETH are added to the balance PBC account B 


![Diagram0](../pbc-fundamentals/depositBridge.png)


### Make a withdrawal

**Withdraw X ETH from PBC account A**
1. Add a pending withdrawal on PBC by invoking the action _Withdrawal_:
```JAVA
public Withdrawal(
        EthereumAddress receiver,
        Unsigned256 amount,
        int numberOfOracles,
        Hash requestingTransaction)

```
2. Invoke the contract action _withdraw_: 
```SOL
withdraw(uint64 withdrawNonce,
   address destination,
   uint amount,
   uint32 bitmask,
   bytes calldata signatures
   )
```
on the BYOC smart contract on Ethereum (_contract address_), the action take an account address and the transferred amount
3. x ETH are added to the balance of ETH account A 

   

