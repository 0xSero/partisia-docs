# Node operators will need to generate 3 sets of keys



The keys are randomly generated at [KeyGen](https://dashboard.partisiablockchain.com/keygen)

You need two sets of keys from the upper box (**NB.** you get the 1st keyset when you go through the KYC process and get your PBC account)

You need one set from the lower box which generate BLS keypairs




**The 1st set**  are Account keys of your PBC account, that you get through KYC the process:
PrivateKey - This is the private key for your PBC account that holds the MPC Tokens that you are staking.
BlockchainAddress - This is the address associated with your PBC account. It is listed in the Register Transaction as "Identity"

**The 2nd set** are Network Keys for network identification:   
PrivateKey - The private key is registered in config.json as "networkKey"  
PublicKey - This is the public key of your PBC account it goes in the Register Transaction as "PublicKey"

**The 3rd set** needs to be generated with a key generation algorithm for BLS keypair and is in the box below the other set:  
PrivateKey - Goes in the config.json as "finalizationKey"  
PublicKey - Goes in the Register Transaction as "BLS PublicKey"
