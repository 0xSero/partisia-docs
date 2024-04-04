# Transaction Binary Format

A transaction is an instruction from a user containing information used to change the state of the blockchain. You can learn more about how interactions work on the blockchain [here](smart-contract-interactions-on-the-blockchain.md#simple-interaction-model). 

After constructing a binary signed transaction it can be delivered to any baker node in the network through
their [REST API](../rest).

The following is the specification of the binary format of signed transactions.

The easiest way of creating a binary signed transaction is by using one of the
available [client libraries](smart-contract-tools-overview.md#client). This specification can help you if you want to
make your own implementation, for instance if you are targeting another programming language.

## New

<div class="binary-format" markdown>

##### [SignedTransaction](#signedtransaction) 

::= {

  <div class="fields"/>
  
  signature: [Signature](#signature) <br>
  transaction: [Transaction](#transaction)

}


##### [Signature](#signature)

::= {

<div class="fields"/>

recoveryId: <span class="bytes">0<span class="sep">x</span>nn</span>  <br>
valueR: <span class="bytes">0<span class="sep">x</span>nn\*32</span>                         <span class="endian">(big endian)</span><br>
valueS: <span class="bytes">0<span class="sep">x</span>nn\*32</span>                         <span class="endian">(big endian)</span><br>

}

</div>

The [Signature](#signature) includes:

- a recovery id between 0 and 3 used to recover the public key when verifying the signature
- the r value of the ECDSA signature
- the s value of the ECDSA signature

<div class="binary-format" markdown>

##### [Transaction](#transaction)

::= {

<div class="fields"/>

nonce: <span class="bytes">0<span class="sep">x</span>nn\*8</span>                          <span class="endian">(big endian)</span><br>
validToTime: <span class="bytes">0<span class="sep">x</span>nn\*8</span>                    <span class="endian">(big endian)</span><br>
gasCost: <span class="bytes">0<span class="sep">x</span>nn\*8</span>                        <span class="endian">(big endian)</span><br>
address: [Address](#)
rpc: [Rpc](#rpc)

}

</div>

<div class="binary-format" markdown>

##### [Rpc](#rpc)

::= len:<span class="bytes">0<span class="sep">x</span>nn\*4</span> payload:<span class="bytes">0<span class="sep">x</span>nn\*</span>len <span class="endian">(len is big endian)</span>

</div>


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

<div class="binary-format" markdown>

##### [ToBeHashed](#ToBeHashed)

::= transaction:[Transaction](#transaction) chainId: [ChainId](#chainid-) 

</div>

<div class="binary-format" markdown>

##### [ChainId](#chainid-) 

::=  len: <span class="bytes">0<span class="sep">x</span>nn\*4</span>  utf8: <span class="bytes">0<span class="sep">x</span>nn\*</span>len  <span class="endian">(len is big endian)</span><br>

</div>

The chain id is a unique identifier for the blockchain. For example, the chain id for Partisia Blockchain mainnet is
`Partisia Blockchain` and the chain id for the testnet is `Partisia Blockchain Testnet`.


## Executable Event Binary Format


<div class="binary-format" markdown>


##### [ExecutableEvent](#executableevent-) 

::= {

<div class="fields"/>

originShard: [Option](#Option)<[String](#string)>    
transaction: [EventTransaction]()

}


##### [Address](#address-) 

::= addressType: [AddressType](#addresstype-) identifier: <span class="bytes">0<span class="sep">x</span>nn\*20</span> <span class="endian">(identifier is big-endian)</span><br> 

</div>

<div class="binary-format" markdown>

##### [AddressType](#addresstype-) 

::= 0x00 => **Account**
|  0x01 => **System**
|  0x02 => **Public**
|  0x03 => **Zk**
|  0x04 => **Gov**

</div>

<div class="binary-format" markdown>

##### [ReturnEnvelope](#returnenvelope-) 

::= [Address](#address-) <br>


##### [Hash](#hash-) 

::= <span class="bytes">0<span class="sep">x</span>nn\*32</span>   <span class="endian">(big-endian)</span><br>


##### [Long](#long)

::= <span class="bytes">0<span class="sep">x</span>nn\*8</span>   <span class="endian">(big-endian)</span><br>


##### [Byte](#byte-) 

::= <span class="bytes">0<span class="sep">x</span>nn</span><br>

##### [Boolean](#boolean)

::= b: <span class="bytes">0<span class="sep">x</span>nn</span>  <span class="endian">(false if b==0, true otherwise)</span><br>

##### [String](#string-) 

::= len:<span class="bytes">0<span class="sep">x</span>nn\*4</span> uft8:<span class="bytes">0<span class="sep">x</span>nn\*</span>len             <span class="endian">(len is big endian)</span><br>


##### [DynamicBytes](#dynamic-bytes-) 

::= len:<span class="bytes">0<span class="sep">x</span>nn\*4</span> payload:<span class="bytes">0<span class="sep">x</span>nn\*</span>len        <span class="endian">(len is big endian)</span><br>


##### [Option<T\>]()  

::= 0x00 => None
| b: 0xnn t:<b>T</b> => Some(t)                      <span class="endian">(b != 0)</span><br>   

##### [List]() 

::= len: <span class="bytes">0<span class="sep">x</span>nn\*4</span> elems: <b>T</b>\*len     <span class="endian">(len is big endian)</span><br>

</div>


<div class="binary-format" markdown>

##### [EventTransaction](#eventtransaction-) 

::= {

  <div class="fields"/>
  
  originatingTransaction: [Hash](#hash-)                      
  inner: [InnerEvent](#innerevent-) 
  shardRoute: [ShardRoute](#shardroute--)
  committeeId:[Long](#long)  
  governanceVersion: [Long](#long)  
  height: [Byte](#byte-) <span class="endian">(unsigned)</span>                       
  returnEnvelope: [Option](#option--t-)<[ReturnEnvelope](#returnenvelope-)\>

}

</div>

<div class="binary-format" markdown>

##### [InnerEvent](#inner-event-) 

::= 0x00 [InnerTransaction]()
  |  0x01 [CallbackToContract]()
  |  0x02 [InnerSystemEvent]()
  |  0x03 [SyncEvent]()

</div>

<div class="binary-format" markdown>

##### [InnerTransaction](#inner-transaction-) 

::= {

<div class="fields"/>

from: [Address]()
cost: [Long]()
transaction: [Transaction]()

}

##### [Transaction]() 

::= 0x00 => CreateContractTransaction 
|  0x01 => InteractWithContractTransaction

##### [CreateContractTransaction](#create-contract-transaction-) ::= {
    address: <a href="#address">Address</a>
    binderJar: <a href="#dynamic-bytes">DynamicBytes</a>                   
    contractJar: <a href="#dynamic-bytes">DynamicBytes</a>                 
    abi: <a href="#dynamic-bytes">DynamicBytes</a>                       
    rpc: <a href="#dynamic-bytes">DynamicBytes</a>                        
  }

##### [InteractWithContractTransaction](#interact-with-contract-transaction-) ::= {
    contractId: <a href="#address">Address</a>
    payload: <a href="#dynamic-bytes">DynamicBytes</a>
}

##### [CallbackToContract](#callback-to-contract-) ::= {
    address: <a href="#address">Address</a>
    callbackIdentifier: <a href="#hash">Hash</a>
    from: <a href="#address">Address</a>
    cost: <a href="#long">Long</a>
    callbackRpc: <a href="#dynamic-bytes">DynamicBytes</a>
  }

##### [InnerSystemEvent](#inner-system-event-) ::= {
    systemEventType: <a href="#system-event-type">SystemEventType</a>
  }

##### [SystemEventType](#system-event-type-) ::= 0x00 <a href="#create-account-event">CreateAccountEvent</a>
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

##### [CreateAccountEvent](#create-account-event-) ::= {
    toCreate: <a href="#address">Address</a>
  }


##### [CheckExistenceEvent](#check-existence-event-) ::= {
    contractOrAccountAddress: <a href="#address">Address</a>
  }

##### [SetFeatureEvent](#set-feature-event-) ::= {
    key: <a href="#string">String</a>
    value: <a href="#option">Option</a><<a href="#string">String</a>>
  }

##### [UpdateLocalPluginStateEvent](#update-local-plugin-state-event-) ::= {
    type: <a href="#chain-plugin-type">ChainPluginType</a>
    update: <a href="#local-plugin-state-update">LocalPluginStateUpdate</a>
  }

##### [ChainPluginType](#chain-plugin-type-) ::= 0x00 => <b>Account</b>
                 |  0x01 => <b>Consensus</b>
                 |  0x02 => <b>Routing</b>
                 |  0x03 => <b>SharedObjectStore</b>

##### [LocalPluginStateUpdate](#local-plugin-state-update-) ::= {
    context: <a href="#address">Address</a>
    rpc: <a href="#dynamic-bytes">DynamicBytes</a>
  }


##### [UpdateGlobalPluginStateEvent](#update-global-plugin-state-event-) ::= {
    type: <a href="#chain-plugin-type">ChainPluginType</a>
    update: <a href="#global-plugin-state-update">GlobalPluginStateUpdate</a>
  }

##### [GlobalPluginStateUpdate](#global-plugin-state-update-) ::= {
    rpc: <a href="#dynamic-bytes">DynamicBytes</a>
  }

##### [UpdatePluginEvent](#update-plugin-event-) ::= {
    type: <a href="#chain-plugin-type">ChainPluginType</a>
    jar: <a href="#option">Option</a><<a href="#dynamic-bytes">DynamicBytes</a>>
    invocation: <a href="#dynamic-bytes">DynamicBytes</a>
  }

##### [CallbackEvent](#callback-event-) ::= {
    returnEnvelope: <a href="#return-envelope">ReturnEnvelope</a>
    completedTransaction: <a href="#hash">Hash</a>
    success: <a href="#boolean">Boolean</a>
    returnValue: <a href="#dynamic-bytes">DynamicBytes</a>
  }

##### [CreateShardEvent](#create-shard-event-) ::= {
    shardId: <a href="#string">String</a>
  }

##### [RemoveShardEvent](#remove-shard-event-) ::= {
    shardId: <a href="#string">String</a>
  }

##### [UpdateContextFreePluginState](#update-context-free-plugin-state-) ::= {
    type: <a href="#chain-plugin-type">ChainPluginType</a>
    rpc: <a href="#dynamic-bytes">DynamicBytes</a>
  }

##### [UpgradeSystemContractEvent](#upgrade-system-contract-event-) ::= {
    contractAddress: <a href="#address">Address</a>
    binderJar: <a href="#dynamic-bytes">DynamicBytes</a>
    contractJar: <a href="#dynamic-bytes">DynamicBytes</a>
    abi: <a href="#dynamic-bytes">DynamicBytes</a>
    rpc: <a href="#dynamic-bytes">DynamicBytes</a>
  }

##### [RemoveContract](#remove-contract-) ::= {
    contractAddress: <a href="#address">Address</a>
  }

##### [SyncEvent](#sync-event-) ::= {
    accounts: <a href="#list">List</a><<a href="#account-transfer">AccountTransfer</a>>
    contracts: <a href="#list">List</a><<a href="#contract-transfer">ContractTransfer</a>>
    stateStorage: <a href="#list">List</a><<a href="#dynamic-bytes">DynamicBytes</a>>
  }

##### [AccountTransfer](#account-transfer-) ::= {
    address: <a href="#address">Address</a>
    accountStateHash: <a href="#hash">Hash</a>
    pluginStateHash: <a href="#hash">Hash</a>
  }

##### [ContractTransfer](#contract-transfer-) ::= {
    address: <a href="#address">Address</a>
    ContractStateHash: <a href="#hash">Hash</a>
    pluginStateHash: <a href="#hash">Hash</a>
  }

##### [ShardRoute](#shard-route-) ::= {
    targetShard: <a href="#option">Option</a><<a href="#string">String</a>>
    nonce: <a href="#long">Long</a>
  }

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