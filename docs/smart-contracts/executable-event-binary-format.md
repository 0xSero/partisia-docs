```
<ExecutableEvent> := {
    originShard: b:0xnn len:0xnn*4 utf8:0xnn*len (Option<String>) (length rpc ?)
    transaction: EventTransaction
}

<EventTransaction> := {
    originatingTransaction: 0xnn*32 (Hash)           
    inner: variant:0xnn (Enum)?? (InnerEvent(type)
    shardRoute: ShardRoute
    committeeId: 0xnn*8                     (big-endian)
    governanceVersion: 0xnn*8               (big-endian)
    height: 0xnn (unsigned byte)
    returnEnvelope: b:0xnn 0xnn*21 (Option<ReturnEnvelope(Blockchainaddress)>)
}

<InnerEvent> := {
    type: variant:0xnn (Enum)?? 
}

<ShardRoute> := {
    targetShard: b:0xnn len:0xnn*4 utf8:0xnn*len (Option<String>)
    nonce: 0xnn*8
}
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