# Delegated staking

Delegation of MPC tokens to a node operator is a way to stake tokens and earn [rewards](https://gitlab.com/partisiablockchain/node-operators-rewards/-/tree/main?ref_type=heads) without running
a [node](../pbc-fundamentals/dictionary.md#node) yourself. You can see an example of how rewards are calculated [here](./node-payment-rewards-and-risks.md#rewards-for-delegated-tokens).

Delegated staking begins with the delegation of MPC tokens to the account of a node operator. 
If the node operator accepts the tokens, they have control over the tokens. 
This means that the node operator can associate the delegated tokens to a [node service](../node-operations/start-running-a-node.md#which-node-should-you-run). 
You can only retract your tokens when the node operator disassociates the tokens from node service. 

As a delegator, it is your responsibility to communicate with the node operator using the tokens, 
if you want them to disassociate your tokens from node service.  

!!! info

    Delegation is a long-term commitment. Tokens delegated to a node operator can be locked to node services. See [restrictions on tokens and rules of retrieval](../node-operations/node-payment-rewards-and-risks.md)

### How to delegate MPC tokens

Before delegating any tokens you should visit the [Staking Marketplace](https://discord.com/channels/819902335567265792/1075334307821920337), where you can find node operators interested in receiving delegated stakes.

Step by step:

1. Go to [Your assets](https://browser.partisiablockchain.com/assets)
2. Sign in
3. Click "Delegate"   
4. Write the [account address](../pbc-fundamentals/dictionary.md#address) of the receiving node operator and amount of MPC tokens you wish to delegate 

!!! success 
    
    Your tokens are now **available** for the node operator to use.
    However, to reap any rewards the node operator needs to accept and associate your tokens to a job.
    You might need to contact them to make sure your tokens are being used.
    

### How to accept delegated tokens

As a node operator, you can choose to accept the full amount or only a partial amount of a delegation offer.

Step by step:

1. Go to [Node operation](https://browser.partisiablockchain.com/node-operation)
2. Sign in
3. Click "SEE MORE" to unfold the collapsed delegation table located below the **Delegated from others** section
4. In the **Amount** column of the offer you wish to respond to, either click on the checkmark icon to accept the full amount, 
5. or click on the minus icon to accept a partial amount

### How to retract delegated MPC tokens

Step by step:

1. Go to [Your assets](https://browser.partisiablockchain.com/assets)
2. Sign in
3. Click "SEE MORE" to unfold the collapsed delegation table located below the **Available to delegate** section
4. Locate the offer you wish to retract from. In the **Amount** column click on the "Retract" icon 
5. Write the amount of MPC tokens you wish to retract  

!!! success

    Your tokens should now be back into to your account. If this does not happen, the tokens are in use by a node service. 
    To retract your tokens follow the steps in the [next section](#how-to-retract-delegated-mpc-tokens-locked-to-a-node-service)

### How to retract delegated MPC tokens locked to a node service

1. Contact the node operator and ask them to disassociate your tokens from node service   
2. Wait for the [pending time](../node-operations/node-payment-rewards-and-risks.md) to be over
3. Follow the steps in the previous section: [How to retract delegated MPC tokens](#how-to-retract-delegated-mpc-tokens) 

