# Transaction Binary Format

A transaction is an instruction from a user containing information used to change the state of the blockchain. You can learn more about how interactions work on the blockchain [here](smart-contract-interactions-on-the-blockchain.md#simple-interaction-model). 

After constructing a binary signed transaction it can be delivered to any baker node in the network through
their [REST API](../rest).

The following is the specification of the binary format of signed transactions.

The easiest way of creating a binary signed transaction is by using one of the
available [client libraries](smart-contract-tools-overview.md#client). This specification can help you if you want to
make your own implementation, for instance if you are targeting another programming language.

<div style="justify-content: center">
<div style="text-align: left">
<pre>

<<a id="signed-transaction"><b><a href="#signed-transaction">SignedTransaction</a></b></a>> := {
    signature: <a href="#signature">Signature</a>
    transaction: <a href="#transaction-outer">Transaction</a>
  }

<<a id="signature"><b><a href="#signature">Signature</a></b></a>> := {
    recoveryId: 0xnn
    valueR: 0xnn*32                         (big endian)
    valueS: 0xnn*32                         (big endian)
  }
</pre></div></div>

The [Signature](#signature) includes:

- a recovery id between 0 and 3 used to recover the public key when verifying the signature
- the r value of the ECDSA signature
- the s value of the ECDSA signature

<div style="justify-content: center">
<div style="text-align: left">
<pre>

<<a id="transaction-outer"><b><a href="#transaction-outer">Transaction</a></b></a>> := {
    nonce: 0xnn*8                           (big-endian)
    validToTime: 0xnn*8                     (big-endian)
    gasCost: 0xnn*8                         (big-endian)
    address: <a href="#address">Address</a>
    rpc: <a href="#rpc">Rpc</a>
  }

<<a id="rpc"><b><a href="#rpc">Rpc</a></b></a>> := len:0xnn*4 payload:0xnn*len        (len is big-endian)
</pre></div></div>

The [Transaction](#transaction-outer) includes:

- the signer's [nonce](../pbc-fundamentals/dictionary.md#nonce)
- a unix time that the transaction is valid to
- the amount of [gas](gas/transaction-gas-prices.md) allocated to executing the transaction
- the address of the smart contract that is the target of the transaction
- the rpc payload of the transaction. See [Smart Contract Binary Formats](smart-contract-binary-formats.md)
  for a way to build the rpc payload.

## Creating the signature

The signature is an ECDSA signature, using secp256k1 as the curve, on a sha256 hash of the transaction and the chain ID of
the blockchain.

<div style="justify-content: center">
<div style="text-align: left">
<pre>
<<a id="to-be-hashed"><b><a href="#to-be-hashed">ToBeHashed</a></b></a>> := transaction: <a href="#transaction-outer">Transaction</a> chainId: <a href="#chain-id">ChainId</a>

<<a id="chain-id"><b><a href="#chain-id">ChainId</a></b></a>> := len:0xnn*4 utf8:0xnn*len       (len is big-endian)
</pre></div></div>

The chain id is a unique identifier for the blockchain. For example, the chain id for Partisia Blockchain mainnet is
`Partisia Blockchain` and the chain id for the testnet is `Partisia Blockchain Testnet`.

## Executable Event Binary Format

<div style="justify-content: center; display: inline-block">
<div style="text-align: left;">
<pre>

<<a id="executable-event"><b><a href="#executable-event">ExecutableEvent</a></b></a>> := { 
    originShard: <a href="#option">Option</a><<a href="#string">String</a>>          
    transaction: <a href="#event-transaction">EventTransaction</a>
  }

<<a id="event-transaction"><b><a href="#event-transaction">EventTransaction</a></b></a>> := {
    originatingTransaction: <a href="#hash">Hash</a>                         
    inner: <a href="#inner-event">InnerEvent</a>
    shardRoute: <a href="#shard-route">ShardRoute</a>
    committeeId: <a href="#long">Long</a>
    governanceVersion: <a href="#long">Long</a>
    height: <a href="#byte">Byte</a> (unsigned)                           
    returnEnvelope: <a href="#option">Option</a><<a href="#return-envelope">ReturnEnvelope</a>>                   
  }

<<a id="inner-event"><b><a href="#inner-event">InnerEvent</a></b></a>> := 0x00 <a href="#inner-transaction">InnerTransaction</a>
            |  0x01 <a href="#callback-to-contract">CallbackToContract</a>
            |  0x02 <a href="#inner-system-event">InnerSystemEvent</a>
            |  0x03 <a href="#sync-event">SyncEvent</a>

<<a id="inner-transaction"><b><a href="#inner-transaction">InnerTransaction</a></b></a>> := {
    from: <a href="#address">Address</a>
    cost: <a href="#long">Long</a>
    transaction: <a href="#transaction">Transaction</a>
  }

<<a id="transaction"><b><a href="#transaction">Transaction</a></b></a>> := 0x00 => <a href="#create-contract-transaction">CreateContractTransaction</a>
             |  0x01 => <a href="#interact-with-contract-transaction">InteractWithContractTransaction</a>

<<a id="create-contract-transaction"><b><a href="#create-contract-transaction">CreateContractTransaction</a></b></a>> := {
    address: <a href="#address">Address</a>
    binderJar: <a href="#dynamic-bytes">DynamicBytes</a>                   
    contractJar: <a href="#dynamic-bytes">DynamicBytes</a>                 
    abi: <a href="#dynamic-bytes">DynamicBytes</a>                       
    rpc: <a href="#dynamic-bytes">DynamicBytes</a>                        
  }

<<a id="interact-with-contract-transaction"><b><a href="#interact-with-contract-transaction">InteractWithContractTransaction</a></b></a>> := {
    contractId: <a href="#address">Address</a>
    payload: <a href="#dynamic-bytes">DynamicBytes</a>
}

<<a id="callback-to-contract"><b><a href="#callback-to-contract">CallbackToContract</a></b></a>> := {
    address: <a href="#address">Address</a>
    callbackIdentifier: <a href="#hash">Hash</a>
    from: <a href="#address">Address</a>
    cost: <a href="#long">Long</a>
    callbackRpc: <a href="#dynamic-bytes">DynamicBytes</a>
  }

<<a id="inner-system-event"><b><a href="#inner-system-event">InnerSystemEvent</a></b></a>> := {
    systemEventType: <a href="#system-event-type">SystemEventType</a>
  }

<<a id="system-event-type"><b><a href="#system-event-type">SystemEventType</a></b></a>> := 0x00 <a href="#create-account-event">CreateAccountEvent</a>
                  |  0x01 <a href="#check-existence-event">CheckExistenceEvent</a>
                  |  0x02 <a href="#set-feature-event">SetFeatureEvent</a>
                  |  0x03 <a href="#update-local-plugin-state-event">UpdateLocalPluginStateEvent</a>
                  |  0x04 <a href="#update-global-plugin-state-event">UpdateGlobalPluginStateEvent</a>
                  |  0x05 <a href="#update-plugin-event">UpdatePluginEvent</a>
                  |  0x06 <a href="#callback-event">CallbackEvent</a>
                  |  0x07 <a href="#create-shard-event">CreateShardEvent</a>
                  |  0x08 <a href="#remove-shard-event">RemoveShardEvent</a>
                  |  0x09 <a href="#update-context-free-plugin-state">UpdateContextFreePluginState</a>
                  |  0x0A <a href="#upgrade-system-contract-event">UpgradeSystemContractEvent</a>
                  |  0x0B <a href="#remove-contract">RemoveContract</a>

<<a id="create-account-event"><b><a href="#create-account-event">CreateAccountEvent</a></b></a>> := {
    toCreate: <a href="#address">Address</a>
  }


<<a id="check-existence-event"><b><a href="#check-existence-event">CheckExistenceEvent</a></b></a>> := {
    contractOrAccountAddress: <a href="#address">Address</a>
  }

<<a id="set-feature-event"><b><a href="#set-feature-event">SetFeatureEvent</a></b></a>> := {
    key: <a href="#string">String</a>
    value: <a href="#option">Option</a><<a href="#string">String</a>>
  }

<<a id="update-local-plugin-state-event"><b><a href="#update-local-plugin-state-event">UpdateLocalPluginStateEvent</a></b></a>> := {
    type: <a href="#chain-plugin-type">ChainPluginType</a>
    update: <a href="#local-plugin-state-update">LocalPluginStateUpdate</a>
  }

<<a id="chain-plugin-type"><b><a href="#chain-plugin-type">ChainPluginType</a></b></a>> := 0x00 => <b>Account</b>
                 |  0x01 => <b>Consensus</b>
                 |  0x02 => <b>Routing</b>
                 |  0x03 => <b>SharedObjectStore</b>

<<a id="local-plugin-state-update"><b><a href="#local-plugin-state-update">LocalPluginStateUpdate</a></b></a>> := {
    context: <a href="#address">Address</a>
    rpc: <a href="#dynamic-bytes">DynamicBytes</a>
  }


<<a id="update-global-plugin-state-event"><b><a href="#update-global-plugin-state-event">UpdateGlobalPluginStateEvent</a></b></a>> := {
    type: <a href="#chain-plugin-type">ChainPluginType</a>
    update: <a href="#global-plugin-state-update">GlobalPluginStateUpdate</a>
  }

<<a id="global-plugin-state-update"><b><a href="#global-plugin-state-update">GlobalPluginStateUpdate</a></b></a>> := {
    rpc: <a href="#dynamic-bytes">DynamicBytes</a>
  }

<<a id="update-plugin-event"><b><a href="#update-plugin-event">UpdatePluginEvent</a></b></a>> := {
    type: <a href="#chain-plugin-type">ChainPluginType</a>
    jar: <a href="#option">Option</a><<a href="#dynamic-bytes">DynamicBytes</a>>
    invocation: <a href="#dynamic-bytes">DynamicBytes</a>
  }

<<a id="callback-event"><b><a href="#callback-event">CallbackEvent</a></b></a>> := {
    returnEnvelope: <a href="#return-envelope">ReturnEnvelope</a>
    completedTransaction: <a href="#hash">Hash</a>
    success: <a href="#boolean">Boolean</a>
    returnValue: <a href="#dynamic-bytes">DynamicBytes</a>
  }

<<a id="create-shard-event"><b><a href="#create-shard-event">CreateShardEvent</a></b></a>> := {
    shardId: <a href="#string">String</a>
  }

<<a id="remove-shard-event"><b><a href="#remove-shard-event">RemoveShardEvent</a></b></a>> := {
    shardId: <a href="#string">String</a>
  }

<<a id="update-context-free-plugin-state"><b><a href="#update-context-free-plugin-state">UpdateContextFreePluginState</a></b></a>> := {
    type: <a href="#chain-plugin-type">ChainPluginType</a>
    rpc: <a href="#dynamic-bytes">DynamicBytes</a>
  }

<<a id="upgrade-system-contract-event"><b><a href="#upgrade-system-contract-event">UpgradeSystemContractEvent</a></b></a>> := {
    contractAddress: <a href="#address">Address</a>
    binderJar: <a href="#dynamic-bytes">DynamicBytes</a>
    contractJar: <a href="#dynamic-bytes">DynamicBytes</a>
    abi: <a href="#dynamic-bytes">DynamicBytes</a>
    rpc: <a href="#dynamic-bytes">DynamicBytes</a>
  }

<<a id="remove-contract"><b><a href="#remove-contract">RemoveContract</a></b></a>> := {
    contractAddress: <a href="#address">Address</a>
  }

<<a id="sync-event"><b><a href="#sync-event">SyncEvent</a></b></a>> := {
    accounts: <a href="#list">List</a><<a href="#account-transfer">AccountTransfer</a>>
    contracts: <a href="#list">List</a><<a href="#contract-transfer">ContractTransfer</a>>
    stateStorage: <a href="#list">List</a><<a href="#dynamic-bytes">DynamicBytes</a>>
  }

<<a id="account-transfer"><b><a href="#account-transfer">AccountTransfer</a></b></a>> := {
    address: <a href="#address">Address</a>
    accountStateHash: <a href="#hash">Hash</a>
    pluginStateHash: <a href="#hash">Hash</a>
  }

<<a id="contract-transfer"><b><a href="#contract-transfer">ContractTransfer</a></b></a>> := {
    address: <a href="#address">Address</a>
    ContractStateHash: <a href="#hash">Hash</a>
    pluginStateHash: <a href="#hash">Hash</a>
  }

<<a id="shard-route"><b><a href="#shard-route">ShardRoute</a></b></a>> := {
    targetShard: <a href="#option">Option</a><<a href="#string">String</a>>
    nonce: <a href="#long">Long</a>
  }

<<a id="address"><b><a href="#address">Address</a></b></a>> := addressType: <a href="#address-type">AddressType</a> identifier: 0xnn*20  (identifier is big-endian)

<<a id="address-type"><b><a href="#address-type">AddressType</a></b></a>> := 0x00 => <b>Account</b>
              |  0x01 => <b>System</b>
              |  0x02 => <b>Public</b>
              |  0x03 => <b>Zk</b>
              |  0x04 => <b>Gov</b>

<<a id="return-envelope"><b><a href="#return-envelope">ReturnEnvelope</a></b></a>> := <a href="#address">Address</a>

<<a id="hash"><b><a href="#hash">Hash</a></b></a>> := 0xnn*32                    (big-endian)

<<a id="long"><b><a href="#long">Long</a></b></a>> := 0xnn*8                    (big endian)

<<a id="byte"><b><a href="#byte">Byte</a></b></a>> := 0xnn

<<a id="boolean"><b><a href="#boolean">Boolean</a></b></a>> := b:0xnn                    (false if b==0, true otherwise)

<<a id="string"><b><a href="#string">String</a></b></a>> := len:0xnn*4 uft8:0xnn*len                    (len is big-endian)

<<a id="dynamic-bytes"><b><a href="#dynamic-bytes">DynamicBytes</a></b></a>> := len:0xnn*4 payload:0xnn*len       (len is big-endian)

<<a id="option"><b>Option</b></a><<b>T</b>>> := 0x00 => None
            | b:0xnn t:<b>T</b> => Some(t)                         (b != 0)

<<a id="list"><b>List</b></a><<b>T</b>>> := len:0xnn*4 elems:<b>T</b>*len                          (len is big-endian)

</pre>
</div>
</div>

The originShard is an [Option](#option)<[String](#string)>, the originating shard.

The EventTransaction includes:

- The originating transaction: the [SignedTransaction](#signed-transaction) initiating the tree of events that this event is a part of.
- The actual inner transaction
- The shard this event is going to and nonce for this event
- The committee id for the block producing this event
- The version of governance when this event was produced
- Current call height in the event stack
- Callback (address) if any