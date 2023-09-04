# Partisia Blockchain MetaMask Snap
The Partisia Blockchain MetaMask snap allows dapp developers to use MetaMask for when signing transactions towards
Partisia Blockchain. The Snap feature is currently only available within [MetaMask Flask](https://metamask.io/flask/).

### What does the snap do?
The snap allows users to use MetaMask to sign transactions. It allows getting the Partisia
Blockchain address of the key and to sign transactions.

### How to install and use the snap as a user?
To sign a transaction you can do the following:

1. Deactivate the original MetaMask extension if it is installed.
2. Install [MetaMask Flask DEVELOPMENT BUILD chrome extension](https://metamask.io/flask/)
3. Create a Wallet in MetaMask Flask. You can reuse the seed phrase from PBC wallet if you want to use the same account address and private key.
4. Run the [example-web-client](https://gitlab.com/partisiablockchain/language/example-web-client). **Steps 5, 6 and 7 are done in the example-web-clients interface**.
5. "Connect Metamask Snap" - this installs the PBC Snap (Protocol 3757).
6. Ensure that your PBC account has gas. If you lack gas, find the account address key inside MetaMask Flask, then get some testnet gas for the account. You can visit [our article about getting testnet gas](../access-and-use-the-testnet.md).
7. Now you can use Metamask to sign your transactions. 

We recommend you to try the "Mint 10.000 tokens" action - and examine the transaction in [the Browser](https://browser.testnet.partisiablockchain.com/transactions). If it succeeds it will appear with the Action named "Mint" in the browser.

???+ warning "Common Pitfalls"
    1. If you have the standard MetaMask installed, and you install MetaMask Flask you need to ensure that you have disabled the standard MetaMask extension. Otherwise, you will experience that the snap is not available and not working.
    2. If your account has no gas it will still allow you to approve the transaction but will return `error 500`. Make sure that you have [some gas on the account](../access-and-use-the-testnet.md) before signing transactions. 


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