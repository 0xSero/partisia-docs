# Terms commonly used in relations to Partisia technology and infrastructure


### ABI
An ABI (application binary interface) - helps applications which need to communicate with the smart contract to do this in a correct manner. The ABI gives the application a descriptions of what type of data the contract contains and what actions it has to offer. Example´: an application interacts with a ERC20 token contract, the ABI lets the application know, that the contract has the action *transfer*.

### Account
Every user on Partisia Blockchain has an account. The account has an address and a nonce. It holds your balance of gas and MPC Tokens. You can read more about accounts and how they work [here](accounts.md).

### Baker Node
An upgraded Reader node whitelisted to participate in the Consensus layer. Whitelisting consist of a KYC process connected to token sale as well as an approval of public information in the node registration. A baker node must have staked sufficient (25000 MPC) to perform baker services - producing and signing blocks.

### Blocks
A block is the basic component of the blockchain ledger. Each block contains a batch of valid [transactions](transactions.md) and [events](events.md) that have been executed at a given *block time*. The block time is incremental. The chain is started with a genesis block that defines the initial state of the blockchain. Each block has a reference to its parent block thus forming a chain all the way back to the genesis block. Read more [here](block.md).

### BYOC 
The Partisia blockchain has a decoupled token economy this means that the native token (MPC Token) is not used to pay for on chain services, consequently price of MPC tokens do not affect the cost of using PBC. Instead, you pay with liquid cryptocurrencies from other blockchains, therefore aptly name "bring your own coin" (BYOC). When you deposit the BYOC a twin is minted, which can interact with PBC. Oracle nodes ensures that BYOC twins match actual stable coin on native chain. When a transaction is paid for by a user that payment covers the fee for the node operators which implement the change on the chain.

### Flooding Network 
A computer network where every node distributes packets to all it neighbors. In a blockchain blocks are propagated using a flooding protocol, which means nodes send the blocks they have processed and signed to all their peers for further validation.

### Large Oracle
After each epoch (When all baker nodes have had their turn as producers) a large Oracle consisting of all Baker nodes or the blockchain as a whole
ensures that the risk managed by the small Oracle in the latest epoch is contained. The large oracle sign off on new small oracle (the oracle nodes which have perform services relating to BYOC). Large oracle also signs when the committee change.

### MPC
Secure multiparty computation (for the token see MPC token). The privacy layer of Partisia Blockchain utilizes several zero knowledge protocols. Most notably MPC. MPC allows for calculation on private date, where you can get the result of the calculation public and keep the private data secure at the same time. A simple example of this could be calculation of average salary in a company. You do not want to disclose your own income, but it would be nice to know if you make more or less than the average. Instead of sneding your private data to your peers you can send a random bite (share) of the private data out to several peers. They do the same. When doing the calculation no salaries are revealed but the total sum of the numbers is the same. So, you get the correct result even though the calculation is done on the data in a randomised form.

### MPC Token 
MPC Tokens is part of the decoupled token economy of PBC, their primary purpose is for staking. When staking MPC tokens above specific thresholds you are allowed operate a node that performs different services on the chain. Tokens can be slashed in case of malicious behaviour. For that reason staked MPC Tokens gives an incentive for good behaviour quality performance among the node operators keeping the blockchain running. Because MPC Tokens are used for staking only, and not as form of payment for services the token value does not have adverse effects on supply or demand of services on chain as you see on other blockchains.   

### MPC Wallet
PBC offers a webwallet which allows your account to interact with the blockchain. The wallet is installed as a browser extension (currently only in the Chrome Browser). You import your account information into the wallet by connecting it to the account either using your account private key or mnemonic phrase. When the wallet has updates it can sometimes be necessary to create a new password and reimport the account information. The wallet can be used for creating additional accounts and for confirm payment of transaction costs when deploying smart contracts or interacting with smart contracts. The wallet allows for deployment and interactions with contracts, when connected with the [MPC Explorer](https://mpcexplorer.com/). Click [here](https://chrome.google.com/webstore/detail/partisia-wallet/gjkdbeaiifkpoencioahhcilildpjhgh) to get the wallet extension now.

### NFT 
A non-fungible-token. Non-fungible means that it is unique unlike other types of tokens such as cryptocurrencies . The ownership is of an NFT is stored on a blockchain. They can be sold and transferred. The NFT can contain a reference to a digital file like a photo, and can be used as a proof of ownership. This is useful to proof ownership of digital content, because the blockchain not only stores the ownership but also timestamps so you have a strong proof of owning the original file.

### Node 
Nodes are the computers in the blockchain network. The nodes run the blockchain software and are connected to each other through the internet.  They perform services for the users of the blockchain, foremost they facilitate the transactions that happens on the blockchain. From the transaction costs paid by users, the node operator can make revenue. Read more about the different types of [here](whatisano.md)

### Oracle Node
A node performing oracle services. These nodes are responsible for processes related to transfer, deposit and withdrawal of BYOC. Smart contracts can only utilize on-chain data. But the contracts can relate to events with consequences outside the blockchain. If a user purchase an auctioned item on PBC for BYOC (ETH), the oracle nodes will have to facilitate and confirm changes on the Ethereum network. Oracle nodes work as a bridge connecting data on the native blockchain PBC to outside sources for example other blockchains.

### PBC 
Partisia Blockchain, read more about what seperates PBC from other blockchains [here](introduction.md).

### PBC Account
Same as *Account*, see entry above.

### PBC Ledger 
The immutable record or ledger, that keeps track of transactions that have already taken place. there is a copy of the ledger on all nodes.

### Public Key Cryptography
Public-key cryptography is a form of cryptography that uses pairs of keys: A public key that may be shared with anyone and a private key that must be kept secret. Read more [here](keys.md).

### Reader Node
A node that reads the state of the blockchain, but does not produce blocks or any other paid services. It is free to [run a reader node](operator-2-reader.md).

### Rest Server
A rest server is a server that gives access to the REST API- An API conforming to REST architectural properties. The API (application binary interface) are the set of definitions for how to integrate software with the existing system. The API set the rules for interaction between the network and the application.

### Shards
PBC distributes the workload to a number of parallel shards. This allows for scalability of the blockchain. Blocks are produced and finalized parallel on each shard. It is important to note that the shards are not separate parallel blockchains. The PBC blockchain ledger is composed of  information on all shards. So contracts deployed on different shards can still interact with each other across shards. The consequence of shards is an extremely fast and efficient blockchain which can be scaled up with more shards if the demand arise. Together with the fast track consensus protocol the type of sharding used by PBC is a unique feature which resolves the blockchain scalability problem. You can read more about sharding on PBC [here](shards.md).

### Smart Contracts
A contract is a program that sends information to the blockchain.

### Token Bridges
The feature that allows you to deposit and withdraw BYOC. Partista Blockchain has a decoupled token economy. That means services are paid for using liquid tokens from other blockchains. You can deposit these outside cryptocurrencies on your account using the token bridge. This allows you to pay the gas cost of transaction. You need gas when you deploy or interact with contracts. Doing a token transfer, staking MPC tokens are examples of transaction you can do from the MPC Explorer and Dashboard. To perform these types of actions you first need to deposit gas into your wallet. See [BYOC](byoc.md).

### Transactions
A transaction is an instruction from a user containing information used to change the state of the blockchain. Read more [here](transactions.md)

#### WASM
Abbreviation for WebAssembly, a standardized binary code format which is used for the smart contracts deployed at PBC.
