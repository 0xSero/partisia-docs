# Node operators will need 3 sets of keys

In the next two pages you will see how to fill out a config.json for a block producing node and how to register your node for block production on Partisia Blockchain. Before you can do that you need 3 private keys.

1) Find your PBC account private key and PBC address.    
2) Generate The Network key pair.   
3) Generate the Finalization key pair.   

The network and finalization keypair are randomly generated at [KeyGen](https://dashboard.partisiablockchain.com/keygen).

### Functions of the keys and where to use them:

You only need the private keys for the node configuration and registration. **It is essential to keep private keys safe, since they cannot be recovered. Do not safe them on your server, store them on something physical where you always have access** Public keys and addresses are generated as a function of the private key and can be recovered if forgotten. Nonetheless, you should the public keys as well for practical purposes. You PBC address works as your public identity on the blockchain, you use it to find your node performance in metrics. Active block producers on PBC are [listed](https://mpcexplorer.com/validators) and identified with by address. So you will be using it a lot.   

**The 1st set**  are Account keys of your PBC account, that you get through KYC the process:  
Account Private key - This is the private key for your PBC account that holds the MPC Tokens that you are staking. When you use the wallet to send the Register Transaction, the transaction is signed with this key. Goes in config.json as "accountKey" unless you are operating a genesis node, then you put the private key referring to the account you have chosen to hold your stake as "accountKey".  
PBC address - This is the address associated with your PBC account. When you send the Register Transaction it is automatically registered as your "Identity" when you sign the transaction.   

**The 2nd set** are Network Keys for network identification:   
Network PrivateKey - The private key is registered in config.json as "networkKey"  
Network PublicKey - Store for practical purposes

**The 3rd set** needs to be generated with a key generation algorithm for BLS keypair and is in the box below the other set:   
Finalization PrivateKey - Goes in the config.json as "finalizationKey"     
Finalization PublicKey - Store for practical purposes   
