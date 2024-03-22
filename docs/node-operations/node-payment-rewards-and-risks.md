# Node payment, rewards and risk

Here you can read about paid services nodes can perform as well as rewards, and risks of disputes.

### How different node services earn fees and rewards

Node operators get paid for running 3 types of services:

- Baker services - signing and producing
  blocks (pays out fees for baker services depending on performance measured by peers)
- ZK services - preprocessing data, executing ZK
  computations ([See the fees paid for different ZK operations](https://partisiablockchain.gitlab.io/documentation/smart-contracts/gas/zk-computation-gas-fees.html))
- Oracle services - services related to BYOC, signing transfers and signing a reported price (deposit and withdrawal
  oracle nodes receive 0.1% of transferred value, price oracle nodes get a steady fee per signed price)

!!! note   
    ZK and oracle nodes are upgrades services. Higher paying services depend on first registering for baker services and
    then committing additional stake and registering for the new service.

When a user commits a transaction on the blockchain he pays a gas cost
in [BYOC](../pbc-fundamentals/byoc/introduction-to-byoc.md). That gas covers the fee for the service performed by the
nodes.

In addition to the fees paid for service nodes receive rewards in the form of MPC tokens. Rewards node performed
measured through block production as well as tokens staked and their vesting
schedule. [See how rewards are calculated and distributed](https://gitlab.com/partisiablockchain/node-operators-rewards/-/tree/main?ref_type=heads)

### How are baker fees calculated

Fees for baker service are paid out by the [Fee distribution contract](https://browser.partisiablockchain.com/contracts/04fe17d1009372c8ed3ac5b790b32e349359c2c7e9). In the state of the contract you can see a list from each node, showing how many signatures on blocks they have seen from each of the other nodes. When every node has produced 100 blocks, the epoch is over and earned fees are distributed equally among the nodes receiving a vote from 2/3s of the nodes.
A peer node will count how often your node's signature has appeared on a block it has seen. It creates a sorted list of the performers. It cast a vote for each node in the top 2/3s.   
Everyone that has received a vote from 2/3s of the committee gets paid an equal share of the fees of the epoch. So, if there are 100 nodes in the current committee then your node needs a vote from 66 other nodes each epoch to get paid.

!!! Note "Note"
    Baker service fees depends on both the performance of the individual node and the level of activity on-chain, meaning the number and size of transactions committed in each epoch.        


### How staking of MPC tokens work

Node services are handled by specific [system contracts](../pbc-fundamentals/governance-system-smart-contracts-overview.md). To sign up for
services a node operator associates a stake of token to the contract administrating the service
([see amount to stake for specific services](start-running-a-node.md)). Before you can associate the stake to a specific service, you need to change the state of your MPC tokens to [_staked_](https://browser.partisiablockchain.com/node-operation).

All nodes running a paid service must first register as [a baker node](run-a-baker-node.md)
. This makes the node eligible to perform baker services. While a service is being performed the tokens are locked to
the contract. A node operator can resign from a service, and release the tokens staked on the service. A delay of
release ensures sufficient time for making dispute claim. Upgraded services require stake of tokens in addition to what
is already staked on baker service, but they also have a bigger earning potential.

Staked [MPC tokens](../pbc-fundamentals/dictionary.md#mpc-token) are used as collateral for a node performing a paid
service. Collateral means the stake of a node can be used to
pay compensation for misconduct committed with the node.
For all services on PBC there is a basic safety principle: $ValueOfStake \gt ValueOfService$

As an example, the [small oracles](../pbc-fundamentals/byoc/bridging-byoc-by-sending-transactions.md#bridgeable-coins-on-mainnet) consisting of 3 nodes with a stake of 250K MPC can transfer less value than their total stake on the service. The
theoretical maximum value of BYOC being bridged per [epoch](../pbc-fundamentals/dictionary.md#epoch) is equivalent to the ETH value of stake (750K MPC). In current
practice the value that can be transferred is 50 ETH for withdrawal oracles and 25 ETH for deposit oracles.

Services have tasks that require a minimum of time. We call that time
an [epoch](../pbc-fundamentals/dictionary.md#epoch). Within the epoch the tokens are _locked_ to the service and cannot
be _disassociated_.

Different services have different criteria of
completion. [See criteria of task that determine the length of different epochs](../pbc-fundamentals/dictionary.md#epoch).

There are pending times for MPC tokens to change state from being [associated](../pbc-fundamentals/mpc-token-model-and-account-elements.md#allocatedtojobs), [locked](../pbc-fundamentals/mpc-token-model-and-account-elements.md#allocatedtojobs) or [staked](../pbc-fundamentals/mpc-token-model-and-account-elements.md#staked).

### How long does it take to retrieve stakes from a node service

MPC tokens need to be unstaked and free from vesting schedule to
be [transferable](../pbc-fundamentals/mpc-token-model-and-account-elements.md#transferable). You can always calculate
how many MPC tokens you can transfer with the formula: $MPC_{transferable} = MPC_{free} - MPC_{staked}$

When tokens are associated to a contract and you want to disassociate the tokens there is some pending time from both
dissassociation and unstaking. To understand the pending time you sum the two values: dissassociation and unstaking. The
below table can help you understand the pending time.

For in depth explanation of all states of MPC tokens in the accounts
see [MPC Token Model](../pbc-fundamentals/mpc-token-model-and-account-elements.md).

| **Token state**                                                                                                        | **Days in Pending** | **Explanation**                                                                                                                                                                                                                                         | **Required action**                                                                                                                                                                                                           |
|------------------------------------------------------------------------------------------------------------------------|---------------------|---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| stakedTokens                                                                                                           | 7                   | MPC tokens in the stakedTokens means that your tokens can be lent out and used for a node service. Tokens in this state are the ones you can associate to a contract administrating a specific node service                                                                                                                    | [Unstake + Check pending unstakes](https://browser.partisiablockchain.com/node-operation)                                                                                                                                     |
| stakedToContract ([Block Producer Orchestration ](https://browser.partisiablockchain.com/contracts/04203b77743ad0ca831df9430a6be515195733ad91))  | 28                  | If your node is not in current committee, you will get the tokens disassociated from the contract immediately when invoking _Remove bp_. If you are in the committee, you can choose to disassociate the tokens when the committee changes by itself, or you can manually trigger a committee change when the committee is atleast 28 days old             | [Remove bp](https://browser.partisiablockchain.com/contracts/04203b77743ad0ca831df9430a6be515195733ad91/removeBp)                                                                                                             |
| stakedToContract ([Large Oracle](https://browser.partisiablockchain.com/contracts/04f1ab744630e57fb9cfcd42e6ccbf386977680014))   | 28                  | Pending time starts from the end of an epoch or if a [Request of a new oracle](run-a-deposit-or-withdrawal-oracle-node#request-new-oracle) is successfully sent. When either action happends, you can unlock old pending tokens, and  disassociate the tokens from the large oracle contract afterwards. If node is not allocated to a deposit or withdrawal oracle you can disassociate immediately | [Unlock old Pending Tokens](https://browser.partisiablockchain.com/contracts/04f1ab744630e57fb9cfcd42e6ccbf386977680014/unlockOldPendingTokens) + [Disassociate](https://browser.partisiablockchain.com/contracts/04f1ab744630e57fb9cfcd42e6ccbf386977680014/disassociateTokensFromContract) |
| stakedToContract ([ZK Node Registry](https://browser.partisiablockchain.com/contracts/01a2020bb33ef9e0323c7a3210d5cb7fd492aa0d65)) | 14                  | If node is not allocated to a [ZK calculation](../pbc-fundamentals/dictionary.md#mpc) (see in state of [ZKNR](https://browser.partisiablockchain.com/contracts/01a2020bb33ef9e0323c7a3210d5cb7fd492aa0d65?tab=state)) or finished within last 14 days, then you can [disassociate from ZKNR](https://browser.partisiablockchain.com/contracts/01a2020bb33ef9e0323c7a3210d5cb7fd492aa0d65/disassociateTokens) immediately. Pending time is measured from the moment a specific [ZK calculation](../pbc-fundamentals/dictionary.md#mpc) is finished, after that you can disassociate the tokens from [ZK Node Registry contract](https://browser.partisiablockchain.com/contracts/01a2020bb33ef9e0323c7a3210d5cb7fd492aa0d65))                                          | [Disassociate tokens](https://browser.partisiablockchain.com/contracts/01a2020bb33ef9e0323c7a3210d5cb7fd492aa0d65/disassociateTokens)                                                                                         |
| stakedToContract (Any price oracle)                                                                                    | 0-1                 | You have to deregister outside a challenge period. If you do that disassociation is immediate.                                                                                                                                                          | [Step by step to Deregister](run-a-price-oracle-node.md#how-to-deregister-as-a-price-oracle)                                                                                                                                       |

### Retrieving stakes that are delegated

If a node is using delegated stakes, the delegator has to reach out to the node operator using the tokens to ask for release, if they wish
to retrieve them. Same locking mechanisms and pending times apply to tokens that come from delegated stakes. Delegated
MPC tokens that are not associated to a contract or locked to a service can be retrieved without any pending period.

### Dispute claims and malicious behaviour

Malicious node behaviour can result in slashing of staked tokens (slashed tokens get burned). The purpose of slashing is to prevent malicious activity.

!!! example "Examples of malicious activity"
    - A withdrawal oracle node signing a BYOC withdrawal that wasn't initiated on PBC   
    - A deposit oracle node signing a BYOC deposit that wasn't initiated on the external chain   
    - A price oracle node signing a wrong price   
    - An account starting an incorrect dispute   

It is possible to start a dispute against a node operator that has done a service for you. Dispute claims are
audited by the [large oracle](../pbc-fundamentals/dictionary.md#large-oracle). If the node operator is found responsible
for the node's alleged malicious behaviour tokens staked on the service may be slashed. Filing an illegitimate dispute claim against another node can also be
considered malicious behaviour and result in slashing.


