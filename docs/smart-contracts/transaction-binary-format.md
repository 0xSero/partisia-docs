# Transaction Binary Format

This article is created to help developers build blockchain transactions from the binary format for their own use or to
translate it into other languages besides the already
supported [client libraries](smart-contract-tools-overview.md#client).

To put a transaction on the blockchain you have to create the binary payload according to the specification of
`SignedTransaction`, using a valid signature.

```
<SignedTransaction> := {
    signature: Signature
    innerPart: InnerPart
}

<Signature> := {
    recoveryId: 0xnn
    valueR: 0xnn*32                         (big endian)
    valueS: 0xnn*32                         (big endian)
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
and the rpc payload of the transaction.
See [Smart Contract Binary Formats](smart-contract-binary-formats.md)
for a way to build the rpc payload.

## Creating the signature

The signature is an ECDSA signature, using secp256k1 as the curve, on a sha256 hash of the innerPart and the chain ID of
the blockchain.

````
<ToBeHashed> := innerPart:InnerPart chainId:ChainId

<ChainId> := len:0xnn*4 utf8:0xnn*len       (len is big-endian)
````

The chain id is a unique identifier for the blockchain. For example, the chain id for Partisia Blockchain mainnet is
`Partisia Blockchain` and the chain id for the testnet is `Partisia Blockchain Testnet`.
