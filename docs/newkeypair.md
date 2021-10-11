# Node operators will need to generate 4 sets of keys



The keys are randomly generated at [KeyGen](https://dashboard.partisiablockchain.com/keygen)

You need three sets of keys from the upper box

The lower box generate BLS keypairs


**The 1st set** is your Node operator account which will hold your stake:  
PrivateKey - This is the private key for config.json.   
BlockchainAddress - The sale address you see on the list of block producers


**The 2end set** is for network authentication and block production:  
PrivateKey - The private key is registered in config.json as networkKey  
PublicKey - The public key is registered in the survey as producer key  


**The 3rd set** is for your KYC account:  
PrivateKey - This is the main private key for your wallet.  
BlockchainAddress - This is the address associated with your KYC  


**The 4th set** needs to be generated with a key generation algorithm for BLS keypair and is in the box below the other set:  
PrivateKey - Goes in the config.json as finalizationKey  
PublicKey - Goes in the survey as Producer key

