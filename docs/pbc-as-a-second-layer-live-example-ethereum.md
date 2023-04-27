# Test the live example of a voting contract with PBC as second layer from ethereum testnet

---

**NOTE**
Before you can live test the example of ours, you need to have a the following setup:
You should have a [testnet](testnet.md) [PBC account with gas](byoc.md)
You should also have a test ethereum account with gas on the Goerli testnet. To get some gas on Goerli testnet we used the [Goerli PoW Faucet](https://goerli-faucet.pk910.de/)
We suggest to use [metamask](accounts.md) for both PBC and Goerli to access the two different testnet from the same wallet.

---

## Registrering as a voter on Ethereum

1. Go to https://goerli.etherscan.io/address/0x<todo>
2. Press the “Contract” button and then the “Write Contract” button to interact with the public contract.
3. Choose the action “register” and enter your PBC account address (write as “0x<address>”), and press “Write” to send the register transaction. (You may need to connect your wallet via the “Connect to Web3”).
4. Verify that the registration was successful by finding in under “Events”

## Transferring voter registration to PBC

1. Go to https://testnet.partisiablockchain.com/info/contract/<todo>
   (Optionally, validate that the contract address and engines pub keys corresponds to state in Ethereum public voting contract, link to details further down)
2. Register your PBC account by pressing the “Register” button (under Contract Interaction)
3. Verify that the account was registered by finding it in the contract state

## Casting secret vote and counting result

1. To vote press the “Add vote” button to input a secret vote
2. Verify that the secret input has been accepted by the computations nodes by checking that there is no “pending input” in the ZK state (see “Show ZK State as Json”). This may take some time.
3. Count the votes of the current vote by pressing the “Start vote counting” button.
4. Wait until the result has been computed, and the result has been signed by the computation nodes, by checking that the “calculationStatus” is “waiting” in the ZK state. This may take some time.
5. Find the result of the vote in the state and verify it is as expected. Note that since this example is publicly available so votes other than your may have been cast. Identify the latest vote by the result with the highest vote_id.

## Transfer the result securely back to Ethereum

1. Next, to securely move the result to the Ethereum public voting contract, go back to the contract on etherscan (link from the beginning) and find the “validateResult” action under “contract”->”write contract”.
2. Fill in the values of the vote result and the proof of the result shown in PBC.
3. Verify that you cannot alter the result by altering the input, e.g. adding votes.The transaction will fail when doing so.
