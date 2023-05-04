# Partisia Blockchain as a second layer

This article explains how Partisia Blockchain (PBC) can function as a second layer. We will dive into a running example and demonstrate how to test the implementation from the Ethereum testnet to our [PBC testnet](../testnet.md). Lastly, we will explain how to develop and recreate our testnet solution to get you started with using PBC as a second layer.

To use PBC's zero-knowledge contracts as a second layer to handle privacy, secrecy or other great possibilities, the minimum viable design stays the same.
We need to deploy two smart contracts: one zero-knowledge smart contract on PBC and a public smart contract on the layer one chain. The public functionality of the contracts will be very similar, but the contract on PBC can privately calculate the result using zero-knowledge computation. This design can be made onto any EVM chain with PBC as second layer and we focus on ETH in this guide because we have designed our running example around that particular chain. The PBC steps are the same and the concept needs to be similar in design.

The author of the contracts determines what information should be publicly available and what should be kept confidential across layer 1 and 2. The users send their input the necessary contracts to either A) give input publicly for layer 1 or 2, or B) give input privately directly onto the layer 2 contract. The main benefits of using PBC as second layer to determine what input goes where and how we handle such input either privately or publicly.

![ConceptPBCAsSecondLayer](../assets/ConceptModels/ConceptPBCAsSecondLayer.png)

To illustrate PBC as a second layer, we will use the model outlined above and describe it with reference to an example that you can find on the following page. This example is based on using Ethereum as the first layer and PBC as the second layer. The scenario involves a voting system where the goal is to privately calculate the results of the votes without revealing how individual voters cast their ballots.

1. A Solidity (.sol) smart contract needs to be deployed on layer 1, in our example layer 1 is Ethereum. The smart contract in our example has two main objectives:
   1. It handles the initialized list of allowed voters on the contract.
   2. It handles the final verification of the result received from PBC. The contract needs to know the adresses for the nodes picked on PBC to handle the verification.
2. A PBC zero knowledge smart contract needs to be deployed on layer 2. The smart contract in our example has three main objectives:
   1. It accepts the list of allowed voters to ensure only voters whos part of the vote can send their vote.
   2. It lets allowed users vote
   3. It counts the votes privately and signs the result with the zero-knowledge (ZK) nodes keys. More on this later.
3. When the PBC smart contract is deployed, it selects four MPC nodes to perform the zero-knowledge calculation.
4. The list of allowed voters from the .sol contract needs to be transferred onto PBC. Typically an off-chain script is used to move the data between chains.
5. After transferring the list of allowed voters, the PBC smart contract knows which votes it can accept and from whom.
6. Voters submit their votes directly to the PBC smart contract, ensuring confidentiality.
7. The smart contract continually sends the votes it receives to the prepicked MPC node operators, also called zero-knowledge nodes. The ZK nodes will handle our computation privately without knowing the voters and votes themselves. You can read more about the MPC process [in our dictionary](../dictionary.md#mpc)
8. When the smart contract on PBC reaches its deadline it will start the ZK computation for counting the votes.
9. When the computation is complete, the nodes are asked to reveal the result, which is then signed by the nodes.
10. The signed result needs to be transferred back to the Ethereum contract, typically done by another off-chain script.
11. The Ethereum contract verifies that the signatures are from the expected MPC addresses before publishing the vote results on its chain to end the vote.

## How do we handle the information and make sure the middle man is not cheating the users of the smart contracts?

To ensure the integrity of the results calculated on PBC, the signed result will need to be validated on the layer 1 contract before being published. The signatures come from the unique keys of the ZK nodes that have completed the MPC calculation, and the layer 1 contract must be able to verify these signed keys to establish the connection between layer 1 and 2. This is an important aspect of how PBC works as a second layer, as it prevents any middle man from cheating. To enable the verification of the signed keys, certain information from the deployed PBC contract state, such as the PBC addresses of the ZK nodes used in the computation, must be manually added to the layer 1 contract.
