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


### Conditions for running a service

Node services are handled by specific [system contracts](insert link for governace overview when merged). To sign up for
services a node operator associates a stake of token to the contract administrating the service
([see amount to stake for specific services](start-running-a-node.md)). Stakes work as an incentive against malicious
behaviour.

All nodes running a paid service must first register as block producers in
the [block producer orchestration contract](https://browser.partisiablockchain.com/contracts/04203b77743ad0ca831df9430a6be515195733ad91)
. This makes the node eligible to perform baker services. While a service is being performed the tokens are locked to
the contract. A node operator can resign from a service, and release the tokens staked on the service. A delay of
release ensures sufficient time for making dispute claim. Upgraded services require stake of tokens in addition to what
is already staked on baker service, but they also have a bigger earning potential.

### Dispute claims and malicious behaviour

Malicious node behaviour can result in slashing of staked tokens (slashed tokens get burned). The purpose of slashing is to prevent malicious activity.

!!! example "Examples of malicious activity"
    - Signing a wrong oracle transfers (Allow stealing)
    - Signing a wrong price
    - Starting an incorrect dispute

It is possible to start a dispute against a node operator that has done a service for you. Dispute claims are
audited by the [large oracle](../pbc-fundamentals/dictionary.md#large-oracle). If the node operator is found responsible
for the node's alleged malicious behaviour tokens staked on the service may be slashed. Filing an illegitimate dispute claim against another node can also be
considered malicious behaviour and result in slashing.
