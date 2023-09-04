# Partisia Blockchain MetaMask Snap
The Partisia Blockchain MetaMask snap allows dapp developers to use MetaMask for when signing transactions towards
Partisia Blockchain. The Snap feature is currently only available within [MetaMask Flask](https://metamask.io/flask/).

### What does the snap do?
The snap allows users to use MetaMask to sign transactions. It allows getting the Partisia
Blockchain address of the key and to sign transactions.

### How to install and use the snap as a user?
To sign a transaction you can do the following:
1. Deactivate the original MetaMask extension if you have it installed.
2. Install [MetaMask Flask DEVELOPMENT BUILD chrome extension](https://metamask.io/flask/)
3. Create a Wallet in MetaMask Flask. If you want to have the same wallet address as you have on the PBC wallet, you can reuse the seed phrase and get the same keys.
4. Run the [example-web-client](https://gitlab.com/partisiablockchain/language/example-web-client).

Steps 5. 6. and 7. are done in the example-web-clients interface:

5. "Connect Metamask Snap" - this installs the PBC Snap (Protocol 3757).
6. If you created a new account, you need to read the account address key - and then get some testnet gas for the account. You can visit [our article about getting testnet gas](../access-and-use-the-testnet.md).
7. Now you can use Metamask to sign your transactions. We recommend after making sure you have gas on the account that you to try out the "mint 10.000 tokens" action - and examine the transaction in [the Browser](https://browser.testnet.partisiablockchain.com/transactions). If it succeeds It will appear with the Action named "Mint" in the browser.


### How do I install the Snap as a developer?
Using MetaMask `wallet_requestSnaps` with the snap
  identifier `npm:@partisiablockchain/snap`.
  
???+ example "How to install the snap"
    ```javascript
    try {
    const result = await window.ethereum.request({
    method: 'wallet_requestSnaps',
    params: {
    'npm:@partisiablockchain/snap': {},
    },
    });
    console.log(result);
        } catch (error) {
          console.log(error);
        }
    ```


### How do I get the Partisia Blockchain address of the user?
When the snap has been installed the snap invocation `get_address` will return the address of the user.
  
???+ example "How to get address of the user"
    ```javascript
    window.ethereum.request({
        method: 'wallet_invokeSnap',
        params: {
          snapId: "npm:@partisiablockchain/snap", 
          request: {method: 'get_address'}},
    });
    ```

### How do I sign a transaction?
Use the snap method `sign_transaction`. The method requires a parameter object with two fields, `chainId` that is the chain id of the chain that the transaction
are signed towards and `payload` that
should be a hex encoded transaction. The method will return a hex encoded signature.
  
???+ example "How to create a signature"
    ```javascript
    window.ethereum.request({method: 'wallet_invokeSnap',
      params: {
        snapId: "npm:@partisiablockchain/snap",
        request: {
            method: 'sign_transaction', 
            params: {
                payload: payload, 
                chainId: chainId},
        },
      },
    });
    ```