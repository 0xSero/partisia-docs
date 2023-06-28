# Price oracle

The price oracles on PBC help to keep the BYOC price up to date by using data from nodes on Chainlink. This means that the price you get when bridging ETH or other BYOC to and from PBC has been checked for accuracy within the last hour.

## Price oracle nodes

Each price oracle consist of at least three nodes. Every hour each node in the price oracle performs a price check. The node operator is paid a reward for performing this service. If three nodes in the price oracle agree on the price they report the price. In addition to checking and reporting prices a price oracle node also compares its own checks with the reports of the other price oracles. If it sees a discrepancy in price the price oracle node starts a dispute. The party found to be responsible in a price oracle dispute will have their 5000 MPC slashed. Types of malicious behavior can include reporting incorrect prices or incorrect dispute claims against other oracle nodes. 

## How to run a price oracle node 

### Prerequisites   

- You must be a [registered block producer](https://partisiablockchain.gitlab.io/documentation/node-operations/what-is-a-node-operator.html)
- You must be in the current committee
- 5000 MPC tokens associated to the [Large Oracle Contract](https://dashboard.partisiablockchain.com/info/contract/04f1ab744630e57fb9cfcd42e6ccbf386977680014) (tokens that are not currently locked to another specific oracle)

### Register as a price oracle node   

1. Go to the [Dashboard](https://dashboard.partisiablockchain.com/) and log in
2. Associate 5000 MPC tokens to the [Large Oracle Contract](https://dashboard.partisiablockchain.com/info/contract/04f1ab744630e57fb9cfcd42e6ccbf386977680014) by clicking the contract interaction button named "ASSOCIATETOKENSTOCONTRACT" (Skip this step if you have 5000 or more unused tokens already asociated with this contract)
3. Go to the [ETH Price Oracle Contract](https://dashboard.partisiablockchain.com/info/contract/0485010babcdb7aa56a0da57a840d81e2ea5f5705d) or [BNB Price Oracle Contract](https://dashboard.partisiablockchain.com/info/contract/049abfc6e763e8115e886fd1f7811944f43b533c39) and register by clicking the contract interaction button named "REGISTER"

Your node will be assigned to a specific price oracle when the number of nodes registered at the contract is divisible by 3, since there are 3 nodes in each price oracle.

