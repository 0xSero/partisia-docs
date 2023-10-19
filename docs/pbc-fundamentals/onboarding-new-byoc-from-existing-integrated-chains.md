# Onboarding new BYOC from existing integrated chains

This article helps you onboard ERC20 and its extension tokens to Partisia Blockchains using the PBC
bridge. In order for the
bridge to work between chains, you must have a contract in the Ethereum, Polygon or BNB smart chain
network as well
as on the Partisia
Blockchain network. We provide a template for anyone to tweak and submit a proposal to add the coin
of their choice to
Partisia Blockchian.
This proposal will go to a vote to our node operator committee. The committee then has 7 days to
review the proposal and
either accept or reject the proposal.
If it is accepted, the contract will go live and the token will become available as an asset in the
network.

## How to create a proposal for a new coin

1. Deploy implementation contract on the chain you want to integrate with.
2. Deploy configured proxy contract on the chain you want to integrate with.
3. Propose a vote on Partisia Blockchain to get node operators consent to enable your new BYOC.
4. When node operators have verified the proposed information and voted yes to the BYOC it will be
   accepted as a mintable coin on Partisia Blockchain. To understand bridging visit our article
   about [bridging coins to PBC](bridging-byoc-by-sending-transactions.md#how-does-the-bridge-work).

The existing BNB bridge is an example of a successful deployment,
see [implementation contract](https://bscscan.com/address/0xf393d008077c97f2632fa04a910969ac58f88e3c)
and [proxy contract](https://bscscan.com/address/0x05ee4eee70452dd555ecc3f997ea03c6fba29ac1).

Before preparing the contracts on the integrated chain some information needs to be collected:

- Which integrated chain does the coin reside on (Ethereum, Polygon or BNB Smart Chain)
- What is the current USD value of a single coin

For non-stable coins a ChainLink reference contract on Ethereum that tracks the current price needs
to be available.
See [Chainlink contracts on Ethereum mainnet](https://data.chain.link/ethereum/mainnet)

For ERC20 tokens the token contract address and the number of decimals is needed.

## Generating payloads

The below form helps generate the needed binary transactions for deploying on the external chain and
proposing the update on Partisia Blockchain.

The bytecode for the contracts have been populated from the compiled artifacts on Gitlab.

1. Select the chain where the token resides
2. Select if the token to be deployed is an ERC20 or a native token
3. Deploy the implementation contract (note the address for later usage)
4. Fill information needed for initializing the implementation contract
5. Deploy the ERC197Proxy with initialization of the implementation contract (note the address for
   later usage)
6. Fill remaining information to prepare vote on Partisia Blockchain
7. Create vote on Partisia Blockchain

For step 2 and 4 the form below allows using Metamask to send the transactions.

For step 7 go to
the [system update contract in the browser](https://browser.partisiablockchain.com/contracts/04c5f00d7c6d70c3d0919fd7f81c7b9bfe16063620/proposeUpdate)
to propose a 'PollUpdateType$INVOKE_CONTRACT(6)' vote with the update RPC from the below form.

--8<-- "docs/snippets/byoc-onboarding-form.html"

## Verify a proposed BYOC

The proposer should have made all the configuration parameters available for the node operators to
check. Fill out the payload form above with all the received information to be able to verify the
payloads.

Validate that the parameters match what is expected:

- Does the supplied price match the price of the token?
- Is the name of the token correct?
- Is the supplied reference contract a chain link reference for the bridged symbol? And does the
  decimal count match the ones on the contract?
- Is the supplied ERC20 contract a valid ERC20 contract for the token? And does the decimal count
  match the decimals on the ERC20 contract?

For both of the deployed contracts lookup the transaction that deployed them, find the payload of
the transaction and verify that this matches exactly the payload generated in the form.

For the vote on Partisia Blockchain the content of the vote should match exactly the payload from
the above form. 

## Configuration parameters

The bytecode for the contracts on the EVM chain should be fetched
from [Gitlab](https://gitlab.com/partisiablockchain/governance/byoc-contract-eth/-/packages/8687576).

For all the files the value in 'bytecode' should be used.

| Parameter                              | Value                                                                                                                                                               |
|----------------------------------------|---------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| Implementation contract byte code      | For ERC20 tokens use _WithdrawAndDepositErc20.json_, for native token use _WithdrawAndDepositEth.json_ from the Gitlab link above                                   |
| ERC1967Proxy                           | Use _ERC1967Proxy.json_ from the Gitlab link above                                                                                                                  |
| Current price in USD (price)           | Need to be supplied                                                                                                                                                 |
| Maximum withdrawal                     | 200000 / price                                                                                                                                                      |
| Minimum withdrawal                     | 25 / price                                                                                                                                                          |
| Maximum deposit                        | 100000 / price                                                                                                                                                      |
| Minimum deposit                        | minWithdrawal                                                                                                                                                       |
| Large oracle address                   | 0x81a19EE43bcF9FF57ab2694B3f435e3354894B3A (Ethereum)<br/>0x3435359Df1D8C126ea1b68BB51E958fdf43F8272 (Polygon)<br/>0x4c4ECb1EFb3BC2a065af1F714B60980a6562C26f (BSC) |
| Name of token                          | Need to be supplied                                                                                                                                                 |
| Chain link reference contract          | Need to be supplied                                                                                                                                                 |
| Chain link reference contract decimals | Need to be supplied                                                                                                                                                 |
| ERC20 contract                         | Need to be supplied                                                                                                                                                 |
| ERC20 decimals                         | Need to be supplied                                                                                                                                                 |
| Implementation contract address        | Deployed as part of the proposal                                                                                                                                    |
| Proxy contract address                 | Deployed as part of the proposal                                                                                                                                    |