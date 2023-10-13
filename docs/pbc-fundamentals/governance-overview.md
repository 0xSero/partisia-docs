# Governance Overview

This article helps you find the contract you need to interact with, depending on what properties of the blockchain you want to utilize.

Partisia Blockchain is governed by a group of system smart contracts called governance contracts. They solve different types of tasks. Below the contracts indexed according to the tasks they ahndle.


## Accounts

On PBC addresses can refer either to a contract or an account. Accounts hold vital user information such as your balance of MPC tokens and BYOC. You can read more [here](create-an-account.md)

## Block Producers


#### [Block producer orchestration contract](https://browser.partisiablockchain.com/contracts/04203b77743ad0ca831df9430a6be515195733ad91)

The BPO contract holds the information about block producers. In the state you can see the current and previous committees. You can see the timestamp showing the last committee change. You can invoke the contract to change committee if the current committee is more than a month old.


#### [Fee distribution](https://browser.partisiablockchain.com/contracts/04fe17d1009372c8ed3ac5b790b32e349359c2c7e9)

Fee distribution contract takes care of the payment for baker node services. Every node makes a list of how many signatures they have received from every other node. Roughly, the top ⅔ best performers in each list get a vote. If more than ⅓ producers vote for your node, then it will be paid in that epoch.


#### [System update](https://browser.partisiablockchain.com/contracts/04c5f00d7c6d70c3d0919fd7f81c7b9bfe16063620)

The system update contract facilitates votes from committee members (confirmed and active block producers) on updates of on chain information. There are manual and automated votes. Automated votes are yes votes by default unless actively changed by the individual node operator. 

#### [Synaps KYC / KYB contract](https://browser.partisiablockchain.com/contracts/014aeb24bb43eb1d62c0cebf2a1318e63e35e53f96)

The KYC contract validates block producer's personal information coming from the KYC provider before they can be confirmed as block producers and listed in the BPO contract. 


## BYOC

#### [Large oracle contract](https://browser.partisiablockchain.com/contracts/04f1ab744630e57fb9cfcd42e6ccbf386977680014)

The LO contract handles a special function of the committee when voting on important issues such as membership of the committee and approval of all BYOC movements in each epoch when the nodes perform these special duties they are referred to as the large oracle. LO contract allocates eligible nodes to the small oracles handling movement of on- and off-chain of BYOC and price oracles.

#### [BYOC orchestration contract](https://browser.partisiablockchain.com/contracts/0458ff0a290e2fe847b23a364925799d1c53c8b36b)

Facilitates the deployment of new deposit and withdrawal [oracles](../node-operations/oracles-on-partisia-blockchain.md).

### [Small oracles](https://partisiablockchain.gitlab.io/documentation/node-operations/oracles-on-partisia-blockchain.html#what-is-a-small-oracle)

Below you see the oracle contracts handling deposits and withdrawals for the currently accepted BYOCs: ETH, BNB and USDC. These contracs have a transfer limit


#### [ETH Deposit on PBC](https://browser.partisiablockchain.com/contracts/045dbd4c13df987d7fb4450e54bcd94b34a80f2351)  

#### [ETH Withdrawal on PBC](https://browser.partisiablockchain.com/contracts/043b1822925da011657f9ab3d6ff02cf1e0bfe0146)

#### [POLYGON_USDC Deposit on PBC](https://browser.partisiablockchain.com/contracts/042f2f190765e27f175424783a1a272e2a983ef372)   

#### [POLYGON_USDC Withdrawal on PBC](https://browser.partisiablockchain.com/contracts/04adfe4aaacc824657e49a59bdc8f14df87aa8531a)

#### [BNB Deposit on PBC](https://browser.partisiablockchain.com/contracts/047e1c96cd53943d1e0712c48d022fb461140e6b9f)   

#### [BNB Withdrawal on PBC](https://browser.partisiablockchain.com/contracts/044bd689e5fe2995d679e946a2046f69f022be7c10)



## Foundation

#### [Foundation Eco-System](https://browser.partisiablockchain.com/contracts/01ad44bb0277a8df16408006c375a6fa015bb22c97)

#### [Foundation Sale](https://browser.partisiablockchain.com/contracts/012635f1c0a9bffd59853c6496e1c26ebda0e2b4da)



## MPC Tokens

#### [MPC token contract](https://browser.partisiablockchain.com/contracts/01a4082d9d560749ecd0ffa1dcaaaee2c2cb25d881)

Facilitates the change of state of MPC tokens as well as transfer of MPC tokens between accounts.


## Zero Knowledge and MPC

#### [ZK Deploy](https://browser.partisiablockchain.com/contracts/018bc1ccbb672b87710327713c97d43204905082cb)
Responsible for the deployment of new ZK contracts

#### [ZK Node Registry](https://browser.partisiablockchain.com/contracts/01a2020bb33ef9e0323c7a3210d5cb7fd492aa0d65)
Handles registration of new ZK nodes, as well as disputes and allocation to specific ZK jobs.

#### [ZK Preprocess](https://browser.partisiablockchain.com/contracts/01385fedf807390c3dedf42ba51208bc51292e2657)



