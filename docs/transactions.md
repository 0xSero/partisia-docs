
# Transactions

A transaction represents an authorized atomic interaction with the blockchain.

Each transaction defines how long into the future it is valid and what the cost is. A hash of the transaction and the signer’s nonce is then signed by the account holder using his/her private key. This signature is used to authenticate the signer on the blockchain. If the signing key does not have a corresponding account, the transaction is rejected.

A transaction is valid when:

- It has as a valid signature
- The nonce in the transaction matches the account nonce in the blockchain state
- The transaction has not expired
- The account can cover the cost of the transaction (see Transaction fees below)

There are three types of transactions: create contract, interact with contract and remove contract. All transactions include an RPC byte stream, the interpretation of which is up to the specific contract. The three transaction types correspond to the `onCreate`, `onInvoke` and `onDestroy` methods comprise the contract lifecycle.
