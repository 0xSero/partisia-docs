# PBC Smart Contracts as a means to strengthen democracy and transparency

## Case - Voting record of parliamentarians
The newly founded republic of Faraway is plagued by corruption. To ensure transparency and public mandate behind the parliamentary process the voting record of the elected MPs is added to the blockchain via smart contracts. Using smart contracts enables the public to see how MPs exercise their mandate. Laws that are passed through the smart contract are added to the immutable record, giving all citizens access to the official legal code.


**The setup of our scenario**
- The parliament has 197 MPs.
- Each MP has a key set. The public key enables the public to follow the MP’s voting record on the blockchain. The private key is known only by the individual MP and is used to sign their vote.
- Each time the parliament votes on an issue they do it through a smart contract vote. Laws that passed are therefore also added to the immutable record.

**The contract**

No ZK computations necessary since the both individual votes and voting results are supposed to be public.

## How to code a smart contract equivalent to our scenario in Rust
 