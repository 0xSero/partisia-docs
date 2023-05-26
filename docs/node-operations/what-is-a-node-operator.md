# What is a node operator

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
- Baker Node 25,000 MPC Tokens.
- ZK Node 75,000 MPC Tokens.
- Oracle Node 250,000 MPC Tokens.

**The Machine**  
In addition to the stake you need a computer to run the node. Most node operators rent a server, but some keep the machine running the node in their own home. Machine Specs are in the [section](../node-operations/operator-1-specs.md) about running the node.

**The Keys**  
When a block of transactions is validated, the node signs off on it with a unique digital signature. The signature is created with the node owner's private key. The signature is verifiable from the public version of the signing key. The different keys play different roles. One keypair references your account with the stake, another refers to your identity on the network and in the PBC internal register. A full description of the keys you will need kan be found in this [section](../pbc-fundamentals/partisia-blockchain-dictionary.md#Public-key cryptography).

**The Skills**  
Setting up the node require some technical skills. You need to be able to configure and run your node, or alternatively pay someone you trust to help you with the setup and upkeep of the node.

The following sections take you through the signup process. If you do not yet have MPC tokens or an appropriate server for running a node you can still complete the firs part of the guide showing you how to run a reader node. A reader node is free. When you have completed the [introduction](../node-operations/what-is-a-node-operator.md), [first](../node-operations/operator-1-specs.md) and [second](../node-operations/operator-2-reader.md) step, then you should know if you have the skills required to run a node performing services on Partisia Blockchain. If you want to buy MPC Tokens, you can follow this [link](https://kyc.partisiablockchain.com/) for information about sale.

## Run a node on Partisia Blockchain

The following guide has 9 parts. If you do the steps of the guide in order, you should know how to set up your node correctly, before you commit your stake. In other words, you can find out if you have the skills and patience for running a block producing node, before you tie your stake to the performance of the node.

1. [Hardware and software for running the node](../node-operations/operator-1-specs.md)
2. [Run a reader node locally](../node-operations/operator-2-reader.md)
3. [Get a VPS](../node-operations/operator-3-vps.md)
4. [Secure your VPS](../node-operations/operator-4-security.md)
5. [Run a reader node on a VPS](../node-operations/operator-5-reader-vps.md)
6. [Create a PBC Account](../node-operations/operator-6-create-account.md)
7. [Get MPC tokens](../node-operations/operator-7-get-mpc-tokens.md)
8. [Complete the Synaps KYB](../node-operations/operator-8-synaps.md)
9. [Create keys for config and registration](../node-operations/operator-9-keys.md)
10. [Upgrade config to a block producing node on the VPS](../node-operations/operator-10-bp.md)
11. [Register your node](../node-operations/operator-11-registration.md)
12. [Node health and maintenance](../node-operations/operator-12-node-health.md)
