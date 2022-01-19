# How to get your node included in the network

The sign-up is a four-step process:  

1. Buy the required stake of MPC tokens.   
2. Rent or buy a server where you can run the node.   
3. Configure the node in accordance with the description [here](operator.md).  
4. Send a Register Transaction and a Staking Transaction through the [MPC Wallet Extension](https://chrome.google.com/webstore/detail/partisia-wallet/gjkdbeaiifkpoencioahhcilildpjhgh) 

## Content of the Register Transaction

- Name (Legal name)
- Website (Company or personal webpage)
- Address (Company or personal address)
- PublicKey (PublicKey of your Network keyset)
- BLS PublicKey (BLS12-381 PublicKey of your BLS keyset)
- EntityJurisdiction (Your country of residence - ISO 3166-1: 3-digit code referring to a country)
- ServerJurisdiction (Location of the server where you operate the node - ISO 3166-1: 3-digit code referring to a country)

## Content of Staking Transaction

- Amount (The amount of MPC Tokens you are staking)

## Conditions for inclusion

Formal conditions for inclusion in the network is stipulated in the [Yellow Paper](accounts@pbc.foundation) (YP_0.95 Ch. 2.3.1 pp. 11-12):

- The public information regarding the node given by the operator must be validated.
- Sufficient stakes committed.
- Test run is successful.
- The transaction fees of Register and Staking Transaction have been paid.
