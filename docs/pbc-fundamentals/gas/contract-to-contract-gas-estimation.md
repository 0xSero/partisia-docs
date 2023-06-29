# Contract to contract gas estimation

<div class="dot-navigation">
    <a class="dot-navigation__item" href="gas-pricing.html"></a>
    <a class="dot-navigation__item" href="storage-gas-price.html"></a>
    <a class="dot-navigation__item" href="how-to-get-testnet-gas.html"></a>
    <a class="dot-navigation__item" href="efficient-gas-practices.html"></a>
    <a class="dot-navigation__item dot-navigation__item--active" href="contract-to-contract-gas-estimation.html"></a>
    <!-- Repeat above for more dots -->
</div>

When creating a contract that sends transactions to other contracts, it is crucial to understand the relationship and adequately account for the gas required for these transactions. There are two important factors to consider in this process: 1. How many transactions does my gas need to cover in total. 2. What is the exact gas price for each transaction. 

It is essential to ensure that the contract includes enough gas to cover the transactions sent to the other contract. This means factoring in the cumulative gas costs of both transactions during the design of the initial transaction. The total cost for the input would be the sum of the gas costs for both the transaction from the first contract to the second contract and from the second contract to the target contract, be it a response or a third objective.

### Examples

To illustrate, let's consider two contracts: Contract A and Contract B. Contract A needs to ensure that enough gas is sent to Contract B. In this case, the total gas cost for the input would be (Tx → Contract A) + (Tx → Contract B).

<img alt="Deposit" style="width: 80%;" src="TxContract-Contract-Gas.png"/>

Another addition to the above example is if contract A expects a response from contract B. Then the total price of the gas for any input becomes a total of three transactions: (tx &rarr; contract A) + (tx &rarr; contract B) + (tx &rarr; response from contract B to contract A).