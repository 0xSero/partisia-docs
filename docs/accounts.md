# Accounts

An account on PBC is identified by a unique address that is derived from the [public key](keys.md).
The account state holds a single piece of information: The nonce. This is a number that is incremented each time a transaction signed by an account is executed.

Accounts are used when sending transactions to any contracts on the blockchain.
Since the account nonce is part of the signature it can be used only once. This means that an account holder can only execute one transaction for each block.
