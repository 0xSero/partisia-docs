# Onboarding new BYOC from existing integrated chains

Onboarding ...  
TODO: Write high level intro

## High level process

1. Deploy implementation contract on integrated chain
2. Deploy configured proxy contract on integrated chain
3. Propose a vote on Partisia Blockchain to enable to the BYOC
4. All node operators need to verify the proposed information and vote on the BYOC to enable it on
   Partisia Blockchain

Before preparing the contracts on the integrated chain some information need to be collected:

- Which integrated chain does the coin reside on (Ethereum, Polygon or BNB Smart Chain)
- What is the current USD value of a single coin

For non-stable coins a ChainLink reference contract on Ethereum that tracks the current price needs
to be available.

For ERC20 tokens the token contract address and the number of decimals is needed.

## Configuration parameters

The bytecode for the contracts on the EVM chain should be fetched
from [Gitlab](https://gitlab.com/partisiablockchain/governance/byoc-contract-eth/-/packages/8687576).
For ERC20 tokens use _WithdrawAndDepositErc20.json_, for native token use
_WithdrawAndDepositEth.json_.  
The _ERC1967Proxy.json_ need to be used as proxy. For all the files the value in 'bytecode' should
be used.

| Parameter                              | Name                | Value                                                                                                                                                               |
|----------------------------------------|---------------------|---------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| Implementation contract byte code      |                     | See above                                                                                                                                                           |
| Proxy contract byte code               |                     | See above                                                                                                                                                           |
| Current price in USD (price)           | price               | Need to be supplied                                                                                                                                                 |
| Maximum withdrawal                     | maxWithdrawal       | 200000 / price                                                                                                                                                      |
| Minimum withdrawal                     | minWithdrawal       | 25 / price                                                                                                                                                          |
| Maximum deposit                        | maxDeposit          | 100000 / price                                                                                                                                                      |
| Minimum deposit                        | minDeposit          | minWithdrawal                                                                                                                                                       |
| Large oracle address                   | loAddress           | 0x81a19EE43bcF9FF57ab2694B3f435e3354894B3A (Ethereum)<br/>0x3435359Df1D8C126ea1b68BB51E958fdf43F8272 (Polygon)<br/>0x4c4ECb1EFb3BC2a065af1F714B60980a6562C26f (BSC) |
| Name of token                          | tokenName           | Need to be supplied                                                                                                                                                 |
| Chain link reference contract          | referenceAddress    | Need to be supplied                                                                                                                                                 |
| Chain link reference contract decimals | priceOracleDecimals | Need to be supplied                                                                                                                                                 |
| ERC20 contract                         | erc20Contract       | Need to be supplied                                                                                                                                                 |
| ERC20 decimals                         | erc20Decimals       | Need to be supplied                                                                                                                                                 |
| Implementation contract address        | implAddress         | Deployed as part of the proposal                                                                                                                                    |
| Proxy contract address                 | proxyAddress        | Deployed as part of the proposal                                                                                                                                    |

## Generating payloads

The below form helps generate the needed binary transactions for deploying on the external chain and
proposing the update on Partisia Blockchain.

The bytecode for the contracts have been populated from the compiled artifacts on Gitlab.

TODO: The form below is not finalized. 

--8<-- "docs/snippets/byoc-onboarding-form.html"

## Verify a proposed BYOC

The proposer should have made all the configuration parameters available for the node operators to
check. Fill out the payload form above with all the received information to be able to verify the
payloads.

Validate that the parameters match what is expected:
 - Does the supplied price match the price of the token?
 - Is the name of the token correct?
 - Is the supplied reference contract a chain link reference for the bridged symbol? And does the decimal count match the ones on the contract?
 - Is the supplied ERC20 contract a valid ERC20 contract for the token? And does the decimal count match the decimals on the ERC20 contract?

For both of the deployed contracts lookup the transaction that deployed them, find the payload of
the transaction and verify that this matches exactly the payload generated in the form.
 