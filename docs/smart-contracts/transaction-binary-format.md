# Transaction Binary Format

This is the specification for transactions, which includes signed transactions from users and executable events which is spawned by the blockchain. 

A signed transaction is an instruction from a user containing information used to change the state of the blockchain.
An executable event is spawned by the blockchain, when it receives a signed transaction. The executable event contains the information about which action to perform to a smart contract.

You can learn more about how interactions work on the blockchain [here](smart-contract-interactions-on-the-blockchain.md#simple-interaction-model).

After constructing a binary signed transaction it can be delivered to any baker node in the network through
their [REST API](../rest).

## Signed Transaction


The following is the specification of the binary format of signed transactions.

The easiest way of creating a binary signed transaction is by using one of the
available [client libraries](smart-contract-tools-overview.md#client). This specification can help you if you want to
make your own implementation, for instance if you are targeting another programming language.


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
<div class="field-with-comment" markdown>
<p markdown>valueR: <span class="bytes">0<span class="sep">x</span>nn\*32</span></p>
<p class="endian"><span class="endian">(big endian)</span> </p>
</div>
<div class="field-with-comment" markdown>
<p markdown>valueS: <span class="bytes">0<span class="sep">x</span>nn\*32</span></p>
<p class="endian"><span class="endian">(big endian)</span> </p>
</div>  

}
</div>

The [Signature](#signature) includes:

- a recovery id between 0 and 3 used to recover the public key when verifying the signature
- the r value of the ECDSA signature
- the s value of the ECDSA signature

<div class="binary-format" markdown>
##### [Transaction](#transaction)
::= {
<div class="field-with-comment" markdown>
<p markdown> nonce: <span class="bytes">0<span class="sep">x</span>nn\*8</span> </p>
<p class="endian"><span class="endian">(big endian)</span> </p>
</div>
<div class="field-with-comment" markdown>
<p markdown>validToTime: <span class="bytes">0<span class="sep">x</span>nn\*8</span></p>
<p class="endian"><span class="endian">(big endian)</span> </p>
</div>
<div class="field-with-comment" markdown>
<p markdown>gasCost: <span class="bytes">0<span class="sep">x</span>nn\*8</span> </p>
<p class="endian"><span class="endian">(big endian)</span> </p>
</div>
<div class="fields"/>
address: [Address](#address)  
rpc: [Rpc](#rpc)

}

</div>

<div class="binary-format" markdown>
<div class="type-with-comment" markdown>
##### [Rpc](#rpc)
<p markdown>::= len:<span class="bytes">0<span class="sep">x</span>nn\*4</span> payload:<span class="bytes">0<span class="sep">x</span>nn\*</span>len </p>
<p class="endian"><span class="endian">(len is big endian)</span></p>
</div>
</div>



The [Transaction](#transactionouter) includes:

- the signer's [nonce](../pbc-fundamentals/dictionary.md#nonce)
- a unix time that the transaction is valid to
- the amount of [gas](gas/transaction-gas-prices.md) allocated to executing the transaction
- the address of the smart contract that is the target of the transaction
- the rpc payload of the transaction. See [Smart Contract Binary Formats](smart-contract-binary-formats.md)
  for a way to build the rpc payload.

### Creating the signature

The signature is an ECDSA signature, using secp256k1 as the curve, on a sha256 hash of the transaction and the chain ID of
the blockchain.

<div class="binary-format" markdown>
##### [ToBeHashed](#tobehashed)
::= transaction: [Transaction](#transaction) chainId: [ChainId](#chainid)
</div>
<div class="binary-format" markdown>
<div class="type-with-comment" markdown>
##### [ChainId](#chainid)
<p markdown>::=  len: <span class="bytes">0<span class="sep">x</span>nn\*4</span>  utf8: <span class="bytes">0<span class="sep">x</span>nn\*</span>len</p>
<p class="endian"><span class="endian">(len is big endian)</span></p>
</div>
</div>

The chain id is a unique identifier for the blockchain. For example, the chain id for Partisia Blockchain mainnet is
`Partisia Blockchain` and the chain id for the testnet is `Partisia Blockchain Testnet`.


## Executable Event Binary Format

The following is the specification of the binary format of executable events.


<div class="binary-format" markdown>
##### [ExecutableEvent](#executableevent)
::= {
<div class="fields"/>
originShard: [Option](#optiont)<[String](#string)>  
transaction: [EventTransaction](#eventtransaction)

}
</div>

The originShard is an [Option](#optiont)<[String](#string)>, the originating shard.


<div class="binary-format" markdown>
##### [EventTransaction](#eventtransaction)
::= {
<div class="fields"/>
originatingTransaction: [Hash](#hash)  
inner: [InnerEvent](#innerevent)  
shardRoute: [ShardRoute](#shardroute)  
committeeId: [Long](#long)  
governanceVersion: [Long](#long)  
<div class="field-with-comment" markdown>
<p markdown>height: [Byte](#byte)</p>
<p class="endian"><span class="endian">(unsigned)</span></p>
</div>
<div class="fields"/>
returnEnvelope: [Option](#optiont)<[ReturnEnvelope](#returnenvelope)>

}
</div>

The [EventTransaction](#eventtransaction) includes:

- The originating transaction: the [SignedTransaction](#signedtransaction) initiating the tree of events that this event is a part of.
- The actual [InnerEvent](#innerevent), i.e. the event type. 
- The [ShardRoute](#shardroute)   this event is going to and nonce for this event
- The committee id for the block producing this event
- The version of governance when this event was produced
- Current call height in the event stack
- Callback ([ReturnEnvelope](#returnenvelope)) if any

#### Event Types

The [InnerEvent](#innerevent) of an [EventTransaction](#eventtransaction) is divided into four types of events: [InnerTransaction](#innertransaction), [CallbackToContract](#callbacktocontract), [InnerSystemEvent](#innersystemevent) and [SyncEvent](#syncevent).

<div class="binary-format" markdown>
<div class="type-with-comment" markdown>
##### [InnerEvent](#innerevent)
::= 
<div class="column-align" markdown>
<p markdown > 0x00 [InnerTransaction](#innertransaction)  </p>
<p markdown class="spaced-or">| 0x01 [CallbackToContract](#callbacktocontract) </p>
<p markdown class="spaced-or">| 0x02 [InnerSystemEvent](#innersystemevent) </p>
<p markdown class="spaced-or">| 0x03 [SyncEvent](#syncevent) </p>
</div>
</div>
</div>



#### Inner Transaction

A transaction is sent by the user or the contract, meaning that it represents the actions the user can activate. 
Transactions can either deploy contracts or interact with them.
Each transaction also carries an associated sender and an associated cost.

<div class="binary-format" markdown>
##### [InnerTransaction](#innertransaction)
::= {
<div class="fields"/>
from: [Address](#address)  
cost: [Long](#long)  
transaction: [Transaction](#transaction) 

}
</div>


<div class="binary-format" markdown>
<div class="type-with-comment" markdown>
##### [Transaction](#transaction)
::= 
<div class="column-align" markdown>
<p markdown > 0x00 => [CreateContractTransaction](#createcontracttransaction)  </p>
<p markdown class="spaced-or">| 0x01 => [InteractWithContractTransaction](#interactwithcontracttransaction) </p>
</div>
</div>
</div>



<div class="binary-format" markdown>
##### [CreateContractTransaction](#createcontracttransaction)
::= {
<div class="fields"/>
address: [Address](#address)  
binderJar: [DynamicBytes](#dynamicbytes)  
contractJar: [DynamicBytes](#dynamicbytes)  
abi: [DynamicBytes](#dynamicbytes)  
rpc: [DynamicBytes](#dynamicbytes)

}
</div>

<div class="binary-format" markdown>
##### [InteractWithContractTransaction](#interactwithcontracttransaction)
::= {
<div class="fields"/>
contractId: [Address](#address)  
payload: [DynamicBytes](#dynamicbytes)

}
</div>

### Callback to Contract
Callback transactions call the callback methods in contracts.


<div class="binary-format" markdown>
##### [CallbackToContract](#callbacktocontract)
::= {
<div class="fields"/>
address: [Address](#address)  
callbackIdentifier: [Hash](#hash)  
from: [Address](#address)  
cost: [Long](#long)  
callbackRpc: [DynamicBytes](#dynamicbytes)

}
</div>

### Inner System Event

System events can manipulate the system state of the blockchain. These are primarily sent by system/governance contracts.

<div class="binary-format" markdown>


##### [InnerSystemEvent](#innersystemevent)
::= {
<div class="fields"/>
systemEventType: [SystemEventType](#systemeventtype)

}
</div>


<div class="binary-format" markdown>
<div class="type-with-comment" markdown>
##### [SystemEventType](#systemeventtype)
::= 
<div class="column-align" markdown>
<p markdown > 0x00 [CreateAccountEvent](#createaccountevent) </p>
<p markdown class="spaced-or">| 0x01 [CheckExistenceEvent](#checkexistenceevent) </p>
<p markdown class="spaced-or">|  0x02 [SetFeatureEvent](#setfeatureevent)  
<p markdown class="spaced-or">|  0x03 [UpdateLocalPluginStateEvent](#updatelocalpluginstateevent)  
<p markdown class="spaced-or">|  0x04 [UpdateGlobalPluginStateEvent](#updateglobalpluginstateevent)  
<p markdown class="spaced-or">|  0x05 [UpdatePluginEvent](#updatepluginevent)  
<p markdown class="spaced-or">|  0x06 [CallbackEvent](#callbackevent)  
<p markdown class="spaced-or">|  0x07 [CreateShardEvent](#createshardevent)  
<p markdown class="spaced-or">|  0x08 [RemoveShardEvent](#removeshardevent)  
<p markdown class="spaced-or">|  0x09 [UpdateContextFreePluginState](#updatecontextfreepluginstate)  
<p markdown class="spaced-or">|  0x0A [UpgradeSystemContractEvent](#upgradesystemcontractevent)  
<p markdown class="spaced-or">|  0x0B [RemoveContract](#removecontract)
</div>
</div>
</div>

<div class="binary-format" markdown>
##### [CreateAccountEvent](#createaccountevent)
::= {
<div class="fields"/>
toCreate: [Address](#address)

}
</div>

<div class="binary-format" markdown>
##### [CheckExistenceEvent](#checkexistenceevent)
::= {
<div class="fields"/>
contractOrAccountAddress: [Address](#address)

}
</div>
<div class="binary-format" markdown>


##### [SetFeatureEvent](#setfeatureevent)
::= {
<div class="fields"/>
key: [String](#string)  
value: [Option](#optiont)<[String](#string)>

}
</div>

<div class="binary-format" markdown>
##### [UpdateLocalPluginStateEvent](#updatelocalpluginstateevent)
::= {
<div class="fields"/>
type: [ChainPluginType](#chainplugintype)  
update: [LocalPluginStateUpdate](#localpluginstateupdate)

}
</div>


<div class="binary-format" markdown>
<div class="type-with-comment" markdown>
##### [ChainPluginType](#chainplugintype)
::= 
<div class="column-align" markdown>
<p markdown > 0x00 => <b>Account</b> </p>
<p markdown class="spaced-or">| 0x01 => <b>Consensus</b> </p>
<p markdown class="spaced-or">| 0x02 => <b>Routing</b>  
<p markdown class="spaced-or">| 0x03 => <b>SharedObjectStore</b>
</div>
</div>
</div>



<div class="binary-format" markdown>
##### [LocalPluginStateUpdate](#localpluginstateupdate)
::= {
<div class="fields"/>
context: [Address](#address)  
rpc: [DynamicBytes](#dynamicbytes)

}
</div>

<div class="binary-format" markdown>
##### [UpdateGlobalPluginStateEvent](#updateglobalpluginstateevent)
::= {
<div class="fields"/>
type: [ChainPluginType](#chainplugintype)  
update: [GlobalPluginStateUpdate](#globalpluginstateupdate)

}
</div>

<div class="binary-format" markdown>
##### [GlobalPluginStateUpdate](#globalpluginstateupdate)
::= {
<div class="fields"/>
rpc: [DynamicBytes](#dynamicbytes)

}

</div>

<div class="binary-format" markdown>
##### [UpdatePluginEvent](#updatepluginevent)
::= {
<div class="fields"/>
type: [ChainPluginType](#chainplugintype)  
jar: [Option](#optiont)<[DynamicBytes](#dynamicbytes)>  
invocation: [DynamicBytes](#dynamicbytes)

}
</div>

<div class="binary-format" markdown>
##### [CallbackEvent](#callbackevent)
::= {
<div class="fields"/>
returnEnvelope: [ReturnEnvelope](#returnenvelope)  
completedTransaction: [Hash](#hash)  
success: [Boolean](#boolean)  
returnValue: [DynamicBytes](#dynamicbytes)

}
</div>

<div class="binary-format" markdown>
##### [CreateShardEvent](#createshardevent)
::= {
<div class="fields"/>
shardId: [String](#string)

}
</div>

<div class="binary-format" markdown>
##### [RemoveShardEvent](#removeshardevent)
::= {
<div class="fields"/>
shardId: [String](#string)

}
</div>

<div class="binary-format" markdown>
##### [UpdateContextFreePluginState](#updatecontextfreepluginstate)
::= {
<div class="fields"/>
type: [ChainPluginType](#chainplugintype)  
rpc: [DynamicBytes](#dynamicbytes)

}
</div>

<div class="binary-format" markdown>
##### [UpgradeSystemContractEvent](#upgradesystemcontractevent)
::= {
<div class="fields"/>
contractAddress: [Address](#address)  
binderJar: [DynamicBytes](#dynamicbytes)  
contractJar: [DynamicBytes](#dynamicbytes)  
abi: [DynamicBytes](#dynamicbytes)  
rpc: [DynamicBytes](#dynamicbytes)

}
</div>

<div class="binary-format" markdown>
##### [RemoveContract](#removecontract)
::= {
<div class="fields"/>
contractAddress: [Address](#address)

}
</div>

<div class="binary-format" markdown>
### Sync Event
</div>

A sync event is used for moving information from one shard to another when changin the shard configuration. 
That is, when adding or removing shards or when changing routing logic.

<div class="binary-format" markdown>
##### [SyncEvent](#syncevent)
::= {
<div class="fields"/>
accounts: [List](#listt)<[AccountTransfer](#accounttransfer)>  
contracts: [List](#listt)<[ContractTransfer](#contracttransfer)>  
stateStorage: [List](#listt)<[DynamicBytes](#dynamicbytes)>

}
</div>

<div class="binary-format" markdown>
##### [AccountTransfer](#accounttransfer)
::= {
<div class="fields"/>
address: [Address](#address)  
accountStateHash: [Hash](#hash)  
pluginStateHash: [Hash](#hash)  

}
</div>

<div class="binary-format" markdown>
##### [ContractTransfer](#contracttransfer)
::= {
<div class="fields"/>
address: [Address](#address)  
ContractStateHash: [Hash](#hash)  
pluginStateHash: [Hash](#hash)

}
</div>

<div class="binary-format" markdown>
##### [ShardRoute](#shardroute)
::= {
<div class="fields"/>
targetShard: [Option](#optiont)<[String](#string)>  
nonce: [Long](#long)  

}
</div>


### Common Types

<div class="binary-format" markdown>
<div class="type-with-comment" markdown>
##### [Address](#address)
<p markdown> ::= addressType: [AddressType](#addresstype) identifier: <span class="bytes">0<span class="sep">x</span>nn\*20</span></p>
<p class="endian"> <span class="endian">(identifier is big-endian)</span></p>
</div>


<div class="type-with-comment" markdown>
##### [AddressType](#addresstype)
::= 
<div class="column-align" markdown>
<p markdown > 0x00 => <b>Account</b> </p>
<p markdown class="spaced-or">| 0x01 => <b>System</b></p>
<p markdown class="spaced-or">| 0x02 => <b>Public</b> </p>  
<p markdown class="spaced-or">| 0x03 => <b>Zk</b> </p>
<p markdown class="spaced-or">| 0x04 => <b>Gov</b> </p>
</div>
</div>

<div class="binary-format" markdown>
##### [ReturnEnvelope](#returnenvelope)
::= [Address](#address)<br>
<div class="type-with-comment" markdown>
##### [Hash](#hash)
<p> ::= <span class="bytes">0<span class="sep">x</span>nn*32</span></p>
<p class="endian"> <span class="endian">(big-endian)</span></p>
</div>

<div class="type-with-comment" markdown>
##### [Long](#long)
<p> ::= <span class="bytes">0<span class="sep">x</span>nn*8</span></p>
<p class="endian"> <span class="endian">(big-endian)</span></p>
</div>

##### [Byte](#byte)

::= <span class="bytes">0<span class="sep">x</span>nn</span><br>

<div class="type-with-comment" markdown>
##### [Boolean](#boolean)
<p>::= b: <span class="bytes">0<span class="sep">x</span>nn</span></p>
<p class="endian"><span class="endian">(false if b==0, true otherwise)</span></p>
</div>


<div class="type-with-comment" markdown>
##### [String](#string)
<p> ::= len:<span class="bytes">0<span class="sep">x</span>nn*4</span> uft8:<span class="bytes">0<span class="sep">x</span>nn*</span>len</p> 
<p class="endian"><span class="endian">(len is big endian)</span></p>
</div>

<div class="type-with-comment" markdown>
##### [DynamicBytes](#dynamicbytes)
<p> ::= len:<span class="bytes">0<span class="sep">x</span>nn*4</span> payload:<span class="bytes">0<span class="sep">x</span>nn*</span>len </p>
<p class="endian"> <span class="endian">(len is big endian)</span></p>
</div>


<div class="binary-format" markdown>
<div class="type-with-comment" markdown>
##### [Option<T\>](#optiont)
::= 
<div class="column-align" markdown>
<p markdown > 0x00 => None </p>
<p markdown  class="spaced-or" >| b:0xnn t:<b>T</b> => Some(t) </p>
</div>
<div class="comment-align" markdown>
<p class="endian"><span class="endian">&nbsp;</span></p>
<p markdown class="spaced">(b != 0)</p>
</div>
</div>
</div>


<div class="type-with-comment" markdown>
##### [List<T\>](#listt)
<p markdown>::= len: <span class="bytes">0<span class="sep">x</span>nn\*4</span> elems: <b>T</b>\*len </p>
<p class="endian"> <span class="endian">(len is big endian)</span> </p>
</div>

</div>



