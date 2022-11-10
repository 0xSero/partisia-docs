# Smart contracts available for combinatorial innovation


### Public auction 

The auction sells tokens of one type for another (can be the same token type). The contract works by escrowing bids as well as the tokens for sale. This is done through `transfer` calls to the token contracts with callbacks ensuring that the transfers were successful. If a bid is not the current highest bid the transferred bidding tokens can be claimed during any phase. The auction has a set `duration`. After this duration the auction no longer accepts bids and can be executed by anyone. Once `execute` has been called the contract moves the tokens for sale into the highest bidders claims and the highest bid into the contract owners claims. In the bidding phase any account can call `bid` on the auction which makes a token `transfer` from the bidder to the contract. Once the transfer is done the contract updates its highest bidder accordingly. The contract owner also has the ability to `cancel` the contract during the bidding phase. If cancel is called the highest bid is taken out of escrow such that the highest bidder can claim it again. The same is done for the tokens for sale which the contract owner then can claim.
  
Link   

### ZK second-price auction   

One of the types of smart contracts you will be able to deploy on PBC is a second-price auction (also called Vickrey auction), which is a sealed bid auction where the winner is the person with the highest bid (as in a normal auction), but the price paid is that of the second-highest bidder. When some valuable item changes hands through an auction it is desirable to have the change in ownership registered on an immutable record. It is however sometimes undesirable that individual maximum bids are public, since the seller can use a third party to drive up the price to the highest possible price. One of the great advantages of PBC over other blockchains is that zero knowledge computations can be performed on the network parallel to the public transactions on the blockchain. The second price auction takes as inputs the bids from the registered participants. The bids are delivered encrypted and secret-shared to the ZK nodes allocated to the contract. When the computation is initiated by the contract owner, the zero knowledge computation nodes reads the collected input and then create a bit vector consisting of prices and the ordering number. The list of bit vectors is now sorted in MPC. The winner is the first entry (the bidder with the highest price-bid), the price is determined by the size of the second-highest bid.
_Link_ repository not public

### NFT contract   

The contract provides basic functionality to track and transfer NFTs. With the mint method, new NFTs can be added to the NFT portfolio of an account. By using a u128 tokenID the NFT can be identified. Any NFT owner can transfer their NFT to other accounts or approve other accounts to be able to transfer their NFTs. Each NFT can only be approved for a single account.
  
Link

### Public Voting

The public vote has a proposal id, a list of accounts that can participate, as well as a list of votes. The state of the contract shows the result, participants and if the vote is finished.
Link

### ZK Voting

ZK voting does the same as the public vote, with a notable exception the votes are anonymous and only the final result is revealed in the public state

Link

### ZK average salary

Description   
Link

### Token contract

Description   
Link

### Token Swap contract

Description   
Link

### ZK token swap

Description   
Link

## Examples of combination

### Next generation AMM
EIP-20 tokens (token contract)

### Health stats
Tokens    
private statistics

### Next generation of supply chain management
ZK statistics   
ZK voting

### Next generation of DAO
Token
Escrow
ZK auction

### Next generation of trading platform
Token
Escrow
ZK auction

### Next generation of advertisement
ZK statistics
ZK Auction







