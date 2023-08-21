# Bridging BYOC by sending transactions



This guide explains how to use transactions to bridge liquid cryptocurrencies recognized by PBC (generally referred to as BYOC bring your own coin) from and to outside chains. 

For a guide to the bridging of BYOC with the bridge's UI see [here](byoc-and-gas.md)

A Partisia Blockchain [account](create-an-account.md) holds the necessary information enabling the user to perform transactions. Among other fields the account state includes a balance of BYOC. Users can transfer BYOC between accounts internally on PBC, we call this BYOC transfer. However, it is also possible to transfer BYOC from and to other chains, we call this action bridging.   

## How does the bridge work

The basic idea behind the bridge is double bookkeeping, always maintaining a record of the BYOC funds both on PBC and on the coin's native chain. To use the bridge you must have an account on PBC and on the chain which coins you want to deposit or withdraw. You must have a wallet to sign transactions on both chains that you are interacting with. In the following examples we will assume, that you are trying to bridge ETH. The method used for other BYOCs is the same. Currently, BYOCs include ETH, Matic, Binance Coin and USDC.

### Make a deposit

**Deposit X ETH from ETH account A to PBC account B**

1. Invoke the contract action _deposit_ on the [small oracle contract on Ethereum](https://etherscan.io/address/0xf393d008077c97f2632fa04a910969ac58f88e3c):   

```SOL
deposit(bytes21 destination, uint amount)
``` 
 
2. The [deposit oracle](https://dashboard.partisiablockchain.com/info/contract/042f2f190765e27f175424783a1a272e2a983ef372) on PBC reads and signs the deposit   
3. x BYOC twins are minted on PBC by the deposit oracle contract   
4. x ETH are added to the balance PBC account B   


![Diagram0](../pbc-fundamentals/depositBridge.png)


### Make a withdrawal

**Withdraw X ETH from PBC account A**   

1. Add a pending withdrawal on PBC by invoking the action _Withdrawal_ on the [ETH withdrawal oracle contract on PBC](https://dashboard.partisiablockchain.com/info/contract/043b1822925da011657f9ab3d6ff02cf1e0bfe0146):   

```JAVA
public Withdrawal(
        EthereumAddress receiver,
        Unsigned256 amount,
        int numberOfOracles,
        Hash requestingTransaction)

```   

2. Invoke the contract action _withdraw_ on the [small oracle contract on Ethereum](https://etherscan.io/address/0xf393d008077c97f2632fa04a910969ac58f88e3c), the action take an account address and the transferred amount: 

```SOL
withdraw(uint64 withdrawNonce,
   address destination,
   uint amount,
   uint32 bitmask,
   bytes calldata signatures
   )
```

on the [small oracle contract on Ethereum](https://etherscan.io/address/0xf393d008077c97f2632fa04a910969ac58f88e3c), the action take an account address and the transferred amount
3. x ETH are added to the balance of ETH account A 

   
## Resources to get you started

You need a way to sign transactions you put PBC and on the chain you are bridging to and from. There are public free wallet extensions for PBC and for the chains from which we accept BYOC. Besides that, you will need the addresses of the [oracle](.../node-operations/oracles-on-partisia-blockchain) contracts you want to interact with. Below is a complete list of our BYOC contracts on PBC and connected chains.

### Bridging ETH
[ETH deposit oracle on PBC](https://dashboard.partisiablockchain.com/info/contract/042f2f190765e27f175424783a1a272e2a983ef372)
[ETH withdrawal oracle on PBC](https://dashboard.partisiablockchain.com/info/contract/043b1822925da011657f9ab3d6ff02cf1e0bfe0146)
[Small oracle contract on Ethereum](https://etherscan.io/address/0xf393d008077c97f2632fa04a910969ac58f88e3c)
[Large oracle contract on Ethereum](https://etherscan.io/address/0x3435359df1d8c126ea1b68bb51e958fdf43f8272)


### Bridging USDC
[USDC deposit oracle on PBC](https://dashboard.partisiablockchain.com/info/contract/042f2f190765e27f175424783a1a272e2a983ef372)
[USDC withdrawal oracle on PBC](https://dashboard.partisiablockchain.com/info/contract/04adfe4aaacc824657e49a59bdc8f14df87aa8531a)
[Small oracle contract on Polygon](https://polygonscan.com/address/0x4c4ecb1efb3bc2a065af1f714b60980a6562c26f)
[Large oracle contract on Polygon](https://polygonscan.com/address/0x3435359df1d8c126ea1b68bb51e958fdf43f8272)

### Bridging BNB Coin
[BNB deposit oracle on PBC](https://dashboard.partisiablockchain.com/info/contract/047e1c96cd53943d1e0712c48d022fb461140e6b9f)
[BNB withdrawal oracle on PBC](https://dashboard.partisiablockchain.com/info/contract/044bd689e5fe2995d679e946a2046f69f022be7c10)
[Small oracle contract on BNB Smartchain](https://bscscan.com/address/0x05ee4eee70452dd555ecc3f997ea03c6fba29ac1)
[Large oracle contract on BNB smartchain](https://bscscan.com/address/0x4c4ecb1efb3bc2a065af1f714b60980a6562c26f)


