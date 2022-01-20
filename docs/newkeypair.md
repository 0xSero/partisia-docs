# Node operators will need to generate 3 sets of keys



The keys are randomly generated at [KeyGen](https://dashboard.partisiablockchain.com/keygen)

You need two sets of keys from the upper box (**NB.** you get the 1st keyset when you go through the KYC process and get your PBC account)

You need one set from the lower box which generate BLS keypairs




**The 1st set**  are Account keys of your PBC account, that you get through KYC the process:  
PrivateKey - This is the private key for your PBC account that holds the MPC Tokens that you are staking. When you use the wallet to send the Register Transaction, the transaction is signed with this key. Goes in config.json as "accountKey" unless you are operating a genesis node, then you put the private key referring to the account you have chosen to hold your stake as "accountKey".  
BlockchainAddress - This is the address associated with your PBC account. When you send the Register Transaction it is automatically registered as your "Identity" when you sign the transaction.

**The 2nd set** are Network Keys for network identification:   
PrivateKey - The private key is registered in config.json as "networkKey"  
PublicKey - This is the public key of your PBC account it goes in the Register Transaction as "PublicKey"

**The 3rd set** needs to be generated with a key generation algorithm for BLS keypair and is in the box below the other set:  
PrivateKey - Goes in the config.json as "finalizationKey"  
PublicKey - Goes in the Register Transaction as "BLS PublicKey"
