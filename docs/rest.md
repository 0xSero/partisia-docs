# The PBC REST API

The REST API supplied with the Partisia Blockchain exposes essential functions for application developers over REST.

## Enabling/disabling the REST server

The REST server is an optional plugin that needs to be enabled in the `config.json` file. You need to add the relevant module to the `modules` section of the file:

````json
  // beginning of config 

  "modules": [
    {
      "fullyQualifiedClass": "io.privacyblockchain.server.rest.RestNode",
      "configuration": {
        "enabled": true
      }
    }
  ],
  "restPort": 8080,

  // rest of config
````

 The complete file can be seen in [Getting started with PBC](operator.md).

 To disable the REST server simply set `enabled` to `false` or optionally remove the module from the `modules` key. You can change the port to any port you deem fit, but remember that the PBC node  may as an unprivileged user and may not be able to bind to port numbers smaller than 1000.

## REST endpoints

### `GET  /blockchain`

This method returns `204 No Content` if the service is running.
This is primarily used to check uptime.

### `GET  /blockchain/chainId`

This method returns the chain identifier for the running node.

````json
{
    "chainId": "The chain id for the running node"
}
````

### `GET  /blockchain/account/{address}`

Given an account address this method returns the account state for the given account. If the account does not exist the method yields a `404 Not Found`. If the account is found the result looks like the following:

````json
{
    "nonce": 123
}
````


### `GET  /blockchain/contracts/{address}`

Gets the contract state for the given address. 
The method returns a `404 Not Found` if no contract with the given address exists.
The method returns a `400 Bad Request` if the address specified is of the wrong type e.g. an account address.

An example result:

````json
{
    "type": "PUBLIC",
    "owner": "00112233445566778899AABBCCDDEEFF00AABBCCDD", 
    "address": "0100112233445566778899AABBCCDDEEFF00AABBCC",
    "jarHash": "5d50eae3e102831b2ce99f2cadf01bebd0bcdd1a9d63c371a39139349e476ba9",
    "storageLength": "14543543",
    "serializedContract": {
        // Implementation-specific state
    }
}
````

| Field | Type |
|-------|------|
| `type`    | One of: `SYSTEM`, `PUBLIC` or `ZERO_KNOWLEDGE`. |
| `owner`   | Account address |
| `address` | Contract address |
| `jarHash` | SHA256 hash |
| `storageLength` | 64 bit signed number |
| `seriallizedContract` | The actual state of the contract. This will vary between contracts since it's implementation-specific | 


### `PUT  /blockchain/transaction/`
### `GET  /blockchain/transaction/{transaction hash}`
### `GET  /blockchain/blocks/latest`
### `GET  /blockchain/blocks/{block hash}`
### `GET  /blockchain/blocks/blockTime/{block time}`
### `PUT  /blockchain/event/`
### `GET  /blockchain/event/{event hash}`

### `POST /blockchain/accountPlugin/global`
### `POST /blockchain/accountPlugin/local`
### `POST /blockchain/consensusPlugin/global`
### `POST /blockchain/consensusPlugin/local`
### `GET  /blockchain/consensusPlugin/local`

### `GET  /blockchain/bootState`
### `GET  /blockchain/features/{feature}`
### `GET  /blockchain/consensusJar`
