# Register your node
<div class="dot-navigation" markdown>
   [](what-is-a-node-operator.md)
   [](create-an-account-on-pbc.md)
   [](get-mpc-tokens.md)
   [](recommended-hardware-and-software.md)
   [](vps.md)
   [](secure-your-vps.md)
   [](reader-node-on-vps.md)
   [](complete-synaps-kyb.md)
   [](run-a-block-producing-node.md)
   [*.*](register-your-node.md)
   [](node-health-and-maintenance.md)
</div>

The final step in becoming a block producer in the Partisia Blockchain is the registration. This is done by committing a stake of MPC Tokens and sending a registration form. Staking is done in the [Partisia Blochain Explorer](https://mpcexplorer.com/node-register), registration is done on the node via the `node-register.sh` script.

There are three prerequisites for registering:

1. You have staked the minimum amount of tokens
1. You have completed your KYC/KYB and it is verified
1. You have a reader node running that is up-to-date with the rest of the network

For the following you need the [MPC Wallet extension](https://chrome.google.com/webstore/detail/partisia-wallet/gjkdbeaiifkpoencioahhcilildpjhgh) for your browser.

## Staking tokens

1. You need to be able to cover gas costs of transaction, click [here](../pbc-fundamentals/byoc.md) for help to get gas in your account.
1. Log in to your account. Click upper right corner (View activity). This will take you to your account page.
1. Click on _Node register_ on the menu bar and then click on _Manage MPC Tokens_. From there, click _Stake MPC Tokens_ and stake 25k or more tokens to your account.

## Registering the node

The registration ensures that your account and tokens are associated with your node. It also creates a profile with public information about your node.

**NOTE:** Your node _must_ be up-to-date with the rest of the network, otherwise the next part won't work.

To send the register transaction you need to log in to your node and go to the `~/pbc` folder and call the `node-register.sh` script.

```bash
cd ~/pbc
```

```bash
./node-register.sh register-node
```

Follow the on-screen instructions and you should now be registered.


**NOTE:** You can change your public information from the Register Transaction by doing a new registration transaction.

If something goes wrong you need to first ensure that you have enough gas to send the transaction, see [here](../pbc-fundamentals/byoc.md).

Then you need to verify that the account key you have in the `config.json` file matches the blockchain address you've used in your KYC/KYB.

If it still fails then reach out to the community.

## Conditions for inclusion

Formal conditions for inclusion in the network is stipulated in the Yellow Paper [YP_0.98 Ch. 2.3.1 pp. 11-12](https://drive.google.com/file/d/1OX7ljrLY4IgEA1O3t3fKNH1qSO60_Qbw/view):

- The public information regarding the node given by the operator must be verified by Synaps.
- Sufficient stakes committed.
- The transaction fees of Register and Staking Transaction have been paid.
