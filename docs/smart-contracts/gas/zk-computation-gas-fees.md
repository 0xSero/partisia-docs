# ZK Computation Gas Fees

<div class="dot-navigation" markdown>
   [](what-is-gas.md)
   [](transaction-gas-prices.md)
   [](storage-gas-price.md)
   [*.*](zk-computation-gas-fees.md)
   [](how-to-get-testnet-gas.md)
   [](efficient-gas-practices.md)
   [](contract-to-contract-gas-estimation.md)
</div>

Zero-knowledge (ZK) computation involves a number of gas fees to ensure that a contract's associated ZK nodes have enough gas to execute the ZK actions. You can find the overview on [our gas price table here](gas-price-table-overview.md). In this article we will dive into the specifics of gas fees when doing ZK actions on Partisia Blockchain.

## ZK computation, MPC tokens and gas

A deployed ZK contract has a number of ZK computation nodes associated with it.

These nodes each lock an amount of their MPC tokens as collateral for the computation. If any malicious activity by a ZK node is detected the collateral can be taken to punish the malicious ZK node. A user deploying a ZK contract decides the amount of MPC tokens that must be locked as collateral. In the following, these tokens are called locked stakes.

The source for the fees is the [Partisia Blockchain yellow paper](https://drive.google.com/file/d/1OX7ljrLY4IgEA1O3t3fKNH1qSO60_Qbw/view).

### Network fees
!!! info "Network gas price"
    NETWORK_FEE = NETWORK_BYTES * 5,000 / 1,000

When sending transactions to a ZK contract, a network fee is paid by the calling user in the same way as for
regular transactions in public contracts.

### WASM execution fees
!!! info "WASM execution gas price"
    WASM_EXECUTION_FEE = NO_OF_INSTRUCTIONS * 5,000 / 1,000

For regular actions, gas is paid by the calling user, in the same way as for public contracts.

Special ZK specific actions which are called when ZK nodes complete some work are paid by the contract.

### Staking fees
!!! info "Staking gas price"
    STAKING_FEE = (LOCKED_STAKES(Minimum 2,000 MPC tokens) / 100) * 40,000

A ZK contract needs to pay 1% of the total locked stakes per month, see yellow paper p. 16.

Currently, the standard option for a ZK contract ensures that it is on the blockchain for 28 days, you can prolong this by up to half a year at a time after deploying the contract.

The staking fee depends on the locked stakes which are determined by the user deploying the contract. The locked stakes are a minimum of 2,000 MPC tokens. To convert to gas the staking fee is multiplied by 40,000.

### Secret input fees
!!! info "Secret input gas fees"
    SECRET_INPUT_FEE = 4 * (700 + 10 * (BIT_LENGTH_OF_INPUT + 5)) + 5000

A ZK contract needs to pay for the transactions that ZK nodes must send when some variable is inputted.

The input fee is calculated taking into account the size of the variable to input. The gas cost for a single node is calculated
by multiplying by 10 the length of the input plus 5, and then adding 700 to the result. Since the secret
must be inputted to four nodes, this value must be multiplied by 4 to cover all participating nodes. This covers
the gas costs incurred by the nodes by processing this transaction. In addition, 5,000 is added as payment to the nodes.

### ZK computation fees
!!! info "ZK computation gas fees"
    ZK_COMPUTATION_FEE = 2 * BASE_SERVICE_FEES + 5 * NO_OF_MULTIPLICATIONS

A ZK contract needs to pay for the transactions that ZK nodes must send when a ZK computation is executed as well as
for the multiplications in the computation.

During a computation transactions are sent from each computation node.
For an optimistic computation each node sends 1 transaction to the binder.
If the optimistic attempt fails, a pessimistic computation must be executed which
entails each node sending 1 additional transaction to the binder. The cost of each of these
transactions is covered using BASE_SERVICE_FEES, which is currently hardcoded to 25,000.

Besides this, the multiplications done during the computation must also be paid for.
According to the yellow paper the price for this is 5 USD cent per 1000 multiplications.
Since this is multiplied by 1000 to convert to gas, the price for the multiplications is:

NO_OF_MULTIPLICATIONS / 1000 * 5 * 1000 = NO_OF_MULTIPLICATIONS * 5

### ZK preprocessing fees
!!! info "ZK preprocessing gas fees"
    ZK_COMPUTATION_FEE = 2 * BASE_SERVICE_FEES + 5 * NO_OF_MULTIPLICATIONS

A ZK contract needs to pay for the preprocessing triples which the preprocessing nodes generate at various points during ZK computation.
Preprocessing material is either multiplication triples used during computation to execute multiplications or input masks used during the generation of secret input variables.

When requesting preprocessing material, each node sends two transactions to the preprocessing contract.
The cost of each of these transactions is covered using BASE_SERVICE_FEES.

As per the yellow paper, the fee for preprocessing material is 5 USD cent per 1000 preprocessing triples.

Preprocessing material is requested in batches of 100,000 triples for multiplication triples and batches of 1,000 triples for input masks.
This means the material for each batch of multiplication triples costs

100,000 / 1,000 * 5 = 5,000 USD cents

while the material for each input mask batch costs

1,000 / 1,000 * 5 = 5 USD cents

which is multiplied by 1,000 to get the price in gas.

### Opening secret variables fees
!!! info "Opening secret variables gas fees"
    OPEN_SECRET_VARIABLES_FEE = SECRET_INPUT_FEE

Fees need to be paid for transactions that ZK nodes must send when secret variables are opened.

The open secret variables fee is calculated taking into account the size of the variable to open. The fee calculation follows
the same rules than the [secret input fee](./zk-computation-gas-fees.md#secret-input-fees).

### Attestation fees
!!! info "Attesting data gas fees"
    ATTESTATION_FEE = BASE_SERVICE_FEES

A ZK contract needs to pay for the transactions that ZK nodes must send when some data needs to be attested.

The attestation fee is part of the basic fees detailed in the yellow paper p. 16 and is currently hardcoded to use BASE_SERVICE_FEES.

### EVM oracle fees
!!! info "Receiving events from external EVM chain"
    EVM_ORACLE_FEE = BASE_SERVICE_FEES

A ZK contract needs to pay for the transactions that the ZK nodes must send when an event from an external EVM contract is moved to the ZK contract.

The EVM oracle fee is part of the basic fees detailed in the yellow paper p. 16 and is currently hardcoded to use BASE_SERVICE_FEES.
