# The Node Operator

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
Staking means that the node operator buy the required stake of MPC Tokens. Services have a hierarchy of cost and security ass well as payment. Therefore, higher paid services require a higher stake. To acquire MPC Tokens go through this [contact page](https://kyc.partisiablockchain.com/).  
The current stakes are:

- Reader Node is free, since it does not perform paid services.
- Baker Node 10,000 $ in MPC Tokens.
- ZK Node 25,000 $ in MPC Tokens.
- Oracle Node 100,000 $ in MPC Tokens.

**The Machine**  
In addition to the stake you need a computer to run the node. Most node operators rent a server, but some keep the machine running the node in their own home. Machine Specs are in the [section](operator.md) about running the node.

**The Keys**  
When a block of transactions is validated, the node signs off on it with a unique digital signature. The signature has a public and private version, the node signs with a private version and the public version of the signature is visible to the network in general. A node operator needs several of these signatures called keys. They come in pairs with a private key and a public key resulting from the private. The different keys play different roles. One keypair references your account with the stake, another refers to your identity on the network and in the PBC internal register. A full description of the keys you will need kan be found in this [section](keys.md).

**The Skills**  
Setting up the node require some technical skills. You need to be able to configure and run your node, or alternatively pay someone you trust to help you with the setup and upkeep of the node.

The following sections take you through the signup process.