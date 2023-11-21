# Start running a node

This page gives you a brief introduction of what a node is, the importance of joining the node community if you want to run a node and an overview of what type of node you can run with the amount of MPC tokens you have available. 

## What is a node? 
Nodes are the computers in the blockchain network. They perform services for the users of the blockchain, first and foremost they facilitate the transactions that happens on the blockchain. From the transaction costs paid by users, the node operator can make revenue.

## Onboarding

To start your journey on becoming a node operator on the Partisia Blockchain you will need to do the following two steps to begin the onboarding proces:

1. Fill out the [node operator onboarding form](https://forms.monday.com/forms/8de1fb7d3099178333db642c4d1fe640?r=euc1).
2. [Join Discord](https://discord.com/invite/KYjucw3Sad) and submit a node operator support ticket. In the ticket, submit a screenshot of your wallet showing your MPC account balance.

We will offer support and notify you in case we or community members register a problem with your node. We also send you news of relevant updates for example when node operators can support deposit or withdrawal of a new coin on the chain ([oracle service](../pbc-fundamentals/dictionary.md#small-oracle)). Node operators will also be alerted to upcoming votes on vital updates.


## Which node should you run?

Nodes performing paid services require a [stake](../pbc-fundamentals/dictionary.md#stakestaking) of MPC tokens. Higher stake services earn higher revenue.    
Set-up of the different nodes overlap. All nodes have the set-up related to reader nodes in common. All staking nodes have the baker node set-up in common. Therefore, you must first set up and register as a baker node, before you can configure and register your node for higher paying services. 

If you have completed the reader and baker part of the guide you can (given sufficient tokens) any combination of the other services, including multiple oracles on the same node.   


| **Required MPC token balance** | **Node service you can run** | **Service consist of**                            |
|----------------------------|------------------------------|---------------------------------------------------|
| 0                          | [Reader node](run-a-reader-node.md)                  | Reading the blockchain state                      |
| 25 K                       | [Baker node](run-a-baker-node.md)                   | Reader node service<br />Signing and producing blocks                      |
| 30 K                       | [Price oracle](run-a-price-oracle-node.md)                 | Baker node service<br />Price monitoring             |
| 100 K                      | [ZK node](run-a-zk-node.md)                      | Baker node service<br />ZK computations              |
| 275 K                      | [Deposit or withdrawal oracle](run-a-deposit-or-withdrawal-oracle-node.md) | Baker node service<br />Moving BYOC on and off chain |

!!! note "All nodes require a [VPS](../pbc-fundamentals/dictionary.md#vps) with these specs or better"   
    - 8 vCPU or 8 cores, 10 GB RAM (8 GB allocated JVM), 60 GB SSD, publicly accessible IPv4 with ports 9888-9897 open
    - Recommended software: Docker, Docker Compose, Linux 20.04.3, nano 4.3 or other text editor
