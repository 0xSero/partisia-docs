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


# Executable Event Binary Format 
```
<ExecutableEvent> := {
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