# Gas price table overview

| **Name**                 | **Cost in gas**                                                                                                  | **Paid by**                                    |
| ------------------------ | ---------------------------------------------------------------------------------------------------------------- | ---------------------------------------------- |
| Network                  | 5,000 per kb sent                                                                                                | Calling user (Actions)                         |
| Storage                  | 1,000 per kb per year                                                                                            | Contract                                       |
| WASM execution (CPU)     | 1 per 1,000 instructions                                                                                         | Calling user (Actions)<br>Contract (ZK events) |
| AVL execution (CPU)      | 100 per 1 instructions                                                                                           | Calling user (Actions)                         |
| Staking                  | 1% of locked stakes (minimum 2,000) multiplied by 40,000                                                         | Calling user                                   |
| Secret input             | 8,000 + 40 per bit of input                                                                                      | Calling user                                   |
| ZK computation           | 50,000 plus 5 per multiplication                                                                                 | Contract                                       |
| ZK preprocessing         | 550,000 per multiplication triple batch (batch size 100,000) <br> 55,000 per input mask batch (batch size 1,000) | Contract                                       |
| Opening secret variables | 8,000 + 40 per bit of input                                                                                      | Contract (Contract variables)                  |
| Attestation              | 25,000                                                                                                           | Contract                                       |
| EVM oracle               | 25,000                                                                                                           | Contract                                       |

### Where is the payment ultimately allocated?

When network, storage, WASM- and AVL execution fees are paid, the gas is distributed among the block producers based on
performance. When ZK fees are paid, the gas is distributed equally among the contract's associated ZK nodes on the
blockchain.
