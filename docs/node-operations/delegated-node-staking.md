# Delegated staking

Delegation of MPC token to a node operator is a way to stake tokens and earn [rewards](https://gitlab.com/partisiablockchain/node-operators-rewards/-/tree/main?ref_type=heads) without running
a [node](../pbc-fundamentals/dictionary.md#node) yourself.

Delegated staking means that you delegate MPC tokens to an account of a node operator. If the node operator accepts the
delegated tokens he has custodianship over the tokens. That means that the node operator can associate the tokens to
a [node service](../node-operations/start-running-a-node.md#which-node-should-you-run). You can only retrieve your token again,
when they are released and no longer used for a node service. It is your responsibility as a delegator to communicate with the
node operator using the tokens, if you want him to release the tokens from node service.  

### Rewards for delegated tokens

You get [rewards](https://gitlab.com/partisiablockchain/node-operators-rewards/-/tree/main?ref_type=heads) for delegating tokens to node operators. The rewards depend on the number of rewardable tokens delegated: $Delegated_{rewardable} = \frac{Released_{MPC}}{Total_{MPC}} Delegated$

The calculation method for rewards, and the history of quarterly payouts can bee seen [here](https://gitlab.com/partisiablockchain/node-operators-rewards/-/blob/main/mainnet/README.md#computing-rewards)

### How to delegate MPC tokens

Before you delegate tokens you should visit the [Staking Marketplace](https://discord.com/channels/819902335567265792/1075334307821920337)  where you can find node operators interested in receiving delegated stakes.

!!! info 

    Delegation is a long term commitment. When your tokens are delegated to a node operator, the tokens can be locked to node services. [See restrictions on tokens and rules of retrieval](../node-operations/node-payment-rewards-and-risks.md)

1. Go to [the assets menu](https://browser.partisiablockchain.com/assets)   
2. Sign in   
3. Unfold the collapsed delegation table in the bottom of the page
4. Click _Delegate_   
5. Choose amount of MPC tokens and [account address](../pbc-fundamentals/dictionary.md#address) of the node operator

### How to accept delegated tokens

1. Go to [the node operation menu](https://browser.partisiablockchain.com/node-operation)
2. Sign in
3. Under the section **Delegated from others**, unfold the collapsed delegation table in the bottom of the page
4. Click _Delegate_
5. Choose amount of MPC tokens and [account address](../pbc-fundamentals/dictionary.md#address) of the node operator

Your tokens will now be in the state of _pending acceptance_. The node operator has 14 days to accept or reject the offered delegation. If the node operator takes no action, the tokens will return your account.

### How to retract delegated MPC tokens

1. Go to [the assets menu](https://browser.partisiablockchain.com/assets)
2. Sign in
3. Unfold the collapsed delegation table in the bottom of the page
4. Click _Retract_
5. Choose amount of MPC tokens and [account address](../pbc-fundamentals/dictionary.md#address) of the node operator

Your tokens should now be retrieved to your account and full control. If this does not happen, the tokens are in use by a node service. Then go [here](#how-to-retrieve-delegated-mpc-tokens-locked-to-a-node-service)

### How to retrieve delegated MPC tokens locked to a node service

1. Contact the node operator and ask him to disassociate the tokens from node service   
2. Wait for [pending time](../node-operations/node-payment-rewards-and-risks.md) to be over
3. Go to [the node operation menu](https://browser.partisiablockchain.com/node-operation)
4. Sign in
5. In the bottom you will see a table showing the
6. To the right of the amount, click the round icon
7. Choose amount of MPC tokens and [account address](../pbc-fundamentals/dictionary.md#address) of the node operator

