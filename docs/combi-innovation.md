# Public and ZK Smart Contract examples - Combine and innovate

## Smart contracts ready and open for combinatorial innovation
[Download example contracts as a ZIP](LINK_TO_RUST_EXAMPLE_CONTRACTS)

### Public auction

The auction sells tokens of one type for another (can be the same token type). The contract works by escrowing bids as well as the tokens for sale. This is done through `transfer` calls to the token contracts with callbacks ensuring that the transfers were successful. If a bid is not the current highest bid the transferred bidding tokens can be claimed during any phase. The auction has a set `duration`. After this duration the auction no longer accepts bids and can be executed by anyone. Once `execute` has been called the contract moves the tokens for sale into the highest bidders claims and the highest bid into the contract owners claims. In the bidding phase any account can call `bid` on the auction which makes a token `transfer` from the bidder to the contract. Once the transfer is done the contract updates its highest bidder accordingly. The contract owner also has the ability to `cancel` the contract during the bidding phase. If cancel is called the highest bid is taken out of escrow such that the highest bidder can claim it again. The same is done for the tokens for sale which the contract owner then can claim.
<!--- Contract link here -->

### ZK second-price auction

One of the types of smart contracts you will be able to deploy on PBC is a second-price auction (also called Vickrey auction), which is a sealed bid auction where the winner is the person with the highest bid (as in a normal auction), but the price paid is that of the second-highest bidder. When some valuable item changes hands through an auction it is desirable to have the change in ownership registered on an immutable record. It is however sometimes undesirable that individual maximum bids are public, since the seller can use a third party to drive up the price to the highest possible price. One of the great advantages of PBC over other blockchains is that zero knowledge computations can be performed on the network parallel to the public transactions on the blockchain. The second price auction takes as inputs the bids from the registered participants. The bids are delivered encrypted and secret-shared to the ZK nodes allocated to the contract. When the computation is initiated by the contract owner, the zero knowledge computation nodes reads the collected input and then create a bit vector consisting of prices and the ordering number. The list of bit vectors is now sorted in MPC. The winner is the first entry (the bidder with the highest price-bid), the price is determined by the size of the second-highest bid.
<!--- Contract link here -->

### NFT contract

The contract provides basic functionality to track and transfer NFTs. With the mint method, new NFTs can be added to the NFT portfolio of an account. By using a u128 tokenID the NFT can be identified. Any NFT owner can transfer their NFT to other accounts or approve other accounts to be able to transfer their NFTs. Each NFT can only be approved for a single account.
<!--- Contract link here -->

### Public Voting

The public vote has a proposal id, a list of accounts that can participate, as well as a list of votes. The state of the contract shows the result, participants and if the vote is finished.
<!--- Contract link here -->

### ZK Voting

ZK voting does the same as the public vote, with a notable exception the votes are anonymous and only the final result is revealed in the public state
<!--- Contract link here -->

### ZK average salary

The secret calculation of an average salary is a common multiparty computation problem, where several privacy-conscious individual are interested in determining if their salary is comparatively fair, but at the same time avoid revealing their own salary to their colleagues.    
This implementation works in following steps:

1. Initialization on the blockchain.
2. Receival of multiple secret salaries, using the real zk protocol.
3. Once enough salaries have been received, the contract owner can start the ZK computation.
4. The Zk computation sums all the given salaries together.
5. Once the zk computation is complete, the contract will publicize the the summed variable.
6. Once the summed variable is public, the contract will compute the average and store it in
   the state, such that the value can be read by all.

<!--- Contract link here -->

### Token contract

The contract has a constant total supply of tokens. The total supply is initialized together with the contract. Any token owner can then `transfer` tokens to other accounts, or `approve` other accounts to use their tokens. If Alice's account has been approved for tokens from Bob, then Alice can use `transfer_from` to use Bob's tokens. The contract is inspired by the ERC20 token contract. <https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md>
<!--- Contract link here -->

### Liquidity Swap contract

This is an example of a simple liquidity swap smart contract.
It is simplified implication of UniSwap v2: <https://docs.uniswap.org/protocol/V2/concepts/protocol-overview/how-uniswap-works>
The contracts exchanges (or swaps) between two types of tokens, with an the exchange rate as given by the `constant product formula: x * y = k`. We consider `x` to be the balance of token pool A and `y` to be the balance of token pool B. `k` represents the invariant (`swap_constant`) that must be upheld between swaps. In order to perform a swap between the two desired tokens, the owner must first initialize both token pools, `initialize_pool_{a,b}`, by transferring an amount of tokens to both pools via a transfer call to the corresponding token contract. This will also initialize the (final) value of `k`. User's (including the owner) can then `deposit` tokens to the contract, which can be used to
exchange to the opposite token. This is done by calling `swap`. `swap` will calculate the
amount of tokens to convert of the incoming token to the opposite token, based on the above formula.
A user may then `withdraw` the resulting tokens of the swap (or simply his own deposited tokens). Finally, the owner of the contract may close the pools, `close_pools`, by transferring both token pools to his own account,
effectively closing the contract. Only valid withdrawals are allowed in the closed state. Both `deposit` and `withdraw` makes use of `transfer` calls to the token contract, which are ensured to be successful via callbacks. Because the relative price of the two tokens can only be changed through swapping, divergences between the prices of the current contract and the prices of similar external contracts create arbitrage opportunities. This mechanism ensures that the contract's prices always trend toward the market-clearing price. The two token contracts linked to this contract must currently be owned by the same owner, as this contract.
<!--- Contract link here -->

### ZK liquidity swap

ZK liquidity swap prevents frontrunning. One of the main challenges to the integrity of liquidity swaps is frontrunning. Since the exchange rate is given by a constant, it is possible to predict the price effect of a purchase or sale. If a hostile actor sees a large purchase coming in, he can place a purchase ahead in the queue, and his sell after the targeted purchase profiting from the price difference. By keeping purchase and sell orders secret until finalized prevents the problem of frontrunning.
<!--- Contract link here -->

### Escrow contract

The escrow contract is a contract for conditional transfer of funds. The contract plays the role of trustee in a value transaction with predetermined conditions. This contract allows a sender  to put tokens into an escrow contract which a receiver can receive when a condition has been fulfilled.
The escrow transfer contract handles a specific token type. A sender can place tokens into escrow specifying the receiver and an approver that signals condition fulfilment and a deadline. The approver can signal fulfilment of the condition. The condition itself is not part of the contract, only the signalling of the fulfilment of the condition. The receiver can claim the tokens when the condition has been fulfilled. The sender can claim the tokens when the deadline is met and the condition is not fulfilled.
<!--- Contract link here -->

## Examples of combinations that you can use in your contract innovation

### Next generation AMM
- Token contract
- Escrow contract
- ZK liquidity swap

### Health stats
- Tokens
- Private statistics

### Next generation of supply chain management
- ZK statistics
- ZK voting

### Next generation of DAO
- Token
- Escrow
- ZK auction

### Next generation of trading platform
- Token
- Escrow
- ZK auction

### Next generation of advertisement
- ZK statistics
- ZK Auction



##MPC examples

The following is an introductory list to the kinds of computation that can be done with secure multiparty computation on Partisia Blockchain. By combining the different types of computations in smart contracts you can develop apps that can solve complex problems. MPC allows for calculation on private data, where you can make the result of the calculation public and keep the private data secure at the same time. A simple example of this could be calculation of average salary in a company. You do not want to disclose your own income, but it would be nice to know if you make more or less than the average. Instead of sending your private data to your peers you can send a random bite (share) of the private data out to several peers. They do the same. When doing the calculation no salaries are revealed but the total sum of the numbers is the same. So, you get the correct result even though the calculation is done on the data in a randomised form.

### Data collaboration

- Voting    
  Voting on a blockchain comes with the inbuilt advantage of getting an accurate result on an unalterable public ledger. However, it used to entail the disadvantage that you could preserve the privacy of the votes and voters. Voting on PBC allows you to use MPC to preserve privacy. That enables you to create a vote that produce a provable correct unalterable result, but also allows the individual voters to stay anonymous.


- [Millionaires problem](https://en.wikipedia.org/wiki/Yao%27s_Millionaires%27_problem)   
  The millionaires problem is a famous MPC problem. Whom of two parties is the richest? So, euphemism for the comparing the size of to numbers without revealing the numbers.


- [Surveys](https://partisia.com/better-data-solutions/surveys/)   
  Individual answers are encrypted at the moment of submission and stay encrypted at all times. Only aggregated statistics are decrypted and revealed.


- Confidential statistics   
  MPC allows for combination and statistical analysis of sensitive data in separate registries. The data can be pulled into a virtual MPC sandbox where you do the analysis on secret-shared inputs.


- Machine learning   
  You can do pattern recognition and regression analysis on secret-shared data. There are a myriad of use cases for this on big data sets, where you still want to keep the data private. For example detection of fraud or dangerous market anomalies.


### Auction

- Sealed bid   
  Is an auction where all the bids and bidders are kept secret until all bids are in and the auction starts. Traditionally this type of auction was done with physically sealed envelopes. With MPC you can figuratively speaking compare the content of each envelope without opening them and revealing the non-winning bidders and bids.


- Second price   
  Is a sealed bid auction where the winner is the person with the highest bid (as in a normal auction), but the price paid is that of the second-highest bidder.
  When some valuable item changes hands through an auction it is desirable to have the change in ownership registered on an immutable record.  It is however sometimes undesirable that individual maximum bids are public, since the seller can use a third party to drive up the price to the highest possible price.

### Automated market solutions

- Order matching   
  Order matching is a process whereby sell orders are matched with buy orders. With MPC you can match orders without revealing sensitive information that could influence the market or put buyer or seller ad a disadvantage.


### Games

- Poker   
  When playing online poker for money you want to make sure, that no one can cheat by guessing the next card being drawn. Pseudorandom numbers can be predicted if you have access to the algorithm generating them. But, by using MPC you can make the deck of cards unpredictable even if the players have visible access to the code controlling the game.







