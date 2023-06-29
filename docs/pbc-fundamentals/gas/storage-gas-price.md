# Storage gas price
Storage gas price is its own segment, since the logic behind the gas and verification of the gas price is inherently not tied to any transaction. When data is stored on a blockchain, it incurs a gas cost. This cost encompasses the gas required for writing the data to the blockchain's storage and ensuring its integrity over time.

For contracts on the blockchain, each contract has an associated account balance. It is essential for this balance to remain positive in order to prevent the contract from being deleted. This balance is used to cover the storage gas fees.


### Negative contract gas balance
If a contract's gas balance becomes negative, certain actions may occur. 1. The account management plugin within the blockchain system may eventually delete the contract if its balance does not stay above a positive value. 2. When a new transaction is received by the contract, the blockchain checks if the gas balance is negative. If it is, the contract will be deleted before the transaction can be processed by the contract. You can see the exact pricing [here](gas-pricing.md#the-cost-for-using-the-blockchain). 
