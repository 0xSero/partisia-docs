# Register your node
<div class="dot-navigation" markdown>
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

The final step in becoming a block producer in the Partisia Blockchain is the registration. This is done by committing a 
stake of MPC Tokens and sending a registration form. Staking is done in the
[Partisia Blockhain Browser](https://browser.partisiablockchain.com/node-operation) on the *Stake* button; registration 
is done on the node via the `node-register.sh` script.

There are three prerequisites for registering:

1. You have staked the minimum amount of tokens (see [Get MPC tokens](get-mpc-tokens.md))
1. You have completed your KYC/KYB, and it is verified (you will have received a verification e-mail). Write down your Synaps Session ID
1. You have a reader node running that is up-to-date with the rest of the network, see below how to check this

## Registering the node

The registration ensures that your account and tokens are associated with your node. It also creates a profile with public information about your node.

???+ note

    Your node _must_ be up-to-date with the rest of the network, otherwise the next part won't work.

The node REST server will respond with a code `204 No Content` if it is up-to-date with the network. 
You can check the status by running the following command:

```bash
./node-register.sh status
```

You will need at least 25,000 gas to send the register transaction. To check your gas balance log in to the
[Partisia Blockchain Browser](https://browser.partisiablockchain.com/account?tab=byoc), go to *Your Account* and then *BYOC*, where your
gas balance is shown.

To send the register transaction you need to log in to your node and go to the `~/pbc` folder and call the `node-register.sh` script.

```bash
cd ~/pbc
```

```bash
./node-register.sh register-node
```

Follow the on-screen instructions and you should now be registered.

???+ note

    You can update your information from the Register Transaction by doing a new registration transaction.

Then you need to verify that the account key you have in the `config.json` file matches the blockchain address you've used in your KYC/KYB.

If it still fails then reach out to the [community](../get-support-from-pbc-community.md).

## Conditions for inclusion

Formal conditions for inclusion in the network is stipulated in the Yellow Paper [YP_0.98 Ch. 2.3.1 pp. 11-12](https://drive.google.com/file/d/1OX7ljrLY4IgEA1O3t3fKNH1qSO60_Qbw/view):

- The public information regarding the node given by the operator must be verified by Synaps.
- Sufficient stakes committed.
- The transaction fees of Register and Staking Transaction have been paid.
