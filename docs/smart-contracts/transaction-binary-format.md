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

<br />

##### [Signature](#signature)

::= {

<div class="fields"/>
recoveryId: 0xnn
<div class="field-with-comment" markdown>
valueR: 0xnn×32
<p class="comment">(big-endian)</p>
</div>
<div class="field-with-comment" markdown>
valueS: 0xnn×32
<p class="comment">(big-endian)</p>
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
  <p>nonce: 0xnn×8</p>
  <p class="comment">(big-endian)</p>
</div>
<div class="field-with-comment">
<p >validToTime: 0xnn×8</p>
<p class="comment">(big-endian)</p>
</div>
<div class="field-with-comment" markdown>
<p>gasCost:  0xnn×8</p>
<p class="comment">(big-endian)</p>
</div>
  <div class="fields"/>
  address: [Address](#address)  
  rpc: [DynamicBytes](#dynamicbytes)
  
  }
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

The `chain id` is a unique identifier for the blockchain. For example, the chain id for Partisia Blockchain mainnet is
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
height: [Byte](#byte)  
returnEnvelope: [Option](#optiont)<[ReturnEnvelope](#returnenvelope)>

}

</div>

The transaction, [EventTransaction](#eventtransaction), includes:

- The originating transaction: the [SignedTransaction](#signedtransaction) initiating the tree of events that this event is a part of.
- The event type, [InnerEvent](#innerevent).
- The [ShardRoute](#shardroute) describes which shard the event should be executed on.
- The id of the [committee](https://partisiablockchain.gitlab.io/documentation/pbc-fundamentals/dictionary.html#committee) that produced the block where the event was spawned. The committee id is used to find the correct committee for validating a finalization proof sent from one shard to another. The committee id of an event must be larger than the latest committee id.
- The [governance](https://partisiablockchain.gitlab.io/documentation/pbc-fundamentals/governance-system-smart-contracts-overview.html) version when this event was produced. The governance version is incremented when the global state is changes, e.g. when updating a plugin. The governance version of the event must be up-to-date with the local governance version.
- The height of the event tree, which is increased for each event spawned after a signed transaction.
- If there is a callback registered to the event, the result of the event is returned in a [ReturnEnvelope](#returnenvelope).

<div class="binary-format" markdown>
##### [ShardRoute](#shardroute)
::= {
<div class="fields"/>
targetShard: [Option](#optiont)<[String](#string)>  
nonce: [Long](#long)

}

</div>

A [ShardRoute](#shardroute), the unique routing to a shard, contains the id of a target shard and a nonce.

#### Event Types

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

### Inner Transaction

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

The [InnerTransaction](#innertransaction) contains an associated sender and an associated cost, as well as the transaction.

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

A [Transaction](#transaction) is either a [CreateContractTransaction](#createcontracttransaction) used to deploy contracts, or an [InteractWithContractTransaction](#interactwithcontracttransaction) used to interact with contracts.

#### Create Contract Transaction

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

A [CreateContractTransaction](#createcontracttransaction) contains the [Address](#address) where the contract should be deployed, and the binding jar, the contract jar, the contract ABI and the RPC of the create-invocation.

#### Interact with Contract Transaction

<div class="binary-format" markdown>
##### [InteractWithContractTransaction](#interactwithcontracttransaction)
::= {
<div class="fields"/>
contractId: [Address](#address)  
payload: [DynamicBytes](#dynamicbytes)

}

</div>

An [InteractWithContractTransaction](#interactwithcontracttransaction) contains the [Address](#address) of the contract to interact with, as well as a payload (RPC) defining the interaction.

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

A [CallbackToContract](#callbacktocontract) contains the [Address](#address) of the contract to target, as well as information about the callback: The event transactions that has been awaited and is completed, the sender, the allocated cost for the callback event, and the callback RPC.

### Inner System Event

System events can manipulate the system state of the blockchain. These are primarily sent by system/governance contracts.

<div class="binary-format" markdown>
##### [InnerSystemEvent](#innersystemevent)
::= {
<div class="fields"/>
systemEventType: [SystemEventType](#systemeventtype)

}

</div>
An [InnerSystemEvent](#innersystemevent) has a [SystemEventType](#systemeventtype).

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

#### Create Account Event

<div class="binary-format" markdown>
##### [CreateAccountEvent](#createaccountevent)
::= {
<div class="fields"/>
toCreate: [Address](#address)

}

</div>

A [CreateAccountEvent](#createaccountevent) contains the address of the account to create.

#### Check Existence Event

<div class="binary-format" markdown>
##### [CheckExistenceEvent](#checkexistenceevent)
::= {
<div class="fields"/>
contractOrAccountAddress: [Address](#address)

}

</div>

A [CheckExistenceEvent](#checkexistenceevent) is an event for checking the existence of a contract or account address.

#### Set Feature Event

<div class="binary-format" markdown>
##### [SetFeatureEvent](#setfeatureevent)
::= {
<div class="fields"/>
key: [String](#string)  
value: [Option](#optiont)<[String](#string)>

}

</div>

A [SetFeatureEvent](#setfeatureevent) is an event for setting a feature in the state. The key indicates the feature to set, and the value is the value to set on the feature.

#### Update Local Plugin State Event

<div class="binary-format" markdown>
##### [UpdateLocalPluginStateEvent](#updatelocalpluginstateevent)
::= {
<div class="fields"/>
type: [ChainPluginType](#chainplugintype)  
update: [LocalPluginStateUpdate](#localpluginstateupdate)

}

</div>

A [UpdateLocalPluginStateEvent](#updatelocalpluginstateevent) updates the local state of the plugin, and its fields are a plugin type [ChainPluginType](#chainplugintype) and a plugin state [LocalPluginStateUpdate](#localpluginstateupdate).

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

A [ChainPluginType](#chainplugintype) can have the following types:

- The **Account** plugin controls additional information about account and fees.
- The **Consensus** plugin validates block proposals and finalizes correct blocks.
- The **Routing plugin** selects the right shard for any transaction.
- The **SharedObjectStore** plugin stores binary objects across all shards.

<div class="binary-format" markdown>
##### [LocalPluginStateUpdate](#localpluginstateupdate)
::= {
<div class="fields"/>
context: [Address](#address)  
rpc: [DynamicBytes](#dynamicbytes)

}

</div>

A [LocalPluginStateUpdate](#localpluginstateupdate) contains the [Address](#address) of the contract where the state should be updated, as well as RPC with the update.

#### Update Global Plugin State Event

<div class="binary-format" markdown>
##### [UpdateGlobalPluginStateEvent](#updateglobalpluginstateevent)
::= {
<div class="fields"/>
type: [ChainPluginType](#chainplugintype)  
update: [GlobalPluginStateUpdate](#globalpluginstateupdate)

}

</div>

A [UpdateGlobalPluginStateEvent](#updateglobalpluginstateevent) contains a chain plugin type [ChainPluginType](#chainplugintype) and a state update [GlobalPluginStateUpdate](#globalpluginstateupdate).

<div class="binary-format" markdown>
##### [GlobalPluginStateUpdate](#globalpluginstateupdate)
::= {
<div class="fields"/>
rpc: [DynamicBytes](#dynamicbytes)

}

</div>

The [GlobalPluginStateUpdate](#globalpluginstateupdate) contains the RPC of the update to execute globally.

#### Update Plugin Event

<div class="binary-format" markdown>
##### [UpdatePluginEvent](#updatepluginevent)
::= {
<div class="fields"/>
type: [ChainPluginType](#chainplugintype)  
jar: [Option](#optiont)<[DynamicBytes](#dynamicbytes)>  
rpc: [DynamicBytes](#dynamicbytes)

}

</div>

An [UpdatePluginEvent](#updatepluginevent) constructs a new event for updating an active plugin. It takes the type of the chain plugin to update, the jar to use as plugin, and RPC of global state migration.

#### Callback Event

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

A [CallbackEvent](#callbackevent) is the callback sent when a transaction has been executed. It contains the following fields:

- A [ReturnEnvelope](#returnenvelope) with the destination for the callback.
- A [Hash](#hash) of the transaction which has been executed.
- A [Boolean](#boolean) indicating whether the transaction was successful.
- The return value of the callback event.

#### Create Shard Event

<div class="binary-format" markdown>
##### [CreateShardEvent](#createshardevent)
::= {
<div class="fields"/>
shardId: [String](#string)

}

</div>

A [CreateShardEvent](#createshardevent) is an event for creating a shard. The shardId is the id of the shard to create.

#### Remove Shard Event

<div class="binary-format" markdown>
##### [RemoveShardEvent](#removeshardevent)
::= {
<div class="fields"/>
shardId: [String](#string)

}

</div>

A [RemoveShardEvent](#removeshardevent) is an event for removing a shard. The shardId is the id of the shard to remove.

#### Update Context Free Plugin State

<div class="binary-format" markdown>
##### [UpdateContextFreePluginState](#updatecontextfreepluginstate)
::= {
<div class="fields"/>
type: [ChainPluginType](#chainplugintype)  
rpc: [DynamicBytes](#dynamicbytes)

}

</div>

An [UpdateContextFreePluginState](#updatecontextfreepluginstate) updates the local state of a plugin without context on a named shard. Its fields are the type of plugin to update, i.e. [ChainPluginType](#chainplugintype), and the local state migration RPC.

#### Upgrade System Contract Event

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

An [UpgradeSystemContractEvent](#upgradesystemcontractevent) upgrades a contract. It contains the contract address, the binder jar, the contract jar, the contract ABI, and the upgrade RPC.

#### Remove Contract

<div class="binary-format" markdown>
##### [RemoveContract](#removecontract)
::= {
<div class="fields"/>
contractAddress: [Address](#address)

}

</div>

The [RemoveContract](#removecontract) event removes an existing contract from the state. The contract to remove is specified by the [Address](#address) of the contract.

### Sync Event

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

The [SyncEvent](#syncevent) contains a lists of account transfer objects, contract transfer objects and serialized data of stored states.

<div class="binary-format" markdown>
##### [AccountTransfer](#accounttransfer)
::= {
<div class="fields"/>
address: [Address](#address)  
accountStateHash: [Hash](#hash)  
pluginStateHash: [Hash](#hash)

}

</div>

An [AccountTransfer](#accounttransfer) consists of an account [Address](#address), a [Hash](#hash) of the account state and a [Hash](#hash) of the plugin state.

<div class="binary-format" markdown>
##### [ContractTransfer](#contracttransfer)
::= {
<div class="fields"/>
address: [Address](#address)  
contractStateHash: [Hash](#hash)  
pluginStateHash: [Hash](#hash)

}

</div>

An [ContractTransfer](#contracttransfer) consists of a contract [Address](#address), a [Hash](#hash) of the contract state and a [Hash](#hash) of the plugin state.

## Common Types

#### Address Type

An [Address](#address) is encoded as 21 bytes. The first byte is the [AddressType](#addresstype), and the remaining 20 bytes are the address identifier.

<div class="binary-format" markdown>
<div class="type-with-comment" markdown>
##### [Address](#address)
<p markdown> ::= addressType:[AddressType](#addresstype) identifier:0xnn×20</p>
<p class="comment">(identifier is big-endian)</p>
</div>
</div>

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

#### Boolean Type

A [Boolean](#boolean) is encoded as a single byte, which is either 0 (false) or non-0 (true).

<div class="binary-format" markdown>
<div class="type-with-comment" markdown>
##### [Boolean](#boolean)
<p>::= b:0xnn</p>
<p class="comment">(false if b==0, true otherwise)</p>
</div>
</div>

#### Byte Type

A [Byte](#byte) is encoded as a byte corresponding to its value.

<div class="binary-format" markdown>
##### [Byte](#byte)

::= 0xnn <br>

</div>

#### Dynamic Bytes

[DynamicBytes](#dynamicbytes) are encoded as a length, len, of 4 bytes, and a payload of len bytes. Both len and payload are encoded in big-endian order.

<div class="binary-format" markdown>
<div class="type-with-comment" markdown>
##### [DynamicBytes](#dynamicbytes)
<p> ::= len:0xnn×4 payload:0xnn×len </p>
<p class="comment">(big-endian)</p>
</div>
</div>

#### Hash Type

A [Hash](#hash) is encoded as 32 bytes in big-endian order.

<div class="binary-format" markdown>
<div class="type-with-comment" markdown>
##### [Hash](#hash)
<p> ::= 0xnn×32</p>
<p class="comment">(big-endian)</p>
</div>
</div>

#### List Type

A [List<T\>](#listt) of len elements of type **T** are encoded as the len (4 bytes, big-endian order), and the len elements are encoded according to their type **T**.

<div class="binary-format" markdown>
<div class="type-with-comment" markdown>
##### [List<T\>](#listt)
<p>::= len:0xnn×4 elems:<b>T</b>×len</p>
<p class="comment">(len is big-endian)</p>
</div>
</div>

#### Long Type

A [Long](#long) is encoded as 8 bytes in big-endian order.

<div class="binary-format" markdown>
<div class="type-with-comment" markdown>
##### [Long](#long)
<p> ::= 0xnn×8</p>
<p class="comment">(big-endian)</p>
</div>
</div>

#### Option Type

An [Option<T\>](#optiont) is encoded as either one 0-byte if **T** is None, or as a non-zero byte and the encoding of **T** according to its type.

<div class="binary-format" markdown>
<div class="type-with-comment" markdown>
##### [Option<T\>](#optiont)
::= 
<div class="column-align" markdown >
  <p markdown > 0x00 => None </p>
  <div class="field-and-comment-row" >
    <p class="spaced-or" markdown > | b:0xnn t:<b>T</b> => Some(t) </p>
    <p class="comment">(b != 0)</p>
  </div>
</div>
</div>
</div>

#### Return Envelope

A [ReturnEnvelope](#returnenvelope) is encoded as an [Address](#address).

<div class="binary-format" markdown>
##### [ReturnEnvelope](#returnenvelope)
::= [Address](#address)<br>
</div>

#### String Type

A [String](#string) is encoded as its length, len (4 bytes), and the UTF-8 of len bytes. Both are encoded in big-endian order.

<div class="binary-format" markdown>
<div class="type-with-comment" markdown>
##### [String](#string)
<p> ::= len:0xnn×4 uft8:0xnn×len</p> 
<p class="comment">(big-endian)</p>
</div>
</div>
