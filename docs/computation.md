# MPC - computation examples

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
- ZK swap

### Games

- Poker   


