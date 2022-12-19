# Zero-knowledge computation fees

This file contains an overview of the different fees that a zero-knowledge (ZK) contract has to pay to its associated ZK nodes.

## ZK computation, MPC tokens and gas

A deployed ZK contract has a number of ZK computation nodes associated with it.

These nodes each lock an amount of their MPC tokens as collateral for the computation. If any malicious activity by a ZK node is detected the collateral can be taken to punish the malicious ZK node. A user deploying a ZK contract decides the amount of MPC tokens that must be locked as collateral. In the following, these tokens are called locked stakes.

In the ZK computation model, ZK nodes are either computation nodes or preprocessing nodes, such that a ZK contract is associated with both a number of computation nodes and a number of preprocessing nodes. In the current implementation the ZK computation nodes generate their own preprocessing material.

Currently,
1 MPC tokens = 40 USD cents
1000 gas = 1 USD cent
which means
1 MPC token = 40,000 gas

The source for the fees is the [Partisia Blockchain yellow paper](https://drive.google.com/file/d/1OX7ljrLY4IgEA1O3t3fKNH1qSO60_Qbw/view).


When fees are paid by a contract they are distributed among the contract’s associated ZK nodes.

## Fee overview

| **Name**                 | **Cost in gas**                   | **Paid by**                                    |
|--------------------------|-----------------------------------|------------------------------------------------|
| Network                  | 5,000 per kb sent                 | Calling user (Actions)                         |
| WASM execution           | 5,000 per 1000 instructions       | Calling user (Actions)<br>Contract (ZK events) |
| Staking                  | (LOCKED_STAKES / 100) * 40,000    | Calling user                                   |
| Secret Input             | 25,000                            | Calling user                                   |
| ZK Computation           | 50,000 +  5 * noOfMultiplications | Contract                                       |
| ZK Preprocessing         | 50,000 + 500,000 * noOfBatches    | Contract                                       |
| Opening secret variables | 25,000                            | Calling user                                   |
| Attestation              | 25,000                            | Contract                                       |

## Fee details

### Network fees

When sending transactions to a ZK contract, a network fee is paid by the calling user in the same way as for regular transactions in public contracts.

### WASM execution fees

For regular actions, gas is paid by the calling user, in the same way as for public contracts.

Special ZK specific actions which are called when ZK nodes complete some work are paid by the contract.

Staking fees

A ZK contract needs to pay 1% of the total locked stakes per month, see yellow paper p. 16.

Currently, a ZK contract lives for 28 days, so this amount is only paid once. The first (and at the moment only) of these payments is paid when the contract is deployed on the blockchain.

The staking fee depends on the locked stakes which are determined by the user deploying the contract. The locked stakes are a minimum of 2,000 MPC tokens. To convert to gas the staking fee is multiplied by 40,000.

STAKING_FEE = (LOCKED_STAKES / 100) * 40,000


### Secret Input fees

A ZK contract needs to pay for the transactions that ZK nodes must send when some variable is inputted.

The input fee is part of the basic fees detailed in the yellow paper p. 16 and is currently hardcoded to BASE_SERVICE_FEES (25,000 gas).
This covers the transaction fees of each node (currently hardcoded to 5,000 each) + 5,000 extra gas to spare.


### ZK Computation fees

A ZK contract needs to pay for the transactions that ZK nodes must send when a ZK computation is executed as well as for the multiplications in the computation.

During a computation a number of transactions are sent from each computation node. For an optimistic computation each node sends 1 transaction to the binder.
If the optimistic attempt fails, a pessimistic computation must be executed which entails each node sending 1 additional transaction to the binder. 

Besides this the multiplications done during the computation must also be paid for. According to the yellow paper the price for this is 5 USD cent per 1000 multiplications. Since this is multiplied by 1000 to convert to gas the price for multiplications is noOfMultiplications / 1000 * 5 * 1000 = noOfMultiplications * 5

### ZK Preprocessing fees

A ZK contract needs to pay for preprocessing triples which the preprocessing nodes generate at various points during ZK computation.

When requesting preprocessing material, each node sends two transactions to the preprocessing contract. This must be paid for by the ZK contract.

As per the yellow paper, the fee for preprocessing material is 5 USD cent per 1000 triples.

Preprocessing material is requested in batches of 100,000 triples. This means each batch costs 100,000 / 1,000 * 5 = 5,000 USD cents which is in gas is 5,000 * 1,000 = 500,000


### Opening secret variables fees

A ZK contract needs to pay for the transactions that ZK nodes must send when some secret variable is opened.

The open secret variables fee is part of the basic fees detailed in the yellow paper p. 16 and is currently hardcoded to BASE_SERVICE_FEES (25,000 gas).


### Attestation fees

A ZK contract needs to pay for the transactions that ZK nodes must send when some data needs to be attested.

The attestation fee is part of the basic fees detailed in the yellow paper p. 16. Currently, the actual fee is hardcoded to BASE_SERVICE_FEES which is 25,000 gas. 

