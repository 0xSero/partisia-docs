# How to get your node included in the network

The sign-up is a five-step process:

1. Buy the required stake of MPC tokens and get [gas](byoc.md) for Register Transaction.
2. Rent or buy a server where you can run the node.
3. Send the public IP of the server hosting the node, your PBC Address and e-mail to *@Kristian Hu#7382* in a direct message on the Node Operator Discord Channel. E-mail is necessary for access to the Gitlab repository, the IP establish contact between the node and network. We check if we can reach you. (This step is only temporary and will be replaced by an automated process).
4. Configure the node in accordance with the description [here](operator.md).
5. Send a Register Transaction and a Staking Transaction through the [MPC Wallet Extension](https://chrome.google.com/webstore/detail/partisia-wallet/gjkdbeaiifkpoencioahhcilildpjhgh)

## Content of the Register Transaction

- Name (Legal name)
- Website (Company or personal webpage)
- Address (Company or personal address)
- PublicKey (PublicKey of your Network keyset) - - the form generates the public key when you sign with the Netwok private key.
- BLS PublicKey (BLS12-381 PublicKey of your BLS keyset) - the form generates the BLS public key when you sign with the BLS private key.
- EntityJurisdiction (Your country of residence - ISO 3166-1: 3-digit code referring to a country)
- ServerJurisdiction (Location of the server where you operate the node - ISO 3166-1: 3-digit code referring to a country)

## Content of Staking Transaction

- Amount (The amount of MPC Tokens you are staking)

## Conditions for inclusion

Formal conditions for inclusion in the network is stipulated in the [Yellow Paper](mailto:accounts@pbc.foundation?subject=Yellow%20Paper%20link,%20please) (YP_0.95 Ch. 2.3.1 pp. 11-12):

- The public information regarding the node given by the operator must be validated.
- Sufficient stakes committed.
- Test run is successful.
- The transaction fees of Register and Staking Transaction have been paid.
