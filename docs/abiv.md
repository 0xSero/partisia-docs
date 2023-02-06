# Partisia Blockchain Smart Contract Binary Formats

A Partisia Smart Contract utilizes three distinct binary formats, which are described in detail below.

- _RPC Format_: When an _action_ of the smart function is invoked, the payload is sent to the action as binary data. The payload identifies which action is invoked and the values for all parameters to the action.
- _State Format_: The _state_ of a smart contract is stored as binary data in the blockchain state. The state holds the value of all smart contract state variables.
- _ABI Format_: Meta-information about the smart contract is also stored as binary data, The ABI holds the list of available actions and their parameters and information about the different state variables.

## ABI Version changes
- Version **5.0** to **6.0**:
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

Only arrays of lengths between (including) 0 and 127 are supported. The high bit in length is reserved for later extensions.

For arguments with variable lengths, such as Vecs or Strings the number of elements is represented as a big endian 32-bit unsigned integer.

$$
\textcolor{mathcolor}{
\begin{align*}
\text{<LengthRpc>} \ := \ & \bytes{4} \ \Rightarrowx \text{u32}  \text{(big endian)} \\
\end{align*}
}
$$

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
\end{align*}
}
$$

Only arrays of lengths between (including) 0 and 127 are supported. The high bit in length is reserved for later extensions.

For arguments with variable lengths, such as Vecs or Strings the number of elements is represented as a little endian 32-bit unsigned integer.

$$
\textcolor{mathcolor}{
\begin{align*}
\text{<LengthState>} \ := \ & \bytes{4} \ \Rightarrowx \text{u32}  &\text{(little endian)} \\
\end{align*}
}
$$

<!-- fix syntax highlighting* -->

### CopySerializable

A state type is said to be CopySerializable, if it's serialization is
identical to it's in-memory representation, and thus require minimal
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
| \ & \text{BTreeMap<K, V>} \Rightarrowx \text{false}\\
| \ & \text{BTreeSet<T>} \Rightarrowx \text{false}\\
| \ & \text{Struct S}\ \{ f_1: T_1, \dots, f_n: T_n \} \Rightarrowx \text{CopySerializable}(T_1) \wedge \dots \wedge \text{CopySerializable}(T_n) \wedge \text{WellAligned(S)} \\
| \ & \text{Enum} \ \{ \text{variant}, f_1, f_2, \dots, f_n \} \Rightarrowx \text{false}\\
\end{align*}
}
$$

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
\\
\end{align*}
}
$$

**NOTE:** `Map` and `Set` cannot be used as RPC arguments since it's not possible for a
caller to check equality and sort order of the elements without running the code.

Only arrays of lengths between (including) 0 and 127 are supported. The high bit in length is reserved for later extensions.

#### ABI File binary format

All `Identifier` names must be [valid Rust identifiers](https://doc.rust-lang.org/reference/identifiers.html); other strings are reserved for future extensions.

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
&\text{Arguments: List<ArgumentAbi>} \ \} \\
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
|\ &\hexi{11} \ \Rightarrowx \text{ZkVarInputted}  &\text{(0..1)}\\
|\ &\hexi{12} \ \Rightarrowx \text{ZkVarRejected}  &\text{(0..1)}\\
|\ &\hexi{13} \ \Rightarrowx \text{ZkComputeComplete}  &\text{(0..1)}\\
|\ &\hexi{14} \ \Rightarrowx \text{ZkVarOpened}  &\text{(0..1)}\\
|\ &\hexi{15} \ \Rightarrowx \text{ZkUserVarOpened} &\text{(0..1)}\\
|\ &\hexi{16} \ \Rightarrowx \text{ZkAttestationComplete} &text{(0..1)}
\end{align*}
}
$$

Note that a `ContractAbi` is only valid if the `Hooks` list contains a specific
number of hooks of each type, as specified in `FnKind`.

<!-- fix syntax highlighting* -->

## Wasm contract result format

The format used by Wasm contracts to return results is a section-based format defined as following:

$$
\textcolor{mathcolor}{
\begin{align*}
\text{<Result>} \ :=
  \ & \text{section}_0\text{: Section} \ \dots \ \text{section}_n\text{: Section} \\
\text{<Section >} \ :=
  \ & \text{id:}\byte{} \ \text{len:}\bytes{4} \ \text{data:}\bytes{len}  \ \text{(len is big endian)} \\
\end{align*}
}
$$
<!-- fix syntax highlighting* -->

Note that section must occur in order of increasing ids. Two ids are
"well-known" and specially handled by the interpreter:

- `0x01`: Stores event information.
- `0x02`: Stores state.

Section ids `0x00` to `0x0F` are reserved for "well-known" usage. All others
are passed through the interpreter without modification.
