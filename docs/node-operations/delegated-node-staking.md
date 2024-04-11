# Delegated staking

Delegation of MPC token to a node operator is way to stake tokens and earn rewards without running
a [node](../pbc-fundamentals/dictionary.md#node) yourself.

Delegated staking means that you delegate MPC tokens to an account of a node operator. If the node operator accepts the
delegated tokens he has custodianship over the tokens. That means that the node operator can associate the tokens to
a [node service](../node-operations/start-running-a-node.md#which-node-should-you-run). Tokens can only be retrieved,
when they are no longer used for a node service. It is your own responsibility as a delegator to communicate with the
node operator using the tokens, if you want him to release the tokens from node service allowing you to retrieve them.

### How rewards and fees work for delegated tokens

You get rewards for delegating tokens to node operators. The rewards are calculated as a factor multiplied with the number of rewardable tokens delegated. $Delegated_{rewardable} = \frac{Released_{MPC}}{Total_{MPC}} Delegated $

### How to delegate MPC tokens



