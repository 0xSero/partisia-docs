# Smart Contract Binary Formats

A Partisia Smart Contract utilizes three distinct binary formats, which are described in detail below.

- _RPC Format_: When an _action_ of the smart function is invoked, the payload is sent to the action as binary data. The payload identifies which action is invoked and the values for all parameters to the action.
- _State Format_: The _state_ of a smart contract is stored as binary data in the blockchain state. The state holds the value of all smart contract state variables.
- _ABI Format_: Meta-information about the smart contract is also stored as binary data, The ABI holds the list of available actions and their parameters and information about the different state variables.

## ABI Version changes
- Version **5.4** to **5.5**:
    * Smart contracts now support \(\text{(0..}\infty\text{)}\) of `FnKind: 0x11`.
    * Smart contracts now support \(\text{(0..}\infty\text{)}\) of `FnKind: 0x13`.
    * `FnKind 0x11` now requires a Shortname.
    * `FnKind 0x13` now requires a Shortname.
- Version **5.3** to **5.4**:
    * Added new `FnKind: 0x18` called `ZkExternalEvent`.
- Version **5.2** to **5.3**:
    * Added new type `AvlTreeMap`, a map whose content is not serialized to the wasm state format, but instead allows
  for lazy access to its contents.
- Version **5.1** to **5.2**:
    * Added new `FnKind: 0x17` called `ZkSecretInputWithExplicitType`.
    * Added `SecretArgument` field to `FnAbi` to support ZK inputs. Only present when `FnKind` is `ZkSecretInputWithExplicitType`.
    * `FnKind: 0x10` is now deprecated.
- Version **5.0** to **5.1**:
    * Added additional abi types: `U256`, `Hash`, `PublicKey`, `Signature`, `BlsPublicKey`, `BlsSignature`.
- Version **4.1** to **5.0**:
    * Added support for enum with struct items.
    * Changed `StructTypeSpec` to `NamedTypeSpec` which is either an `EnumTypeSpec` or `StructTypeSpec`.
      This means that there is an additional byte when reading the list of `NamedTypeSpec` in `ContractAbi`.
- Version **3.1** to **4.1**:
    * Added `Kind: FnKind` field to `FnAbi`.
    * Removed `Init` field from `ContractAbi`.
    * Added zero-knowledge related `FnKind`s, for use in Zk contracts.
- Version **2.0** to **3.1**:
    * Shortnames are now encoded as LEB128; `ShortnameLength` field have been
      removed.
    * Added explicit, easily extensible return result format.

## RPC Binary Format

The RPC payload identifies which action is invoked and the values for all parameters of the action.

To decode the payload binary format you have to know which argument types each action expects,
since the format of the argument values depends on the argument type.
The _ABI Format_ holds exactly the meta-data needed for finding types of the arguments for each action.

The RPC payload contains the short name identifying the action being called followed by each of the arguments for the action.


<div class="binary-format" markdown>
<div class="type-with-comment" markdown>
##### [PayloadRpc](#payloadrpc)
<p markdown>::= action:[Shortname](#shortname) arguments:[ArgumentsRpc](#argumentsrpc) => action(arguments) </p>
</div>
</div>

The short name of an action is an u32 integer identifier that uniquely identifies the action within the smart contract.
The short name is encoded as [unsigned LEB128 format](https://en.wikipedia.org/wiki/LEB128#Unsigned_LEB128), which means that short names have variable lengths.
It is easy to determine how many bytes a LEB128 encoded number contains by examining bit 7 of each byte.

<div class="binary-format" markdown>
<div class="type-with-comment" markdown>
##### [ShortName](#shortname)
<p markdown> ::= pre:0xnn last:0xnn => action </p>
<p class="endian"> <span class="endian">(where pre is 0-4 bytes that are &ge;0x80 and last &lt;0x80)</span></p>
</div>
</div>

The argument binary format depends on the type of the argument. The argument types for each action is defined by the contract, and can be read from the ABI format.

<div class="binary-format" markdown>
<div class="type-with-comment" markdown>
##### [ArgumentRpc](#argumentrpc) 
::= 
<div class="column-align" markdown>
<p markdown > 0xnn => u8/i8 </p>
<p markdown  class="spaced-or" >| 0xnn*2 => u16/i16 </p>
<p markdown  class="spaced-or" >| 0xnn*4 => u32/i32 </p>
<p markdown  class="spaced-or" >| 0xnn*8 => u64/i64 </p>
<p markdown  class="spaced-or" >| 0xnn*16 => u128/i128 </p>
<p markdown  class="spaced-or" >| 0xnn*32 => u256 </p>
<p markdown  class="spaced-or" >| b:0xnn => [Boolean](#boolean) </p>
<p markdown  class="spaced-or" >| 0xnn*21 => [Address](#address) </p>
<p markdown  class="spaced-or" >| 0xnn*32 => [Hash](#hash) </p>
<p markdown  class="spaced-or" >| 0xnn*33 => [PublicKey](#publickey) </p>
<p markdown  class="spaced-or" >| 0xnn*65 => [Signature](#signature) </p>
<p markdown  class="spaced-or" >| 0xnn*95 => [BlsPublicKey](#blspublickey) </p>
<p markdown  class="spaced-or" >| 0xnn*48 => [BlsSignature](#blssignature) </p>
<p markdown  class="spaced-or" >| 0xnn*len => [Array](#array)&lt;u8;len&gt; </p>
<p markdown  class="spaced-or" >| len:[LengthRpc](#lengthrpc) utf8:0xnn*len => [String](#string) </p>
<p markdown  class="spaced-or" >| len:[LengthRpc](#lengthrpc) elems:[ArgumentRpc](#argumentrpc)*len => [Vec](#vec)&lt;&gt; </p>
<p markdown  class="spaced-or" >| b:0xnn arg:[ArgumentRpc](#argumentrpc) => [Option](#optiont)&lt;&gt; </p>
<p markdown  class="spaced-or" >| <i>f<sub>1</sub></i>:[ArgumentRpc](#argumentrpc) ... <i>f<sub>n</sub></i>:[ArgumentRpc](#argumentrpc) => [Struct](#struct) S {<i>f<sub>1</sub></i>,<i>f<sub>2</sub></i>,...,<i>f<sub>n</sub></i>} </p>
<p markdown  class="spaced-or" >| variant:0xnn <i>f<sub>1</sub></i>:[ArgumentRpc](#argumentrpc) ... <i>f<sub>n</sub></i>:[ArgumentRpc](#argumentrpc) => [Enum](#enum){variant,<i>f<sub>1</sub></i>,<i>f<sub>2</sub></i>,...,<i>f<sub>n</sub></i>} </p>
</div>
<div class="comment-align" markdown>
<p class="endian"><span class="endian">(i8 is two's complement)</span></p>
<p markdown class="spaced">(big endian, i16 is two's complement)</p>
<p markdown class="spaced">(big endian, i32 is two's complement)</p>
<p markdown class="spaced">(big endian, i64 is two's complement)</p>
<p markdown class="spaced">(big endian, i128 is two's complement)</p>
<p markdown class="spaced">&nbsp;</p>
<p markdown class="spaced">(false if b==0, true otherwise)</p>
<p markdown class="spaced">&nbsp;</p>
<p markdown class="spaced">&nbsp;</p>
<p markdown class="spaced">&nbsp;</p>
<p markdown class="spaced">&nbsp;</p>
<p markdown class="spaced">&nbsp;</p>
<p markdown class="spaced">&nbsp;</p>
<p markdown class="spaced">(containing the len u8 values)</p>
<p markdown class="spaced">(with len UTF-8 encoded bytes)</p>
<p markdown class="spaced">(containing the len elements)</p>
<p markdown class="spaced">(None if b==0, Some(arg) otherwise)</p>
<p markdown class="spaced">&nbsp;</p>
<p markdown class="spaced">&nbsp;</p>
</div>
</div>
</div>


Only arrays of lengths between (including) 0 and 127 are supported. The high bit in length is reserved for later extensions.

For arguments with variable lengths, such as Vecs or Strings the number of elements is represented as a big endian 32-bit unsigned integer.

<div class="binary-format" markdown>
<div class="type-with-comment" markdown>
##### [LengthRpc](#lengthrpc)
<p markdown>::= 0xnn*4 => u32 </p>
<p class="endian"><span class="endian">(big endian)</span></p>
</div>
</div>

## State Binary Format

Integers are stored as little-endian. Signed integers are stored as two's
complement. Note that lengths are also stored as little-endian.

<div class="binary-format" markdown>
<div class="type-with-comment" markdown>
##### [State](#state)
::= 
<div class="column-align" markdown>
<p markdown >  0xnn => u8/i8 </p>
<p markdown class="spaced-or" >| 0xnn*2 => u16/i16 </p>
<p markdown class="spaced-or" >| 0xnn*4 => u32/i32 </p>
<p markdown class="spaced-or" >| 0xnn*8 => u64/i64 </p>
<p markdown class="spaced-or" >| 0xnn*16 => u128/i128 </p>
<p markdown class="spaced-or" >| 0xnn*32 => u256 </p>
<p markdown class="spaced-or" >| b:0xnn => [Boolean](#boolean) </p>
<p markdown class="spaced-or" >| 0xnn*21 => [Address](#address) </p>
<p markdown class="spaced-or" >| 0xnn*32 => [Hash](#hash) </p>
<p markdown class="spaced-or" >| 0xnn*33 => [PublicKey](#publickey) </p>
<p markdown class="spaced-or" >| 0xnn*65 => [Signature](#signature) </p>
<p markdown class="spaced-or" >| 0xnn*95 => [BlsPublicKey](#blspublickey) </p>
<p markdown class="spaced-or" >| 0xnn*48 => [BlsSignature](#blssignature) </p>
<p markdown class="spaced-or" >| 0xnn*len => [Array](#array)&lt;u8;len&gt; </p>
<p markdown class="spaced-or" >| len:[LengthState](#lengthstate) utf8:0xnn*len => [String](#string) </p>
<p markdown class="spaced-or" >| len:[LengthState](#lengthstate) elems:[State](#state)*len => [Vec](#vec)&lt;&gt; </p>
<p markdown class="spaced-or" >| b:0xnn arg:[State](#state) => [Option](#optiont)&lt;&gt; </p>
<p markdown class="spaced-or" >| <i>f<sub>1</sub></i>:[State](#state) ... <i>f<sub>n</sub></i>:[State](#state) => [Struct](#struct) S {<i>f<sub>1</sub></i>,<i>f<sub>2</sub></i>,...,<i>f<sub>n</sub></i>} </p>
<p markdown class="spaced-or" >| variant:0xnn <i>f<sub>1</sub></i>:[State](#state) ... <i>f<sub>n</sub></i>:[State](#state) => [Enum](#enum){variant,<i>f<sub>1</sub></i>,<i>f<sub>2</sub></i>,...,<i>f<sub>n</sub></i>} </p>
<p markdown class="spaced-or" >| 0xnn*4 => [AvlTree](#avltree){<i>f<sub>1</sub></i>,<i>f<sub>2</sub></i>,...,<i>f<sub>n</sub></i>} </p>
</div>
<div class="comment-align" markdown>
<p class="endian"><span class="endian">(i8 is two's complement)</span></p>
<p markdown class="spaced">(little endian, i16 is two's complement)</p>
<p markdown class="spaced">(little endian, i32 is two's complement)</p>
<p markdown class="spaced">(little endian, i64 is two's complement)</p>
<p markdown class="spaced">(little endian, i128 is two's complement)</p>
<p markdown class="spaced">&nbsp;</p>
<p markdown class="spaced">(false if b==0, true otherwise)</p>
<p markdown class="spaced">&nbsp;</p>
<p markdown class="spaced">&nbsp;</p>
<p markdown class="spaced">&nbsp;</p>
<p markdown class="spaced">&nbsp;</p>
<p markdown class="spaced">&nbsp;</p>
<p markdown class="spaced">&nbsp;</p>
<p markdown class="spaced">(containing the len u8 values)</p>
<p markdown class="spaced">(with len UTF-8 encoded bytes)</p>
<p markdown class="spaced">(containing the len elements)</p>
<p markdown class="spaced">(None if b==0, Some(arg) otherwise)</p>
<p markdown class="spaced">&nbsp;</p>
<p markdown class="spaced">&nbsp;</p>
<p markdown class="spaced">&nbsp;</p>
</div>
</div>
</div>

Only arrays of lengths between (including) 0 and 127 are supported. The high bit in length is reserved for later extensions.

For arguments with variable lengths, such as Vecs or Strings the number of elements is represented as a little endian 32-bit unsigned integer.

<div class="binary-format" markdown>
<div class="type-with-comment" markdown>
##### [LengthState](#lengthstate)
<p markdown>::= 0xnn*4 => u32 </p>
<p class="endian"><span class="endian">(little endian)</span></p>
</div>
</div>


**Note:** An AvlTreeMap is only stored in wasm state as an integer. The actual content of the AvlTreeMap is stored
outside the wasm code. The content of the AvlTreeMap is accessed using external calls to the java code. 
The integer stored is the tree id of the AvlTreeMap and is used as a pointer to find the correct AvlTreeMap.
This is done to avoid having to serialize and deserialize the entire content of the Map for every invocation
saving gas cost.

### CopySerializable Binary Format

A state type is said to be CopySerializable, if it's serialization is
identical to its in-memory representation, and thus requires minimal
serialization overhead. PBC have efficient handling for types that
are CopySerializable. Internal pointers are the main reason that types are not
CopySerializable.


<div class="binary-format" markdown>
<div class="type-with-comment" markdown>
##### [CopySerializable](#copyserializable)
::= 
<div class="column-align" markdown>
<p markdown  >  0XXX => true </p>
<p markdown class="spaced-or" >| iXXX => true </p>
<p markdown class="spaced-or" >| Boolean  => true </p>
<p markdown class="spaced-or" >| Address  => true </p>
<p markdown class="spaced-or" >| [u8;n] => true </p>
<p markdown class="spaced-or" >| String => false </p>
<p markdown class="spaced-or" >| Vec&lt;T&gt; => false </p>
<p markdown class="spaced-or" >| Option &lt;T&gt; => false </p>
<p markdown class="spaced-or" >| SortedVecMap&lt;K,V&gt; => false </p>
<p markdown class="spaced-or" >| SortedVecSet&lt;K,V&gt; => false </p>
<p markdown class="spaced-or" >| AvlTreeMap&lt;K,V&gt; => false </p>
<p markdown class="spaced-or" >| Struct S {<i>f<sub>1</sub></i>:<i>T<sub>1</sub></i>,...,<i>f<sub>n</sub></i>:<i>T<sub>n</sub></i></sub></i>} =>
[CopySerializable](#copyserializable)(<i>T<sub>1</sub></i>) &wedge; ... &wedge; [CopySerializable](#copyserializable)(<i>T<sub>n</sub></i>) &wedge; WellAligned(S) </p>
<p markdown class="spaced-or" >| Enum{variant, <i>f<sub>1</sub></i>, <i>f<sub>2</sub></i>,...,<i>f<sub>n</sub></i>} => false </p>
</div>
</div>
</div>


The WellAligned constraint on Struct CopySerializable is to guarentee that
struct layouts are identical to serialization. <div class="binary-format" style="display: inline" markdown><p style="display: inline" >Struct S {<i>f<sub>1</sub></i>:<i>T<sub>1</sub></i>,...,<i>f<sub>n</sub></i>:<i>T<sub>n</sub></i></sub></i>}</p></div>  is WellAligned if following points hold:

1. Annotated with `#[repr(C)]`. Read the [Rust Specification](https://doc.rust-lang.org/reference/type-layout.html#reprc-structs)
   for details on this representation.
2. No padding: <div class="binary-format" style="display: inline" markdown><p  style="display: inline" >size_of(<i>S</i>) = size_of(<i>T<sub>1</sub></i>) + ... + size_of(<i>T<sub>n</sub></i>).</p></div>
3. No wasted bytes when stored in array: <div class="binary-format" style="display: inline"<p  style="display: inline" > markdown>size_of(<i>S</i>) mod align_of(<i>T<sub>n</sub></i>) = 0.</p></div>

It may be desirable to manually add "padding" fields structs in order to
achieve CopySerializable. While this will use extra unneeded bytes for the
serialized state, it may significantly improve serialization speed and lower
gas costs. A future version of the compiler may automatically add padding fields.

#### Examples

These structs are CopySerializable:

- `Struct E1 { /* empty */ }`
- `Struct E2 { f1: u32 }`
- `Struct E3 { f1: u32, f2: u32 }`

These structs are not CopySerializable:

- `Struct E4 { f1: u8, f2: u16 }` due to padding between f1 and f2.
- `Struct E5 { f1: u16, f2: u8 }` due to alignment not dividing size.
- `Struct E6 { f1: Vec<u8> }` due to non-CopySerializable subfield.

## ABI Binary Format

### Type Specifier binary format

<div class="binary-format" markdown>
<div class="type-with-comment" markdown>
##### [TypeSpec](#typespec) 
::= 
<div class="column-align" markdown>
<p markdown > [SimpleTypeSpec](#simpletypespec)  </p>
<p markdown class="spaced-or">| [CompositeTypeSpec](#compositetypespec) </p>
<p markdown class="spaced-or">| [NamedTypeRef](#namedtyperef) </p>
</div>
</div>
</div>

<div class="binary-format" markdown>
<div class="type-with-comment" markdown>
##### [NamedTypeRef](#namedtyperef) 
<p markdown > ::= 0x00 Index:0xnn => NamedTypes(Index)  </p>
</div>
</div>


<div class="binary-format" markdown>
<div class="type-with-comment" markdown>
##### [SimpleTypeSpec](#simpletypespec)
::= 
<div class="column-align" markdown>
<p markdown > 0x01 => u8  </p>
<p markdown class="spaced-or">| 0x02 => u16 </p>
<p markdown class="spaced-or">| 0x03 => u32 </p>
<p markdown class="spaced-or">| 0x04 => u64 </p>
<p markdown class="spaced-or">| 0x05 => u128 </p>
<p markdown class="spaced-or">| 0x18 => u256 </p>
<p markdown class="spaced-or">| 0x06 => i8 </p>
<p markdown class="spaced-or">| 0x07 => i16 </p>
<p markdown class="spaced-or">| 0x08 => i32 </p>
<p markdown class="spaced-or">| 0x09 => i64 </p>
<p markdown class="spaced-or">| 0x0a => i128 </p>
<p markdown class="spaced-or">| 0x0b => [String](#string)  </p>
<p markdown class="spaced-or">| 0x0c => [Boolean](#boolean)  </p>
<p markdown class="spaced-or">| 0x0d => [Address](#address) </p>
<p markdown class="spaced-or">| 0x13 => [Hash](#hash) </p>
<p markdown class="spaced-or">| 0x14 => [PublicKey](#publickey) </p>
<p markdown class="spaced-or">| 0x15 => [Signature](#signature) </p>
<p markdown class="spaced-or">| 0x16 => [BlsPublicKey](#blspublickey) </p>
<p markdown class="spaced-or">| 0x17 => [BlsSignature](#blssignature) </p>
</div>
</div>
</div>

<div class="binary-format" markdown>
<div class="type-with-comment" markdown>
##### [CompositeTypeSpec](#compositetypespec) 
::= 
<div class="column-align" markdown>
<p markdown > 0x0e T:[TypeSpec](#typespec) => [Vec](#vec)&lt;T&gt; </p>
<p markdown class="spaced-or"> | 0x0f K:[TypeSpec](#typespec) V:[TypeSpec](#typespec) => [Map](#map)&lt;V,K&gt; </p>
<p markdown class="spaced-or"> | 0x10 T:[TypeSpec](#typespec) => [Set](#set)&lt;T&gt; </p>
<p markdown class="spaced-or"> | 0x11 L:0xnn => [u8;L] </p>
<p markdown class="spaced-or"> | 0x12 T:[TypeSpec](#typespec) => [Option](#optiont)&lt;T&gt; </p>
<p markdown class="spaced-or"> | 0x19 K:[TypeSpec](#typespec) V:[TypeSpec](#typespec) => [AvlTreeMap](#avltreemap)&lt;V,K&gt; </p>
</div>
<div class="comment-align" markdown>
<p class="endian"><span class="endian">&nbsp;</span></p>
<p markdown class="spaced">&nbsp;</p>
<p markdown class="spaced">&nbsp;</p>
<p markdown class="spaced">(0x00 &le; L &le; 0x7F)</p>
<p markdown class="spaced">&nbsp;</p>
<p markdown class="spaced">&nbsp;</p>
</div>
</div>
</div>



**NOTE:** `Map` and `Set` cannot be used as RPC arguments since it's not possible for a
caller to check equality and sort order of the elements without running the code.

Only arrays of lengths between (including) 0 and 127 are supported. The high bit in length is reserved for later extensions.

#### ABI File binary format

All [Identifier](#identifier) names must be [valid Java identifiers](https://docs.oracle.com/javase/specs/jls/se20/html/jls-3.html#jls-3.8); other strings are reserved for future extensions.


<div class="binary-format" markdown>
##### [FileAbi](#fileabi) 
::= {
<div class="field-with-comment" markdown>
<p markdown> Header: 0xnn </p>
<p class="endian"><span class="endian">(The header is always "PBCABI" in ASCII)</span> </p>
</div>  
<div class="fields"/>
VersionBinder: 0xnn\*3 <br>
VersionClient: 0xnn\*3 <br>
Contract: [ContractAbi](#contractabi)
</div>  
}


<div class="binary-format" markdown>
##### [ContractAbi](#contractabi) 
::= {
<div class="fields"/>
NamedTypes: [List](#list)&lt;[NamedTypeSpec](#namedtypespec)&gt; <br>
Hooks: [List](#list)&lt;[FnAbi](#fnabi)&gt;<br>
StateType: [TypeSpec](#typespec)<br>
</div>  
}


<div class="binary-format" markdown>
<div class="type-with-comment" markdown>
##### [NamedTypeSpec](#namedtypespec) 
::= 
<div class="column-align" markdown>
<p markdown > 0x01 [StructTypeSpec](#structtypespec) </p>
<p markdown class="spaced-or"> | 0x02 [EnumTypeSpec](#enumtypespec) </p>
</div>
</div>
</div>


<div class="binary-format" markdown>
##### [StructTypeSpec](#structtypespec) 
::= {
<div class="fields"/>
Name: [Identifier](#identifier) <br>
Fields: [List](#list)&lt;[FieldAbi](#fieldabi)&gt;

}
</div>  


<div class="binary-format" markdown>
##### [EnumTypeSpec](#enumtypespec)
::= {
<div class="fields"/>
Name: [Identifier](#identifier) <br>
Variants: [List](#list)&lt;[EnumVariant](#enumvariant)&gt;
</div>  
}


<div class="binary-format" markdown>
<div class="type-with-comment" markdown>
##### [EnumVariant](#enumvariant)
<p markdown > ::= { Discriminant: 0xnn def:[NamedTypeRef](#namedtyperef) } </p>
</div>
</div>


<div class="binary-format" markdown>
##### [FnAbi](#fnabi)
::= {
<div class="fields"/>
Kind: [FnKind](#fnkind) <br>
Name: [Identifier](#identifier) <br>
Shortname: LEB128 <br>
Arguments: [List](#list)&lt;[ArgumentAbi](#argumentabi)&gt;
<div class="field-with-comment" markdown>
<p markdown>SecretArgument: [ArgumentAbi](#argumentabi)</p>
<p class="endian"><span class="endian">(Only present if Kind is 0x17)</span> </p>
</div>  
</div>
}

<div class="binary-format" markdown>
##### [FieldAbi](#fieldabi)
::= {
<div class="fields"/>
Name: [Identifier](#identifier) <br>
Type: [TypeSpec](#typespec)
</div>
}

<div class="binary-format" markdown>
##### [ArgumentAbi](#argumentabi)
::= {
<div class="fields"/>
Name: [Identifier](#identifier) <br>
Type: [TypeSpec](#typespec)
</div>
}
  

<div class="binary-format" markdown>
<div class="type-with-comment" markdown>
##### [Identifier](#identifier)
<p markdown > ::= len:0xnn\*4 utf8:0xnn\*len </p>
<p class="endian"><span class="endian">(utf8 must be Rust identifier, len is big endian)</span></p>
</div>
</div>

<div class="binary-format" markdown>
<div class="type-with-comment" markdown>
##### [LEB128](#leb128)
<p markdown > ::= A LEB128 encoded unsigned 32 bit integer </p>
<p class="endian"><span class="endian">(1-5 bytes)</span></p>
</div>
</div>


<div class="binary-format" markdown>
<div class="type-with-comment" markdown>
##### [FnKind](#fnkind)
::= 
<div class="column-align" markdown>
<p markdown > 0x01 => <b>Init</b> </p>
<p markdown class="spaced-or"> | 0x02 => <b>Action</b> </p>
<p markdown class="spaced-or"> | 0x02 => <b>Action</b> </p>
<p markdown class="spaced-or"> | 0x03 => <b>Callback</b> </p>
<p markdown class="spaced-or"> | 0x10 => <b>ZkSecretInput</b> </p>
<p markdown class="spaced-or"> | 0x11 => <b>ZkVarInputted</b> </p>
<p markdown class="spaced-or"> | 0x12 => <b>ZkVarRejected</b> </p>
<p markdown class="spaced-or"> | 0x13 => <b>ZkComputeComplete</b> </p>
<p markdown class="spaced-or"> | 0x14 => <b>ZkVarOpened</b> </p>
<p markdown class="spaced-or"> | 0x15 => <b>ZkUserVarOpened</b> </p>
<p markdown class="spaced-or"> | 0x16 => <b>ZkAttestationComplete</b> </p>
<p markdown class="spaced-or"> | 0x17 => <b>ZkSecretInputWithExplicitType</b> </p>
<p markdown class="spaced-or"> | 0x18 => <b>ZkExternalEvent</b> </p>
</div>
<div class="comment-align" markdown>
<p class="endian"><span class="endian">(Num allowed: 1)</span></p>
<p markdown class="spaced">(0..&infin;)</p>
<p markdown class="spaced">(0..&infin;)</p>
<p markdown class="spaced">(0..&infin;)</p>
<p markdown class="spaced">(0..&infin;)</p>
<p markdown class="spaced">(0..1)</p>
<p markdown class="spaced">(0..&infin;)</p>
<p markdown class="spaced">(0..1)</p>
<p markdown class="spaced">(0..1)</p>
<p markdown class="spaced">(0..1)</p>
<p markdown class="spaced">(0..&infin;)</p>
<p markdown class="spaced">(0..1)</p>
</div>
</div>
</div>


Note that a [ContractAbi](#contractabi) is only valid if the `Hooks` list contains a specific
number of hooks of each type, as specified in [FnKind](#fnkind).

Also note that if a function has the deprecated kind <b>ZkSecretInput</b>, the default 
secret argument associated with it is of type `i32`. 

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

<div class="type-with-comment" markdown>
##### [Hash](#hash)
<p> ::= <span class="bytes">0<span class="sep">x</span>nn*32</span></p>
<p class="endian"> <span class="endian">(big-endian)</span></p>
</div>


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


<div class="binary-format" markdown>
##### [PublicKey](#publickey)
::= {  
<div class="fields"/>
ecPoint: 0xnn*33 (point on an elliptic curve)
</div>
}


<div class="binary-format" markdown>
##### [Signature](#signature)
::= {  
<div class="fields"/>
recoveryId: id:0xnn*32 (0 <= id <= 3) <br>
valueR: r:BigInteger (r >= 0) <br>
valueS: s:BigInteger TODO (s >= 0)
</div>
}

<div class="binary-format" markdown>
##### [BlsPublicKey](#blspublickey)
::= {  
<div class="fields"/>
publicKeyValue:  0xnn*96 (point on an elliptic curve)
</div>
}

<div class="binary-format" markdown>
##### [BlsSignature](#blspublickey)
::= {  
<div class="fields"/>
signatureBytes:  0xnn*48 (point on an elliptic curve)
</div>
}



<div class="binary-format" markdown>
##### [AvlTreeMap](#avltreemap)
::= {  
<div class="fields"/>
signatureBytes:  0xnn*48 (point on an elliptic curve)
</div>
}





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




## Section format

A [Section](#section) is an indexed chunk of a binary file of dynamic length, which is defined as follows:

<div class="binary-format" markdown>
<div class="type-with-comment" markdown>
##### [Section](#section)
<p markdown > ::= id:0xnn len:0xnn\*4 data:0xnn\*len </p>
<p class="endian"><span class="endian">(len is big endian)</span></p>
</div>
</div>

The id of a section is a single, leading byte that identifies the section.
The section's length then follows and is given as a 32-bit, big-endian,
unsigned integer. The byte length of the following dynamically sized data
of the section should match this length.

## Wasm contract result format

The format used by Wasm contracts to return results is a [section format](#section-format) defined as follows:

<div class="binary-format" markdown>
<div class="type-with-comment" markdown>
##### [Result](#result)
<p markdown > ::= section<sub>0</sub>:[Section](#section) ... section<sub>n</sub>:[Section](#section) </p>
</div>
</div>


<!-- fix syntax highlighting* -->

Note that sections must occur in order of increasing ids. Two ids are
"well-known" and specially handled by the interpreter:

- `0x01`: Stores event information.
- `0x02`: Stores state.

Section ids `0x00` to `0x0F` are reserved for "well-known" usage. All others
are passed through the interpreter without modification.

## ZKWA format

ZK-contracts have their own binary file format  with the extension ".zkwa"
that contains their compiled WASM code and ZK-circuit byte code. 
This is a [section format](#section-format) defined as:

<div class="binary-format" markdown>
<div class="type-with-comment" markdown>
##### [ZKWA](#result)
<p markdown > ::= section<sub>0</sub>:[Section](#section) section<sub>1</sub>:[Section](#section) </p>
</div>
</div>

<!-- fix syntax highlighting* -->

Note that sections must occur in order of increasing ids. The .zkwa format consists
of two sections indexed by the following ids:

- `0x02`: The contract's WASM code.
- `0x03`: The contract's ZK-circuit byte code.

## Partisia Blockchain Contract File

The file extension of Partisia Blockchain Contract Files is written as ".pbc". This is a [section format](#section-format) defined as:

<div class="binary-format" markdown>
<div class="type-with-comment" markdown>
##### [PbcFile](#pbcfile)
<p markdown > ::= PbcHeader: 0xnn\*4 section<sub>0</sub>:[Section](#section) ... section<sub>n</sub>:[Section](#section) </p>
<p class="endian"><span class="endian">(The header is always "PBSC" in ASCII)</span></p>
</div>
</div>

Note that sections must occur in order of increasing ids. The .pbc format can
consist of up to three sections indexed by the following ids:

- `0x01`: The contract's [ABI](#abi-binary-format).
- `0x02`: The contract's WASM code.
- `0x03`: The contract's ZK-circuit byte code.
