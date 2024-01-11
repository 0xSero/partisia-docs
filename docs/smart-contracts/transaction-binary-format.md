# Transaction Binary Format

A transaction is an instruction from a user containing information used to change the state of the blockchain.

After constructing a binary signed transaction it can be delivered to any baker node in the network through
their [REST API](../rest).

The following is the specification of the binary format of signed transactions.

The easiest way of creating a binary signed transaction is by using one of the
available [client libraries](smart-contract-tools-overview.md#client). This specification can help you if you want to
make your own implementation, for instance if you are targeting another programming language.

```
<SignedTransaction> := {
    signature: Signature
    transaction: Transaction
}

<Signature> := {
    recoveryId: 0xnn
    valueR: 0xnn*32                         (big endian)
    valueS: 0xnn*32                         (big endian)
}

<Transaction> := {
    nonce: 0xnn*8                           (big-endian)
    validToTime: 0xnn*8                     (big-endian)
    gasCost: 0xnn*8                         (big-endian)
    address: 0xnn*21
    rpc := Rpc
}

<Rpc> := len:0xnn*4 payload:0xnn*len        (len is big-endian)
```

The Signature includes:

- a recovery id between 0 and 3 used to recover the public key when verifying the signature
- the r value of the ECDSA signature
- the s value of the ECDSA signature

The Transaction includes:

- the signer's [nonce](../pbc-fundamentals/dictionary.md#nonce)
- a unix time that the transaction is valid to
- the amount of [gas](gas/transaction-gas-prices.md) allocated to executing the transaction 
- the address of the smart contract that is the target of the transaction
- the rpc payload of the transaction. See [Smart Contract Binary Formats](smart-contract-binary-formats.md)
  for a way to build the rpc payload.

## Creating the signature

The signature is an ECDSA signature, using secp256k1 as the curve, on a sha256 hash of the transaction and the chain ID of
the blockchain.

````
<ToBeHashed> := transaction:Transaction chainId:ChainId

<ChainId> := len:0xnn*4 utf8:0xnn*len       (len is big-endian)
````

The chain id is a unique identifier for the blockchain. For example, the chain id for Partisia Blockchain mainnet is
`Partisia Blockchain` and the chain id for the testnet is `Partisia Blockchain Testnet`.
