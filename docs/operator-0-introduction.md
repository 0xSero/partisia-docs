## What is a Node
Nodes are the computers in the blockchain network. They perform services for the users of the blockchain, foremost they facilitate the transactions that happens on the blockchain. From the transaction costs paid by users, the node operator can make revenue.
PBC has four types of nodes:

- Reader node: A node that only reads the information on the chain and does not perform paid services.
- Baker Node: A node that produces and validates blocks. Revenue is generated from user payment on transactions in the blocks produced and validated by the node.
- ZK Node: A node that performs zero knowledge computations in addition to baker node services.
- Oracle Node: A node that performs oracle services in addition to ZK and baker services.

## Requirements of a Node Operator
**The Stake**  
If you want to be a node operator you are required to have a stake in the network. A stake is basically a deposit strengthening the security and user confidence of the network. The stake means that the node operator has something to lose, if they try to cheat or damage the network.
Staking means that the node operator buy the required stake of MPC Tokens. Services have a hierarchy of cost and security as well as payment. Therefore, higher paid services require a higher stake. To acquire MPC Tokens go through this [contact page](https://kyc.partisiablockchain.com/).

The current stakes are:

- Reader Node is free, since it does not perform paid services.
- Baker Node 10,000 $ in MPC Tokens.
- ZK Node 25,000 $ in MPC Tokens.
- Oracle Node 100,000 $ in MPC Tokens.

**The Machine**  
In addition to the stake you need a computer to run the node. Most node operators rent a server, but some keep the machine running the node in their own home. Machine Specs are in the [section](operator-1-specs.md) about running the node.

**The Keys**  
When a block of transactions is validated, the node signs off on it with a unique digital signature. The signature is created with the node owner's private key. The signature is verifiable from the public version of the signing key. The different keys play different roles. One keypair references your account with the stake, another refers to your identity on the network and in the PBC internal register. A full description of the keys you will need kan be found in this [section](keys.md).

**The Skills**  
Setting up the node require some technical skills. You need to be able to configure and run your node, or alternatively pay someone you trust to help you with the setup and upkeep of the node.

The following sections take you through the signup process. If you do not yet have MPC tokens or an appropriate server for running a node you can still complete the firs part of the guide showing you how to run a reader node. A reader node is free. When you have completed the [introduction](operator-0-introduction.md), [first](operator-1-specs.md) and [second](operator-2-reader.md) step, then you should know if you have the skills required to run a node performing services on Partisia Blockchain. If you want to buy MPC Tokens, you can follow this [link](https://kyc.partisiablockchain.com/) for information about sale.


## Run a node on Partisia Blockchain

The following guide has 9 parts. If you do the steps of the guide in order, you should know how to set up your node correctly, before you commit your stake. In other words, you can find out if you have the skills and patience for running a block producing node, before you tie your stake to the performance of the node.

1. [Hardware and software for running the node](operator-1-specs.md)   
2. [Run a reader node locally](operator-2-reader.md)   
3. [Get a VPS](operator-3-vps.md)   
4. [Secure your VPS](operator-4-security.md)   
5. [Run a reader node on a VPS](operator-5-reader-vps.md)   
6. [Create keys for config and registration](operator-6-keys.md)   
7. [Run a block producing node on the VPS](operator-7-bp.md)   
8. [Register your node](operator-8-registration.md)   
9. [Node health and maintenance](operator-9-node-health.md)   