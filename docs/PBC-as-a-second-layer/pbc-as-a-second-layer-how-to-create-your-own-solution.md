# How to create your own solution with PBC as a second layer
<div class="dot-navigation">
    <a class="dot-navigation__item" href="pbc-as-second-layer.html"></a>
    <a class="dot-navigation__item" href="pbc-as-a-second-layer-live-example-ethereum.html"></a>
    <a class="dot-navigation__item dot-navigation__item--active" href="pbc-as-second-layer-how-to-create-you-own-solution.html"></a>
    <a class="dot-navigation__item" href="pbc-as-a-second-layer-how-to-deploy.html"></a>
    <a class="dot-navigation__item" href="pbc-as-second-layer-technical-differences-eth-pbc.html"></a>

    <!-- Repeat above for more dots -->
</div>

In this section we will show you how to create you own application that uses PBC as a second 
layer.

We will use the code from the voting example, but it should be evident that is possible to use PBC 
as second layer for any type of application.

---
**NOTE** We recommend you to have some knowledge in creating smarts contracts on both layer one and 
layer two. If you are unsure we suggest you to read up on how to do the following when trying to 
recreate the example contract of ours:

1. How to create smart contracts on PBC. Our documentation starts on this page: 
   [What is a smart contract](../contract-development.md)
2. How to create smart contracts in ETH (or another layer one chain for this case).
   We recommend you go to soliditys own documentation to understand how to make smart contracts in 
   ETH if you are new to this specific case: 
   [https://docs.soliditylang.org/en/latest/](https://docs.soliditylang.org/en/latest/)
---

## Secret voting example code

The [voting example](pbc-as-a-second-layer-live-example-ethereum.md) works by having two separate 
smart contracts, one deployed on the PBC testnet and another deployed on the Goerli testnet.

The source code contracts can be found in the public repository 
https://gitlab.com/partisiablockchain/. We urge you to study the two contracts to understand their 
common design, their differences, and how data is shared between them.

We will not provide a line-by-line walkthrough of the code, as some knowledge of both PBC and EVM
smart contract development is expected. We will briefly discuss the structure of the project and
parts of the code, relevant for understanding how PBC as second layer works, in both contracts
starting with the private PBC smart contract.

### Project structure

The root of the project contains two subdirectories: `private-voting` and `public-voting`.

The `private-voting` directory contains a Cargo project for the PBC ZK smart contract.
The public part of the contract is defined in `src/contract.rs` and the ZK computation is defined in
`src/zk_compute.rs`.

The contract depends on version 13.5.0 of the
[contract-sdk](https://gitlab.com/partisiablockchain/language/contract-sdk) crate, version 3.63.0 of
the [zk-compiler](https://gitlab.com/partisiablockchain/language/zk-compiler), and can be compiled
with version 1.20.0 <todo>(or earlier) of the
[cargo-partisia-contract](https://gitlab.com/partisiablockchain/language/cargo-partisia-contract)
build tool.

The `public-voting` directory contains Hardhat project for the public Solidity contract.
The solidity contract is defined in `contracts/PublicVoting.sol`. The `scripts` folder contains
a script for deploying and interacting with the solidity contract, and some helper functions for
converting data formats. See [this page](pbc-as-second-layer-technical-differences-eth-pbc.md) for
a more detailed explanation of why the conversion is needed.

The solidity contract can be built and the scripts can run with Node.js version 16.15.0.

### PBC private voting contract

Explaining how the ZK computation in `src/zk_compute.rs` and how all the hooks in `src/contract.rs`
works are beyond the scope of this walkthrough. We urge you to read the contract yourself carefully,
and refer to [this page](../zk-language.md) for understanding the ZK computation and
[this page](../ZKSC.md) for the smart contract.

However, we will briefly talk about the overall flow of the contract, and point out specific code
snippets that are relevant for understanding how PBC as second layer works.

The flow of the contract is as follows:

1. Once the contract is deployed on PBC, it is initialized with an empty list of registered voters,
   an empty list of voting results, and an initial vote id of 1.
2. Anyone can register their PBC account as voter.
3. Any registered voter can cast a single secret vote on the currently active vote.
4. Anyone can at anytime count the cast votes of the currently active vote.
   This is what the ZK computation does.
5. Once the votes have been counted the result, i.e. the number of yes votes, no votes and absenting
   voters, is archived in the state and the next vote is activated by deleting the inputs and
   incrementing the vote id.
6. Additionally, the result is attested by the computation nodes, meaning that they each sign it.

The last attestation step is what enables us to move data from PBC back to the 1. layer chain, so it
is useful to understand how that works.

The following is an abbreviated snippet of the functions that receive the opened computation result
and asks for it to be attested by the computation nodes.

```rust
#[zk_on_variables_opened]
fn build_and_attest_voting_result(
   _context: ContractContext,
   mut state: ContractState,
   zk_state: ZkState<SecretVarMetadata>,
   opened_variables: Vec<SecretVarId>,
) -> (ContractState, Vec<EventGroup>, Vec<ZkStateChange>) {
   // Get the id of the variable the was opened after the computation was completed.
   let computation_result_variable_id = opened_variables.get(0);
   // Build the result of the vote by getting the raw numbers from the opened variables and the
   // state.
   let vote_result = determine_result(&state, &zk_state, computation_result_variable_id);
   // Add the result to the open state. The result is still missing the proof.
   state.vote_results.push(vote_result.clone());
   // Return the tuple with the modified state, no events, and with a request that the computation 
   // nodes sign the serialized bytes of the result.
   (
      state,
      vec![],
      vec![ZkStateChange::Attest {
         data_to_attest: serialize_result_as_big_endian(vote_result),
      }],
   )
}

fn serialize_result_as_big_endian(result: VoteResult) -> Vec<u8> {
   let mut output: Vec<u8> = vec![];
   result
           .rpc_write_to(&mut output)
           .expect("Could not serialize result");
   output
}
```

The important thing to notice in the code above, is that after we have stored the result in the
state, we serialize it into raw bytes and ask that the computation nodes sign the bytes.
To be able to verify the signatures later in the Solidity contract it is important that the bytes
are exactly the same here as when we serialize the result in Solidity. That means the fields should
be written in the right order and right format which is big endian.

Actually what will be signed is a SHA-256 hash of the bytes prepended with additional data, but more
on that later.

After the data has been signed, the following code is executed.

```rust
#[zk_on_attestation_complete]
fn save_attestation_on_result_and_start_next_vote(
   _context: ContractContext,
   mut state: ContractState,
   zk_state: ZkState<SecretVarMetadata>,
   attestation_id: AttestationId,
) -> (ContractState, Vec<EventGroup>, Vec<ZkStateChange>) {
   // Get ids of all secret variables, to delete all votes cast in the previous vote before
   // starting the next one. Only cast votes are deleted, registered voters are kept from vote to
   // vote.
   let variables_to_delete: Vec<SecretVarId> = ...;

   // Find the result of the vote that was just concluded.
   let mut result: &mut VoteResult = ...;

   // Find the attestation that was just completed.
   let attestation: &DataAttestation = ...;

   // Parse the signatures into a text format that can be used in an Eth transaction without
   // further data conversions. The format is an array of the signatures in hex encoding.
   let proof_of_result: String = format! {"[{}]", attestation
           .signatures
           .iter()
           .map(as_evm_string)
           .collect::<Vec<String>>()
           .join(", ")};

   // Save the proof on the result object for convenient retrieval.
   result.proof = Some(proof_of_result);
   // Increment the vote id.
   state.current_vote_id += 1;
   // Return the tuple with the new updated state, no events, and an update to notify the runtime
   // environment to delete the variables and set the calculation status to Waiting. This ensures
   // that the contract will accept secret votes for the next round.
   (
      state,
      vec![],
      vec![ZkStateChange::OutputComplete {
         variables_to_delete,
      }],
   )
}

fn as_evm_string(signature: &Signature) -> String {
   // Ethereum expects that the recovery id has value 0x1B or 0x1C, but the algorithm used by PBC 
   // outputs 0x00 or 0x01. Add 27 to the recovery id to ensure it has an expected value, and 
   // format as a hexidecimal string.
   let recovery_id = signature.recovery_id + 27;
   let recovery_id = format!("{recovery_id:02x}");
   // The r value is 32 bytes, i.e. a string of 64 characters when represented in hexidecimal.
   let mut r = String::with_capacity(64);
   // For each byte in the r value format is a hexidecimal string of length 2 to ensure zero 
   // padding, and write it to the output string defined above.
   for byte in signature.value_r {
      write!(r, "{byte:02x}").unwrap();
   }
   // Do the same for the s value.
   let mut s = String::with_capacity(64);
   for byte in signature.value_s {
      write!(s, "{byte:02x}").unwrap();
   }
   // Combine the three values into a single string, prepended with "0x".
   format!("0x{r}{s}{recovery_id}")
}

```

As the previous code, this snippet is abbreviated to highlight the most relevant parts. The code is
invoked after all the computation nodes have signed the data that we request before. It then cleans
up the contract state and prepares for the next vote to begin. But more importantly for us, it also
takes the signatures the nodes provided and converts them into a format that can be understood by
the Solidity contract. To make it easier to find the signature for a given result it stores them
on the result object that was signed.

Note that this is not strictly necessary since the signatures will remain available in state, but
doing this will make it much easier to find the proof for a given result and not needing to convert
it when moving the data to the Solidity contract.

It should be clear from the above code examples that any type of data can be signed and moved out of 
the private smart contract, and that the code needed for doing so is independent of the actual 
application code.

Next we will discuss how the Solidity contract can receive and validate the result of a concluded
vote.

### Solidity public voting contract
