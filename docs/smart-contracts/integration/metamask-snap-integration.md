# Partisia Blockchain MetaMask Snap
The Partisia Blockchain MetaMask snap allows dapp developers to use MetaMask for when signing transactions towards
Partisia Blockchain. The Snap feature is currently only available within [MetaMask Flask](https://metamask.io/flask/).

### What does the snap do?
The snap allows users to use MetaMask to sign transactions. It allows getting the Partisia
  Blockchain address of the key and to sign transactions.
### How do I install the Snap?
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

To sign a transaction you can do the following:
1. Deactivate the original MetaMask extension if you have it installed.
2. Install MetaMask Flask DEVELOPMENT BUILD chrome extension 
3. Create a Wallet. 
4. Run the example-web-client. The following steps are done in the example:
5. "Connect Metamask Snap" - Install the PBC Snap (Protocol 3757).
6. Read the account address key - and then get some testnet gas for the account.
7. Now you can use Metamask to sign your transactions. Try out the "mint 10.000 tokens" action - and examine the transaction in the Browser.