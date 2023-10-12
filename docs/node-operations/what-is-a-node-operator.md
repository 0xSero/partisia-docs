# What is a node operator?

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

## Onboarding    

If you want to run a node, please join our community. We would like to offer you the best possible support and be able to notify you in case we or community members register a problem with your node.    

1. Fill out the node operator onboarding [form](https://forms.monday.com/forms/8de1fb7d3099178333db642c4d1fe640?r=euc1) to sign yourself up as a node operator applicant
2. Join [discord](https://discord.com/invite/KYjucw3Sad) and submit a support ticket to get added as a node operator applicant. In the ticket, submit a screenshot of your wallet showing your account balance.    

## How to run a block producing node on Partisia Blockchain

The following guide has 10 parts. If you do the steps of the guide in order, you should know how to set up your node correctly, before you commit your stake. In other words, you can find out if you have the skills and patience for running a block producing node, before you tie your stake to the performance of the node.

1. [Create a PBC Account](create-an-account-on-pbc.md)
1. [Get MPC tokens](get-mpc-tokens.md)
1. [Recommended hardware and software](recommended-hardware-and-software.md)
1. [Get a VPS](vps.md)
1. [Secure your VPS](secure-your-vps.md)
1. [Run a reader node on a VPS](reader-node-on-vps.md)
1. [Complete the Synaps KYB](complete-synaps-kyb.md)
1. [Run a block producing node](run-a-block-producing-node.md)
1. [Register your node](register-your-node.md)
1. [Node health and maintenance](node-health-and-maintenance.md)
