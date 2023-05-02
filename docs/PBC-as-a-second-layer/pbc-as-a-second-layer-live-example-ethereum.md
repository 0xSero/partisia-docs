# Test the live example of a voting contract with PBC as second layer from ethereum testnet
<div class="dot-navigation">
   <a class="dot-navigation__item" href="pbc-as-second-layer.html"></a>
    <a class="dot-navigation__item dot-navigation__item--active" href="pbc-as-a-second-layer-live-example-ethereum.html"></a>
    <a class="dot-navigation__item" href="pbc-as-a-second-layer-how-to-create-your-own-solution.html"></a>
    <a class="dot-navigation__item" href="pbc-as-second-layer-technical-differences-eth-pbc.html"></a>

    <!-- Repeat above for more dots -->
</div>

---
**NOTE**
Before you can live test the example of ours, you need the following setup:

1. You should have a [testnet](../testnet.md) [PBC account with gas](../byoc.md)
2. You should also have a test ethereum account with gas on the Goerli testnet. To get some gas on Goerli testnet we used the [Goerli PoW Faucet](https://goerli-faucet.pk910.de/)

We suggest to use [metamask](../accounts.md) for both PBC and Goerli to access the two different testnet from the same wallet.

---

## Registrering as a voter on Ethereum

1. Go to [https://goerli.etherscan.io/address/0x<todo>](https://goerli.etherscan.io/address/0x<todo>)
2. Press the “Contract” button and then the “Write Contract” button to interact with the public contract.
3. Choose the action “register” and enter your PBC account address (write as “0x<address\>”), and press “Write” to send the register transaction. (You may need to connect your wallet via the “Connect to Web3”).
4. Verify that the registration was successful by finding in under “Events”

## Transferring voter registration to PBC

1. Go to [https://testnet.partisiablockchain.com/info/contract/<todo>](https://testnet.partisiablockchain.com/info/contract/<todo>)
   (Optionally, validate that the contract address and engines pub keys corresponds to state in Ethereum public voting contract, link to details further down)
2. Register your PBC account by pressing the “Register” button (under Contract Interaction)
3. Verify that the account was registered by finding it in the contract state

## Casting secret vote and counting result

 1. Navigate to the voting interface and click the “Add vote” button to input your secret vote.
 2. Verify that the input has been accepted by the computations nodes by checking that there is no “pending input” in the ZK state (see “Show ZK State as Json”). Note that this may take some time.

 3. Once your vote has been accepted, click the “Start vote counting” button to begin counting the votes of the current vote.
 4. Wait until the result has been computed and signed by the computation nodes by checking that the “calculationStatus” is “waiting” in the ZK state. Note that this may take some time.

 5. Once the result has been computed and signed, find the result of the vote in the state and verify that it is as expected.

By following these steps you have now cast a secret vote and counted the result using PBC.

Note that since this example is publicly available, other votes may have been cast. Identify the latest vote by the result with the highest vote_id.

If you encounter any issues while casting your vote or counting the result, you are always welcome to ask for assistance in our [active community](https://partisiablockchain.com/community).

## Transfer the result securely back to Ethereum

These steps shows you how to securely move the vote result to the Ethereum public voting contract while ensuring accuracy and integrity.

1. To securely move the result to the Ethereum public voting contract, go back to [the contract on etherscan](https://goerli.etherscan.io/address/0x<todo>) and find the “validateResult” action under “contract” and then ”write contract”.
2. Fill in the values of the vote result and the proof of the result shown in PBC.
3. Verify that you cannot alter the result by altering the input, e.g. adding votes.The transaction will fail when doing so.

[<button class="button-pretty bprev" role="button">Partisia Blockchain as a second layer</button>](pbc-as-second-layer.md) [<button class="button-pretty bnext" role="button">PBC as a second layer how to create your own solution</button>](pbc-as-a-second-layer-how-to-create-your-own-solution.md)