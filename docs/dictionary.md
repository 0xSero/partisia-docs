# Terms commonly used in relations to Partisia technology and infrastructure


### ABI
An ABI (application binary interface) - helps applications which need to communicate with the smart contract to do this in a correct manner. The ABI gives the application a descriptions of what type of data the contract contains and what actions it has to offer. Example´: an application interacts with a ERC20 token contract, the ABI lets the application know, that the contract has the action *transfer*.

### Account
Every user on Partisia Blockchain has an account. The account has an address and a nonce. It holds your balance of gas and MPC Tokens. You can read more about accounts and how they work [here](accounts.md).

### Baker Node
A node which have staked sufficient to perform baker services. But does not have enough staked to perform ZK or oracle services. A baker node produces and signs blocks.

### Blocks
A block is the basic component of the blockchain ledger. Each block contains a batch of valid [transactions](transactions.md) and [events](events.md) that have been executed at a given *block time*. The block time is incremental. The chain is started with a genesis block that defines the initial state of the blockchain. Each block has a reference to its parent block thus forming a chain all the way back to the genesis block. Read more [here](block.md).

### BP Node
Block producing node. All nodes in the current [committee](https://mpcexplorer.com/validators) are block producers. Only one node is chosen as producer at a given time on each shard. Block producing nodes can perform 3 types of services: baker service, ZK service and oracle service. Baker service consist of producing and signing blocks. ZK service involves performing zero knowledge computations of zero knowledge smart contracts. Oracle services bridges data between on-chain and off-chain sources.

### BYOC 
The Partisia blockchain has a decoupled token economy this means that the native token (MPC Token) is not used to pay for on chain services, consequently price of MPC tokens do not affect the cost of using PBC. Instead, you pay with liquid cryptocurrencies from other blockchains, therefore aptly name "bring your own coin" (BYOC). When you deposit the BYOC a twin is minted, which can interact with PBC. Oracle nodes ensures that BYOC twins match actual stable coin on native chain. When a transaction is paid for by a user that payment covers the fee for the node operators which implement the change on the chain.

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
MPC Tokens is part of the decoupled token economy of PBC, their primary purpose is for staking. When staking MPC tokens above specific thresholds you are allowed operate a node that performs different services on the chain. Tokens can be slashed in case of malicious behaviour. For that reason staked MPC Tokens gives an incentive for good behaviour quality performance among the node operators keeping the blockchain running. Because MPC Tokens are used for staking only, and not as form of payment for services the token value does not have adverse effects on supply or demand of services on chain as you see on other blockchains.   

### MPC Wallet
There is a [wallet extension](https://chrome.google.com/webstore/detail/partisia-wallet/gjkdbeaiifkpoencioahhcilildpjhgh) for the Google Chrome Browser. It allows for deployment and interactions with contracts, when connected with the [MPC Explorer](https://mpcexplorer.com/). 

### NFT 
A technology which allows proof of ownership, and can thereby help ensure intellectual property rights for digital products.

### Node 
A machine or virtual machine linked in the network. See more [here](whatisano.md)

### Oracle Node
A node performing oracle services. These nodes are responsible for processes related to transfer, deposit and withdrawal of BYOC. Smart contracts can only utilize on-chain data. But the contracts can relate to events with consequences outside the blockchain. If a user purchase an auctioned item on PBC for BYOC (ETH), the oracle nodes will have to facilitate and confirm changes on the Ethereum network. Oracle nodes work as a bridge connecting data on the native blockchain PBC to outside sources for example other blockchains.

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
