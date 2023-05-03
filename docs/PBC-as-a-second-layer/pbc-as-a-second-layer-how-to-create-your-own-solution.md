# How to deploy your own solution with PBC as a second layer
<div class="dot-navigation">
    <a class="dot-navigation__item" href="pbc-as-second-layer.html"></a>
    <a class="dot-navigation__item" href="pbc-as-a-second-layer-live-example-ethereum.html"></a>
    <a class="dot-navigation__item dot-navigation__item--active" href="pbc-as-a-second-layer-how-to-create-your-own-solution.html"></a>
    <a class="dot-navigation__item" href="pbc-as-second-layer-technical-differences-eth-pbc.html"></a>

    <!-- Repeat above for more dots -->
</div>

---
**NOTE** We recommend you to have some knowledge in creating smarts contracts on both layer one and layer two. If you are unsure we suggest you to read up on how to do the following when trying to recreate the example contract of ours: 

1. How to create smart contracts on PBC. Our documentation starts on this page: [What is a smart contract](../contract-development.md)
2. How to create smart contracts in ETH (or another layer one chain for this case).
    We recommend you go to soliditys own documentation to understand how to make smart contracts in ETH if you are new to this specific case: [https://docs.soliditylang.org/en/latest/](https://docs.soliditylang.org/en/latest/)
---

## Step by step guide on how to deploy your own solution
1. Grab the project from: Private repo [https://gitlab.com/secata/pbc/language/contracts/zk-as-a-service](https://gitlab.com/secata/pbc/language/contracts/zk-as-a-service), will be open-sourced <todo>
2. [Compile your contract](../compile-zk.md)

3. [Deploy a ZK contract on PBC](../contract-compilation.md).
   
    We recommend you to follow our guide on how to deploy contracts on PBC [here](../contract-compilation.md)
    
    Please keep in mind that deploying private contracts (.zkwa) is more expensive than the dashboard estimates, remember to add more gas (4x). You can test down to the exact gas amount on the [testnet for free](../testnet.md).
   
4. Note down your address as 42 chars hexstring (starting with 03). You need to add it to the testnet link to go to your zk contract. If you deployed your contract on PBC through the dashboard app, you can grab it from the link at the top. 
   
5. Go to https://testnet.partisiablockchain.com/info/contract/<privateVotingPbcAddress\>
   
6. Press the button “Show ZK state as json”

    Inside the json you'll find an object named “engines”. The engines object contains a list also called “engines”. Each of the four objects in the “engines” list contains information for one of the ZK nodes selected for this contract. 
    
    **Note** that the order of the nodes in the list is important and should not be changed. We need to grab their publickeys and its very important that you keep this in order, we urge you to refer to the nodes as node0, node1, node2, and node3, based on their place in the list.

7. For each node, grab the 33 bytes in the “publicKey” field. The key is encoded using Base64.

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

## Code walkthrough / Understanding how the code works / Mikey can think of a good title?

The source code for the two contracts used in the 
[public live example](pbc-as-a-second-layer-live-example-ethereum.md) can be found in the public 
repository https://gitlab.com/partisiablockchain/. We urge you to study the two contracts to 
understand their common design, their differences and how data is shared between them.

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
    let variables_to_delete: Vec<SecretVarId> = zk_state
        .secret_variables
        .iter()
        .map(|x| x.variable_id)
        .collect();

    let mut result = state
        .vote_results
        .iter_mut()
        .find(|r| r.vote_id == state.current_vote_id)
        .unwrap();

    let attestation = zk_state
        .data_attestations
        .iter()
        .find(|a| a.attestation_id == attestation_id)
        .unwrap();

    let evm_formatted_proof = format! {"[{}]", attestation
    .signatures
    .iter()
    .map(format_signature_for_evm)
    .collect::<Vec<String>>()
    .join(", ")};

    result.proof = Some(evm_formatted_proof);
    state.current_vote_id += 1;
    (
        state,
        vec![],
        vec![ZkStateChange::OutputComplete {
            variables_to_delete,
        }],
    )
}

fn format_signature_for_evm(signature: &Signature) -> String {
   let recovery_id = signature.recovery_id + 27;
   let recovery_id = format!("{recovery_id:02x}");
   let mut r = String::with_capacity(64);
   for byte in signature.value_r {
      write!(r, "{byte:02x}").unwrap();
   }
   let mut s = String::with_capacity(64);
   for byte in signature.value_s {
      write!(s, "{byte:02x}").unwrap();
   }
   format!("0x{r}{s}{recovery_id}")
}

```


### Solidity public voting contract
