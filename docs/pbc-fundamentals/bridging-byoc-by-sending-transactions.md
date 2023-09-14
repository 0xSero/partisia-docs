# Bridging BYOC by sending transactions



This guide explains how to use transactions to bridge liquid cryptocurrencies recognized by PBC (generally referred to as BYOC bring your own coin) from and to outside chains. 

For a guide to the bridging of BYOC with the bridge's UI see [here](byoc.md)

A Partisia Blockchain [account](create-an-account.md) holds the necessary information enabling the user to perform transactions. Among other fields the account state includes a balance of BYOC. Users can transfer BYOC between accounts internally on PBC, we call this BYOC transfer. It is also possible to transfer BYOC from and to other chains, we call this action bridging.   

## How does the bridge work

The basic idea behind the bridge is to move liquid cryptocurrencies to and from PBC.

&nbsp;

![Diagram0](../pbc-fundamentals/bridge-overview.png)

&nbsp;  


To deposit funds on PBC from a foreign chain the coins are locked on an oracle contract on the foreign chain. A deposit oracle consisting of three nodes on PBC monitors this contract. When the oracle nodes confirm that the funds are locked on the relevant contract the oracle nodes can sign the minting of equivalent funds on PBC called BYOC (bring your own coin).   
The BYOC essentially works as IOUs that can only be created when the equal sum of money is locked on the chain where the deposit comes from.
   
Withdrawal is the same operation in reverse order:    
The BYOCs are first burned on PBC, then when the withdrawal oracle nodes confirm this, they sign for the funds to be unlocked from the contract on the native chain.
To use the bridge you must have an account on PBC and on the chain which coins you want to deposit or withdraw. You must have a wallet to sign transactions on both chains that you are interacting with. In the following examples we will assume, that you are trying to bridge ETH. The method used for other BYOCs is the same. Currently, BYOCs include ETH, Binance Coin and USDC. There is a detailed description below, describing which contracts and invocations are used for deposits and withdrawals.

### Make a deposit

**Deposit X ETH from ETH account A to PBC account B**

1. Invoke the contract action _deposit_ on the [small oracle contract on Ethereum](https://etherscan.io/address/0xf393d008077c97f2632fa04a910969ac58f88e3c#writeProxyContract):
```SOL
deposit(bytes21 destination, uint amount)
```
2. The [deposit oracle](https://browser.partisiablockchain.com/contracts/045dbd4c13df987d7fb4450e54bcd94b34a80f2351) on PBC reads and signs the deposit   
3. x BYOC twins are minted on PBC by the deposit oracle contract   
4. x ETH are added to the balance PBC account B   


![Diagram1](../pbc-fundamentals/depositBridge.png)


### Make a withdrawal

**Withdraw X ETH from PBC account A**   

1. Add a pending withdrawal on PBC by invoking the action _Withdrawal_ on the [ETH withdrawal oracle contract on PBC](https://browser.partisiablockchain.com/contracts/043b1822925da011657f9ab3d6ff02cf1e0bfe0146):
```JAVA 
 public ByocOutgoingContractState addPendingWithdrawal(
      SysContractContext context,
      ByocOutgoingContractState state,
      EthereumAddressRpc receiver,
      Unsigned256 amount) 
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
3. x ETH are added to the balance of ETH account A    

   
## Resources to get you started

You can use the [Metamask wallet](https://metamask.io/download/) to sign and send transaction for Ethereum, Polygon, BNB smartchain and Partisia. This wallet is primarily designed for Ethereum, but can interact with the other chains as well. To see how you use the metamask wallet to send transactions with the RPC method see [here](https://docs.metamask.io/wallet/how-to/send-transactions/). If you want a wallet that is designed to interact with PBC, use the [Partisia Blockchain Wallet extension](https://partisiablockchain.gitlab.io/partisia-wallet-sdk-docs/#/partisia) to sign and send your transactions to PBC.

Besides the wallets, you will need the addresses of the [oracle](.../node-operations/oracles-on-partisia-blockchain) contracts you want to interact with. Below is a complete list of our BYOC contracts on PBC and connected chains. On the testnet test BYOC from the ETH Goerli testnet is available, but do no other BYOC test coins from other chains.

### Bridging test ETH

[ETH_GOERLI Deposit on PBC testnet](https://browser.testnet.partisiablockchain.com/contracts/045dbd4c13df987d7fb4450e54bcd94b34a80f2351)       
[ETH_GOERLI Withdrawal on PBC testnet](https://browser.testnet.partisiablockchain.com/contracts/043b1822925da011657f9ab3d6ff02cf1e0bfe0146)     
[Small oracle contract on Ethereum testnet](https://goerli.etherscan.io/address/0x4818370f9d55fb34de93e200076533696c4531f3)    
[Large oracle contract on Ethereum testnet](https://goerli.etherscan.io/address/0x5De7b80e5CeB9550ee1BeC3291b15e9B04E8de68)    

### Bridging ETH

[ETH Deposit on PBC](https://browser.partisiablockchain.com/contracts/045dbd4c13df987d7fb4450e54bcd94b34a80f2351)   
[ETH Withdrawal on PBC](https://browser.partisiablockchain.com/contracts/043b1822925da011657f9ab3d6ff02cf1e0bfe0146)   
[Small oracle contract on Ethereum](https://etherscan.io/address/0xf393d008077c97f2632fa04a910969ac58f88e3c)   
[Large oracle contract on Ethereum](https://etherscan.io/address/0x3435359df1d8c126ea1b68bb51e958fdf43f8272)   


### Bridging USDC

[POLYGON_USDC Deposit on PBC](https://browser.partisiablockchain.com/contracts/042f2f190765e27f175424783a1a272e2a983ef372)   
[POLYGON_USDC Withdrawal on PBC](https://browser.partisiablockchain.com/contracts/04adfe4aaacc824657e49a59bdc8f14df87aa8531a)   
[Small oracle contract on Polygon](https://polygonscan.com/address/0x4c4ecb1efb3bc2a065af1f714b60980a6562c26f)   
[Large oracle contract on Polygon](https://polygonscan.com/address/0x3435359df1d8c126ea1b68bb51e958fdf43f8272)   

### Bridging BNB Coin

[BNB Deposit on PBC](https://browser.partisiablockchain.com/contracts/047e1c96cd53943d1e0712c48d022fb461140e6b9f)   
[BNB Withdrawal on PBC](https://browser.partisiablockchain.com/contracts/044bd689e5fe2995d679e946a2046f69f022be7c10)   
[Small oracle contract on BNB Smartchain](https://bscscan.com/address/0x05ee4eee70452dd555ecc3f997ea03c6fba29ac1)   
[Large oracle contract on BNB smartchain](https://bscscan.com/address/0x4c4ecb1efb3bc2a065af1f714b60980a6562c26f)   


