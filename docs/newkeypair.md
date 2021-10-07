# Node operators need to generate 3 sets of keys

Every node operator needs to have updated their config.json and resubmitted the survey by October 11th at 10 UTC

The keys are randomly generated at https://dashboard.partisiablockchain.com/keygen

You need two sets of keys from the upper box

The lower box generate BLS keypairs


- **The 1st set** is your account, registered during KYC:  
*PrivateKey* - This is the private key for config.json. This is also the key used to login to the wallet.   
*BlockchainAddress* - The sale address you see on the list of block producers

- **The 2end set** is for network authentication and block production
*PrivateKey* - The private key is registered in config.json as networkKey  
*PublicKey* - The public key is registered in the survey as producer key

- **The 3rd set** needs to be generated with a key generation algorithm for BLS keypair. and is in the box below the other set  
*PrivateKey* - Goes in the config.json as finalizationKey  
*PublicKey* - Goes in the survey as finalization key
