# Run a ZK node

This page explains how to change the configuration of your baker node to ZK node's and how to register your node for the
service. ZK nodes do [ZK computations](../pbc-fundamentals/dictionary.md#mpc) in addition to their baker node work of
signing and producing blocks. By completing the steps below your node will be eligible to be allocated for specific
computations by [ZK smart contracts](../smart-contracts/zk-smart-contracts/zk-smart-contracts.md) and earning revenue
for the zero knowledge computations performed.


!!! Warning " You must complete these requirements before you can continue"   
    For a reader node only set up reverse proxy - step 3

    1. [Stake 100 K MPC tokens](https://browser.partisiablockchain.com/node-operation) including the 25 K for baker service    
    2. [Run baker node](run-a-baker-node.md)
    3. You have set up a reverse proxy and purchased a domain as described [here](https://drive.google.com/file/d/1WOzM63QsBntSVQMpWhG7oDuEWYJE2Ass/view?usp=sharing)
    4. Verify that your ZK node domain maps to the ipv4 address of your host VPS, use <https://www.nslookup.io/> or similar

## Complete the following steps

1. [Associate](https://browser.partisiablockchain.com/contracts/01a2020bb33ef9e0323c7a3210d5cb7fd492aa0d65/associateTokens) 75 K MPC tokens to the ZK Node Registry contract
2. [Register](https://browser.partisiablockchain.com/contracts/01a2020bb33ef9e0323c7a3210d5cb7fd492aa0d65/registerAsZkNode) as a ZK node (You need to have your https rest endpoint ready)
3. Restart your node

If you have additional tokens you can read how to run a deposit or withdrawal oracle on the following page.    
