#Register your node

The final step in becoming a block producer in the Partisia Blockchain is the registration. This is done by committing a stake of MPC Tokens and sending a registration form. Both are done with transaction you can perform in the [Partisia Blochain Explorer](https://mpcexplorer.com/node-register).

1) You need the [MPC Wallet extension](https://chrome.google.com/webstore/detail/partisia-wallet/gjkdbeaiifkpoencioahhcilildpjhgh) for your browser.   
2) You need to be able to cover gas costs of transaction, click [here](byoc.md) for help to get gas in your account.   
3) Go to the [Partisia Blochain Explorer](https://mpcexplorer.com/node-register). Log in.    
4) Stake MPC Tokens: Put your PBC address in the search bar, then you get your account information. There is a staking button next to your balance of MPC Tokens.   
5) Click *Register Node* Connect your MPC Wallet by clicking *Connect Wallet*.    
6) Send Register Transaction.   
7) Send the public IP of the server hosting the node and your PBC account address to @Kristian Hu#7382 in a direct message on the Node Operator Discord Channel.   

## Content of Staking Transaction

- Amount (The amount of MPC Tokens you are staking)   

## How to fill out the form for the Register Transaction

You need the same 3 private keys you have put in the `config.json`. You use the private key of your account to log into your wallet and the Explorer. The form generates the public versions of the network and finalization key when you put in the private version. The registration ensures that your account and tokens are associated with your node. Also, it creates a profile with public information about your node. For this reason it is important to put trustworthy information in this form. IP is cross-checked with server jurisdiction and address with entity jurisdiction. Mismatched information will not be approved.      


- Name (Legal name)   
- Website (Company or personal webpage - do not use Partisia in domain name)   
- Address (Company or personal address)   
- Put in network private key   
- Put in finalization private key (The BLS key)   
- EntityJurisdiction (Node owner's (company or person) country of residence - [ISO 3166-1](https://en.wikipedia.org/wiki/ISO_3166-1): 3-digit code referring to a country)   
- ServerJurisdiction (Location of the server where you operate the node - ISO 3166-1: 3-digit code referring to a country)     

**NB.** You can change your public information from the Register Transaction by doing an [Update Transaction](update-transaction.md)   


## Conditions for inclusion

Formal conditions for inclusion in the network is stipulated in the soon-to-be published Yellow Paper (YP_0.95 Ch. 2.3.1 pp. 11-12):   

- The public information regarding the node given by the operator must be validated.   
- Sufficient stakes committed.   
- Test run is successful.   
- The transaction fees of Register and Staking Transaction have been paid.   