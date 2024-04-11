# Delegated staking

Delegation of MPC token to a node operator is way to stake tokens and earn [rewards](https://gitlab.com/partisiablockchain/node-operators-rewards/-/tree/main?ref_type=heads) without running
a [node](../pbc-fundamentals/dictionary.md#node) yourself.

Delegated staking means that you delegate MPC tokens to an account of a node operator. If the node operator accepts the
delegated tokens he has custodianship over the tokens. That means that the node operator can associate the tokens to
a [node service](../node-operations/start-running-a-node.md#which-node-should-you-run). Tokens can only be retrieved,
when they are no longer used for a node service. It is your own responsibility as a delegator to communicate with the
node operator using the tokens, if you want him to release the tokens from node service allowing you to retrieve them.

### How rewards and fees work for delegated tokens

You get [rewards](https://gitlab.com/partisiablockchain/node-operators-rewards/-/tree/main?ref_type=heads) for delegating tokens to node operators. The rewards are calculated as a factor multiplied with the number of rewardable tokens delegated. $Delegated_{rewardable} = \frac{Released_{MPC}}{Total_{MPC}} Delegated$

### How to delegate MPC tokens

Before you delegate tokens you should visit the [Staking Marketplace](https://discord.com/channels/819902335567265792/1075334307821920337)  where you can find node operators interested in receiving delegated stakes.
!!! warning 

    Delegation is a long term commitment. When your tokens are delegated to a node operator the tokens can be locked to node services. [See restrictions on tokens and rules of retrieval](../node-operations/node-payment-rewards-and-risks.md)

1. Go to [the node operation menu](https://browser.testnet.partisiablockchain.com/node-operation)   
2. Sign in   
3. Unfold the collapsed delegation table in the bottom of the page
4. Click _Delegate_   
5. Choose amount of MPC tokens and [account address](../pbc-fundamentals/dictionary.md#address) of the node operator

Your tokens will now be in the state of _pending acceptance_. The node operator has 14 days to accept or reject the offered delegation. If the node operator takes no action, the tokens will return your account.
