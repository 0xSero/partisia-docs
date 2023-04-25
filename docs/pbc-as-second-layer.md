# Partisia Blockchain as a second layer
In this article we will first explain how Partisia Blockchain(PBC) can work as a second layer. Secondly we will dive into our running example and how we can directly test the implementation from ETH testnet to our [PBC testnet](testnet.md). Lastly we will explain how to develop and recreate our testnet solution to get you on your way to start using PBC as a second layer.

To use PBCs zero knowledge contracts as the second layer to handle your use case, be it privacy, secrecy or other great possibilities, the minimum viable design stays the same. To create such a design we would need to deploy two smart contracts: one zero knowledge smart contract on PBC and a public smart contract on the layer one chain. The public functionality of the contracts will be very similar. But the contract on PBC can privately calculate the result using zero knowledge computation.

The author controls what information should be given to the public record (on layer one) and then in the contract deployed on PBC we need to define what should not be given to the public record (layer two on PBC). The users then interact with the needed contracts to either A. give input publicly for layer one or two or B. give input privately directly onto layer two contract. The contracts need to be designed around each other, but for now PBC as a second layer can only support a manual movement of data from layer one to layer two, but can make sure that the package delivered out from layer two is sufficiently packed to make sure it is not tampered with. In general we recommend building an outside layer of automation that can move the information from layer one blockchain to the PBC and vice versa. 

### How do we handle the information and make sure the middle man is not cheating the users of the smart contracts?
Ensuring that the middle man is not cheating is an important aspect of how PBC works as a second layer. To sum up the proces of the below model: The package that will be delivered from PBC will be signed with unique keys from our node operators(Name of the four working together privately?**) that has done the MPC calculation. This signed package is the package that will need to be moved manually to the SOL contract to publish the public result of your contracts. The layer one contract would need to be able to validate the signed keys from the prepicked node operators. 




_
The contract owner controls the functions on the Zero knowledge smart contract on PBC, but the functions of the layer one public contract are open for all users. The flow goes like this: After deployment on PBC, the contract owner needs to add some information from the state of the PBC contract to the contract on layer one.

The contract on PBC still goes through the same phases listed above, but the contract owner has to manually add some information from the state of the deployed PBC contract to contract on layer one. The layer one contract needs to contain the identities (PBC addresses) of the ZK nodes that have been allocated to do the zero knowledge computation. This is necessary because the outcome from PBC uses signatures from the ZK nodes to claim and prove themselves as the actual outcome of the computation from PBC. The signatures contain the identity of the zk nodes and the result which the respective nodes approved. To claim a win on the layer one contract your identity has to match the result calculated by a majority of the ZK nodes. In practice 3 out of 4.



