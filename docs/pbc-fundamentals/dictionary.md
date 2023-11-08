# Dictionary

### ABI

An ABI (application binary interface) helps applications which need to communicate with the smart contract to do this in a correct manner. The ABI gives the application a descriptions of what type of data the contract contains and what actions it has to offer. Example´: an application interacts with a ERC20 token contract, the ABI lets the application know, that the contract has the action _transfer_.

### Account

Every user on Partisia Blockchain has an account. The account has an address and a nonce. It holds your balance of gas and MPC Tokens. You can read more about accounts and how they work [here](../pbc-fundamentals/create-an-account.md).

### Address

An addresses on PBC is a unique number that identifies the recipients and senders of transactions. User accounts and smart contracts can be senders and recipients of transactions and hence both have addresses. The address is a hexadecimal number derived from the public key. You use addresses when you deposit or withdraw BYOC. And when you transfer tokens to other accounts. Deployed contracts shows the owners account address and the contract address. In public node information the address refers to the geographical address of the entity (person or company) operating the node.

### Baker Node

Baker nodes perform baker services - they produce and sign blocks. You can get a baker node by upgrading the config of your reader node and get whitelisted to participate in the Consensus layer. Whitelisting consist of a KYC process connected to token sale as well as an approval of public information in the node registration. A baker node must have staked sufficient (25000 MPC) to perform baker services.

### Block

A block is the basic component of the blockchain ledger. Each block contains a batch of valid [transactions](dictionary.md#transactions) and [events](dictionary.md#event-transactions) that have been executed at a given _block time_. The block time is incremental. The chain is started with a genesis block that defines the initial state of the blockchain. Each block has a reference to its parent block thus forming a chain all the way back to the genesis block.

A block is produced by a block producer. When a block is produced the transactions and events are executed and the resulting state is stored as the current state. The produced block is then validated by the committee according to the currently running [consensus protocol](../pbc-fundamentals/consensus.md).

### Block (height, number, time)

On each shard blocks have a number being incremented since the first block. This number is referred to as height in MPC Explorer. You can imagine the blocks being stacked on top of each other. If you combine the block's number with shard number, then each block has an unambiguous identity. A specific block points to a shard and a time, so the number is also sometimes referred to as block time, since the order in which a block is produced also works as a reference in time.

### Bridge

Cross-chain bridges connect the Partisia Blockchain with other blockchains, enabling information and assets to flow between the two chains. One example of a bridge is the [BYOC bridge](https://bridge.mpcexplorer.com/), the feature that allows you to deposit and withdraw BYOC. Partista Blockchain has a decoupled token economy. That means services are paid for using liquid tokens from other blockchains. You can deposit these outside cryptocurrencies on your account using the token bridge. This allows you to pay the gas cost of transaction. You need gas when you deploy or interact with contracts. Doing a token transfer, staking MPC tokens are examples of transaction you can do from the MPC Explorer and Dashboard. To perform these types of actions you first need to deposit gas into your wallet. For more information see [BYOC](byoc/introduction-to-byoc.md). Or to go directly to the bridge - click [here](https://bridge.mpcexplorer.com/).

### BYOC

The Partisia blockchain has a decoupled token economy this means that the native token (MPC Token) is not used to pay for on chain services, consequently price of MPC tokens do not affect the cost of using PBC. Instead, you pay with liquid cryptocurrencies from other blockchains, which is aptly name "bring your own coin" (BYOC). When you deposit the BYOC a twin is minted, which can interact with PBC. Oracle nodes ensures that BYOC twins match actual coins on the native chain. When a transaction is paid for by a user that payment covers the fee for the node operators which implement the change on the chain. Read more [here](byoc/introduction-to-byoc.md).

### ETH

The name of the native token of the Ethereum blockchain. It is a liquid cryptocurrency. On Partisia Blockchain you can pay for transactions using outside cryptocurrencies [(BYOC)](byoc/introduction-to-byoc.md). ETH was the first BYOC on PBC, but soon USDC will also be available.

### Event transactions

An event transaction is a special type of transaction that is spawned during the execution of another transaction. Events are used to communicate across different contracts and/or shards.

Events have the same basic properties as ordinary transactions. Events are sent through the flooding network and have the same validity rules as ordinary transactions. When a transaction is executed the network and CPU fees are collected, the rest of the cost is distributed evenly between any events said transaction spawns. Events are executed the same way as ordinary transactions meaning they can _also_ spawn events. This means one can implement asynchronous, indefinite recursion which will eventually terminate since the events will run out of gas to pay the fees.

Event transactions are instrumental in enabling cross-shard transactions since they can be routed by the blockchain to their respective destination shard. A routed event transaction is enriched with a finalization proof and routed based on the routing table in the chain state. For more details see [Shards](../pbc-fundamentals/sharding.md).

### Flooding Network

A computer network where every node distributes packets to all it neighbors. In a blockchain blocks are propagated using a flooding protocol, which means nodes send the blocks they have processed and signed to all their peers for further validation.

### Gas

Gas is a small fraction of BYOC. The cost of transactions on PBC is measured in gas. Your account holds your current balance of gas, you can see how much gas you have by viewing you account information in the [MPC Explorer](https://mpcexplorer.com/). The gas cost of using PBC goes to cover the fees to the Node Operators (The people running and maintaining the servers in the blockchain).

### Large Oracle

After each epoch (When all baker nodes have had their turn as producers) a large Oracle consisting of all Baker nodes or the blockchain as a whole
ensures that the risk managed by the small Oracle in the latest epoch is contained. The large oracle sign off on new small oracle (the oracle nodes which have perform services relating to BYOC). Large oracle also signs when the committee change.

### MPC

Secure multiparty computation (for the token see MPC token). The privacy layer of Partisia Blockchain utilizes several zero knowledge protocols. Most notably MPC. MPC allows for calculation on private data, where you can make the result of the calculation public and keep the private data secure at the same time. A simple example of this could be calculation of average salary in a company. You do not want to disclose your own income, but it would be nice to know if you make more or less than the average. Instead of sending your private data to your peers you can send a random bite (share) of the private data out to several peers. They do the same. When doing the calculation no salaries are revealed but the total sum of the numbers is the same. So, you get the correct result even though the calculation is done on the data in a randomised form.

### MPC Token

MPC Tokens is part of the decoupled token economy of PBC, their primary purpose is for staking. When staking MPC tokens above specific thresholds you are allowed operate a node that performs different services on the chain. Tokens can be lost in case of malicious behaviour (conditions stipulated in [Yellow Paper section 2.8, pp. 20-21](https://drive.google.com/file/d/1OX7ljrLY4IgEA1O3t3fKNH1qSO60_Qbw/view)). For this reason staked MPC Tokens gives an incentive for good behaviour among the node operators keeping the blockchain running. Because MPC Tokens are used for staking only, and not as form of payment for services the token value does not have adverse effects on supply or demand of services on chain as you see on other blockchains. Read more [here](../pbc-fundamentals/introduction-to-the-fundamentals.md).

### MPC Wallet

PBC offers a webwallet which allows your account to interact with the blockchain. The wallet is installed as a browser extension. You import your account information into the wallet by connecting it to the account either using your account private key or mnemonic phrase. When the wallet has updates it can sometimes be necessary to create a new password and reimport the account information. The wallet can be used for creating additional accounts and for confirm payment of transaction costs when deploying smart contracts or interacting with smart contracts. The wallet allows for deployment and interactions with contracts, when connected with the [MPC Explorer](https://mpcexplorer.com/). Click [here](https://www.partisiablockchain.com/ecosystem) to get the wallet extension now.

### NFT

A non-fungible-token. Non-fungible means that it is unique unlike other types of tokens such as cryptocurrencies . The ownership is of an NFT is stored on a blockchain. They can be sold and transferred. The NFT can contain a reference to a digital file like a photo.

### Node

Nodes are the computers in the blockchain network. The nodes run the blockchain software and are connected to each other through the internet. Some nodes perform services for the users of the blockchain, foremost they facilitate the transactions that happens on the blockchain. From the transaction costs paid by users, the node operator can make revenue. Read more about the different types of [here](../node-operations/what-is-a-node-operator.md)

### Node operator

A node operator is a person who runs and maintains a node on Partisia Blockchain. PBC has four types of nodes:

- Reader node: A node that only reads the information on the chain and does not perform paid services.
- Baker Node: A node that produces and validates blocks. Revenue is generated from user payment on transactions in the blocks produced and validated by the node.
- ZK Node: A node that performs zero knowledge computations in addition to baker node services.
- Oracle Node: A node that performs oracle services in addition to ZK and baker services.

See requirements of a node operator and how to run a node [here](../node-operations/what-is-a-node-operator.md).

### Nonce

A nonce is a number used only once. Nonces are used to ensure that old messages cannot be reused in replay attacks. In the state of an account on PBC is a nonce, which is incremented every time the account signs a transaction.

### Oracle Node

A node performing oracle services. These nodes are responsible for processes related to transfer, deposit and withdrawal of BYOC. Smart contracts can only utilize on-chain data. But the contracts can relate to events with consequences outside the blockchain. If a user purchase an auctioned item on PBC for BYOC (ETH), the oracle nodes will have to facilitate and confirm changes on the Ethereum network. Oracle nodes work as a bridge connecting data on the native blockchain PBC to outside sources for example other blockchains.

### PBC

Partisia Blockchain (PBC) is the only blockchain that supports secure multiparty computation. This gives PBC a completely unique potential for use for Web. 3.0 technologies where users have control of their own data. Other blockchains can use zero knowledge smart contracts on PBC to add a ZK computational layer to their own chain.

### PBC Account

Same as [Account](../pbc-fundamentals/dictionary.md#account), see entry above.

### PBC Ledger

The immutable record or ledger, that keeps track of transactions that have already taken place. There is a copy of the ledger on all nodes. Partisia Blockchain has sharding, the ledger records the activities on all shards, they are combined to form the complete ledger.

### Public-key cryptography

Public-key cryptography is a form of cryptography that uses pairs of keys: A public key that may be shared with anyone and a private key that must be kept secret. The public and private keys are generated in mathematically connected pairs. The public key can be used to encrypt a message that can be decrypted by the private key, meaning that anyone can send an encrypted message to any recipient assuming they know their public key. PBC uses elliptic curve cryptography, specifically the curve [secp256k1](https://en.bitcoinwiki.org/wiki/Secp256k1).

### Reader Node

A node that reads the state of the blockchain, but does not produce blocks or any other paid services. It is free to [run a reader node](../node-operations/reader-node-on-vps.md).

### Rest Server

A rest server is a server that gives access to the REST API. An API conforming to REST architectural properties. The API (application programming interface) gives the definitions other systems need to read from the blockchain and send new information in the form of transaction.

### Shards

PBC distributes the workload to a number of parallel shards. This allows for scalability of the blockchain. Blocks are produced and finalized parallel on each shard. It is important to note that the shards are not separate parallel blockchains. The PBC blockchain ledger is composed of information on all shards. So contracts deployed on different shards can still interact with each other across shards. The consequence of shards is an extremely fast and efficient blockchain which can be scaled up with more shards if the demand arise. Together with the [fast track consensus protocol](../pbc-fundamentals/consensus.md) the type of sharding used by PBC is a unique feature which resolves the blockchain scalability problem. You can read more about sharding on PBC [here](../pbc-fundamentals/sharding.md).

### Smart Contracts

A smart contract is a program you run on the blockchain. The conditions of the contract are present across the blockchain. This ensures that actions of the smart contract will happen only once, are trackable and irreversible. In this way a smart contract works independently, without any need for outside authority to facilitate the change in state. Effectively a smart contract can replace the trustee in a binding transaction. This makes smart contracts useful tool for auctions, voting and purchases. In addition to public layer actions on the blockchain, smart contracts can also be used to facilitate ZK computations on the private layer of PBC. Read more [here](../smart-contracts/what-is-a-smart-contract.md)

### Transactions

A transaction is an instruction from a user containing information used to change the state of the blockchain. Transactions are bundled into blocks and added to a distributed and immutable ledger in a sequential manner across multiple [shards](sharding.md) in PBC.
On PBC there is one type of transaction existing and it is used to interact with a contract. All transactions include a RPC byte stream, the interpretation of which is up to the specific contract.

Each transaction defines how long into the future it is valid and what the cost is. A hash of the transaction and the signer’s nonce is then signed by the account holder using his/her private key. This signature is used to authenticate the signer on the blockchain. If the signing key does not have a corresponding account, the transaction is rejected.

A transaction is valid when:

- It has as a valid signature
- The nonce in the transaction matches the account nonce in the blockchain state
- The transaction has not expired
- The account can cover the cost of the transaction

### WASM

Abbreviation for WebAssembly, a standardized binary code format which is used for the smart contracts deployed at PBC.
