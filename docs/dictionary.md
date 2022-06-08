# Terms commonly used in relations to Partisia technology and infrastructure


### ABI
Application binary interface, it is needed when deploying a smart contract. An ABI helps the blockchain interpret the binary version of the contract file.

### Account
Every user on Partisia Blockchain has an account. The account holds your balance of gas and MPC Tokens. You can read more about accounts and how they work [here](accounts.md).

### Baker Node
A node performing baker services, but not ZK or Oracle services.

### Blocks
A block is the basic component of the blockchain ledger. Each block contains a batch of valid [transactions](transactions.md) and [events](events.md) that have been executed at a given *block time*. The block time is incremental. The chain is started with a genesis block that defines the initial state of the blockchain. Each block has a reference to its parent block thus forming a chain all the way back to the genesis block. Read more [here](block.md).

### BP Node
Block producing node. All nodes in the current [committee](https://mpcexplorer.com/validators) are block producers. However, production is turn based. Only one node is chosen as producer at the time.

### BYOC 
Bring your own coin, basically the idea, that you can bring a myriad of liquid currencies to PBC and interact with them through contracts.

### Consensus Node
A node participating in the [FastTrack Consensus](consensus.md)

### Smart Contracts  
A contract is a program that sends information to the blockchain.

### Flooding Network 
A computer network where every node distributes packets to all it neighbors

### Large Oracle
A reference to the entire committee when performing some vital task involving MPC, E.G. forming a new committee.

### MPC
Secure multiparty computation (for the token see MPC token). The privacy layer of Partisia Blockchain utilizes several zero knowledge protocols. Most notably MPC.

### MPC Node
A node in the PBC network which has been allocated for doing an MPC protocol.

### MPC Token 
It is in a sense a cryptocurrency, but not liquid like Ethereum og Bitcoin

### MPC Wallet
There is a [wallet extension](https://chrome.google.com/webstore/detail/partisia-wallet/gjkdbeaiifkpoencioahhcilildpjhgh) for the Google Chrome Browser. It allows for deployment and interactions with contracts, when connected with the [MPC Explorer](https://mpcexplorer.com/). 

### NFT 
A technology which allows proof of ownership, and can thereby help ensure intellectual property rights for digital products.

### Node 
A machine or virtual machine linked in the network. See more [here](whatisano.md)

### Oracle Node
A node performing oracle services. These nodes are responsible for processes related to transfer, deposit and withdrawal of BYOC.

### PBC 
Partisia Blockchain, read more about what seperates PBC from other blockchains [here](introduction.md).

### PBC Account
Same as *Account*, see entry above.

### PBC Ledger 
The immutable record or ledger, where you can see transactions that have already taken place.

### Public Key Cryptography
Public-key cryptography is a form of cryptography that uses pairs of keys: A public key that may be shared with anyone and a private key that must be kept secret. Read more [here](keys.md).

### Reader Node
A node that reads the state of the blockchain, but does not produce blocks or any other paid services. It is free to [run a reader node](operator-2-reader.md).

### Rest Server
An infrastructure that allows for individual servers in a network to be offline without the remaining servers to be affected. 

### Shards
The feature that allows PBC to be scalable. read more [here](shards.md)


### Token Bridges
The feature that allows you to deposit and withdraw BYOC. Partista Blockchain has a decoupled token economy. That means services are paid for using liquid tokens from other blockchains. You can deposit these outside cryptocurrencies on your account using the token bridge. This allows you to pay the gas cost of transaction. You need gas when you deploy or interact with contracts. Doing a token transfer, staking MPC tokens are examples of transaction you can do from the MPC Explorer and Dashboard. To perform these types of actions you first need to deposit gas into your wallet. See [BYOC](byoc.md).

### Transactions
A transaction is an instruction from a user containing information used to change the state of the blockchain. Read more [here](transactions.md)

#### WASM
Abbreviation for WebAssembly, a standardized binary code format which is used for the smart contracts deployed at PBC.
