# Smart Contract examples

[Visit our example contracts repository for all our open source code](https://gitlab.com/partisiablockchain/language/example-contracts)

The Partisia Blockchain Foundation provides the following reviewed smart contracts, as examples of real world problems with a blockchain solution. This page is created to explain the usecases of our example contracts and the titles reflect the name of the smart contract one-to-one.
You want to solve problems with smart contracts. The easiest way of getting started coding smart contracts is to learn from concrete examples showing smart contracts solving problems similar to the one you need to solve. The examples includes both normal contracts and [zero-knowledge smart contracts](zk-smart-contracts.md)


## Examples of combinations that you can use in your contract innovation

Partisia has several successful use cases, pilot projects with private deployments of the same infrastructure supporting Partisia Blockchain.
The scope of these applications include internet privacy, user control of data, financial privacy, cybersecurity, humanitarian aid and confidential health statistics.
You can read more about these pilot projects [here](https://partisiablockchain.com/ecosystem).

By combining the functionality of different types of open sourced smart contracts it is possible to create application on the public blockchain within the same areas as the successful pilot projects for quick MVPs. 

## MPC examples

Secure multiparty computation [(MPC)](../pbc-fundamentals/dictionary.md#mpc) extent the scope blockchain technology to encompass areas that before required some kind of independent third party to handle sensitive data like a trustee.
With MPC in your smart contracts on PBC you can do arithmetic and statistics. But the original variables of the problem being solved are split into randomized parts called secret shares. Inputs are preprocessed so the data handled by the ZK nodes cannot recreate the original user data, you can read more about how and why in the [MPC Techniques series](https://medium.com/partisia-blockchain/pbcacademy/home). See the average salary contract above as an example of MPC being used.

### Data collaboration

- [Voting](https://gitlab.com/partisiablockchain/language/example-contracts/-/tree/main/voting)
  Voting on a public blockchain comes with the inbuilt advantage of getting an accurate result on an unalterable public ledger. However, it used to entail the disadvantage that you could not preserve the privacy of the voters while proving the accuracy of the vote count. Voting on PBC allows you to use MPC to preserve privacy. That enables you to create a vote that produce a provable correct unalterable result, but also allows the individual voters to stay anonymous.

- [Millionaires problem](https://en.wikipedia.org/wiki/Yao%27s_Millionaires%27_problem)  
  The millionaires problem is a famous MPC problem. Whom of two parties is the richest? So, euphemism for the comparing the size of to numbers without revealing the numbers. You can see how some of these issues are handled by visiting our [average salary example](https://gitlab.com/partisiablockchain/language/example-contracts/-/tree/main/zk-average-salary).

- [Surveys](https://partisia.com/better-data-solutions/surveys/)  
  Individual answers are encrypted at the moment of submission and stay encrypted at all times. Only aggregated statistics are decrypted and revealed.

- Confidential statistics  
  MPC allows for combination and statistical analysis of sensitive data in separate registries. The data can be pulled into a virtual MPC sandbox where you do the analysis on secret-shared inputs.

- Machine learning  
  You can do pattern recognition and regression analysis on secret-shared data. There are a myriad of use cases for this on big data sets, where you still want to keep the data private. For example detection of fraud or dangerous market anomalies.
