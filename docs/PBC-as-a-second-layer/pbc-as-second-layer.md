# Partisia Blockchain as a second layer

This article explains how Partisia Blockchain (PBC) can function as a second layer. We will dive into a running example and demonstrate how to test the implementation from the Ethereum testnet to our [PBC testnet](testnet.md). Lastly, we will explain how to develop and recreate our testnet solution to get you started with using PBC as a second layer.

To use PBC's zero-knowledge contracts as a second layer to handle privacy, secrecy or other great possibilities, the minimum viable design stays the same.
We need to deploy two smart contracts: one zero-knowledge smart contract on PBC and a public smart contract on the layer one chain. The public functionality of the contracts will be very similar, but the contract on PBC can privately calculate the result using zero-knowledge computation.

The author of the contract determines what information should be given to the public record (on layer one). In the contract deployed on PBC, the author defines what information should not be given to the public record (layer two on PBC). Users interact with the necessary contracts to either A) give input publicly for layer one or two, or B) give input privately directly onto layer two contract. The contracts need to be designed around each other. The inputs can also be forwarded for the user but still assumes the same placing of the inputs as described.

At present, PBC as a second layer only supports a manual movement of data from layer one to layer two by scripting. However, PBC ensures that the package delivered out from layer two is sufficiently signed to prevent tampering with it. The model tries to showcase what has been described earlier.

![ConceptPBCAsSecondLayer](assets/ConceptModels/ConceptPBCAsSecondLayer.png)
The graphic is made from the perspective of our live example on ethereum, you can check how the process works from our running example on [this page.](pbc-as-a-second-layer-live-example-ethereum.md)

In general We recommend building an outside layer of automation that can move the information from the layer one blockchain to PBC and vice versa.

## How do we handle the information and make sure the middle man is not cheating the users of the smart contracts?

Ensuring that the middle man is not cheating is an important aspect of how PBC works as a second layer. The package that will be delivered from PBC will be signed with unique keys, as shown on the above model, from our node operators(the ZK nodes for this specific contract) that has done the MPC calculation. This signed package is the package that will need to be moved manually to the SOL contract to publish the public result of your contracts. The layer one contract would need to be able to validate the signed keys from the prepicked node operators.

The contract owner must manually add certain information from the state of the deployed Partisia Blockchain (PBC) contract to the contract on layer one. The layer one contract must contain the identities (PBC addresses) of the ZK nodes allocated to perform the zero knowledge computation. This is necessary because the outcome from PBC uses signatures from the ZK nodes to prove themselves as the actual outcome of the computation from PBC. The signatures include the identity of the ZK nodes and the result which the respective nodes approved. To claim a win on the layer one contract, your identity must match the result calculated by a majority of the ZK nodes, which is typically 3 out of 4 in practice.
