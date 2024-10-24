# Gas price table overview

| **Name**                 | **Cost in gas**                                                                                                   | **Paid by**                                    |
| ------------------------ | ----------------------------------------------------------------------------------------------------------------- | ---------------------------------------------- |
| Network                  | 5,000 per kb sent                                                                                                 | Calling user (Actions)                         |
| WASM execution           | 5,000 per 1000 instructions                                                                                       | Calling user (Actions)<br>Contract (ZK events) |
| Staking                  | 1% of locked stakes (minimum 2,000) multiplied by 40,000                                                          | Calling user                                   |
| Secret input             | 25,000                                                                                                            | Calling user                                   |
| ZK computation           | 50,000 plus 5 per multiplication                                                                                  | Contract                                       |
| ZK preprocessing         | 550,000 per multiplication triple batch (batch size 100,000) <br> 55,000 per input mask batch (batch size 10,000) | Contract                                       |
| Opening secret variables | 25,000                                                                                                            | Contract (Contract variables)                  |
| Attestation              | 25,000                                                                                                            | Contract                                       |

The source for the fees are the [Partisia Blockchain yellow paper](https://drive.google.com/file/d/1OX7ljrLY4IgEA1O3t3fKNH1qSO60_Qbw/view).

### Where does the payment end?

When network and WASM execution fees are paid, the gas is distributed among the block producers. When ZK fees are paid, the gas is distributed among the contract's associated ZK nodes on the blockchain.
