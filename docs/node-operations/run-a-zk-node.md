# Run a zk node

ZK nodes do zk computations in addition to their baker node work of signing and producing blocks.

!!! Warning " You must complete these requirements before you can continue"  
    - [Stake 100 K MPC tokens](https://browser.partisiablockchain.com/node-operation) including the 25 K for baker service    
    - [Run baker node](run-a-baker-node.md)
    - You have set up a reverse proxy and purchased a domain as described [here](https://drive.google.com/file/d/1WOzM63QsBntSVQMpWhG7oDuEWYJE2Ass/view?usp=sharing)
    - [Gas](../pbc-fundamentals/byoc/introduction-to-byoc.md) for the transaction

## Complete the following steps

1. [Associate](https://browser.partisiablockchain.com/contracts/01a2020bb33ef9e0323c7a3210d5cb7fd492aa0d65/associateTokens) 75 K MPC tokens to the ZK Node Registry contract
2. [Register](https://browser.partisiablockchain.com/contracts/01a2020bb33ef9e0323c7a3210d5cb7fd492aa0d65/registerAsZkNode) as a ZK node (You need to have your https rest endpoint ready)
3. Restart your node

If you have additional tokens you can read how to run a deposit or withdrawal oracle on the following page.