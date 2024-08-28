# Delegated staking

Delegation of MPC tokens to a node operator is a way to stake tokens and earn [rewards](https://gitlab.com/partisiablockchain/node-operators-rewards/-/tree/main?ref_type=heads) without running
a [node](../pbc-fundamentals/dictionary.md#node) yourself.

Delegated staking begins with the delegation of MPC tokens to the account of a node operator. 
If the node operator accepts the tokens, they have custodianship over the tokens. 
This means that the node operator can associate the delegated tokens to a [node service](../node-operations/start-running-a-node.md#which-node-should-you-run). 
You can only retract your tokens when the node operator releases the tokens and no longer uses them for a node service. 

As a delegator, it is your responsibility to communicate with the node operator using the tokens, 
if you want them to release your tokens from node service.  

!!! info

    Delegation is a long-term commitment. Tokens delegated to a node operator can be locked to node services. [See restrictions on tokens and rules of retrieval](../node-operations/node-payment-rewards-and-risks.md)

### How to delegate MPC tokens

Before delegating any tokens you should visit the [Staking Marketplace](https://discord.com/channels/819902335567265792/1075334307821920337), where you can find node operators interested in receiving delegated stakes.

Step by step:

1. Sign in 
2. Go to the [Your assets](https://browser.partisiablockchain.com/assets) menu in the browser left sidebar. If the menu is not visible, sign in
3. Click "Delegate"   
4. Write the [account address](../pbc-fundamentals/dictionary.md#address) of the receiving node operator and amount of MPC tokens you wish to delegate 

!!! success 
    
    Your tokens are now **available** for the node operator to use.
    However, to reap any rewards the node operator needs to accept your tokens and associate them to a job.
    You might need to contact them to make sure your tokens are being used.
    

### How to accept delegated tokens

As a node operator, you can choose to accept the full amount or only a partial amount of a delegation offer.

Step by step:

1. Sign in
2. Go to the [Node operation](https://browser.partisiablockchain.com/node-operation) menu in the browser left sidebar. If the menu is not visible, sign in
3. Click "SEE MORE" to unfold the collapsed delegation table located below the **Delegated from others** section
4. Locate the offer you wish to respond to. In the **Amount** column, either click on the checkmark icon to accept the full amount, or click the minus icon to accept a partial amount

### How to retract delegated MPC tokens

Step by step:

1. Sign in
2. Go to the [Your assets](https://browser.partisiablockchain.com/assets) menu in the browser left sidebar. If the menu is not visible, sign in
3. Click "SEE MORE" to unfold the collapsed delegation table located below the **Available to delegate** section
4. Locate the offer you wish to retract from. In the **Amount** column click on the "Retract" icon 
5. Write the amount of MPC tokens you wish to retract  

Your tokens should now be back into to your account. If this does not happen, the tokens are in use by a node service. 
Then go to the [next section](#how-to-retract-delegated-mpc-tokens-locked-to-a-node-service)

### How to retract delegated MPC tokens locked to a node service

1. Contact the node operator and ask them to disassociate your tokens from node service   
2. Wait for the [pending time](../node-operations/node-payment-rewards-and-risks.md) to be over
3. Follow the steps in the previous section: [How to retract delegated MPC tokens](#how-to-retract-delegated-mpc-tokens) 


### Rewards for delegated tokens

You get [rewards](https://gitlab.com/partisiablockchain/node-operators-rewards/-/tree/main?ref_type=heads) when node operators associate your delegated tokens to a node service. The rewards depend on
the [baker service](../node-operations/node-payment-rewards-and-risks.md#how-different-node-services-earn-fees-and-rewards)'s
performance of the node you delegate to, and the amount of rewardable tokens delegated.

!!! Example "Calculation example"

    Consider a group of token holders indexed $i=0...n$. We want to calculate the rewards of the token holder with index 4.  

    **Variables:**

    - **T** is the total allocated rewards for the period. In this scenario 1,000,000 MPC tokens   
    - **r<sub>i<sub>** is the rewardable delegated tokens of token holder _i_. Suppose token holder 4 delegates all his 20,000 MPC tokens to a node operator, and half the tokens are released. This means that 10,000 MPC tokens of the delegation is rewardable: $Delegated_{rewardable} = \frac{Released_{MPC}}{Total_{MPC}} Delegated = \frac{10,000}{20,000} 20,000 = 10,000$   
    - **p<sub>i<sub>** is the performance of the node using the tokens of token holder _i_. Suppose that in this  period, the performance of the node using token holder 4's tokens was 90%   
    - $\sum_{i=0}^{n}r_{i} \cdot p_{i}$ is the sum of rewardable tokens adjusted for performance. In this scenario we imagine 100 nodes with an average of 12,000 MPC rewardable adjusted for performance, bringing the total to 1,200,000 MPC tokens    

    **Calculation:**  

    $RewardForDelegation = T \frac{r_{4} \cdot p_{4}}{\sum_{i=0}^{n}r_{i} \cdot p_{i}} = 1,000,000 \frac{10000 \cdot 90\%}{1,200,000} = 7,500$   
    Token holder 4's reward for the delegated stakes in the given period is 7,500 MPC tokens.   
    The node operator takes a 2% cut of the total rewards. Thus token holder 4 would get 7,350 of the 7,500.

    This calculation is simplified by omitting the calculation of the sum $\sum_{i=0}^{n}r_{i} \cdot p_{i}$. In an actual case, you need to know rewardables and performance scores of each and every node in the network for the given period to calculate $\sum_{i=0}^{n}r_{i} \cdot p_{i}$. 

You can consult the calculation method for rewards, and the history of quarterly payouts [here](https://gitlab.com/partisiablockchain/node-operators-rewards/-/blob/main/mainnet/README.md#computing-rewards).
