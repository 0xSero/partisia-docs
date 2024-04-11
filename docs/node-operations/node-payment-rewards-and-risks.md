# Node payment, rewards and risk

Here you can read about [paid services nodes can perform](start-running-a-node.md#which-node-should-you-run) as well as rewards, and risks of disputes.

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

In addition to the fees paid for service nodes receive rewards in the form of MPC tokens. Rewards are distributed according to node performance
measured by block production as well as tokens staked and their vesting
schedule. [See how rewards are calculated and distributed](https://gitlab.com/partisiablockchain/node-operators-rewards/-/tree/main/mainnet?ref_type=heads#computing-rewards)

### How are baker fees calculated

Fees for baker service are paid out by
the [Fee distribution contract](https://browser.partisiablockchain.com/contracts/04fe17d1009372c8ed3ac5b790b32e349359c2c7e9)
. In the state of the contract you can see a list from each node, showing how many signatures on blocks they have seen
from each of the other nodes. When every node has produced 100 blocks, the [epoch](../pbc-fundamentals/dictionary.md#epoch) is over and earned fees are distributed
equally among the nodes receiving a vote from 2/3s of the nodes. A peer node will count how often your node's signature
has appeared on a block it has seen. It creates a sorted list of the performers. It cast a vote for each node in the top
2/3s.   
Everyone that has received a vote from 2/3s of the committee gets paid an equal share of the fees of the epoch. So, if
there are 100 nodes in the current committee then your node needs a vote from 66 other nodes each epoch to get paid.

!!! Note "Note"
    Baker service fees depends on both the performance of the individual node and the level of activity on-chain, meaning the number and size of transactions committed in each epoch.        


### How staking of MPC tokens work

Staked [MPC tokens](../pbc-fundamentals/dictionary.md#mpc-token) are used as collateral for a
node [performing a paid service](start-running-a-node.md#which-node-should-you-run). Collateral is the stake of a
node, which will be used to pay compensation for misconduct committed with the node. For all services on PBC there is a basic
safety principle: $ValueOfStake \gt ValueOfService$. 
The safety principle can be showcased through the application of it in the oracle service and the ZK service, explained below:

Three [oracle nodes](../pbc-fundamentals/dictionary.md#oracle-node) performing oracle service together constitutes
one [small oracle](../pbc-fundamentals/byoc/bridging-byoc-by-sending-transactions.md#bridgeable-coins-on-mainnet). A
small oracle can transfer less value than the total stake on the service (750K MPC). The theoretical maximum value
of [BYOC](../pbc-fundamentals/dictionary.md#byoc) being bridged per [epoch](../pbc-fundamentals/dictionary.md#epoch) is
equivalent to the ETH value of the total stake (collateral) of the three oracle nodes. In current practice the value
that can be transferred is 50 ETH for withdrawal oracles and 25 ETH for deposit oracles.

Four [ZK nodes](../pbc-fundamentals/dictionary.md) performing ZK service together have an equal share in the total stake
on the service, just like oracle nodes. A ZK node stakes 1/4 of the amount defined in the ZK
contract to which they are allocated. The contract owner defines the total required stake to participate in the ZK job.

When tokens are allocated to a node service, the tokens are always locked to
the [system contract](../pbc-fundamentals/governance-system-smart-contracts-overview.md) administrating the service for
one [epoch](../pbc-fundamentals/dictionary.md#epoch). See how the length of an epoch is determined [here](../pbc-fundamentals/dictionary.md#epoch).

A node operator can resign from a service, and retrieve the tokens staked on the service. A delay of release ensures
sufficient time for the service to complete and for the possibility of dispute claims. For this reason there are pending times for MPC tokens to change state from
being [associated](../pbc-fundamentals/mpc-token-model-and-account-elements.md#allocatedtojobs)
, [locked](../pbc-fundamentals/mpc-token-model-and-account-elements.md#allocatedtojobs)
or [staked](../pbc-fundamentals/mpc-token-model-and-account-elements.md#staked). [Changing state](https://browser.partisiablockchain.com/node-operation) from _staked_ to _unstaked_ always takes 7 days plus
the [pending time for disassociation or unlocking](#how-long-does-it-take-to-retrieve-stakes-from-a-node-service)
.

#### How long does it take to retrieve stakes from a node service

MPC tokens need to be unstaked and free from vesting schedule to
be [transferable](../pbc-fundamentals/mpc-token-model-and-account-elements.md#transferable). You can always calculate
how many MPC tokens you can transfer with the formula: $MPC_{transferable} = MPC_{released} - MPC_{staked}$

When a node operator wants to retrieve his stake from a node service, he disassociates and unstakes the tokens currently associated to the contract administrating the node service.
The node operator should be aware of the total pending time for removing tokens from a node service. The total pending time is the sum of pending time of the two actions: _disassociate_ and _unstake_.
The table below explains the pending time for retrieving tokens from the contracts governing the different node services.

For in depth explanation of all states of MPC tokens in the accounts
see [MPC Token Model](../pbc-fundamentals/mpc-token-model-and-account-elements.md).

| **Token state**                                                                                                        | **Days in Pending** | **Explanation**                                                                                                                                                                                                                                         | **Required action**                                                                                                                                                                                                           |
|------------------------------------------------------------------------------------------------------------------------|---------------------|---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| [_stakedTokens_](../pbc-fundamentals/mpc-token-model-and-account-elements.md#staked)                                                                                                           | 7                   | MPC tokens in the stakedTokens means that your tokens are deposited on chain. Tokens in this state can be associated by a node operator to a contract administrating a specific node service. Staked tokens can also be delegated from a token holder to a node operator.                                                                                                                    | [Unstake](https://browser.partisiablockchain.com/node-operation) + [Check pending unstakes](https://browser.partisiablockchain.com/account)                                                                                                                                     |
| [_stakedToContract_](../pbc-fundamentals/mpc-token-model-and-account-elements.md#allocatedtojobs): <br /> [Large Oracle](https://browser.partisiablockchain.com/contracts/04f1ab744630e57fb9cfcd42e6ccbf386977680014)   | 14                  | The large oracle contract holds the stake and registration of [oracle nodes](../pbc-fundamentals/dictionary.md#oracle-node). Tokens allocated to a specific deposit or withdrawal oracle are in pending state from the end of the [epoch](../pbc-fundamentals/dictionary#epoch). <br><br> The epoch can be ended prematurely by invoking [Request a new oracle](run-a-deposit-or-withdrawal-oracle-node#request-new-oracle) if the oracle is 14 days old. When the epoch has ended you can unlock old pending tokens, and  disassociate the tokens from the large oracle contract afterwards. <br><br> If the node is not allocated to an active deposit or withdrawal oracle-contract you can disassociate immediately | [Unlock old Pending Tokens](https://browser.partisiablockchain.com/contracts/04f1ab744630e57fb9cfcd42e6ccbf386977680014/unlockOldPendingTokens) + [Disassociate](https://browser.partisiablockchain.com/contracts/04f1ab744630e57fb9cfcd42e6ccbf386977680014/disassociateTokensFromContract) |
| [_stakedToContract_](../pbc-fundamentals/mpc-token-model-and-account-elements.md#allocatedtojobs): <br /> [ZK Node Registry](https://browser.partisiablockchain.com/contracts/01a2020bb33ef9e0323c7a3210d5cb7fd492aa0d65) | 14                  | The ZK node registry contract holds the stake and registration of [ZK nodes](../smart-contracts/zk-smart-contracts/zk-smart-contracts.md#what-is-zero-knowledge-smart-contracts). The ZK registry in the [contract state](https://browser.partisiablockchain.com/contracts/01a2020bb33ef9e0323c7a3210d5cb7fd492aa0d65?tab=state) includes a map showing all nodes allocated to specific ZK contracts. <br><br> To check if your tokens are allocated to a [ZK calculation](../pbc-fundamentals/dictionary.md#mpc), you need to go to the state of [ZKNR](https://browser.partisiablockchain.com/contracts/01a2020bb33ef9e0323c7a3210d5cb7fd492aa0d65?tab=state), click `stakedTokens` map and find all current ZK contracts your node is engaged with. <br><br> In the state of the ZK contracts you can see the contract lifespan. From the moment the contract's lifespan or calculation is completed, the 14 day pending time starts for the allocated tokens.                                         | [Disassociate tokens](https://browser.partisiablockchain.com/contracts/01a2020bb33ef9e0323c7a3210d5cb7fd492aa0d65/disassociateTokens)                                                                                         |
| [_stakedToContract_](../pbc-fundamentals/mpc-token-model-and-account-elements.md#allocatedtojobs): <br /> Any price oracle, [find out which one your node serve](run-a-price-oracle-node.md#how-to-deregister-as-a-price-oracle)                                                                                    | 0-1                 | The price oracle contracts hold the stake and registration of [price oracle nodes](../pbc-fundamentals/dictionary.md#price-oracle). You have to deregister outside a challenge period (the time until a proposed price is finalized). If you do that, disassociation is immediate.                                                                                                                                                          | [Deregister](run-a-price-oracle-node.md#deregister-from-a-price-oracle)                                                                                                                                       |
| [_stakedToContract_](../pbc-fundamentals/mpc-token-model-and-account-elements.md#allocatedtojobs): <br /> [Block Producer Orchestration ](https://browser.partisiablockchain.com/contracts/04203b77743ad0ca831df9430a6be515195733ad91)  | 28                  | The block producer orchestration contract holds the stake and registration of [baker nodes](../pbc-fundamentals/dictionary.md#baker-node) By invoking [Remove bp](https://browser.partisiablockchain.com/contracts/04203b77743ad0ca831df9430a6be515195733ad91/removeBp), you both deregister and disassociate tokens from the contract. <br><br> If your node is in the committee when you invoke removal, the node will still serve in committee until rotation. You can manually trigger a committee rotation if the committee is at least 28 days old. <br><br> If your node is not in the current committee, the tokens will be disassociated from the contract immediately when invoking _Remove bp_.              | [Remove bp](https://browser.partisiablockchain.com/contracts/04203b77743ad0ca831df9430a6be515195733ad91/removeBp)                                                                                                            |

#### Retrieving stakes that are delegated

If a node is using delegated stakes, the delegator has to reach out to the node operator using the tokens to ask for release, if they wish
to retrieve them. Same locking mechanisms and pending times apply to tokens that come from delegated stakes. Delegated
MPC tokens that are not associated to a contract or locked to a service can be retrieved without any pending period.

Rules:

- If [delegated to an account](../pbc-fundamentals/mpc-token-model-and-account-elements.md#delegatedtoothers) of a node operator, but not [associated to a contract](../pbc-fundamentals/mpc-token-model-and-account-elements.md#allocatedtojobs), token owner can retrieve with no issues
- If [delegated to an account](../pbc-fundamentals/mpc-token-model-and-account-elements.md#delegatedtoothers) of a node operator, and [associated to a contract](../pbc-fundamentals/mpc-token-model-and-account-elements.md#allocatedtojobs) but not being used for a job, token owner cannot retrieve before the node operator has disassociated the token from the job
- If [delegated to the account](../pbc-fundamentals/mpc-token-model-and-account-elements.md#delegatedtoothers) of a node operator, [associated to a contract](../pbc-fundamentals/mpc-token-model-and-account-elements.md#allocatedtojobs) and being used for a job, token owner cannot retrieve until the job completes, pending period is over, and the node operator has disassociated the tokens from the job
- Tokens retrieved from delegation are not immediately [transferable](../pbc-fundamentals/mpc-token-model-and-account-elements.md#transferable). The token owner must [unstake](https://browser.partisiablockchain.com/node-operation) the tokens after retrieval. If the tokens have passed the [release date](../pbc-fundamentals/mpc-token-model-and-account-elements.md#unlocking-schedules) the tokens will become transferable, when the 7-day pending period is over and the owner invokes [Check pending unstakes](https://browser.partisiablockchain.com/account)
- Tokens must be retrieved to your account before you can [unstake](https://browser.partisiablockchain.com/node-operation). This means you change the state of the tokens back from staked to unstaked. Unstaking causes a 7-day pending state for the tokens. Afterwards you invoke [Check pending unstakes](https://browser.partisiablockchain.com/account). This operation returns the tokens to your balance


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
