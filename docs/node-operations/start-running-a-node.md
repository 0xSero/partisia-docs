# Start running a node

This page explains what a node is, how to join the node operator community and an
overview of what type of node you can run with the amount of MPC tokens you have.

## What is a node?

Nodes are the computers on the blockchain network. They perform services for the users by facilitating the transactions on the blockchain. The node operator
can make revenue from the transaction costs.

## Onboarding

To start your journey becoming a node operator on the Partisia Blockchain complete the two onboarding steps:

1. Fill out the [node operator onboarding form](https://forms.monday.com/forms/8de1fb7d3099178333db642c4d1fe640?r=euc1).
2. [Join Discord](https://discord.com/invite/KYjucw3Sad) and submit a node operator support ticket. In the ticket,
   submit a screenshot of your wallet showing your MPC account balance.    

Joining the Discord server and completing the survey gives you the following benefits:

- Support and notification in case we or community members register a problem with your node
- News of updates subject to node operator votes, for example when node operators can support a new coin on the
  chain ([oracle service](../pbc-fundamentals/dictionary.md#small-oracle))    

## Which node should you run?

Nodes performing paid services require a [stake](../pbc-fundamentals/dictionary.md#stakestaking) of MPC tokens. Higher
stake services earn higher revenue. For paid services it is required that the node's owner completes [Synaps KYC/KYB](complete-synaps-kyb.md).    

Set-up of the different nodes overlap. All nodes have the set-up related to reader nodes in common. All staking nodes
have the baker node set-up in common. Therefore, you must first set up and register as a baker node, before you can
configure and register your node for higher paying services.

If you have completed the reader and baker part of the guide you can do (given sufficient tokens) any combination of the
other services, including multiple oracles on the same node.   

| **Required total MPC token balance** | **Available Node service** | **Service consist of**                                                      |
|--------------------------------------|------------------------------|-----------------------------------------------------------------------------|
| 0                                    | [Reader node](run-a-reader-node.md)                  | Free: Reading the blockchain state                                          |
| 25K                                  | [Baker node](run-a-baker-node.md)                   | Free: Reader node service<br />25K stake: Signing and producing blocks      |
| 30K                                  | [Price oracle](run-a-price-oracle-node.md)                 | 25K stake: Baker node service<br />5K stake: Price monitoring               |
| 100K                                 | [ZK node](run-a-zk-node.md)                      | 25K stake: Baker node service<br />75K stake: ZK computations               |
| 275K                                 | [Deposit or withdrawal oracle](run-a-deposit-or-withdrawal-oracle-node.md) | 25K stake: Baker node service<br />250K stake: Moving BYOC on and off chain |

!!! note "All nodes require a [VPS](../pbc-fundamentals/dictionary.md#vps) with these specs or better"   
    - 8 vCPU or 8 cores, 10 GB RAM (8 GB allocated JVM), 128 GB SSD, publicly accessible IPv4 with ports 9888-9897 open 
    - Recommended software: Docker, Docker Compose V2, Ubuntu 20.04, nano or other text editors
