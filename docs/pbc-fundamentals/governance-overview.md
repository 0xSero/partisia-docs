# Governance system smart contracts overview

This article helps you find the contract you need to interact with, depending on what properties of the blockchain you
want to utilize.

Partisia Blockchain is governed by a group of system smart contracts. The system
contracts solve different types of tasks. Below the contracts and plugins are listed under a category and description of
their overall responsibilities. Each contract has a link for to the contract through
the [Partisia Blockchain Browser](https://browser.partisiablockchain.com/). In the browser you can see the contract state and
invoke the actions of the contract with your [wallet](https://snaps.metamask.io/snap/npm/partisiablockchain/snap/).


## Node operation

[Node operators](../node-operations/what-is-a-node-operator.md) (also referred to as block producers) own and operate
the nodes (servers) where the blockchain software runs. The system contracts are needed for listing and staking of 
confirmed node operators, payment for services, votes on software updates and registration of new node operators.

??? info "[Block producer orchestration contract](https://browser.partisiablockchain.com/contracts/04203b77743ad0ca831df9430a6be515195733ad91)"
    The Block producer orchestration (BPO) contract holds the information about block producers. In the state you can see
    the current and previous committees. You can see the timestamp showing the last committee change. Invoking the
    contract will change the committee if the current committee is more than a month old. [See contract in browser](https://browser.partisiablockchain.com/contracts/04203b77743ad0ca831df9430a6be515195733ad91)

??? info "[Fee distribution](https://browser.partisiablockchain.com/contracts/04fe17d1009372c8ed3ac5b790b32e349359c2c7e9)"
    The Fee distribution contract takes care of the payment for baker node services. Every node makes a list of how many
    signatures they have received from every other node. Roughly, the top ⅔ best performers in each list get a vote. If more
    than ⅓ producers vote for your node, then it will be paid in that [epoch](dictionary.md#epoch). [See contract in browser](https://browser.partisiablockchain.com/contracts/04fe17d1009372c8ed3ac5b790b32e349359c2c7e9)

??? info "[System update](https://browser.partisiablockchain.com/contracts/04c5f00d7c6d70c3d0919fd7f81c7b9bfe16063620)"
    The system update contract facilitates votes from committee members (confirmed and active block producers) on updates of
    on chain information, such as updates to governance contracts. There are manual and automated votes. Automated votes are
    yes votes by default unless actively changed by the individual node operator. [See contract in browser](https://browser.partisiablockchain.com/contracts/04c5f00d7c6d70c3d0919fd7f81c7b9bfe16063620)

??? info "[Synaps KYC / KYB contract](https://browser.partisiablockchain.com/contracts/014aeb24bb43eb1d62c0cebf2a1318e63e35e53f96)"
    The KYC contract validates block producer's personal information coming from the KYC provider before they can be
    confirmed as block producers and listed in the BPO contract. [See contract in browser](https://browser.partisiablockchain.com/contracts/014aeb24bb43eb1d62c0cebf2a1318e63e35e53f96)

## Transfer of cryptocurrencies across chains ([BYOC](byoc.md))

On Partisia Blockchain you use coins from other chains (BYOC) as payment for transactions. PBC also allows users
transfer BYOC between [accounts](create-an-account.md) and contracts. BYOC system contracts controls allocations of nodes handling the
transfers, withdrawals, deposits, staking of nodes and the audit of transfers done in each epoch.

??? info "[Large oracle contract](https://browser.partisiablockchain.com/contracts/04f1ab744630e57fb9cfcd42e6ccbf386977680014)"
    The Large oracle (LO) contract handles a special function of the committee when voting on important issues such as
    membership of the committee and approval of all BYOC movements in each epoch when the nodes perform these special duties
    they are referred to as the large oracle. LO contract allocates eligible nodes to the small oracles handling movement of
    on- and off-chain of BYOC and price oracles. [See contract in browser](https://browser.partisiablockchain.com/contracts/04f1ab744630e57fb9cfcd42e6ccbf386977680014)


??? info "[BYOC orchestration](https://browser.partisiablockchain.com/contracts/0458ff0a290e2fe847b23a364925799d1c53c8b36b)"
    Facilitates the deployment of new deposit and withdrawal [oracles](../node-operations/oracles-on-partisia-blockchain.md). [See contract in browser](https://browser.partisiablockchain.com/contracts/0458ff0a290e2fe847b23a364925799d1c53c8b36b


??? info "[Small oracles](https://partisiablockchain.gitlab.io/documentation/node-operations/oracles-on-partisia-blockchain.html#what-is-a-small-oracle)"
    Below you see the oracle contracts handling deposits and withdrawals for BYOCs. These contracts have a transfer limit controlling when the nodes providing the service will be rotated. The
    contract state shows which nodes serve the oracle and a list of the deposits or withdrawals they have completed. [Read more about oracles](https://partisiablockchain.gitlab.io/documentation/node-operations/oracles-on-partisia-blockchain.html#what-is-a-small-oracle)   
    [ETH Deposit](https://browser.partisiablockchain.com/contracts/045dbd4c13df987d7fb4450e54bcd94b34a80f2351)    
    [ETH Withdrawal](https://browser.partisiablockchain.com/contracts/043b1822925da011657f9ab3d6ff02cf1e0bfe0146)    
    [POLYGON_USDC](https://browser.partisiablockchain.com/contracts/042f2f190765e27f175424783a1a272e2a983ef372)   
    [POLYGON_USDC](https://browser.partisiablockchain.com/contracts/04adfe4aaacc824657e49a59bdc8f14df87aa8531a)    
    [BNB Deposit](https://browser.partisiablockchain.com/contracts/047e1c96cd53943d1e0712c48d022fb461140e6b9f)    
    [BNB Withdrawal](https://browser.partisiablockchain.com/contracts/044bd689e5fe2995d679e946a2046f69f022be7c10)    

## Foundation

[Partisia Blockchain foundation](https://partisiablockchain.com/foundation) can choose to provide incentives for node
operators in form of tokens and raise funds for providing infrastructure through the sale of tokens, this is done by the
following system contracts. [Read more about PBC foundation](https://partisiablockchain.com/foundation)

??? info "[Foundation Eco-System](https://browser.partisiablockchain.com/contracts/01ad44bb0277a8df16408006c375a6fa015bb22c97)"
    Allows foundation members to release remaining tokens from the eco-system pool to incentivise further growth of the
    infrastructure and expansion of services. [See contract in browser](https://browser.partisiablockchain.com/contracts/01ad44bb0277a8df16408006c375a6fa015bb22c97)

??? info "[Foundation Sale](https://browser.partisiablockchain.com/contracts/012635f1c0a9bffd59853c6496e1c26ebda0e2b4da)"
    Facilitates the sale of MPC tokens. [See contract in browser](https://browser.partisiablockchain.com/contracts/012635f1c0a9bffd59853c6496e1c26ebda0e2b4da)

## MPC tokens

[MPC tokens](dictionary.md#mpc-token) are used by node operators and other token holders for staking on a service
provided by a node. Tokens can be confiscated in case of malicious behaviour and be used for dispute settlement. Staked
tokens incentives honest and reliable node services. [Read more about MPC tokens](dictionary.md#mpc-token)

??? info "[MPC token contract](https://browser.partisiablockchain.com/contracts/01a4082d9d560749ecd0ffa1dcaaaee2c2cb25d881)"
    Facilitates the change of state (location, association, staking, vesting) of MPC tokens as well as transfer of MPC
    tokens between accounts. MPC tokens are always associated with the MPC token balance of a specific account. You can
    learn more about MPC tokens and their properties in the [MPC token model](mpc-token-model-and-account-elements.md)

## Public smart contracts and Zero Knowledge smart contract

Users can deploy two types of smart contracts, public and zero knowledge. Public SC has a public state so anyone can see what the contract is doing. ZKSCs additionally have a secret state, meaning the contracts can keep data used in calculations private. This is one of the most important features of PBC, the ability to
do [zero knowledge computations](../smart-contracts/zk-smart-contracts/zk-smart-contracts.md) most notably secure
multiparty computations. For this you need to be able to register, and allocate a select group of nodes to handles the
secret calculation you want to do. The nodes involved in MPC have to fulfill requirements: higher stake and encrypting
the traffic communication with the other nodes involved in the secret calculation.    
You have the ability to deploy your own ZK smart contracts with the ZK Deploy contract, so you can allocate nodes to a
problem you define. The calculations are done on secret shared data and preprocessed to ensure that individual secret
inputs cannot be recreated from the variables in the calculation.

??? info "[ZK Deploy](https://browser.partisiablockchain.com/contracts/018bc1ccbb672b87710327713c97d43204905082cb)"
    Responsible for the deployment of new ZK smart contracts. [See contract in browser](https://browser.partisiablockchain.com/contracts/018bc1ccbb672b87710327713c97d43204905082cb)

??? info "[ZK Node Registry](https://browser.partisiablockchain.com/contracts/01a2020bb33ef9e0323c7a3210d5cb7fd492aa0d65)"
    Handles registration of new ZK nodes, as well as disputes and allocation to specific ZK jobs. [See contract in browser](https://browser.partisiablockchain.com/contracts/01a2020bb33ef9e0323c7a3210d5cb7fd492aa0d65)

??? info "[ZK Preprocess](https://browser.partisiablockchain.com/contracts/01385fedf807390c3dedf42ba51208bc51292e2657)"
    Preprocesses data prior to use for secure multiparty computation by currently allocated ZK nodes. [See contract in browser](https://browser.partisiablockchain.com/contracts/01385fedf807390c3dedf42ba51208bc51292e2657)

??? info "[WASM Deploy](https://browser.partisiablockchain.com/contracts/0197a0e238e924025bad144aa0c4913e46308f9a4d)"
    Facilitates deployment of public smart contracts. [See contract in browser](https://browser.partisiablockchain.com/contracts/0197a0e238e924025bad144aa0c4913e46308f9a4d)
