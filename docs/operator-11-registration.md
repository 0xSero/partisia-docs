#Register your node

The final step in becoming a block producer in the Partisia Blockchain is the registration. This is done by committing a stake of MPC Tokens and sending a registration form. Both are done with transaction you can perform in the [Partisia Blochain Explorer](https://mpcexplorer.com/node-register).

1) You need the [MPC Wallet extension](https://chrome.google.com/webstore/detail/partisia-wallet/gjkdbeaiifkpoencioahhcilildpjhgh) for your browser.   
2) You need to be able to cover gas costs of transaction, click [here](byoc.md) for help to get gas in your account.   
3) For this your KYB must be verified (you will have received a verification e-mail). You need to get your Synapse Session ID.
   - Log in to https://partisiablockchain.synaps.me/ (using Chrome)   
   - Ctrl+Shift+i (To inspect page)   
   - Click Networks (refresh page)   
   - Click Fetch XHR   
   - Click the partisia bucket   
   - Copy session ID    

4) Go to the [Partisia Blochain Explorer](https://mpcexplorer.com/node-register). Log in.    
5) Log in to your account. Click upper right corner (View activity). This will take you to your account page.   
6) Click on *Node register* on the menu bar and then click on *Manage MPC Tokens*. From there, click *Stake MPC Tokens* and stake 25k or more tokens to your account.     
7) Click Register or Update tab on the menu and fill out the registration information (details below)    
8) Send Register Transaction.     


## Content of Staking Transaction

- Amount (The amount of MPC Tokens you are staking)   

## How to fill out the form for the Register Transaction

You need the same 3 keypairs that you used in the `config.json`. You use the private key of your account to log into your wallet and the Explorer.  The registration ensures that your account and tokens are associated with your node. Also, it creates a profile with public information about your node.     
 
- Session ID from [Synaps KYB](https://partisiablockchain.synaps.me/)   
- Finalization private key in the form called BLS Signing key   
- Network public key   
- Website   
- ServerJurisdiction (pick location from slide down menu)      


**NB.** You can change your public information from the Register Transaction by doing a new registration transaction.   


## Conditions for inclusion

Formal conditions for inclusion in the network is stipulated in the Yellow Paper [YP_0.98 Ch. 2.3.1 pp. 11-12](https://drive.google.com/file/d/1OX7ljrLY4IgEA1O3t3fKNH1qSO60_Qbw/view):   

- The public information regarding the node given by the operator must be verified by Synaps.    
- Sufficient stakes committed.    
- The transaction fees of Register and Staking Transaction have been paid.   
