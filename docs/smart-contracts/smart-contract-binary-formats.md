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

<!-- Define mathjax macros -->

$$
\definecolor{mathcolor}{RGB}{33,33,33}
\definecolor{mathgray}{RGB}{100,100,100}
\newcommand{\Rightarrowx}{{\color{mathgray} \  \Rightarrow \ \ }}
\newcommand{\hexi}[1]{{\color{mathcolor}\mathtt{0x}}{\color{mathgray}}{\color{mathcolor}\mathtt{#1}}}
\newcommand{\nnhexi}[1]{{\color{mathcolor}\mathtt{0x}}{\color{mathgray}}{\color{mathcolor} #1}}
\newcommand{\repeat}[2]{#1\text{*}#2}
\newcommand{\byte}{\nnhexi{nn}}
\newcommand{\bytes}[1]{\repeat{\byte{}}{\text{#1}}}
$$

$$
\textcolor{mathcolor}{
\begin{align*}
\text{<PayloadRpc>} \ := \ & \text{action:}\text{ShortName}\ \text{arguments:}\text{ArgumentRpc}\text{*}  \Rightarrowx \text{action(arguments)}  \\
\end{align*}
}
$$

<div class="binary-format" markdown>
<div class="type-with-comment" markdown>
##### [PayloadRpc](#payloadrpc)
<p markdown>::= action:[Shortname](#shortname) arguments:[ArgumentsRpc](#argumentsrpc) => action(arguments) </p>
</div>
</div>

The short name of an action is an u32 integer identifier that uniquely identifies the action within the smart contract.
The short name is encoded as [unsigned LEB128 format](https://en.wikipedia.org/wiki/LEB128#Unsigned_LEB128), which means that short names have variable lengths.
It is easy to determine how many bytes a LEB128 encoded number contains by examining bit 7 of each byte.

$$
\textcolor{mathcolor}{
\begin{align*}
\text{<ShortName>} \ := \ & \text{pre:}\nnhexi{nn}\text{*}\ \text{last:}\nnhexi{nn}\ \Rightarrowx \text{Action}  &\text{(where pre is 0-4 bytes that are &ge;0x80 and last&lt;0x80)} \\
\end{align*}
}
$$

<div class="binary-format" markdown>
<div class="type-with-comment" markdown>
##### [ShortName](#shortname)
<p markdown> ::= pre:0xnn last:0xnn => action </p>
<p class="endian"> <span class="endian">(where pre is 0-4 bytes that are &ge;0x80 and last &lt;0x80)</span></p>
</div>
</div>

The argument binary format depends on the type of the argument. The argument types for each action is defined by the contract, and can be read from the ABI format.

$$
\textcolor{mathcolor}{
\begin{align*}
\text{<ArgumentRpc>} \ :=
  \ & \byte{} \ \Rightarrowx \text{u8/i8} & \text{(i8 is twos complement)} \\
| \ & \bytes{2} \ \Rightarrowx \text{u16/i16} & \text{(big endian, i16 is two's complement)} \\
| \ & \bytes{4} \ \Rightarrowx \text{u32/i32} & \text{(big endian, i32 is two's complement)} \\
| \ & \bytes{8} \ \Rightarrowx \text{u64/i64} & \text{(big endian, i64 is two's complement)} \\
| \ & \bytes{16} \ \Rightarrowx \text{u128/i128} & \text{(big endian, i128 is two's complement)} \\
| \ & \bytes{32} \ \Rightarrowx \text{u256} \\
| \ & \text{b:}\byte{} \ \Rightarrowx \text{bool} & \text{(false if b==0, true otherwise)} \\
| \ & \bytes{21} \ \Rightarrowx \text{Address} \\
| \ & \bytes{32} \ \Rightarrowx \text{Hash} \\
| \ & \bytes{33} \ \Rightarrowx \text{PublicKey} \\
| \ & \bytes{65} \ \Rightarrowx \text{Signature} \\
| \ & \bytes{96} \ \Rightarrowx \text{BlsPublicKey} \\
| \ & \bytes{48} \ \Rightarrowx \text{BlsSignature} \\
| \ & \bytes{len} \ \Rightarrowx \text{Array }\text{[u8;len]} & \text{(containing the len u8 values)} \\
| \ & \text{len:}\text{LengthRpc} \ \text{utf8:}\bytes{len} \ \Rightarrowx \text{String} & \text{(with len UTF-8 encoded bytes)} \\
| \ & \text{len:}\text{LengthRpc} \ \text{elems:}\repeat{\text{ArgumentRpc}}{\text{len}} \ \Rightarrowx \text{Vec&lt;&gt;} & \text{(containing the len elements)} \\
| \ & \text{b:}\byte{} \ \text{arg:}\text{ArgumentRpc} \ \Rightarrowx \text{Option&lt;&gt;} & \text{(None if b==0, Some(arg) otherwise)} \\
| \ & f_1 \text{:ArgumentRpc} \dots f_n \text{:ArgumentRpc} \Rightarrowx \text{Struct S}\ \{ f_1, f_2, \dots, f_n \} & \\
| \ & \text{variant:} \byte{} \ f_1 \text{:ArgumentRpc} \dots f_n \text{:ArgumentRpc} \Rightarrowx \text{Enum}\ \{ \text{variant}, f_1, f_2, \dots, f_n \} & \\
\end{align*}
}
$$


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
<p markdown  class="spaced-or" >| b:0xnn arg:[ArgumentRpc](#argumentrpc) => [Option](#option)&lt;&gt; </p>
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

$$
\textcolor{mathcolor}{
\begin{align*}
\text{<LengthRpc>} \ := \ & \bytes{4} \ \Rightarrowx \text{u32}  \text{(big endian)} \\
\end{align*}
}
$$

<div class="binary-format" markdown>
<div class="type-with-comment" markdown>
##### [LengthRpc](#lengthrpc)
<p markdown>::= 0xnn*4 => u32 </p>
<p class="endian"><span class="endian">(big endian)</span></p>
</div>
</div>



<!-- fix syntax highlighting* -->

## State Binary Format

Integers are stored as little-endian. Signed integers are stored as two's
complement. Note that lengths are also stored as little-endian.

$$
\textcolor{mathcolor}{
\begin{align*}
\text{<State>} \ := \ & \nnhexi{nn} \ \Rightarrowx \text{u8/i8} & \text{(i8 is twos complement)} \\
| \ & \bytes{2} \ \Rightarrowx \text{u16/i16} & \text{(little endian, i16 is two's complement)} \\
| \ & \bytes{4} \ \Rightarrowx \text{u32/i32} & \text{(little endian, i32 is two's complement)} \\
| \ & \bytes{8} \ \Rightarrowx \text{u64/i64} & \text{(little endian, i64 is two's complement)} \\
| \ & \bytes{16} \ \Rightarrowx \text{u128/i128} & \text{(little endian, i128 is two's complement)} \\
| \ & \bytes{32} \ \Rightarrowx \text{u256} \\
| \ & \text{b:}\byte{} \ \Rightarrowx \text{bool} & \text{(false if b==0, true otherwise)} \\
| \ & \bytes{21} \ \Rightarrowx \text{Address} \\
| \ & \bytes{32} \ \Rightarrowx \text{Hash} \\
| \ & \bytes{33} \ \Rightarrowx \text{PublicKey} \\
| \ & \bytes{65} \ \Rightarrowx \text{Signature} \\
| \ & \bytes{96} \ \Rightarrowx \text{BlsPublicKey} \\
| \ & \bytes{48} \ \Rightarrowx \text{BlsSignature} \\
| \ & \bytes{len} \ \Rightarrowx \text{Array }\text{[u8;len]} & \text{(containing the len u8 values)} \\
| \ & \text{len:}\text{LengthState} \ \text{utf8:}\bytes{len} \ \Rightarrowx \text{String} & \text{(with len UTF-8 encoded bytes)} \\
| \ & \text{len:}\text{LengthState} \ \text{elems:}\repeat{\text{State}}{\text{len}} \ \Rightarrowx \text{Vec&lt;&gt;} & \text{(containing the len elements)} \\
| \ & \text{b:}\byte{} \ \text{arg:}\text{State} \ \Rightarrowx \text{Option&lt;&gt;} & \text{(None if b==0, Some(arg) otherwise)} \\
| \ & f_1 \text{:State} \dots f_n \text{:State} \Rightarrowx \text{Struct S}\ \{ f_1, f_2, \dots, f_n \} & \\
| \ & \text{variant:} \byte{} \ f_1 \text{:State} \dots f_n \text{:State} \Rightarrowx \text{Enum}\ \{ \text{variant}, f_1, f_2, \dots, f_n \} & \\
| \ & \bytes{4} \ \Rightarrowx \text{AvlTreeMap} \\
\end{align*}
}
$$


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
<p markdown class="spaced-or" >| b:0xnn => bool </p>
<p markdown class="spaced-or" >| 0xnn*21 => [Address](#address) </p>
<p markdown class="spaced-or" >| 0xnn*32 => [Hash](#hash) </p>
<p markdown class="spaced-or" >| 0xnn*33 => [PublicKey](#publickey) </p>
<p markdown class="spaced-or" >| 0xnn*65 => [Signature](#signature) </p>
<p markdown class="spaced-or" >| 0xnn*95 => [BlsPublicKey](#blspublickey) </p>
<p markdown class="spaced-or" >| 0xnn*48 => [BlsSignature](#blssignature) </p>
<p markdown class="spaced-or" >| 0xnn*len => [Array](#array)&lt;u8;len&gt; </p>
<p markdown class="spaced-or" >| len:[LengthState](#lengthstate) utf8:0xnn*len => [String](#string) </p>
<p markdown class="spaced-or" >| len:[LengthState](#lengthstate) elems:[State](#state)*len => [Vec](#vec)&lt;&gt; </p>
<p markdown class="spaced-or" >| b:0xnn arg:[State](#state) => [Option](#option)&lt;&gt; </p>
<p markdown class="spaced-or" >| <i>f<sub>1</sub></i>:[State](#state) ... <i>f<sub>n</sub></i>:[State](#state) => [Struct](#struct) S {<i>f<sub>1</sub></i>,<i>f<sub>2</sub></i>,...,<i>f<sub>n</sub></i>} </p>
<p markdown class="spaced-or" >| variant:0xnn <i>f<sub>1</sub></i>:[State](#state) ... <i>f<sub>n</sub></i>:[State](#state) => [Enum](#enum){variant,<i>f<sub>1</sub></i>,<i>f<sub>2</sub></i>,...,<i>f<sub>n</sub></i>} </p>
<p markdown class="spaced-or" >| 0xnn*4 => [AvlTree](#enum){variant,<i>f<sub>1</sub></i>,<i>f<sub>2</sub></i>,...,<i>f<sub>n</sub></i>} </p>
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

$$
\textcolor{mathcolor}{
\begin{align*}
\text{<LengthState>} \ := \ & \bytes{4} \ \Rightarrowx \text{u32}  &\text{(little endian)} \\
\end{align*}
}
$$

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

<!-- fix syntax highlighting* -->

### CopySerializable Binary Format

A state type is said to be CopySerializable, if it's serialization is
identical to its in-memory representation, and thus requires minimal
serialization overhead. PBC have efficient handling for types that
are CopySerializable. Internal pointers are the main reason that types are not
CopySerializable.

$$
\textcolor{mathcolor}{
\begin{align*}
\text{<CopySerializable>} \ :=
  \ & \text{uXXX} \Rightarrowx \text{true}\\
| \ & \text{iXXX} \Rightarrowx \text{true}\\
| \ & \text{bool} \Rightarrowx \text{true}\\
| \ & \text{Address} \Rightarrowx \text{true}\\
| \ & \text{[u8;N]} \Rightarrowx \text{true}\\
| \ & \text{String} \Rightarrowx \text{false}\\
| \ & \text{Vec<T>} \Rightarrowx \text{false}\\
| \ & \text{Option<T>} \Rightarrowx \text{false}\\
| \ & \text{SortedVecMap<K, V>} \Rightarrowx \text{false}\\
| \ & \text{SortedVecSet<K, V>} \Rightarrowx \text{false}\\
| \ & \text{AvlTreeMap<K, V>} \Rightarrowx \text{false}\\
| \ & \text{Struct S}\ \{ f_1: T_1, \dots, f_n: T_n \} \Rightarrowx \text{CopySerializable}(T_1) \wedge \dots \wedge \text{CopySerializable}(T_n) \wedge \text{WellAligned(S)} \\
| \ & \text{Enum} \ \{ \text{variant}, f_1, f_2, \dots, f_n \} \Rightarrowx \text{false}\\
\end{align*}
}
$$

<div class="binary-format" markdown>
<div class="type-with-comment" markdown>
##### [CopySerializable](#copyserializable)
::= 
<div class="column-align" markdown>
<p markdown  >  0XXX => true </p>
<p markdown class="spaced-or" >| iXXX => true </p>
<p markdown class="spaced-or" >| [Boolean](#boolean) => true </p>
<p markdown class="spaced-or" >| [Address](#address) => true </p>
<p markdown class="spaced-or" >| [u8;n] => true </p>
<p markdown class="spaced-or" >| [String](#string) => false </p>
<p markdown class="spaced-or" >| [Vec](#vec)&lt;T&gt; => false </p>
<p markdown class="spaced-or" >| [Option](#option)&lt;T&gt; => false </p>
<p markdown class="spaced-or" >| [SortedVecMap](#sortedvecmap)&lt;K,V&gt; => false </p>
<p markdown class="spaced-or" >| [SortedVecSet](#sortedvecset)&lt;K,V&gt; => false </p>
<p markdown class="spaced-or" >| [AvlTreeMap](#avltreemap)&lt;K,V&gt; => false </p>
<p markdown class="spaced-or" >| [Struct](#struct) S {<i>f<sub>1</sub></i>:<i>T<sub>1</sub></i>,...,<i>f<sub>n</sub></i>:<i>T<sub>n</sub></i></sub></i>} =>
[CopySerializable](#copyserializable)(<i>T<sub>1</sub></i>) &wedge; ... &wedge; [CopySerializable](#copyserializable)(<i>T<sub>n</sub></i>) &wedge; WellAligned(S) </p>
<p markdown class="spaced-or" >| [Enum](#enum){variant, <i>f<sub>1</sub></i>, <i>f<sub>2</sub></i>,...,<i>f<sub>n</sub></i>} => false </p>
</div>
</div>
</div>





The WellAligned constraint on Struct CopySerializable is to guarentee that
struct layouts are identical to serialization.  \(\text{Struct S}\ \{ f_1: T_1, \dots, f_n: T_n \}\) is WellAligned if following points hold:

1. Annotated with `#[repr(C)]`. Read the [Rust Specification](https://doc.rust-lang.org/reference/type-layout.html#reprc-structs)
   for details on this representation.
2. No padding: \(\text{size_of}(S) = \text{size_of}(T_1) + ... + \text{size_of}(T_n)\)
3. No wasted bytes when stored in array: \(\text{size_of}(S) \mod \text{align_of}(T_n) = 0\)

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

$$
\textcolor{mathcolor}{
\begin{align*}
\text{<TypeSpec>} \ := \ &\text{SimpleTypeSpec} \\
| \ &\text{CompositeTypeSpec} \\
| \ &\text{NamedTypeRef} \\
\\
\text{<NamedTypeRef>} \ := \ &\hexi{00} \ \text{Index}:\nnhexi{nn} \Rightarrowx NamedTypes(\text{Index}) \\
\\
\text{<SimpleTypeSpec>} \ := \ &\hexi{01} \ \Rightarrowx \text{u8} \\
| \ &\hexi{02} \ \Rightarrowx \text{u16} \\
| \ &\hexi{03} \ \Rightarrowx \text{u32} \\
| \ &\hexi{04} \ \Rightarrowx \text{u64} \\
| \ &\hexi{05} \ \Rightarrowx \text{u128} \\
| \ &\hexi{18} \ \Rightarrowx \text{u256} \\
| \ &\hexi{06} \ \Rightarrowx \text{i8} \\
| \ &\hexi{07} \ \Rightarrowx \text{i16} \\
| \ &\hexi{08} \ \Rightarrowx \text{i32} \\
| \ &\hexi{09} \ \Rightarrowx \text{i64} \\
| \ &\hexi{0a} \ \Rightarrowx \text{i128} \\
| \ &\hexi{0b} \ \Rightarrowx \text{String} \\
| \ &\hexi{0c} \ \Rightarrowx \text{bool} \\
| \ &\hexi{0d} \ \Rightarrowx \text{Address} \\
| \ &\hexi{13} \ \Rightarrowx \text{Hash} \\
| \ &\hexi{14} \ \Rightarrowx \text{PublicKey} \\
| \ &\hexi{15} \ \Rightarrowx \text{Signature} \\
| \ &\hexi{16} \ \Rightarrowx \text{BlsPublicKey} \\
| \ &\hexi{17} \ \Rightarrowx \text{BlsSignature} \\
\\
\text{<CompositeTypeSpec>} \ := \ &\hexi{0e} \text{ T:}\text{TypeSpec} \Rightarrowx \text{Vec<}\text{T>} \\
| \ &\hexi{0f} \text{ K:}\text{TypeSpec}\text{ V:}\text{TypeSpec} \Rightarrowx \text{Map <}\text{K}, \text{V>} \\
| \ &\hexi{10} \text{ T:}\text{TypeSpec} \Rightarrowx \text{Set<}\text{T>} \\
| \ &\hexi{11} \text{ L:}\nnhexi{nn} \Rightarrowx \text{[u8; }\text{L}\text{]}  (\hexi{00} \leq L \leq \hexi{7F}) \\
| \ &\hexi{12} \text{ T:}\text{TypeSpec} \Rightarrowx \text{Option<}\text{T>} \\
| \ &\hexi{19} \text{ K:}\text{TypeSpec}\text{ V:}\text{TypeSpec} \Rightarrowx \text{AvlTreeMap <}\text{K}, \text{V>} \\
\\
\end{align*}
}
$$


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
<p markdown > ::= 0x00 Index: 0xnn => NamedTypes(Index)  </p>
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


<div class="binary-format" markdown>
<div class="type-with-comment" markdown>
##### [CompositeTypeSpec](#compositetypespec) 
::= 
<div class="column-align" markdown>
<p markdown > 0x0e T:[TypeSpec](#typespec) => [Vec](#vec)&lt;T&gt; </p>
<p markdown class="spaced-or"> | 0x0f K:[TypeSpec](#typespec) V:[TypeSpec](#typespec) => [Map](#map)&lt;V,K&gt; </p>
<p markdown class="spaced-or"> | 0x10 T:[TypeSpec](#typespec) => [Set](#set)&lt;T&gt; </p>
<p markdown class="spaced-or"> | 0x11 L:0xnn => [u8;L] </p>
<p markdown class="spaced-or"> | 0x12 T:[TypeSpec](#typespec) => [Option](#option)&lt;T&gt; </p>
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

$$
\textcolor{mathcolor}{
\begin{align*}
\text{<FileAbi>} \ := \ \{ \
&\text{Header: } \bytes{6},\text{The header is always "PBCABI" in ASCII}\\
&\text{VersionBinder: } \bytes{3} \ \\
&\text{VersionClient: } \bytes{3} \ \\
&\text{Contract: ContractAbi} \ \} \\
\\
\text{<ContractAbi>} \ := \ \{ \
&\text{NamedTypes: List<NamedTypeSpec>}, \\
&\text{Hooks: List<FnAbi>}, \\
&\text{StateType: TypeSpec} \ \} \\
\\
\text{<NamedTypeSpec>} \ := \
&\hexi{01} \ \text{StructTypeSpec}\\
|\ & \hexi{02} \ \text{EnumTypeSpec} \\
\\
\text{<StructTypeSpec>} \ := \ \{ \
&\text{Name: Identifier}, \\
&\text{Fields: List<FieldAbi>} \ \} \\
\\
\text{<EnumTypeSpec>} \ := \ \{ \
&\text{Name: Identifier}, \\
&\text{Variants: List<EnumVariant>} \ \} \\
\\
\text{<EnumVariant>} \ := \ \{ \
&\text{Discriminant: } \nnhexi{nn} \ \text{def: NamedTypeRef} \ \} \\
\\
\text{<FnAbi>} \ := \ \{ \
&\text{Kind: FnKind}, \\
&\text{Name: Identifier}, \\
&\text{Shortname: LEB128}, \\
&\text{Arguments: List<ArgumentAbi>}  \\
&\text{SecretArgument: ArgumentAbi} \ \} &\text{Only present if Kind is } \hexi{17} \\
\\
\text{<FieldAbi>} \ := \ \{ \
&\text{Name: Identifier}, \\
&\text{Type: TypeSpec} \ \} \\
\\
\text{<ArgumentAbi>} \ := \ \{ \
&\text{Name: Identifier}, \\
&\text{Type: TypeSpec} \ \} \\
\\
\text{<Identifier>} \ := \ \phantom{\{} \
&\text{len:}\bytes{4} \ \text{utf8:}\bytes{len}  \text{ utf8 must be Rust identifier, len is big endian} \\
\\
\text{<LEB128>} \ := \ \phantom{\{} \
&\text{A LEB128 encoded unsigned 32 bit integer (1-5 bytes).} \\
\\
\text{<FnKind>} \ := \ \
&\hexi{01} \ \Rightarrowx \text{Init} &\text{(Num allowed: 1)} \\
|\ &\hexi{02} \ \Rightarrowx \text{Action}  &\text{(0..}\infty\text{)}\\
|\ &\hexi{03} \ \Rightarrowx \text{Callback}  &\text{(0..}\infty\text{)}\\
|\ &\hexi{10} \ \Rightarrowx \text{ZkSecretInput}  &\text{(0..}\infty\text{)}\\
|\ &\hexi{11} \ \Rightarrowx \text{ZkVarInputted}  &\text{(0..}\infty\text{))}\\
|\ &\hexi{12} \ \Rightarrowx \text{ZkVarRejected}  &\text{(0..1)}\\
|\ &\hexi{13} \ \Rightarrowx \text{ZkComputeComplete}  &\text{(0..}\infty\text{))}\\
|\ &\hexi{14} \ \Rightarrowx \text{ZkVarOpened}  &\text{(0..1)}\\
|\ &\hexi{15} \ \Rightarrowx \text{ZkUserVarOpened} &\text{(0..1)}\\
|\ &\hexi{16} \ \Rightarrowx \text{ZkAttestationComplete} &\text{(0..1)} \\
|\ &\hexi{17} \ \Rightarrowx \text{ZkSecretInputWithExplicitType} &\text{(0..}\infty\text{)} \\
|\ &\hexi{18} \ \Rightarrowx \text{ZkExternalEvent} &\text{(0..1} \\
\end{align*}
} \\
$$

<div class="binary-format" markdown>
<div class="type-with-comment" markdown>
##### [FileAbi](#fileabi) 
::= {
<div class="column-align" markdown>
<p markdown > Header: 0xnn </p>
<p markdown class="spaced"> VersionBinder: 0xnn*3 </p>
<p markdown class="spaced"> VersionClient: 0xnn*3 </p>
<p markdown class="spaced"> Contract: [ContractAbi](#contractabi) </p>
<p markdown class="spaced"> } </p>
</div>
<div class="comment-align" markdown>
<p class="endian"><span class="endian">(The header is always "PBCABI" in ASCII)</span></p>
<p markdown class="spaced">&nbsp;</p>
<p markdown class="spaced">&nbsp;</p>
<p markdown class="spaced">&nbsp;</p>
<p markdown class="spaced">&nbsp;</p>
</div>
</div>
</div>

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
<div class="type-with-comment" markdown>
##### [ContractAbi](#contractabi) 
::= {
<div class="column-align" markdown>
<p markdown > NamedTypes: [List](#list)&lt;[NamedTypeSpec](#namedtypespec)&gt; </p>
<p markdown class="spaced"> Hooks: [List](#list)&lt;[FnAbi](#fnabi)&gt; </p>
<p markdown class="spaced"> StateType: [TypeSpec](#typespec) </p>
<p markdown class="spaced"> } </p>
</div>
</div>
</div>


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
<div class="type-with-comment" markdown>
##### [StructTypeSpec](#structtypespec) 
::= {
<div class="column-align" markdown>
<p markdown > Name: [Identifier](#identifier) </p>
<p markdown class="spaced"> Fields: [List](#list)&lt;[FieldAbi](#fieldabi)&gt; </p>
<p markdown class="spaced"> } </p>
</div>
</div>
</div>

<div class="binary-format" markdown>
##### [StructTypeSpec](#structtypespec) 
::= {
<div class="fields"/>
Name: [Identifier](#identifier) <br>
Fields: [List](#list)&lt;[FieldAbi](#fieldabi)&gt;</div>
}
</div>  


<div class="binary-format" markdown>
<div class="type-with-comment" markdown>
##### [EnumTypeSpec](#enumtypespec)
::= {
<div class="column-align" markdown>
<p markdown > Name: [Identifier](#identifier) </p>
<p markdown class="spaced"> Variants: [List](#list)&lt;[EnumVariant](#enumvariant)&gt; </p>
<p markdown class="spaced"> } </p>
</div>
</div>
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
<p markdown > ::= { Discriminant: 0xnn def: [NamedTypeRef](#namedtyperef) } </p>
</div>
</div>

<div class="binary-format" markdown>
<div class="type-with-comment" markdown>
##### [FnAbi](#fnabi)
::= {
<div class="column-align" markdown>
<p markdown > Kind: [FnKind](#fnkind) </p>
<p markdown class="spaced"> Name: [Identifier](#identifier) </p>
<p markdown class="spaced"> Shortname: LEB128 </p>
<p markdown class="spaced"> Arguments: [List](#list)&lt;[ArgumentAbi](#argumentabi)&gt; </p>
<p markdown class="spaced"> SecretArgument: [ArgumentAbi](#argumentabi) </p>
<p markdown class="spaced"> } </p>
</div>
<div class="comment-align" markdown>
<p markdown >&nbsp;</p>
<p markdown class="spaced">&nbsp;</p>
<p markdown class="spaced">&nbsp;</p>
<p markdown class="spaced">&nbsp;</p>
<p class="spaced"><span class="endian">(Only present if Kind is 0x17)</span></p>
<p markdown class="spaced">&nbsp;</p>
</div>
</div>
</div>


<div class="binary-format" markdown>
##### [FieldAbi](#fieldabi)
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
<div class="type-with-comment" markdown>
##### [FieldAbi](#fieldabi)
::= {
<div class="column-align" markdown>
<p markdown > Name: [Identifier](#identifier) </p>
<p markdown class="spaced"> Type: [TypeSpec](#typespec) </p>
<p markdown class="spaced"> } </p>
</div>
</div>
</div>

<div class="binary-format" markdown>
##### [FieldAbi](#fieldabi)
::= {
<div class="fields"/>
Name: [Identifier](#identifier) <br>
Type: [TypeSpec](#typespec)
</div>
}


<div class="binary-format" markdown>
<div class="type-with-comment" markdown>
##### [ArgumentAbi](#argumentabi)
::= {
<div class="column-align" markdown>
<p markdown > Name: [Identifier](#identifier) </p>
<p markdown class="spaced"> Type: [TypeSpec](#typespec) </p>
<p markdown class="spaced"> } </p>
</div>
</div>
</div>

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

<!-- fix syntax highlighting* -->
## Section format

A [Section](#section) is an indexed chunk of a binary file of dynamic length, which is defined as follows:

$$
\textcolor{mathcolor}{
\begin{align*}
\text{<Section >} \ :=
\ & \text{id:}\byte{} \ \text{len:}\bytes{4} \ \text{data:}\bytes{len}  \ \text{(len is big endian)} \\
\end{align*}
}
$$

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

$$
\textcolor{mathcolor}{
\begin{align*}
\text{<Result>} \ :=
  \ & \text{section}_0\text{: Section} \ \dots \ \text{section}_n\text{: Section} \\
\end{align*}
}
$$

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

$$
\textcolor{mathcolor}{
\begin{align*}
\text{<ZKWA>} \ :=
\ & \text{section}_0\text{: Section} \ \text{section}_1\text{: Section} \\
\end{align*}
}
$$

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

$$
\textcolor{mathcolor}{
\begin{align*}
\text{<PbcFile>} \ :=
\ & \text{PbcHeader:}\bytes{4},\text{The header is always "PBSC" in ASCII}\ \\
\ & \text{section}_0\text{: Section} \ \dots \ \text{section}_n\text{: Section} \\
\end{align*}
}
$$

<div class="binary-format" markdown>
<div class="type-with-comment" markdown>
##### [PbcFile](#pbcfile)
<p markdown > ::= PbcHeader: 0xnn\*4 section<sub>0</sub>:[Section](#section) ... section<sub>n</sub>:[Section](#section) </p>
<p class="endian"><span class="endian">(The header is always "PBSC" in ASCII)</span></p>
</div>
</div>

<!-- fix syntax highlighting* -->

Note that sections must occur in order of increasing ids. The .pbc format can
consist of up to three sections indexed by the following ids:

- `0x01`: The contract's [ABI](#abi-binary-format).
- `0x02`: The contract's WASM code.
- `0x03`: The contract's ZK-circuit byte code.
