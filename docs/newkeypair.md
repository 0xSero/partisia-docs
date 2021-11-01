# Node operators will need to generate 4 sets of keys



The keys are randomly generated at [KeyGen](https://dashboard.partisiablockchain.com/keygen)

You need three sets of keys from the upper box

You need one  set from the lower box generate which BLS keypairs


**The 1st set** is your Node operator account which will hold your stake:  
PrivateKey - This is the private key for config.json. Registered in config.json as "accountKey".   
BlockchainAddress - The Baker address you see on the list of block producers on the dashboard, registered in the survey as "Blockchain address for Node operator account"


**The 2nd set** is for network authentication and block production:  
PrivateKey - The private key is registered in config.json as "networkKey"  
PublicKey - The public key is registered in the survey as "Public key for block production"


**The 3rd set** is for your KYC account:  
PrivateKey - This is the main private key for your wallet.  
BlockchainAddress - This is the address associated with your KYC. It is registered in the survey as "Blockchain address from sale"  


**The 4th set** needs to be generated with a key generation algorithm for BLS keypair and is in the box below the other set:  
PrivateKey - Goes in the config.json as "finalizationKey"  
PublicKey - Goes in the survey as "Producer key (BLS12-381)"

