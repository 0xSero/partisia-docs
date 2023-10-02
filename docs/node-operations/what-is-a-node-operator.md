# What is a node operator
<div class="dot-navigation" markdown>
   [*.*](what-is-a-node-operator.md)
   [](create-an-account-on-pbc.md)
   [](get-mpc-tokens.md)
   [](recommended-hardware-and-software.md)
   [](vps.md)
   [](secure-your-vps.md)
   [](reader-node-on-vps.md)
   [](complete-synaps-kyb.md)
   [](run-a-block-producing-node.md)
   [](register-your-node.md)
   [](node-health-and-maintenance.md)
</div>

Nodes are the computers in the blockchain network. They perform services for the users of the blockchain, first and foremost they facilitate the transactions that happens on the blockchain. From the transaction costs paid by users, the node operator can make revenue.
PBC has four types of nodes:

- Reader node: A node that only reads the information on the chain and does not perform paid services.
- Baker Node: A node that produces and validates blocks. Revenue is generated from user payment on transactions in the blocks produced and validated by the node.
- ZK Node: A node that performs zero knowledge computations in addition to baker node services.
- Oracle Node: A node that performs oracle services in addition to ZK and baker services.

## Requirements of a Node Operator

**The Stake**  
If you want to be a node operator you are required to have a stake in the network. A stake is basically a deposit strengthening the security and user confidence of the network. The stake means that the node operator has something to lose should they try to cheat or damage the network.
Staking requires that the node operator buys the required stake of MPC Tokens. Services have a hierarchy of cost and security as well as payment. Therefore, higher paid services require a higher stake. To acquire MPC Tokens go through this [contact page](https://kyc.partisiablockchain.com/).

The current stake requirements are:

- Reader Node is free, since it does not perform paid services
- Baker Node 25,000 MPC Tokens
- ZK Node 75,000 MPC Tokens
- Oracle Node 250,000 MPC Tokens
- Price Oracle Node 5,000 MPC Tokens

**The Machine**  
In addition to the stake you need a computer to run the node. Most node operators rent a server, but some keep the machine running the node in their own home. Machine requirements are detailed in the [Recommended hardware and software](recommended-hardware-and-software.md) section.

**The Keys**  
When a block of transactions is validated, the node signs off on it with a unique digital signature. The signature is created with the node owner's private key. The signature is verifiable from the public version of the signing key. The different keys play different roles. One keypair references your account with the stake, another refers to your identity on the network and in the PBC internal register. A full description of the keys you will need kan be found in this [section](../pbc-fundamentals/dictionary.md#public-key-cryptography).

**The Skills**  
Setting up the node requires some technical skills. You need to be able to configure and run your node, or alternatively pay someone you trust to help you with the setup and upkeep of the node.

The following sections take you through the signup process. If you do not yet have MPC tokens or an appropriate server for running a node you can still complete the firs part of the guide showing you how to run a reader node. A reader node is free. When you have completed the [introduction](what-is-a-node-operator.md), [first](recommended-hardware-and-software.md) and [second](reader-node-on-vps.md) step, then you should know if you have the skills required to run a node performing services on Partisia Blockchain. If you want to buy MPC Tokens, you can follow this [link](https://kyc.partisiablockchain.com/) for information about sale.
