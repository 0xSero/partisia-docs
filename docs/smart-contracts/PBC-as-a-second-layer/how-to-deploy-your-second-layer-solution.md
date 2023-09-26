# How to deploy your second layer solution
<div class="dot-navigation">
    <a class="dot-navigation__item" href="pbc-as-second-layer.html"></a>
    <a class="dot-navigation__item" href="pbc-as-a-second-layer-live-example-ethereum.html"></a>
    <a class="dot-navigation__item" href="pbc-as-a-second-layer-how-to-create-your-own-solution.html"></a>
    <a class="dot-navigation__item dot-navigation__item--active" href="pbc-as-a-second-layer-how-to-deploy.html"></a>
    <a class="dot-navigation__item" href="pbc-as-second-layer-technical-differences-eth-pbc.html"></a>
    <!-- Repeat above for more dots -->
</div>

!!! note 
    We recommend that you read the [walkthrough of the example contracts](how-to-create-your-own-second-layer-solution.md) to understand the contracts being deployed in this guide.

## Deploying a PBC as second layer solution

The following guide shows how to deploy a PBC private smart contract and an Ethereum solidity
contract in such a way that the solidity contract utilizes the PBC private smart contract as a
second layer for ZK services.

The guide will use the
[example voting solution](how-to-create-your-own-second-layer-solution.md)
and will deploy to the PBC testnet and Ethereum Goerli testnet.

To follow the guide you must have an [PBC testnet account](../../pbc-fundamentals/create-an-account.md) with
[testnet gas](../gas/how-to-get-testnet-gas.md).
You must also have
an [Ethereum Goerli testnet account](https://ethereum.org/en/wallets/find-wallet/)
with Goerli testnet ETH. Goerli testnet ETH can be obtained via a
[faucet](https://ethereum.org/en/developers/docs/networks/#goerli).

### Deploy PBC private smart contract

First we will deploy the PBC private smart contract, and obtain any information necessary for
deploying the solidity contract.

#### Getting the contracts ready

Download the example project from the git
repository [https://gitlab.com/partisiablockchain/language/<todo>](https://gitlab.com/partisiablockchain/language/<todo>),
or use your own contracts.

Note that the rest of this guide expects the constructor arguments of the solidity contract to
match the one in the example, and uses the deployment scripts found in the example.

[Compile your PBC private smart contract](../zk-smart-contracts/compile-and-deploy-zk-contract.md).

#### Deploy a ZK contract on PBC

We recommend you to follow our guide on how to deploy contracts on PBC
[here](../../contract-compilation.md)

Please keep in mind that deploying private contracts (.zkwa) is more expensive than the dashboard
estimates, remember to add more gas (4x). You can test down to the exact gas amount on the
[testnet for free](../access-and-use-the-testnet.md).

#### Note the address of the newly deployed contract.

The address of a deployed private smart contract is a 42 chars long hex string starting with `03`.

For example an address could look like `030102030405060708090AA0908070605040302010`.

If you deployed your contract on PBC through the dashboard app, you can grab it from the link at the top.

#### Read the public keys of the ZK computation nodes

Go to the contract info page
e.g. https://testnet.partisiablockchain.com/info/contract/030102030405060708090AA0908070605040302010

Read the ZK state by pressing the “Show ZK State as JSON” button.

The JSON contains a lot of information needed to run a ZK computation, but we are only interested
in the information about the chosen ZK computation nodes.

Find the list called "engines". This list contains 4 objects, each with information about the ZK
computation nodes. For each of the nodes, note down the Base64 encoded "publicKey".

**Note** that the order of the nodes in the list is important and should not be changed!

### Deploy Ethereum solidity contract

We recommend that you follow the official guides from Ethereum for developing and deploying Solidity
smart contracts. In the following, we use the
[hello world tutorial](https://ethereum.org/en/developers/tutorials/hello-world-smart-contract-fullstack/)
from Ethereum as a template for how to deploy a solidity smart contract on the Goerli testnet.

#### Prepare for deploying the solidity contract

Before being able to deploy the solidity contract, the deployment script
(`public-voting/scripts/deploy.js`) assumes that a number of environment variables are present.

These can be added by writing them down in an .env file. See the example below.

```text
API_URL = "<WRITE_YOUR_OWN_API_ENDPOINT>"
PRIVATE_KEY = "<WRITE_YOUR_OWN_PRIVATE_KEY_HERE>"
PBC_CONTRACT_ADDRESS = "030102030405060708090AA0908070605040302010"
ZK_ENGINE_PUB_KEY_0 = "A/J83e6pRe9ARxCJNrUxu2iVfh3HTKk4CEYyZFxWn4NG"
ZK_ENGINE_PUB_KEY_1 = "AmThsZafkQKXdpGkBDGwtnIFXc8xFjiX2ZZDRCDmyV3J"
ZK_ENGINE_PUB_KEY_2 = "A7NVEdZ+Y/plUtt0C0irptIwwheZ5lpmR6XL/Hie8BhL"
ZK_ENGINE_PUB_KEY_3 = "A54hWPDXwNXybDeR7++nlZdlTnorJGT1Kx7mwTR3ae9X"
```

In the above, API_URL is the url of an endpoint to the Ethereum Goerli testnet. The PRIVATE_KEY
is the private key of you Ethereum Goerli test account. PBC_CONTRACT_ADDRESS is the address of
the PBC private smart contract you just deployed, and ZK_ENGINE_PUB_KEY_0, ...,
ZK_ENGINE_PUB_KEY_3 are the public keys of the PBC private smart contract.

**Note** that the order in which the public keys are written must match the order in which they
are listed in private smart contract's ZK state.

#### Deploy the solidity contract

Once you've inserted your own values in the .env file, the contract can be deployed by running
the following command.

```shell
npx hardhat run scripts/deploy.js --network goerli
```

Once deployed it should display the address of the newly deployed Solidity contract.

#### Verify on [goerli.etherscan.io](https://goerli.etherscan.io/)

If you wish to see the state of the contract and be able to interact with it on
https://goerli.etherscan.io/, you can add the following to the .env file

```text
... <THE SAME VARIABLES AS BEFORE> ...
ETH_CONTRACT_ADDRESS = "<WRITE_THE_ADDRESS_OF_THE_NEWLY_DEPLOYED_SOLIDITY_CONTRACT>"
ETHERSCAN_API_KEY = "<WRITE_YOUR_OWN_ETHERSCAN_API_KEY>"
```

Then run the following command.

```shell
npx hardhat run scripts/verify.js --network goerli
```

### Verify deployments

To test that the deployment of the PBC as second layer solution works, you can run a test similar to
what is described in the
[live voting example walkthrough](live-example-of-pbc-as-a-second-layer.md). 
