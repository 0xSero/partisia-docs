```
<ExecutableEvent> := {
    originShard: Option<String>          
    transaction: EventTransaction
}

<EventTransaction> := {
    originatingTransaction: Hash                         
    inner: InnerEvent
    shardRoute: ShardRoute
    committeeId: 0xnn*8                                     (big-endian)
    governanceVersion: 0xnn*8                               (big-endian)
    height: 0xnn                            
    returnEnvelope: Option<ReturnEnvelope>                   
}

<InnerEvent> := 0x00 InnerTransaction
             |  0x01 CallbackToContract
             |  0x02 InnerSystemEvent
             |  0x03 SyncEvent

<InnerTransaction> := {
    from: Address
    cost: 0xnn*8                                             (big-endian)
    transaction: Transaction
}

<Transaction> := 0x00 CreateContractTransaction
              |  0x01 InteractWithContractTransaction

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
    cost: 0xnn*8                                            (big-endian)
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

<ChainPluginType> := 0x00 => ACCOUNT
                  |  0x01 => CONSENSUS
                  |  0x02 => ROUTING
                  |  0x03 => SHARED_OBJECT_STORE
                  
<LocalPluginStateUpdate> := {
    context: Address
    rpc: Rpc
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
    nonce: 0xnn*8                                           (big-endian)
}


<Hash> := 0xnn*32                                            (big-endian)

<Address> := addrtype:AddressType identifier:0xnn*20         (identifier is big-endian)

<AddressType> := 0x00 => ACCOUNT
              |  0x01 => CONTRACT_SYSTEM
              |  0x02 => CONTRACT_PUBLIC
              |  0x03 => CONTRACT_ZK
              |  0x04 => CONTRACT_GOV

<ReturnEnvelope> := Address

<Boolean> := b:0xnn

<String> := len:0xnn*4 uft8:0xnn*len                         (len is big-endian)

<DynamicBytes> := len:0xnn*4 payload:0xnn*len                (len is big-endian)

<Option<T> := Boolean arg:T

<List<T>> := len:0xnn*4 args:T*len                           (len is big-endian)
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