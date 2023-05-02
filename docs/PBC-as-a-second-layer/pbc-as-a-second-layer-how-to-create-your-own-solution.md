# How to create your own solution with PBC as a second layer
<div class="dot-navigation">
    <a class="dot-navigation__item" href="pbc-as-second-layer.html"></a>
    <a class="dot-navigation__item" href="pbc-as-a-second-layer-live-example-ethereum.html"></a>
    <a class="dot-navigation__item dot-navigation__item--active" href="pbc-as-a-second-layer-how-to-create-your-own-solution.html"></a>
    <a class="dot-navigation__item" href="pbc-as-second-layer-technical-differences-eth-pbc.html"></a>

    <!-- Repeat above for more dots -->
</div>

---
**NOTE** We recommend you to have some knowledge in creating smarts contracts on both layer one and layer two. If you are unsure we suggest you to read up on how to do the following: 

1. How to create smart contracts on PBC. Our documentation starts on this page: [What is a smart contract](../contract-development.md)
2. How to create smart contracts in ETH (or another layer one chain for this case).
    We recommend you go to soliditys own documentation to understand how to make smart contracts in ETH if you are new to this specific case: [https://docs.soliditylang.org/en/latest/](https://docs.soliditylang.org/en/latest/)
---

## Step by step guide on how to deploy your own solution
1. Grab the project from: Private repo [https://gitlab.com/secata/pbc/language/contracts/zk-as-a-service](https://gitlab.com/secata/pbc/language/contracts/zk-as-a-service), will be open-sourced

2. How to deploy a ZK contract on PBC.
   
    We recommend you to follow our guide on how to deploy contracts on PBC [here](../contract-compilation.md)
    
    Please keep in mind that deploying private contracts (.zkwa) is more expensive than the dashboard estimates, remember to add more gas (4x).
   
3. Note down your address as 42 chars hexstring (starting with 03). You need to add it to the testnet link to go to your zk contract. If you deployed your contract on PBC through the dashboard app, you can grab it from the link at the top. 
   
4. Go to https://testnet.partisiablockchain.com/info/contract/<privateVotingPbcAddress\>
   
5. Press the button “Show ZK state as json”

    Inside the json you'll find an object named “engines”. The engines object contains a list also called “engines”. Each of the four objects in the “engines” list contains information for one of the ZK nodes selected for this contract. 
    
    **Note** that the order of the nodes in the list is important and should not be changed. We need to grab their publickeys and its very important that you keep this in order, we urge you to refer to the nodes as node0, node1, node2, and node3, based on their place in the list.

6. For each node, grab the 33 bytes in the “publicKey” field. The key is encoded using Base64.

    The publickey could look like this: (INSERT OBJECT WITH HIGHLIGHT OF PUBLICKEY)<todo>


## How to deploy ETH
In general we recommend you to follow the official guide on how to deploy sol contracts, since that documentation will be supported by developers on ETH. We used this this official guide to deploy our sol contract: [https://ethereum.org/en/developers/tutorials/hello-world-smart-contract-fullstack/](https://ethereum.org/en/developers/tutorials/hello-world-smart-contract-fullstack/)

When we followed the guide, we noticed that it can be difficult to get test goerli, which is described in the official docs here: [https://ethereum.org/en/developers/tutorials/hello-world-smart-contract-fullstack/#step-4-add-ether-from-a-faucet](https://ethereum.org/en/developers/tutorials/hello-world-smart-contract-fullstack/#step-4-add-ether-from-a-faucet) but when you first get some test Goerli it goes more smooth from there. 

Etherscan link? <todo>

We have created a a deploy script in the repo. This helps with converting the public keys from compressed form to uncompressed. <todo> link to the deploy scripts, small explanation of what they do?

What are these used for? Can we see them on etherscan as the things we need to supply? Maybe a screenshot here <todo>
Store environment variables for deploing (e.g. in .env file)
`**API_URL** = url to goerli endpoint
**PRIVATE_KEY** = private key for deploying account
**PBC_CONTRACT_ADDRESS** = private voting contract on PBCKv
**ZK_ENGINE_PUB_KEY_i** = for i 0 - 3 zk engine public key on private voting contract`

Manual data movement PBC -> ETH
Aadd 27 (1B in hex) to the first recoveryId byte and move it to the end of the signature instead. See details <todo> explain what this means what part it belongs to. 

In general we recommend that you automate the moving of data between chains and to support these movements we have created a couple of scripts for the example that shows and helps with data conversions such that it requires minimal human interaction. 
<todo> link to the scripts and shortly/briefly explain what they do.
Tue: I’ve added scripts and code that help with the data conversions such that it requires minimal human interaction.

In conclusion, this step-by-step tutorial shows you how to create a solution with PBC as a second layer. It requires you to have a bit of knowledge on creating smart contracts on both ETH and PBC which is linked at the top of the guide. By following the step-by-step instructions provided, users can successfully deploy a zero-knowledge contract on PBC that can work with a deployed ETH contract. on deploying ETH and provides a deploy script in the repo to help with converting the public keys. The example contracts are free to use and expand on to explore by yourself how to use PBC as a second layer. You can already now go and make an anonymous vote completely based on ETH and PBC as the example shows. 