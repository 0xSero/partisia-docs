# Storage gas price

<div class="dot-navigation" markdown>
   [](what-is-gas.md)
   [](transaction-gas-prices.md)
   [*.*](storage-gas-price.md)
   [](zk-computation-gas-fees.md)
   [](how-to-get-testnet-gas.md)
   [](efficient-gas-practices.md)
   [](contract-to-contract-gas-estimation.md)
</div>
!!! info inline end "Storage fee"
    
    1 USD cent/kb per year

When data is stored on a Partisia blockchain, it incurs a running gas cost. Storage gas is inherently not tied to any transaction. For contracts on the blockchain, each contract has an associated account balance. This balance is used to cover the storage gas fees.

### Negative contract gas balance

If a contract's gas balance becomes negative the contract is deleted.
This is done by one of two possible methods.

1. The account management plugin within the blockchain system will eventually delete the contract if its balance does not stay above a positive value.
2. When a new transaction is received by the contract, the blockchain checks if the gas balance is negative. If it is, the contract will be deleted before the transaction can be processed by the contract.
