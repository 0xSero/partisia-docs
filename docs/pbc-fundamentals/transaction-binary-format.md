# Transaction Binary Format

To put a transaction on the blockchain you need to have an account with gas. You can then create a binary payload of a SignedTransaction as follows:

```
<SignedTransaction> := {
    signature: 0xnn*65
    innerPart: InnerPart
}

<InnerPart> := {
    nonce: 0xnn*8                           (big-endian)
    validToTime: 0xnn*8                     (big-endian)
    gasCost: 0xnn*8                         (big-endian)
    innerTransaction: Transaction
}
```
The innerPart includes the signer's nonce, a unix time that the transaction is valid to,
the amount of gas allocated to executing the transaction, and the actual content of the transaction.

```
<Transaction> := {
    address: 0xnn*21
    rpc := Rpc
}

<Rpc> := len:0xnn*4 payload:0xnn*len        (len is big-endian)
```

The transaction itself contains the address of the contract that is the target of the transaction 
and the rpc payload of the transaction. See [Smart Contract Binary Formats](../smart-contracts/smart-contract-binary-formats.md) 
for a way to build the rpc payload.

## Creating the signature
The signature is created using the secp256k1 elliptic curve by signing a sha256 hash created from the innerPart and chain the id of the blockchain.

````
<ToBeHashed> := innerPart:InnerPart chainId:ChainId

<ChainId> := len:0xnn*4 utf8:0xnn*len       (len is big-endian)
````

The chain id is a unique identifier for the blockchain. For example, the chain id for Partisia Blockchain mainnet is
`Partisia Blockchain` and the chain id for the testnet is `Partisia Blockchain Testnet`.
