# Transaction Binary Format

A transaction is an instruction from a user containing information used to change the state of the blockchain. You can learn more about how interactions work on the blockchain [here](smart-contract-interactions-on-the-blockchain.md#simple-interaction-model). 

After constructing a binary signed transaction it can be delivered to any baker node in the network through
their [REST API](../rest).

The following is the specification of the binary format of signed transactions.

The easiest way of creating a binary signed transaction is by using one of the
available [client libraries](smart-contract-tools-overview.md#client). This specification can help you if you want to
make your own implementation, for instance if you are targeting another programming language.

```
<SignedTransaction> := {
    signature: Signature
    transaction: Transaction
}

<Signature> := {
    recoveryId: 0xnn
    valueR: 0xnn*32                         (big endian)
    valueS: 0xnn*32                         (big endian)
}

<Transaction> := {
    nonce: 0xnn*8                           (big-endian)
    validToTime: 0xnn*8                     (big-endian)
    gasCost: 0xnn*8                         (big-endian)
    address: 0xnn*21
    rpc := Rpc
}

<Rpc> := len:0xnn*4 payload:0xnn*len        (len is big-endian)
```

The Signature includes:

- a recovery id between 0 and 3 used to recover the public key when verifying the signature
- the r value of the ECDSA signature
- the s value of the ECDSA signature

The Transaction includes:

- the signer's [nonce](../pbc-fundamentals/dictionary.md#nonce)
- a unix time that the transaction is valid to
- the amount of [gas](gas/transaction-gas-prices.md) allocated to executing the transaction 
- the address of the smart contract that is the target of the transaction
- the rpc payload of the transaction. See [Smart Contract Binary Formats](smart-contract-binary-formats.md)
  for a way to build the rpc payload.

## Creating the signature

The signature is an ECDSA signature, using secp256k1 as the curve, on a sha256 hash of the transaction and the chain ID of
the blockchain.

````
<ToBeHashed> := transaction:Transaction chainId:ChainId

<ChainId> := len:0xnn*4 utf8:0xnn*len       (len is big-endian)
````

The chain id is a unique identifier for the blockchain. For example, the chain id for Partisia Blockchain mainnet is
`Partisia Blockchain` and the chain id for the testnet is `Partisia Blockchain Testnet`.

<div style="justify-content: center;display: flex; margin: 25px;">
<div>
<pre>

<<a id="executable-event"><b>ExecutableEvent</b></a>> := { 
    originShard: <a href="#option">Option</a><<a href="#string">String</a>>          
    transaction: <a href="#event-transaction">EventTransaction</a>
  }

<<a id="event-transaction"><b>EventTransaction</b></a>> := {
    originatingTransaction: <a href="#hash">Hash</a>                         
    inner: <a href="#inner-event">InnerEvent</a>
    shardRoute: <a href="#shard-route">ShardRoute</a>
    committeeId: <a href="#long">Long</a>
    governanceVersion: <a href="#long">Long</a>
    height: <a href="#byte">Byte</a> (unsigned)                           
    returnEnvelope: <a href="#option">Option</a><<a href="#return-envelope">ReturnEnvelope</a>>                   
}

<<a id="inner-event"><b>InnerEvent</b></a>> := 0x00 => <a href="#inner-transaction">InnerTransaction</a>
            |  0x01 => <a href="#callback-to-contract">CallbackToContract</a>
            |  0x02 => <a href="#inner-system-event">InnerSystemEvent</a>
            |  0x03 => <a href="#sync-event">SyncEvent</a>

<<a id="inner-transaction"><b>InnerTransaction</b></a>> := {
    from: <a href="#address">Address</a>
    cost: <a href="#long">Long</a>
    transaction: <a href="#transaction">Transaction</a>
}

<<a id="transaction"><b>Transaction</b></a>> := 0x00 => <a href="#create-contract-transaction">CreateContractTransaction</a>
             |  0x01 => <a href="#interact-with-contract-transaction">InteractWithContractTransaction</a>

<<a id="create-contract-transaction"><b>CreateContractTransaction</b></a>> := {
    address: <a href="#address">Address</a>
    binderJar: <a href="#dynamic-bytes">DynamicBytes</a>                   
    contractJar: <a href="#dynamic-bytes">DynamicBytes</a>                 
    abi: <a href="#dynamic-bytes">DynamicBytes</a>                       
    rpc: <a href="#dynamic-bytes">DynamicBytes</a>                        
}

<<a id="interact-with-contract-transaction"><b>InteractWithContractTransaction</b></a>> := {
    contractId: <a href="#address">Address</a>
    payload: <a href="#dynamic-bytes">DynamicBytes</a>
}

<<a id="callback-to-contract"><b>CallbackToContract</b></a>> := {
    address: <a href="#address">Address</a>
    callbackIdentifier: <a href="#hash">Hash</a>
    from: <a href="#address">Address</a>
    cost: <a href="#long">Long</a>
    callbackRpc: <a href="#dynamic-bytes">DynamicBytes</a>
}

<<a id="inner-system-event"><b>InnerSystemEvent</b></a>> := {
    systemEventType: <a href="#system-event-type">SystemEventType</a>
}

<<a id="system-event-type"><b>SystemEventType</b></a>> := 0x00 => <a href="#create-account-event">CreateAccountEvent</a>
                  |  0x01 => <a href="#check-existence-event">CheckExistenceEvent</a>
                  |  0x02 => <a href="#set-feature-event">SetFeatureEvent</a>
                  |  0x03 => <a href="#update-local-plugin-state-event">UpdateLocalPluginStateEvent</a>
                  |  0x04 => <a href="#update-global-plugin-state-event">UpdateGlobalPluginStateEvent</a>
                  |  0x05 => <a href="#update-plugin-event">UpdatePluginEvent</a>
                  |  0x06 => <a href="#callback-event">CallbackEvent</a>
                  |  0x07 => <a href="#create-shard-event">CreateShardEvent</a>
                  |  0x08 => <a href="#remove-shard-event">RemoveShardEvent</a>
                  |  0x09 => <a href="#update-context-free-plugin-state">UpdateContextFreePluginState</a>
                  |  0x0A => <a href="#upgrade-system-contract-event">UpgradeSystemContractEvent</a>
                  |  0x0B => <a href="#remove-contract">RemoveContract</a>

<<a id="create-account-event"><b>CreateAccountEvent</b></a>> := {
    toCreate: <a href="#address">Address</a>
}


<<a id="check-existence-event"><b>CheckExistenceEvent</b></a>> := {
    contractOrAccountAddress: <a href="#address">Address</a>
}

<<a id="set-feature-event"><b>SetFeatureEvent</b></a>> := {
    key: <a href="#string">String</a>
    value: <a href="#option">Option</a><<a href="#string">String</a>>
}

<<a id="update-local-plugin-state-event"><b>UpdateLocalPluginStateEvent</b></a>> := {
    type: <a href="#chain-plugin-type">ChainPluginType</a>
    update: <a href="#local-plugin-state-update">LocalPluginStateUpdate</a>
}

<<a id="chain-plugin-type"><b>ChainPluginType</b></a>> := 0x00 => <b>Account</b>
                 |  0x01 => <b>Consensus</b>
                 |  0x02 => <b>Routing</b>
                 |  0x03 => <b>SharedObjectStore</b>

<<a id="local-plugin-state-update"><b>LocalPluginStateUpdate</b></a>> := {
    context: <a href="#address">Address</a>
    rpc: <a href="#dynamic-bytes">DynamicBytes</a>
}


<<a id="update-global-plugin-state-event"><b>UpdateGlobalPluginStateEvent</b></a>> := {
    type: <a href="#chain-plugin-type">ChainPluginType</a>
    update: <a href="#global-plugin-state-update">GlobalPluginStateUpdate</a>
}

<<a id="global-plugin-state-update"><b>GlobalPluginStateUpdate</b></a>> := {
    rpc: <a href="#dynamic-bytes">DynamicBytes</a>
}

<<a id="update-plugin-event"><b>UpdatePluginEvent</b></a>> := {
    type: <a href="#chain-plugin-type">ChainPluginType</a>
    jar: <a href="#option">Option</a><<a href="#dynamic-bytes">DynamicBytes</a>>
    invocation: <a href="#dynamic-bytes">DynamicBytes</a>
}

<<a id="callback-event"><b>CallbackEvent</b></a>> := {
    returnEnvelope: <a href="#return-envelope">ReturnEnvelope</a>
    completedTransaction: <a href="#hash">Hash</a>
    success: <a href="#boolean">Boolean</a>
    returnValue: <a href="#dynamic-bytes">DynamicBytes</a>
}

<<a id="create-shard-event"><b>CreateShardEvent</b></a>> := {
    shardId: <a href="#string">String</a>
}

<<a id="remove-shard-event"><b>RemoveShardEvent</b></a>> := {
    shardId: <a href="#string">String</a>
}

<<a id="update-context-free-plugin-state"><b>UpdateContextFreePluginState</b></a>> := {
    type: <a href="#chain-plugin-type">ChainPluginType</a>
    rpc: <a href="#dynamic-bytes">DynamicBytes</a>
}

<<a id="upgrade-system-contract-event"><b>UpgradeSystemContractEvent</b></a>> := {
    contractAddress: <a href="#address">Address</a>
    binderJar: <a href="#dynamic-bytes">DynamicBytes</a>
    contractJar: <a href="#dynamic-bytes">DynamicBytes</a>
    abi: <a href="#dynamic-bytes">DynamicBytes</a>
    rpc: <a href="#dynamic-bytes">DynamicBytes</a>
}

<<a id="remove-contract"><b>RemoveContract</b></a>> := {
    contractAddress: <a href="#address">Address</a>
}

<<a id="sync-event"><b>SyncEvent</b></a>> := {
    accounts: <a href="#list">List</a><<a href="#account-transfer">AccountTransfer</a>>
    contracts: <a href="#list">List</a><<a href="#contract-transfer">ContractTransfer</a>>
    stateStorage: <a href="#list">List</a><<a href="#dynamic-bytes">DynamicBytes</a>>
}

<<a id="account-transfer"><b>AccountTransfer</b></a>> := {
    address: <a href="#address">Address</a>
    accountStateHash: <a href="#hash">Hash</a>
    pluginStateHash: <a href="#hash">Hash</a>
}

<<a id="contract-transfer"><b>ContractTransfer</b></a>> := {
    address: <a href="#address">Address</a>
    ContractStateHash: <a href="#hash">Hash</a>
    pluginStateHash: <a href="#hash">Hash</a>
}

<<a id="shard-route"><b>ShardRoute</b></a>> := {
    targetShard: <a href="#option">Option</a><<a href="#string">String</a>>
    nonce: <a href="#long">Long</a>
}

<<a id="address"><b>Address</b></a>> := addressType: <a href="#address-type">AddressType</a> identifier: 0xnn*20         (identifier is big-endian)

<<a id="address-type"><b>AddressType</b></a>> := 0x00 => <b>Account</b>
              |  0x01 => <b>System</b>
              |  0x02 => <b>Public</b>
              |  0x03 => <b>Zk</b>
              |  0x04 => <b>Gov</b>

<<a id="return-envelope"><b>ReturnEnvelope</b></a>> := <a href="#address">Address</a>

<<a id="hash"><b>Hash</b></a>> := 0xnn*32                                            (big-endian)

<<a id="long"><b>Long</b></a>> := 0xnn*8                                             (big endian)

<<a id="byte"><b>Byte</b></a>> := 0xnn

<<a id="boolean"><b>Boolean</b></a>> := b:0xnn                                          (false if b==0, true otherwise)

<<a id="string"><b>String</b></a>> := len:0xnn*4 uft8:0xnn*len                         (len is big-endian)

<<a id="dynamic-bytes"><b>DynamicBytes</b></a>> := len:0xnn*4 payload:0xnn*len                (len is big-endian)

<<a id="option"><b>Option</b></a><<b>T</b>>> := 0x00 => None
            | b:0xnn t:<b>T</b> => Some(t)                         (b != 0)

<<a id="list"><b>List</b></a><<b>T</b>>> := len:0xnn*4 elems:<b>T</b>*len                          (len is big-endian)

</pre>
</div>
</div>

# Executable Event Binary Format 
```
<ExecutableEvent>:= {
    originShard: Option<String>          
    transaction: EventTransaction
}

<EventTransaction> := {
    originatingTransaction: Hash                         
    inner: InnerEvent
    shardRoute: ShardRoute
    committeeId: Long
    governanceVersion: Long
    height: Byte (unsigned)                           
    returnEnvelope: Option<ReturnEnvelope>                   
}

<InnerEvent> := 0x00 => InnerTransaction
             |  0x01 => CallbackToContract
             |  0x02 => InnerSystemEvent
             |  0x03 => SyncEvent

<InnerTransaction> := {
    from: Address
    cost: Long
    transaction: Transaction
}

<Transaction> := 0x00 => CreateContractTransaction
              |  0x01 => InteractWithContractTransaction

<CreateContractTransaction> := {
    address: Address
    binderJar: DynamicBytes                   
    contractJar: DynamicBytes                 
    abi: DynamicBytes                       
    rpc: DynamicBytes                        
}

<InteractWithContractTransaction> := {
    contractId: Address
    payload: DynamicBytes
}

<CallbackToContract> := {
    address: Address
    callbackIdentifier: Hash
    from: Address
    cost: Long
    callbackRpc: DynamicBytes
}

<InnerSystemEvent> := {
    systemEventType: SystemEventType
}

<SystemEventType> := 0x00 => CreateAccountEvent
                  |  0x01 => CheckExistenceEvent
                  |  0x02 => SetFeatureEvent
                  |  0x03 => UpdateLocalPluginStateEvent
                  |  0x04 => UpdateGlobalPluginStateEvent
                  |  0x05 => UpdatePluginEvent
                  |  0x06 => CallbackEvent
                  |  0x07 => CreateShardEvent
                  |  0x08 => RemoveShardEvent
                  |  0x09 => UpdateContextFreePluginState
                  |  0x0A => UpgradeSystemContractEvent
                  |  0x0B => RemoveContract

<CreateAccountEvent> := {
    toCreate: Address
}

<CheckExistenceEvent> := {
    contractOrAccountAddress: Address
}

<SetFeatureEvent> := {
    key: String
    value: Option<String>
}

<UpdateLocalPluginStateEvent> := {
    type: ChainPluginType
    update: LocalPluginStateUpdate
}

<ChainPluginType> := 0x00 => Account
                  |  0x01 => Consensus
                  |  0x02 => Routing
                  |  0x03 => SharedObjectStore
                  
<LocalPluginStateUpdate> := {
    context: Address
    rpc: DynamicBytes
}                 
                  
               
<UpdateGlobalPluginStateEvent> := {
    type: ChainPluginType
    update: GlobalPluginStateUpdate
}

<GlobalPluginStateUpdate> := {
    rpc: DynamicBytes
}      

<UpdatePluginEvent> := {
    type: ChainPluginType
    jar: Option<DynamicBytes>
    invocation: DynamicBytes
}

<CallbackEvent> := {
    returnEnvelope: ReturnEnvelope
    completedTransaction: Hash
    success: Boolean
    returnValue: DynamicBytes
}

<CreateShardEvent> := {
    shardId: String
}

<RemoveShardEvent> := {
    shardId: String
}

<UpdateContextFreePluginState> := {
    type: ChainPluginType
    rpc: DynamicBytes
}

<UpgradeSystemContractEvent> := {
    contractAddress: Address
    binderJar: DynamicBytes
    contractJar: DynamicBytes
    abi: DynamicBytes
    rpc: DynamicBytes
}

<RemoveContract> := {
    contractAddress: Address
}

<SyncEvent> := {
    accounts: List<AccountTransfer>
    contracts: List<ContractTransfer>
    stateStorage: List<DynamicBytes>
}

<AccountTransfer> := {
    address: Address
    accountStateHash: Hash
    pluginStateHash: Hash
}

<ContractTransfer> := {
    address: Address
    ContractStateHash: Hash
    pluginStateHash: Hash
}
<ShardRoute> := {
    targetShard: Option<String>
    nonce: Long
}
<ReturnEnvelope> := Address
<Hash> := 0xnn*32                                            (big-endian)
<Long> := 0xnn*8                                             (big endian)
<Byte> := 0xnn
<Boolean> := b:0xnn                                          (false if b==0, true otherwise)
<String> := len:0xnn*4 uft8:0xnn*len                         (len is big-endian)
<DynamicBytes> := len:0xnn*4 payload:0xnn*len                (len is big-endian)
<Option<T>> := 0x00 => None
            |  b:0xnn t:T => Some(t)                         (b != 0)
<List<T>> := len:0xnn*4 elems:T*len                          (len is big-endian)
<Address> := addrtype:AddressType identifier:0xnn*20         (identifier is big-endian)
<AddressType> := 0x00 => Account
              |  0x01 => System
              |  0x02 => Public
              |  0x03 => Zk
              |  0x04 => Gov
```

The originShard is an `Option<String>`, the originating shard.

The EventTransaction includes:

- the originating transaction: the [SignedTransaction](transaction-binary-format.md) initiating the tree of events that this event is a part of.
- the actual inner transaction
- the shard this event is going to and nonce for this event
- the committee id for the block producing this event
- the version of governance when this event was produced
- current call height in the event stack
- callback (address) if any