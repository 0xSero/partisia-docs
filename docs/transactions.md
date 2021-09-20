
# Transactions

A transaction represents an authorized atomic interaction with the blockchain.

Each transaction defines how long into the future it is valid and what the cost is. A hash of the transaction and the signer’s nonce is then signed by the account holder using his/her private key. This signature is used to authenticate the signer on the blockchain. If the signing key does not have a corresponding account, the transaction is rejected.

A transaction is valid when:

- It has as a valid signature
- The nonce in the transaction matches the account nonce in the blockchain state
- The transaction has not expired
- The account can cover the cost of the transaction (see Transaction fees below)

There are three types of transactions: create contract, interact with contract and remove contract. All transactions include an RPC byte stream, the interpretation of which is up to the specific contract. The three transaction types correspond to the `onCreate`, `onInvoke` and `onDestroy` methods comprise the contract lifecycle.

## Create contract

The create contract interaction deploys a smart contract on the blockchain. The code of the contract is packaged as a jar file (see [Contract development](contract-development.md) for details) and encoded as a part of the transaction. Along with the contract code the create contract transaction sends a contract [binder](binders.md) jar, which is needed for API compatibility reasons. The last part of the transaction is the RPC is not validated by the system but read in its entirety and passed directly to the `onCreate` method of the contract.

## Interact with contract

The interact transaction is used for invoking actions on a contract. The RPC portion of the transaction is read and passed on to the deployed contract. The contract handles the RPC as it sees fit and a successful contract interaction yields a contract state update. This updated state is then persisted on the blockchain. If the contract code fails with an exception the state is rolled back and an error is logged to the node process log.

## Remove contract

This transaction type allows the owner of the contract to delete the contract from the blockchain. Only the owner is allowed to call remove. If a remove call succeeds without throwing exceptions the contract is removed and any residual gas left on the contract is distributed to the block producers.
During this transaction the `onDestroy` method is called on the contract. If this fails with an exception the contract is not removed.

## State and storage

The contract state is a part of the blockchain state. The state can only be updated through one of the life cycle methods. The state serialization works with any composition of classes that implement `io.privacyblockchain.serialization.StateSerializable` and the following Java types:

- Primitives: byte, char, short, int, long
- Wrappers: Byte, Char, Short, Integer, Long
- java.lang.String
- org.bouncycastle.math.ec.ECPoint

All classes implementing `io.privacyblockchain.serialization.StateSerializable` must have a no-args constructor.

## Signatures

The signatures on PBC are ECDSA signatures of the hash of the byte representation of the transaction. The signature consists of two integers `r` and `s` and a byte  denoting the recovery id of the signature. The recovery id is needed because for any given ECDSA signature there are four potential keys. It is therefore necessary to store the recovery id alongside the signature. See [SEC 1: Elliptic Curve Cryptography](https://www.secg.org/sec1-v2.pdf) for the mathematical reasoning.

To create a signature you need to create the correct byte stream for the transaction. The easiest and recommended way of doing this is using the `blockchain-client` library's `io.privacyblockchain.client.transaction.SignedTransactionC` class. This is a Java representation of a signed transaction which is easily written as a byte stream using the `write` method.

Note: Debugging signatures and  hashes is a non-trivial process. We strongly recommend using the supplied client libraries.

## Transaction fees

Transactions are priced according to the type and size of the transaction. The transaction size is calculated as the size of the entire signed transaction byte stream plus the size of the inner transaction.

Create transactions cost a base fee of 10,000 gas + the size of the contract being deployed.

Interact transactions cost a base fee of 100 gas plus the size of the  contract the transaction interacts with.

Remove transactions cost 2500 gas.
