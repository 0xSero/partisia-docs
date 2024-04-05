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
  
  signature: [Signature](#signature)  
  transaction: [Transaction](#transaction)

}


##### [Signature](#signature)

::= {

<div class="fields"/>

recoveryId: <span class="bytes">0<span class="sep">x</span>nn</span>  
valueR: <span class="bytes">0<span class="sep">x</span>nn\*32</span> <span class="endian">(big endian)</span>  
valueS: <span class="bytes">0<span class="sep">x</span>nn\*32</span> <span class="endian">(big endian)</span>  

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

nonce: <span class="bytes">0<span class="sep">x</span>nn\*8</span> <span class="endian">(big endian)</span>  
validToTime: <span class="bytes">0<span class="sep">x</span>nn\*8</span> <span class="endian">(big endian)</span>  
gasCost: <span class="bytes">0<span class="sep">x</span>nn\*8</span> <span class="endian">(big endian)</span>  
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

::= [Address](#address-)


##### [Hash](#hash-) 

::= <span class="bytes">0<span class="sep">x</span>nn\*32</span> <span class="endian">(big-endian)</span>  


##### [Long](#long)

::= <span class="bytes">0<span class="sep">x</span>nn\*8</span><span class="endian">(big-endian)</span>  


##### [Byte](#byte-) 

::= <span class="bytes">0<span class="sep">x</span>nn</span>  

##### [Boolean](#boolean)

::= b: <span class="bytes">0<span class="sep">x</span>nn</span>  <span class="endian">(false if b==0, true otherwise)</span><br>

##### [String](#string-) 

::= len:<span class="bytes">0<span class="sep">x</span>nn\*4</span> uft8:<span class="bytes">0<span class="sep">x</span>nn\*</span>len             <span class="endian">(len is big endian)</span><br>


##### [DynamicBytes](#dynamic-bytes-) 

::= len:<span class="bytes">0<span class="sep">x</span>nn\*4</span> payload:<span class="bytes">0<span class="sep">x</span>nn\*</span>len        <span class="endian">(len is big endian)</span><br>


##### [Option<T\>]()  

::= 0x00 => None  
| b: 0xnn t:<b>T</b> => Some(t) <span class="endian">(b != 0)</span><br>

##### [List<T/>]()
::= len: <span class="bytes">0<span class="sep">x</span>nn\*4</span> elems: <b>T</b>\*len <span class="endian">(len is big endian)</span><br>

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
</div>



<div class="binary-format" markdown>

##### [Transaction]() 

::= 0x00 => [CreateContractTransaction]()  
|  0x01 => [InteractWithContractTransaction]() 

</div>

<div class="binary-format" markdown>

##### [CreateContractTransaction](#create-contract-transaction-) 

::= {

<div class="fields"/>

address: [Address]()  
binderJar: [DynamicBytes]()  
contractJar: [DynamicBytes]()  
abi: [DynamicBytes]()  
rpc: [DynamicBytes]()

}

</div>

<div class="binary-format" markdown>

##### [InteractWithContractTransaction](#interact-with-contract-transaction-) 

::= {

<div class="fields"/>

contractId: [Address]()  
payload: [DynamicBytes]() 

}

</div>

<div class="binary-format" markdown>

##### [CallbackToContract](#callback-to-contract-) 

::= {

<div class="fields"/>

address: [Address]()  
callbackIdentifier: [Hash]()  
from: [Address]()  
cost: [Long]()  
callbackRpc: [DynamicBytes]()

}

</div>

<div class="binary-format" markdown>


##### [InnerSystemEvent](#inner-system-event-) 

::= {

<div class="fields"/>

systemEventType: [SystemEventType]()

}

</div>


<div class="binary-format" markdown>

##### [SystemEventType](#system-event-type-) 

::= 0x00 [CreateAccountEvent]()  
                  |  0x01 [CheckExistenceEvent]()  
                  |  0x02 [SetFeatureEvent]()  
                  |  0x03 [UpdateLocalPluginStateEvent]()  
                  |  0x04 [UpdateGlobalPluginStateEvent]()  
                  |  0x05 [UpdatePluginEvent]()  
                  |  0x06 [CallbackEvent]()  
                  |  0x07 [CreateShardEvent]()  
                  |  0x08 [RemoveShardEvent]()  
                  |  0x09 [UpdateContextFreePluginState]()  
                  |  0x0A [UpgradeSystemContractEvent]()  
                  |  0x0B [RemoveContract]()
</div>

<div class="binary-format" markdown>

##### [CreateAccountEvent](#create-account-event-)

::= {

<div class="fields"/>

toCreate: [Address]()

}

</div>

<div class="binary-format" markdown>

##### [CheckExistenceEvent](#check-existence-event-) 

::= {

<div class="fields"/>

contractOrAccountAddress: [Address]()

}

</div>

<div class="binary-format" markdown>


##### [SetFeatureEvent](#set-feature-event-) 

::= {

<div class="fields"/>

key: [String]()
value: [Option]()<[String]()>

}

</div>

<div class="binary-format" markdown>

##### [UpdateLocalPluginStateEvent](#update-local-plugin-state-event-) 

::= {

<div class="fields"/>

type: [ChainPluginType]()  
update: [LocalPluginStateUpdate]()

}

</div>

<div class="binary-format" markdown>

##### [ChainPluginType](#chain-plugin-type-) 

::= 0x00 => <b>Account</b>  
                 |  0x01 => <b>Consensus</b>  
                 |  0x02 => <b>Routing</b>  
                 |  0x03 => <b>SharedObjectStore</b>


</div>

<div class="binary-format" markdown>

##### [LocalPluginStateUpdate](#local-plugin-state-update-) 

::= {

<div class="fields"/>

context: [Address]()  
rpc: [DynamicBytes]()

}

</div>

<div class="binary-format" markdown>


##### [UpdateGlobalPluginStateEvent](#update-global-plugin-state-event-) 

::= {

<div class="fields"/>

type: [ChainPluginType]()  
update: [GlobalPluginStateUpdate]()

}

</div>

<div class="binary-format" markdown>

##### [GlobalPluginStateUpdate](#global-plugin-state-update-) 

::= {

<div class="fields"/>

rpc: [DynamicBytes]()

}

</div>

<div class="binary-format" markdown>

##### [UpdatePluginEvent](#update-plugin-event-) 

::= {

<div class="fields"/>

type: [ChainPluginType]()  
jar: [Option]()<[DynamicBytes]()>  
invocation: [DynamicBytes]()

}

</div>

<div class="binary-format" markdown>

##### [CallbackEvent](#callback-event-) 

::= {

<div class="fields"/>

returnEnvelope: [ReturnEnvelope]()  
completedTransaction: [Hash]()  
success: [Boolean]()  
returnValue: [DynamicBytes]()

}

</div>

<div class="binary-format" markdown>

##### [CreateShardEvent](#create-shard-event-) 

::= {

<div class="fields"/>

shardId: [String]()

}

</div>

<div class="binary-format" markdown>

##### [RemoveShardEvent](#remove-shard-event-) 

::= {

<div class="fields"/>

shardId: [String]()

}

</div>

<div class="binary-format" markdown>

##### [UpdateContextFreePluginState](#update-context-free-plugin-state-) 

::= {

<div class="fields"/>

type: [ChainPluginType]()  
rpc: [DynamicBytes]()

}

</div>

<div class="binary-format" markdown>

##### [UpgradeSystemContractEvent](#upgrade-system-contract-event-) 

::= {

<div class="fields"/>

contractAddress: [Address]()  
binderJar: [DynamicBytes]()  
contractJar: [DynamicBytes]()  
abi: [DynamicBytes]()  
rpc: [DynamicBytes]()

}


</div>

<div class="binary-format" markdown>

##### [RemoveContract](#remove-contract-) 

::= {

<div class="fields"/>

contractAddress: [Address]()

}


</div>

<div class="binary-format" markdown>

##### [SyncEvent](#sync-event-) 

::= {

<div class="fields"/>

accounts: [List]()<[AccountTransfer]()>  
contracts: [List]()<[ContractTransfer]()>>  
stateStorage: [List]()<[DynamicBytes]()>

}


</div>

<div class="binary-format" markdown>

##### [AccountTransfer](#account-transfer-) 

::= {

<div class="fields"/>

address: [Address]()  
accountStateHash: [Hash]()  
pluginStateHash: [Hash]()  

}

</div>

<div class="binary-format" markdown>

##### [ContractTransfer](#contract-transfer-) 

::= {

<div class="fields"/>

address: [Address]()  
ContractStateHash: [Hash]()  
pluginStateHash: [Hash]()

}


</div>

<div class="binary-format" markdown>

##### [ShardRoute](#shard-route-) 

::= {

<div class="fields"/>

targetShard: [Option]()<[String]()>  
nonce: [Long]()  

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