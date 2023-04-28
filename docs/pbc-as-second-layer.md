# Partisia Blockchain as a second layer

This article explains how Partisia Blockchain (PBC) can function as a second layer. We will dive into a running example and demonstrate how to test the implementation from the Ethereum testnet to our [PBC testnet](testnet.md). Lastly, we will explain how to develop and recreate our testnet solution to get you started with using PBC as a second layer.

To use PBC's zero-knowledge contracts as a second layer to handle privacy, secrecy or other great possibilities, the minimum viable design stays the same. We need to deploy two smart contracts: one zero-knowledge smart contract on PBC and a public smart contract on the layer one chain. The public functionality of the contracts will be very similar, but the contract on PBC can privately calculate the result using zero-knowledge computation.

The author determines what information should be given to the public record (on layer one). In the contract deployed on PBC, we define what information should not be given to the public record (layer two on PBC). Users interact with the necessary contracts to either A) give input publicly for layer one or two, or B) give input privately directly onto layer two contract. The contracts need to be designed around each other.

At present, PBC as a second layer only supports a manual movement of data from layer one to layer two. However, it ensures that the package delivered out from layer two is sufficiently signed to prevent tampering.
We recommend building an outside layer of automation that can move the information from the layer one blockchain to PBC and vice versa.
![ConceptPBCAsSecondLayer](assets/ConceptModels/ConceptPBCAsSecondLayer.png)

## How do we handle the information and make sure the middle man is not cheating the users of the smart contracts?

Ensuring that the middle man is not cheating is an important aspect of how PBC works as a second layer. To sum up the proces of the below model: The package that will be delivered from PBC will be signed with unique keys from our node operators(the ZK nodes for this specific contract) that has done the MPC calculation. This signed package is the package that will need to be moved manually to the SOL contract to publish the public result of your contracts. The layer one contract would need to be able to validate the signed keys from the prepicked node operators.

The contract owner must manually add certain information from the state of the deployed Partisia Blockchain (PBC) contract to the contract on layer one. The layer one contract must contain the identities (PBC addresses) of the ZK nodes allocated to perform the zero knowledge computation. This is necessary because the outcome from PBC uses signatures from the ZK nodes to prove themselves as the actual outcome of the computation from PBC. The signatures include the identity of the ZK nodes and the result which the respective nodes approved. To claim a win on the layer one contract, your identity must match the result calculated by a majority of the ZK nodes, which is typically 3 out of 4 in practice.

### How information is represented on PBC and Ethereum and how to convert between the two

One of the problems with transferring data between PBC and Ethereum is that the two chains take
different approaches on how information is represented. Specifically, the differences relevant for
using PBC as second layer are; 1) how user data is encoded, 2) the hashing algorithm used, 3) how contract/account addresses are derived, and 4) the encoding of signatures.

#### Encoding data

Solidity has two methods for encoding data into bytes, `abi.encode()` and `abi.encodePacked()`.
For a detailed overview of how they work, see the
[solidity documentation](https://docs.soliditylang.org/en/latest/abi-spec.html).

Data received from PBC should be encoded using `abi.encodePacked()`.

Similarly, PBC also has two ways to encode or serialize data based on what they are used for.
See [documentation](abiv.md) for more details.

Data that are meant to be sent to Ethereum must be encoded as an argument for an RPC payload.
This can be done by the method `<type>.rpc_write_to(&mut writer)`, where the type implements
the `WriteRPC` trait.

One significant difference between `abi.encodePacked()` and `<data>.rpc_write_to(&mut writer)` is
that `abi.encodePacked()` does not encode the length of dynamic sized types e.g. strings or lists,
but `<data>.rpc_write_to(&mut writer)` does add the length to the encoding.
This means that the length must be manually added to the arguments in `abi.encodePacked()`.

Solidity example:

```solidity
0x48656c6c6f2c20776f726c6421 == abi.encodePacked("Hello, World!");
0x0000000d48656c6c6f2c20776f726c6421 == abi.encodePacked(unint32(13), "Hello, World!");
```

PBC example:

```rust
let mut output: Vec<u8> = vec![];
"Hello, World!".rpc_write_to( & mut output);
0x0000000d48656c6c6f2c20776f726c6421 == output;
```

#### Hashing data

As a standard, Ethereum uses the Keccak-256 hashing algorithm, while PBC uses SHA-256 when signing
data.
This means that the same bytes results in different digests when hashing either on Ethereum or PBC.
However, solidity also provides a SHA-256 method, which should be used whenever verifying data sent
from PBC.

#### Deriving addresses

When using PBC as second layer, there may exist accounts on PBC that we wish to represent on
Ethereum, that is given an PBC account with signing key _k_ which address corresponds to _k_ on
Ethereum?

We need this information to be able to verify the signatures provided by the ZK computation nodes.

As described [here](https://ethereum.org/en/developers/docs/accounts/#account-creation) the address
is derived by first generating the public key from the private key. Then the Ethereum address is the
last 20 bytes of the Keccak-256 hash of the public key.

Since PBC holds the public keys of the computation nodes in the state this sound easy enough, but
there is a problem.

To understand the problem it is important to understand that both Ethereum and PBC uses [Elliptic
Curve Cryptography](https://en.wikipedia.org/wiki/Elliptic-curve_cryptography) (ECC) for providing signatures. This means that public keys are actually a point
on an elliptic curve, and the point can be encoded in two different formats: compressed and
uncompressed.

The uncompressed encoding is 64 bytes, 32 bytes for each coordinate in the point.
As the name implies, the compressed encoding compresses the points, so they can be represented in
fewer bytes.

When using PBC, public keys are saved in compressed encoding to optimize storage usage. However, when deriving the address from the public keys, Ethereum expects them to be in uncompressed format. Therefore, before deriving the addresses, the compressed public keys from PBC must be converted to an uncompressed 64-byte encoding. This conversion will ensure that Ethereum can derive the address from the public key.

#### Signatures

Finally, in order to be able to verify data signed by the ZK computation nodes, we need to ensure
the signatures are on a format which Ethereum can decode.

Recall that Ethereum and PBC uses ECC and specifically the Elliptic Curve Digital Signature
Algorithm (ECDSA), when signing messages.

Signatures outputted by the algorithm consists of three values; _r_ and _s_ which are both 32 bytes,
and a _recovery_id_ which is a single byte.

PBC stores these values as a single 65 bytes entity, on the format `recovery_id || s || r`.
However, Ethereum expects that _recovery_id_ is the last byte instead of the first, so it
should be moved to the end of the signature `r || s || recovery_id`.

Additionally, on PBC the _recovery_id_ can be either 0 or 1, but Ethereum expects it to be either
27 or 28. So we should add 27 to it before we can send to Ethereum.

The final transformation looks like
`recovery_id || s || r => s || r || (recovery_id + 27)`.
