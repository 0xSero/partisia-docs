# Transaction Binary Format

This is the specification for transactions, which includes signed transactions from users and executable events which is spawned by the blockchain.

A signed transaction is an instruction from a user containing information used to change the state of the blockchain.
An executable event is spawned by the blockchain, when it receives a signed transaction and verifies the signature.
The executable event contains the information about which action to perform to a smart contract.

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
address: [Address](#address)  
rpc: [Rpc](#rpc)

}

</div>

<div class="binary-format" markdown>

##### [Rpc](#rpc)

::= len:<span class="bytes">0<span class="sep">x</span>nn\*4</span> payload:<span class="bytes">0<span class="sep">x</span>nn\*</span>len <span class="endian">(len is big endian)</span>

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

##### [ChainId](#chainid)


::=  len: <span class="bytes">0<span class="sep">x</span>nn\*4</span>  utf8: <span class="bytes">0<span class="sep">x</span>nn\*</span>len  <span class="endian">(len is big endian)</span><br>

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

<div class="binary-format" markdown>

##### [EventTransaction](#eventtransaction)


::= {

  <div class="fields"/>
  
  originatingTransaction: [Hash](#hash)  
  inner: [InnerEvent](#innerevent)  
  shardRoute: [ShardRoute](#shardroute)  
  committeeId: [Long](#long)  
  governanceVersion: [Long](#long)  
  height: [Byte](#byte) <span class="endian">(unsigned)</span>  
  returnEnvelope: [Option](#optiont)<[ReturnEnvelope](#returnenvelope)>

}

</div>

#### Event Types

The [InnerEvent](#innerevent) of an [EventTransaction](#eventtransaction) is divided into four types of events: [InnerTransaction](#innertransaction), [CallbackToContract](#callbacktocontract), [InnerSystemEvent](#innersystemevent) and [SyncEvent](#syncevent).

<div class="binary-format" markdown>

##### [InnerEvent](#innerevent)


::= 0x00 [InnerTransaction](#innertransaction)  
<span class="left-align-spacer-alt"/>|  0x01 [CallbackToContract](#callbacktocontract)  
<span class="left-align-spacer-alt"/>|  0x02 [InnerSystemEvent](#innersystemevent)  
<span class="left-align-spacer-alt"/>|  0x03 [SyncEvent](#syncevent)

</div>


#### Inner Transaction

An event that is a transaction. It also carries an associated sender and an associated cost.

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

##### [Transaction](#transaction)


::= 0x00 => [CreateContractTransaction](#createcontracttransaction)  
<span class="left-align-spacer-alt"/> |  0x01 => [InteractWithContractTransaction](#interactwithcontracttransaction) 

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

A transaction sent to a contract for callbacks.


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

Event for manipulating the system state of the blockchain.

<div class="binary-format" markdown>


##### [InnerSystemEvent](#innersystemevent)


::= {

<div class="fields"/>

systemEventType: [SystemEventType](#systemeventtype)

}

</div>


<div class="binary-format" markdown>

##### [SystemEventType](#systemeventtype)


::=  0x00 [CreateAccountEvent](#createaccountevent)  
<span class="left-align-spacer"/> |  0x01 [CheckExistenceEvent](#checkexistenceevent)  
<span class="left-align-spacer"/> |  0x02 [SetFeatureEvent](#setfeatureevent)  
<span class="left-align-spacer"/> |  0x03 [UpdateLocalPluginStateEvent](#updatelocalpluginstateevent)  
<span class="left-align-spacer"/> |  0x04 [UpdateGlobalPluginStateEvent](#updateglobalpluginstateevent)  
<span class="left-align-spacer"/> |  0x05 [UpdatePluginEvent](#updatepluginevent)  
<span class="left-align-spacer"/> |  0x06 [CallbackEvent](#callbackevent)  
<span class="left-align-spacer"/> |  0x07 [CreateShardEvent](#createshardevent)  
<span class="left-align-spacer"/> |  0x08 [RemoveShardEvent](#removeshardevent)  
<span class="left-align-spacer"/> |  0x09 [UpdateContextFreePluginState](#updatecontextfreepluginstate)  
<span class="left-align-spacer"/> |  0x0A [UpgradeSystemContractEvent](#upgradesystemcontractevent)  
<span class="left-align-spacer"/> |  0x0B [RemoveContract](#removecontract)
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

##### [ChainPluginType](#chainplugintype)


::= 0x00 => <b>Account</b>  
<span class="left-align-spacer"/> |  0x01 => <b>Consensus</b>  
<span class="left-align-spacer"/> |  0x02 => <b>Routing</b>  
<span class="left-align-spacer"/> |  0x03 => <b>SharedObjectStore</b>


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


#### Sync Event
Event with any information that should be moved from one shard to another when changing the shard configuration.

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

##### [Address](#address)

::= addressType: [AddressType](#addresstype) identifier: <span class="bytes">0<span class="sep">x</span>nn\*20</span> <span class="endian">(identifier is big-endian)</span><br>

</div>

<div class="binary-format" markdown>

##### [AddressType](#addresstype)


::= 0x00 => **Account**  
<span class="left-align-spacer-alt"/>   |  0x01 => **System**  
<span class="left-align-spacer-alt"/>   |  0x02 => **Public**  
<span class="left-align-spacer-alt"/>   |  0x03 => **Zk**  
<span class="left-align-spacer-alt"/>   |  0x04 => **Gov**

</div>

<div class="binary-format" markdown>

##### [ReturnEnvelope](#returnenvelope)


::= [Address](#address)<br>


##### [Hash](#hash)

::= <span class="bytes">0<span class="sep">x</span>nn\*32</span> <span class="endian">(big-endian)</span><br>


##### [Long](#long)

::= <span class="bytes">0<span class="sep">x</span>nn\*8</span><span class="endian">(big-endian)</span><br>


##### [Byte](#byte)

::= <span class="bytes">0<span class="sep">x</span>nn</span><br>

##### [Boolean](#boolean)

::= b: <span class="bytes">0<span class="sep">x</span>nn</span>  <span class="endian">(false if b==0, true otherwise)</span><br>

##### [String](#string)

::= len:<span class="bytes">0<span class="sep">x</span>nn\*4</span> uft8:<span class="bytes">0<span class="sep">x</span>nn\*</span>len             <span class="endian">(len is big endian)</span><br>


##### [DynamicBytes](#dynamicbytes)

::= len:<span class="bytes">0<span class="sep">x</span>nn\*4</span> payload:<span class="bytes">0<span class="sep">x</span>nn\*</span>len        <span class="endian">(len is big endian)</span><br>


##### [Option<T\>](#optiont)

::= 0x00 => None  
<span class="left-align-spacer-alt"/>| b: 0xnn t:<b>T</b> => Some(t) <span class="endian">(b != 0)</span><br>

##### [List<T\>](#listt)
::= len: <span class="bytes">0<span class="sep">x</span>nn\*4</span> elems: <b>T</b>\*len <span class="endian">(len is big endian)</span><br>

</div>



The originShard is an [Option](#optiont)<[String](#string)>, the originating shard.

The EventTransaction includes:

- The originating transaction: the [SignedTransaction](#signedtransaction) initiating the tree of events that this event is a part of.
- The actual inner transaction
- The shard this event is going to and nonce for this event
- The committee id for the block producing this event
- The version of governance when this event was produced
- Current call height in the event stack
- Callback (address) if any