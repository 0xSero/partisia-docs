# The PBC Ecosystem

**Welcome to the documentation hub of Partisia Blockchain.**  
Here you can find information that enables you to get the most out of the platform. If you are interested in making money by operating a node, or you want to use PBC as a platform for an app or use smart contracts, then you have come to the right place.  
Below is a small introduction to the some of the core concepts of blockchains and an explanation of what make PBC different from other blockchains. On webpage you can find topic specific guides that will help you to interact with PBC and get the maximal utility of our platform.


### What is a blockchain

Blockchains are a means to make an immutable record of transactions on a decentralized database. This makes blockchains a useful place to record important information e.g. of a financial, medical or legal nature.  
A blockchain is a public database where any update is added sequentially. Since all information is time stamped. You can add information in the present, but you cannot edit past information. In this way a blockchain creates an immutable ledger.

The name blockchain means that information added to the ledger comes in discrete bundles called blocks. A block points to the block before it. That way a chain is created that connects the changes on the ledger from the beginning to the present.
The blocks are connected cryptographically. The hash of each block is produced as a function of the hash of the transactions and the hash of the previous block.  

![Diagram0](blockchain.jpg)  

A blockchain exists on a distributed network of computers called [nodes](whatisano.md). Changes to the database happens to all the computers on the network through a secure [consensus mechanism](consensus.md). In a traditional centralized database you just need to hack or compromise one computer and the integrety of all content on that database would be in jeopardy.  
Conversely, a blockchain is a decentralized database. Therefore, data on the blockchain remains secure even if a computer in the network is hacked, short circuits or loose connection to the internet. 
### What happens when I use a blockchain
In the following paragraph we will examine user interactions with the blockchain using a purchase of an NFT as our case example. We will explore how a user action like purchase of NFTs affect the blockchain on different levels.  
On the surface level your phone or computer is connected to the internet. Apps and webpages can get you in contact with the blockchain through the internet just like using any other online service like e-mail.   

![Diagram1](surface.jpg)  

The Partisia blockchain lives on a network of computers connected to each other through the internet. The blockchain comes with a software architecture which allows for binding trackable transactions to happen very fast.
A puchase of an NFT is a transaction on the blockchain. Specifically it is an action of an active [smart contract](contract-development.md). 

![Diagram2](Contract.jpg)

Smart contracts hold some information which can be changed, that information is called the state. The state of our NFT contract holds an inventory of NFTs and their owners. The contract action *Transfer* can change the ownership of an NFT by changing an owner address in the inventory. Actions of contracts are themselves transactions on the blockchain. When they have been added to a block and executed, the resulting state change of the contract becomes part of the blockchain state. We now have a permanent timestamped record of the purchase.
### What is special about Partisia Blockchain? - A privacy preserving blockchain

The advantages of a public blockchain comes with a tradeoff. The fact that everything that happens on the public blockchain is added to a permanent record limits the scope of their use. You can only use a public ledger for things you want everyone to know. Imagine you want to make use of the public blockchain to prevent voter fraud in a general election. The public blockchain can give you a transparent election without fraud, but the price will be compromising the privacy of the voters.

Partisia Blockchain comes with an extra privacy layer. This allows for [zero knowledge computations](https://medium.com/partisia-blockchain/mpc-techniques-series-part-8-zero-knowledge-proofs-what-are-they-and-what-are-they-good-for-2f39ed0eab39) to happen in parallel with the activities on the public blockchain. For our example that would mean that PBC could provide an election without the possibility of voter fraud and at the same time keep all votes secret. This way PBC expands the scope of use for a blockchain into much broader domains.  
For zero knowledge computation to happen simultaneous with the public activities on the blockchain it is necessary to allocate part of the nodes of the network to focus on these tasks. To increase security of these services even further nodes that partake in them are selected through an economic staking model. This means that the owners of the computers handling the sensitive data has a common interest with the users of Partisia Blockchain to protect the data and preserve their privacy. 

### Find out more

[**What is a node operator?**](whatisano.md)

[**How does the economy of PBC work?**](byoc.md)

[**What is a smart contract?**](contract-development.md)

[**How can I add zero knowledge computation to a smart contract?**](vickrey.md)
