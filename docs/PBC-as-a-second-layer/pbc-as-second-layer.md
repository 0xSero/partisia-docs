# Partisia Blockchain as a second layer

This article explains how Partisia Blockchain (PBC) can function as a second layer. We will dive into a running example and demonstrate how to test the implementation from a layer one testnet to our [PBC testnet](/docs/testnet.md). Lastly, we will explain how to develop and recreate our testnet solution to get you started with using PBC as a second layer.

To use PBC's zero-knowledge contracts as a second layer to handle privacy, secrecy or other great possibilities, the minimum viable design stays the same.
We need to deploy two smart contracts: one zero-knowledge smart contract on PBC and a public smart contract on the layer one chain. The public functionality of the contracts will be very similar to eachother, the difference is that the contract on PBC can privately calculate the result using zero-knowledge computation. This design can be used on any EVM chain with PBC as second layer.

The author of the contracts determines what information should be publicly available and what should be kept confidential across layer 1 and 2. The users of the smart contracts sends their input to the necessary contracts to either A) give input publicly for layer 1 or 2, or B) give input privately directly to the layer 2 contract on PBC.

![ConceptPBCAsSecondLayer](../assets/ConceptModels/ConceptPBCAsSecondLayer.png)

To illustrate PBC as a second layer, we will use the model outlined above and describe it with reference to an example that you can find on the following page. This example is based on using Ethereum as the first layer and PBC as the second layer. The scenario involves a voting system where the goal is to privately calculate the results of the votes without revealing how individual voters cast their ballots.

1. A Solidity (.sol) smart contract is deployed on layer 1, in our example layer 1 is Ethereum. The smart contract has two main objectives:
   * It handles the initialized list of allowed voters on the contract.
   * It handles the final verification of the result received from PBC. The contract needs to know the adresses for the nodes picked on PBC to handle the verification.
2. A PBC zero knowledge smart contract is deployed on layer 2. The smart contract has three main objectives:
   * It accepts the list of allowed voters to ensure only voters whos part of the vote can send their vote.
   * It lets allowed users vote
   * It counts the votes privately and signs the result with the zero-knowledge (ZK) nodes keys. More on this later.
3. When the PBC smart contract is deployed, it selects four [MPC nodes](/docs/dictionary.md#mpc) to perform the zero-knowledge calculation.
4. The list of allowed voters from the .sol contract is transferred onto PBC. Typically an off-chain script is used to move the data between chains.
5. After transferring the list of allowed voters, the PBC smart contract knows which votes it can accept and from whom.
6. Voters submit their votes directly to the PBC smart contract, ensuring confidentiality. The smart contract verifies the sender from the list of allowed voters. 
7. The votes secret input are being monitored by the four MPC nodes and individually they take their secret share out of the transaction and saves it to their local storage. 

    The MPC nodes are also known as zero-knowledge nodes. The ZK nodes will handle our computation privately without knowing what the vote is since none of the secret shares makes sense on an individual basis. You can read more about the MPC computation [in our dictionary](/docs/dictionary.md#mpc) or read the [article series that explains the math behind MPC](https://medium.com/partisia-blockchain/mpc-techniques-series-part-1-secret-sharing-d8f98324674a).
8. When the smart contract on PBC reaches its deadline the ZK computation for counting the votes can be started by any user.
9.  When the computation is complete, the nodes are asked to reveal the result, which is then signed by the nodes.
10. The signed result is transferred back to the Ethereum contract, typically done by another off-chain script.
11. The Ethereum contract verifies that the signatures are from the expected MPC addresses before publishing the vote results on its chain to end the vote.

## How do we handle the information and make sure the middle man is not cheating the users of the smart contracts?

Ensuring that the middle man is not cheating is an important aspect of how PBC works as a second layer. The results that will be calculated on PBC will be signed with unique keys coming from The ZK nodes that has completed the MPC calculation. The signed result will need to be moved to the layer 1 contract to publish the public results of your contracts. The layer 1 contract would need to be able to validate the signed keys from the prepicked node operators to create the connection between layer 1 and 2.

To prove the outcome of a computation from PBC, signatures from the ZK nodes are used. This requires the manual addition of certain information from the state of the deployed PBC contract to the contract on layer 1, including the PBC addresses of the ZK nodes allocated to perform the computation.

the outcome from PBC uses signatures from the ZK nodes to prove themselves as the actual outcome of the computation from PBC. The signatures include the identity of the ZK nodes and the result which the respective nodes approved. The contract owner must therefore manually add certain information from the state of the deployed PBC contract to the contract on layer one. The layer one contract needs to contain the identities (PBC addresses) of the ZK nodes allocated to perform the zero knowledge computation.
