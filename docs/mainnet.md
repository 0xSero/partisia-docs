# MainNet is coming - What to expect 
We are soon launching MainNet. This means that a myriad of opportunities are emerging for developers, node operators and contract consumers. The Partisia infrastructure team is working to include as many high quality features as possible. Below you see a list of the features we are working to include by the launch.

## WASM smart contracts on PBC

- External users are able to compile and deploy own contract
- ABI does not have to be auto generated, but can be handwritten by the programmer
- Has a metered interpreter for CPU fees
- It is possible to auto generate ABI files from the rust source
- Contracts should be able to pay for outbound events instead of the user

## Rewards contract - Block Producer orchestration

- It is possible to register a new block producer if the user has enough stakes
- The contract orchestrates the large oracle
- The large oracle consists of a Sepior threshold key held by the block producers
- It is possible for the contract to trigger a committee change:
    1. Generates a new large oracle key given the new producers
    2. Should be able to handle if some producers are down
    3. The old large oracle signs off on the new producers
    4. The new committee is registered in FastTrack
- At the end of each epoch all producers send a transaction (per shard) to the contract indicating that an epoch has ended. When ⅔ of the producers has notified the contract (and a small time window has passed to allow for everyone that is present to participate) the contract collects spent gas for the epoch and pay out to the producers
- Is able to allocate a new oracle to BYOC oracles. Manages the rotation of BYOC oracles. The change is signed by the large oracle key.
- Procedure has been described for generating the first large oracle key
- BPs will have a property list e.g. Name, Address, Jurisdiction entity, Jurisdiktion server

## BYOC

- It is possible to deposit ETH into a contract on Ethereum that is then minted by an oracle as BYOC twins on PBC
- It is possible to withdraw ETH BYOC twins from PBC to Ethereum
- The oracle is limited to transact (deposit or withdraw) X ETH before it is changed through a request to the large oracle in BP orchestration
- The BYOC contracts are able to handle disputes about erroneous transfers
- Fees are collected for transactions

## Governance contracts

- BYOC, BP orchestration and SystemUpdateContract are free to interact with for block producers  (requires having staked tokens) 
- It is possible to update system  and governance contracts through a system interaction

## MPC tokens

- Account plugin and a contract for interactions
- An initial token distribution is present in the genesis block with different vesting periods The vestings will be relative short to make it possible to test that vesting unlocks work as expected
- It is possible to stake and unstake MPC tokens
- It is possible to stake the tokens towards a contract to be able to register as block producer or oracle node
- Users are able to transfer unlocked tokens to others
- Oracle for accepting ETH from KYC'ed persons and directly mint MPC tokens
- The BYOC contracts has a way to exchange MPC tokens for BYOC twins to recalibrate the bridge


## SystemUpdateContract

- A contract exists that allows updating the system (enable feature, update global plugin state, change plugin, update system contract) The update is done through a poll on chain

## Node and service configuration

- It is possible to configure a node to act as a producer, including:
    1. Being part of the large oracle
    2. Monitoring BYOC contracts and Ethereum
    3. If elected as a BYOC committee member take part in the oracle work
    4. Identify corrupt behaviour and triggering a dispute if it happens
    5. Using producer key as identity in the flooding network
    6. Any transactions sent are through a single proxy (maybe in-process) that ensures that nonce are not reused

## Consensus Model

- FastTrack uses BLS signatures in finalization data



