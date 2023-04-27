# How to create your own solution with PBC as a second layer

## How to SC PBC

## How to SC ETH

https://docs.soliditylang.org/en/latest/

Grab the project from: Private repo https://gitlab.com/secata/pbc/language/contracts/zk-as-a-service, will be open-sourced
PBC example
ETH example

### How to deploy PBC

Deploying private contracts (.zkwa) is more expensive than the dashboard estimates, remember to add more gas (4x)
Get address as 42 chars hexstring (starting with 03). Ref as privateVotingPbcAddress going forward.

Go to https://testnet.partisiablockchain.com/info/contract/<privateVotingPbcAddress>
Press “Show ZK state as json”
The json contains an object called “engines” which contains a list also called “engines”. Each of the four objects in the “engines” list contains information for one of the ZK nodes selected for this contract. Note that the order of the nodes in the list is important and should not be changed. Refer to the nodes as node0, node1, node2, and node3, based on their place in the list.

For each of node, grab the 33 bytes in the “publicKey” field. The key is encoded using Base64.
How to deploy ETH
Possibly using the guide in https://ethereum.org/en/developers/tutorials/hello-world-smart-contract-fullstack/
Problems with getting test goerli described in official docs here: https://ethereum.org/en/developers/tutorials/hello-world-smart-contract-fullstack/#step-4-add-ether-from-a-faucet
The deploy scripts in the repo helps with converting the public keys from compressed form to uncompressed.
TODO list of env vars needed to compile and deploy .sol contract (these contain sensitive info such as private keys and api keys, so beware)
Verify deployment
Code walkthrough?
How to remove ZK parts
Manual data movement
Example of manual data movement
Manual movement of data from ETH -> PBC
Verification of successful datamovement?
Manual data movement PBC -> ETH
Aadd 27 (1B in hex) to the first recoveryId byte and move it to the end of the signature instead. See details
Show result
How to automate / Tips to automate
Tue: I’ve added scripts and code that help with the data conversions such that it requires minimal human interaction.
Summing up the experience (Shiny conclusion),
What else can we do with this new knowledge?
Easy wins from the example code, what can you quickly use this case for/small changes needed to expand the possibilities.
