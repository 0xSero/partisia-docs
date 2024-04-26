# Transaction Binary Format

This is the specification for transactions, which includes signed transactions from users and executable events, which are spawned by the blockchain. 

You can learn more about how interactions work on the blockchain [here](smart-contract-interactions-on-the-blockchain.md#simple-interaction-model).

## Signed Transaction

A signed transaction is an instruction from a user containing information used to change the state of the blockchain.
After constructing a binary signed transaction it can be delivered to any baker node in the network through
their [REST API](../rest).

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
recoveryId: 0xnn
<div class="field-with-comment" markdown>
valueR: 0xnn*32
<p class="endian">(big-endian)</p>
</div>
<div class="field-with-comment" markdown>
valueS: 0xnn*32
<p class="endian">(big-endian)</p>
</div>  

}
</div>

The [Signature](#signature) includes:

- A recovery id between 0 and 3 used to recover the public key when verifying the signature
- The r value of the ECDSA signature
- The s value of the ECDSA signature

<div class="binary-format" markdown>
##### [Transaction](#transaction)
::= {
<div class="field-with-comment">
  <p>nonce: 0xnn*8</p>
  <p class="endian">(big-endian)</p>
</div>
<div class="field-with-comment">
<p >validToTime: 0xnn*8</p>
<p class="endian">(big-endian)</p>
</div>
<div class="field-with-comment" markdown>
<p>gasCost:  0xnn*8</p>
<p class="endian">(big-endian)</p>
</div>
  <div class="fields"/>
  address: [Address](#address)  
  rpc: [Rpc](#rpc)
  
  }
</div>

<div class="binary-format" markdown>
<div class="type-with-comment" markdown>
##### [Rpc](#rpc)
<p>::= len:0xnn\*4 payload:0xnn\*len</p>
<p class="endian">(len is big-endian)</p>
</div>
</div>



The [Transaction](#transactionouter) includes:

- The signer's [nonce](../pbc-fundamentals/dictionary.md#nonce)
- A unix time that the transaction is valid to
- The amount of [gas](gas/transaction-gas-prices.md) allocated to executing the transaction
- The address of the smart contract that is the target of the transaction
- The rpc payload of the transaction. See [Smart Contract Binary Formats](smart-contract-binary-formats.md)
  for a way to build the rpc payload.

### Creating the signature

The signature is an ECDSA signature, using secp256k1 as the curve, on a sha256 hash of the transaction and the chain ID of
the blockchain.

<div class="binary-format" markdown>
##### [ToBeHashed](#tobehashed)
::= transaction:[Transaction](#transaction) chainId:[ChainId](#chainid)
</div>

<div class="binary-format" markdown>
##### [ChainId](#chainid)

::= [String](#string)
</div>

The chain id is a unique identifier for the blockchain. For example, the chain id for Partisia Blockchain mainnet is
`Partisia Blockchain` and the chain id for the testnet is `Partisia Blockchain Testnet`.


## Executable Event Binary Format

An executable event is spawned by the blockchain, and not by a user. It can be created from other events or when the blockchain receives a signed transaction. The executable event contains the information about which action to perform to a smart contract.

The following is the specification of the binary format of executable events.


<div class="binary-format" markdown>
##### [ExecutableEvent](#executableevent)
::= {
<div class="fields"/>
originShard: [Option](#optiont)<[String](#string)>  
transaction: [EventTransaction](#eventtransaction)

}
</div>

The originShard is an [Option](#optiont)<[String](#string)>, the originating shard of the event.


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
<p class="endian">(unsigned)</p>
</div>
<div class="fields"/>
returnEnvelope: [Option](#optiont)<[ReturnEnvelope](#returnenvelope)>

}
</div>

The transaction, [EventTransaction](#eventtransaction), includes:

- The originating transaction: the [SignedTransaction](#signedtransaction) initiating the tree of events that this event is a part of.
- The event type, [InnerEvent](#innerevent).
- The [ShardRoute](#shardroute) describes which shard the event should be executed on.
- The id of the committee that produced the block where the event was spawned.
- The governance version when this event was produced.
- The height of the event tree, which is increased for each event spawned after a signed transaction.
- If there is a callback registered to the event, the result of the event is returned in a [ReturnEnvelope](#returnenvelope).  


### Event Types
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

The [InnerEvent](#innerevent) of an [EventTransaction](#eventtransaction) is divided into four types of events: [InnerTransaction](#innertransaction), [CallbackToContract](#callbacktocontract), [InnerSystemEvent](#innersystemevent) and [SyncEvent](#syncevent).

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

#### Callback to Contract
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

#### Inner System Event

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
<p> 0x00 => <b>Account</b> </p>
<p class="spaced-or">| 0x01 => <b>Consensus</b> </p>
<p class="spaced-or">| 0x02 => <b>Routing</b>  
<p class="spaced-or">| 0x03 => <b>SharedObjectStore</b>
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

A sync event is used for moving information from one shard to another when changing the shard configuration. 
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


#### Address Types
An [Address](#address) is encoded as 21 bytes. The first byte is the [AddressType](#addresstype), and the remaining 20 bytes are the address identifier.

<div class="binary-format" markdown>
<div class="type-with-comment" markdown>
##### [Address](#address)
<p markdown> ::= addressType:[AddressType](#addresstype) identifier:0xnn*20</p>
<p class="endian">(identifier is big-endian)</p>
</div>
</div>

<br>

An [AddressType](#addresstype) can either be an account address, a system address, public address, zk address or a government address.

<div class="binary-format" markdown>
<div class="type-with-comment" markdown>
##### [AddressType](#addresstype)
::= 
<div class="column-align" markdown>
<p> 0x00 => <b>Account</b> </p>
<p class="spaced-or">| 0x01 => <b>System</b></p>
<p class="spaced-or">| 0x02 => <b>Public</b> </p>  
<p class="spaced-or">| 0x03 => <b>Zk</b> </p>
<p class="spaced-or">| 0x04 => <b>Gov</b> </p>
</div>
</div>
</div>

<br>

#### Booleans

A [Boolean](#boolean) is encoded as a single byte, which is either 0 (false) or non-0 (true).

<div class="binary-format" markdown>
<div class="type-with-comment" markdown>
##### [Boolean](#boolean)
<p>::= b:0xnn</p>
<p class="endian">(false if b==0, true otherwise)</p>
</div>
</div>

<br>

#### Bytes 

A [Byte](#byte) is encoded as a byte corresponding to its value.
<div class="binary-format" markdown>
##### [Byte](#byte)

::= 0xnn  <br>
</div>

<br>

#### Dynamic Bytes

[DynamicBytes](#dynamicbytes) are encoded as a length, len, of 4 bytes, and a payload of len bytes. Both len and payload are encoded in big-endian order.

<div class="binary-format" markdown>
<div class="type-with-comment" markdown>
##### [DynamicBytes](#dynamicbytes)
<p> ::= len:0xnn*4 payload:0xnn*len </p>
<p class="endian">(big-endian)</p>
</div>
</div>

<br>

#### Hash Types

A [Hash](#hash) is encoded as 32 bytes in big-endian order.

<div class="binary-format" markdown>
<div class="type-with-comment" markdown>
##### [Hash](#hash)
<p> ::= 0xnn*32</p>
<p class="endian">(big-endian)</p>
</div>
</div>

<br>

#### Lists

A [List<T\>](#listt) of len elements of type **T** are encoded as the len (4 bytes, big-endian order), and the len elements are encoded according to their type **T**.

<div class="binary-format" markdown>
<div class="type-with-comment" markdown>
##### [List<T\>](#listt)
<p>::= len:0xnn*4 elems:<b>T</b>*len</p>
<p class="endian">(len is big-endian)</p>
</div>
</div>

<br>

#### Longs

A [Long](#long) is encoded as 8 bytes in big-endian order.

<div class="binary-format" markdown>
<div class="type-with-comment" markdown>
##### [Long](#long)
<p> ::= 0xnn*8</p>
<p class="endian">(big-endian)</p>
</div>
</div>

<br>

#### Option Types

An [Option<T\>](#optiont) is encoded as either one 0-byte if **T** is None, or as a non-zero byte and the encoding of **T** according to its type.

<div class="binary-format" markdown>
<div class="type-with-comment" markdown>
##### [Option<T\>](#optiont)
::= 
<div class="column-align" markdown>
<p> 0x00 => None </p>
<p class="spaced-or">| b:0xnn t:<b>T</b> => Some(t) </p>
</div>
<div class="comment-align" markdown>
<p class="endian">&nbsp;</p>
<p class="spaced">(b != 0)</p>
</div>
</div>
</div>

<br>

#### Return Envelopes


A [ReturnEnvelope](#returnenvelope) is encoded as an [Address](#address).

<div class="binary-format" markdown>
##### [ReturnEnvelope](#returnenvelope)
::= [Address](#address)<br>
</div>

<br>

#### Strings


A [String](#string) is encoded as its length, len (4 bytes), and the UTF-8 of len bytes. Both are encoded in big-endian order.

<div class="binary-format" markdown>
<div class="type-with-comment" markdown>
##### [String](#string)
<p> ::= len:0xnn*4 uft8:0xnn*len</p> 
<p class="endian">(big-endian)</p>
</div>
</div>







