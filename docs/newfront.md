# The PBC Ecosystem

**Welcome to the documentation page of Partisia Blockchain.**  
Here you can find information that enables you to get the most out of PBC. If you are interested in making money by operating a node, or you want to use PBC as a platform for an app or use smart contracts, then you have come to the right place.  
Below is a small introduction to the some of the core concepts of blockchains and an explanation of what make PBC different from other blockchains. On webpage you can find topic specific guides that will help you to interact with PBC and get the maximal utility of our platform.


### What is a blockchain

Blockchains are a means to make an immutable record of transactions on a decentralized database. This makes blockchains a useful place to record important information e.g. of a financial, medical or legal nature.  
A blockchain is a public database where any update is added sequentially. Since all information is time stamped. You can add information in the present, but you cannot edit past information. In this way a blockchain creates an immutable ledger.

The name blockchain means that information added to the ledger comes in discrete bundles called blocks. A block points to the block before it. That way a chain is created that connects the changes on the ledger from the beginning to the present.
The blocks are connected cryptographically. The hash of each block is produced as a function of the hash of the transactions and the hash of the previous block.  

![Diagram0](blockchain.jpg)  

A blockchain exists on a distributed network of computers called [nodes](whatisano.md), therefore it does not rely on a single point like a centralized database and this eliminates the problem of trusting the database. A breach of one point in a distributed database still leaves the majority of servers intact and consequently the control of the data remains in the network.

### What happens when I use a blockchain
One very popular way in which users interact with the blockchain is to buy NFTs. In the illustrations below you can see how the user action affect the blockchain.  
On the surface level your phone or computer is connected to the internet. Apps and webpages can get you in contact with the blockchain through the internet just like using any other online service like e-mail.   

![Diagram1](surface.jpg)  

The Partisia blockchain lives on a network of computers connected to each other through the internet. When you use an app to facilitate a transaction on the blockchain the transaction is first validated by the network, then it is put in a package with other incoming transactions called a block. The transactions are then executed by the computers on the network. When the block's transactions has been validated and executed by a 2/3 majority, next block is introduced, when that block has been through the same process, then our transaction is finalized. This means that it is on an immutable record. In our example of an buying an NFT, this would mean that there is a timestamped unchangable record of that purchase, proving the ownership.  

![Diagram2](conceptualchange.jpg)

If we move down to a more technical level the transaction of buying the NFT is an expression of a change of state of an active [smart contract](contract-development.md). The contract related to the NFT has actions available such as transferring the NFT to the users [account](accounts.md). When our transaction invoke the transfer of the NFT to the user's account, the contract state *balances* change. The token balance of the user now includes the NFT.


````json
#[state]
pub struct TokenContractState {
    symbol: [u8; 16],
    owner: Address,
    total_supply: u64,
    balances: BTreeMap<Address, u64>,
}
````


### What is special about Partisia Blockchain? - A privacy preserving blockchain

The advantages of a public blockchain comes with a tradeoff. The fact that everything that happens on the public blockchain is added to a permanent record limits the scope of their use. You can only use a public ledger for things you want everyone to know. Imagine you want to make use of the public blockchain to prevent voter fraud in a general election. The public blockchain can give you a transparent election without fraud, but the price will be compromising the privacy of the voters.

Partisia Blockchain comes with an extra privacy layer. This allows for [zero knowledge computations](https://medium.com/partisia-blockchain/mpc-techniques-series-part-8-zero-knowledge-proofs-what-are-they-and-what-are-they-good-for-2f39ed0eab39) to happen in parallel with the activities on the public blockchain. For our example that would mean that PBC could provide an election without the possibility of voter fraud and at the same time keep all votes secret. This way PBC expands the scope of use for a blockchain into much broader domains.  
For zero knowledge computation to happen simultaneous with the public activities on the blockchain it is necessary to allocate part of the nodes of the network to focus on these tasks. To increase security of these services even further nodes that partake in them are selected through an economic staking model. This means that the owners of the computers handling the sensitive data has a common interest with the users of Partisia Blockchain to protect the data and preserve their privacy. 

### Find out more

[**What is a node operator?**](whatisano.md)

[**How does the economy of PBC work?**](byoc.md)

[**What is a smart contract?**](contract-development.md)

[**How can I add zero knowledge computation to a smart contract?**](vickrey.md)
