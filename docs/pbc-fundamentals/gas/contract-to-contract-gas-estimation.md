# Contract to contract gas estimation

When creating a contract that sends transactions to other contracts its important to understand the relationship behind sending enough gas for all transactions. There are two important factors. First is to make sure the contract will send enough gas with the transaction to the other contract. Then factoring in the added gas cost to the deployment of that contract itself.

If we for example have two contracts, contract a and contract b. Contract a would need to ensure enough gas is sent to contract b. This means that the cummulative costs of gas of both transactions needs to be factored into the design of the first transaction. The total cost for the input would be in this case (tx &rarr; contract a) + (tx &rarr; contract b).

<img alt="Deposit" src="TxContract-Contract-Gas.drawio.png"/>

Another addition to the above example is if contract a expects a response from contract b. Then the total price of the gas for any input becomes a total of three transactions: (tx &rarr; contract a) + (tx &rarr; contract b) + (tx &rarr; response from contract b to a). 


