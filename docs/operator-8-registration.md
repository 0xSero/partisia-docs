#Register your node

The final step in becoming a block producer in the Partisia Blockchain is the registration. This is done by committing a stake of MPC Tokens and sending a registration form. Both are done with transaction you can perform in the [Partisia Blochain Explorer](https://mpcexplorer.com/node-register).

1) You need to be able to cover gas costs of transaction, click [here](byoc.md) for help to get gas in your account.
2) Go to the [Partisia Blochain Explorer](https://mpcexplorer.com/node-register). Log in.   
3) Stake MPC Tokens: Put your PBC address in the search bar, then you get your account information. There is a staking button next to your balance of MPC Tokens.
4) Click *Register Node* Connect your [MPC Wallet](https://chrome.google.com/webstore/detail/partisia-wallet/gjkdbeaiifkpoencioahhcilildpjhgh) by clicking *Connect Wallet*.    
5) Send Register Transaction.   
6) Send the public IP of the server hosting the node, your PBC Address to @Kristian Hu#7382 in a direct message on the Node Operator Discord Channel.   

## Content of Staking Transaction

- Amount (The amount of MPC Tokens you are staking)

## Content of the Register Transaction

- Name (Legal name)
- Website (Company or personal webpage)
- Address (Company or personal address)
- PublicKey (PublicKey of your Network keyset) - - the form generates the public key when you sign with the Netwok private key.
- BLS PublicKey (BLS12-381 PublicKey of your BLS keyset) - the form generates the BLS public key when you sign with the BLS private key.
- EntityJurisdiction (Your country of residence - ISO 3166-1: 3-digit code referring to a country)
- ServerJurisdiction (Location of the server where you operate the node - ISO 3166-1: 3-digit code referring to a country)

**NB.** You can change your public information from the Register Transaction by doing an [Update Transaction](update-transaction.md)


## Conditions for inclusion

Formal conditions for inclusion in the network is stipulated in the soon-to-be published Yellow Paper (YP_0.95 Ch. 2.3.1 pp. 11-12):

- The public information regarding the node given by the operator must be validated.
- Sufficient stakes committed.
- Test run is successful.
- The transaction fees of Register and Staking Transaction have been paid.