# Start running a node

Nodes are the computers in the blockchain network. They perform services for the users of the blockchain, first and foremost they facilitate the transactions that happens on the blockchain. From the transaction costs paid by users, the node operator can make revenue.


## Onboarding

If you want to run a node, please join our community. We would like to offer you the best possible support and be able to notify you in case we or community members register a problem with your node. We also send you news of relevant updates for example when node operators can support deposit or withdrawal of a new coin on the chain ([oracle service](../pbc-fundamentals/dictionary.md#small-oracle)). Node operators will also be alerted to upcoming votes on vital updates.

1. Fill out the node operator onboarding [form](https://forms.monday.com/forms/8de1fb7d3099178333db642c4d1fe640?r=euc1) to sign yourself up as a node operator applicant
2. Join [discord](https://discord.com/invite/KYjucw3Sad) and submit a support ticket to get added as a node operator applicant. In the ticket, submit a screenshot of your wallet showing your account balance.

## Which node should you run?

Nodes performing paid services require a [stake](../pbc-fundamentals/dictionary.md#stakestaking) of MPC tokens. Higher stakes services earn higher revenue.
You must first set up and register as a baker node, before you can register your node for higher paying services.

| Your MPC token balance | Node service you can run     |
|------------------------|------------------------------|
| 0                      | [Reader node](../node-operations/run-a-reader-node.md)                  |
| 25 K                   | [Baker node](../node-operations/run-a-baker-node.md)                   |
| 30 K                   | [Price oracle node](../node-operations/run-a-price-oracle-node.md.md)                 |
| 100 K                  | [ZK node](../node-operations/run-a-zk-node.md)                      |
| 275 K                  | [Deposit or withdrawal oracle node](../node-operations/run-a-deposit-or-withdrawal-oracle-node.md) |


!!! note "NB. All nodes require a VPS with these specs or better"   
- 8 vCPU or 8 cores, 10 GB RAM (8 GB allocated JVM), 60 GB SSD, publicly accessible IPv4 with ports 9888-9897 open
- Recommended software: Docker, Docker Compose, Linux 20.04.3, nano 4.3 or other text editor
