# Storage gas price

<div class="dot-navigation">
    <a class="dot-navigation__item" href="what-is-gas.html"></a>
    <a class="dot-navigation__item" href="transaction-gas-prices.html"></a>
    <a class="dot-navigation__item dot-navigation__item--active" href="storage-gas-price.html"></a>
    <a class="dot-navigation__item" href="zk-computation-gas-fees.html"></a>
    <a class="dot-navigation__item" href="how-to-get-testnet-gas.html"></a>
    <a class="dot-navigation__item" href="efficient-gas-practices.html"></a>
    <a class="dot-navigation__item" href="contract-to-contract-gas-estimation.html"></a>
    <!-- Repeat above for more dots -->
</div>
!!! info inline end "Storage fee"
    1 USD cent/kb per year

When data is stored on a Partisia blockchain, it incurs a running gas cost. Storage gas is inherently not tied to any transaction. For contracts on the blockchain, each contract has an associated account balance. This balance is used to cover the storage gas fees.

### Negative contract gas balance
If a contract's gas balance becomes negative the contract gets deleted.
This is done by one of two possible methods. 

1. The account management plugin within the blockchain system will eventually delete the contract if its balance does not stay above a positive value. 
2. When a new transaction is received by the contract, the blockchain checks if the gas balance is negative. If it is, the contract will be deleted before the transaction can be processed by the contract. 
