# Draft: PBC contract ABI version 1.0

## ABI serialization

### BNF for types
$$\definecolor{mathcolor}{RGB}{33,33,33}
\definecolor{mathgray}{RGB}{100,100,100}
\newcommand{\hexi}[1]{{\color{mathcolor}\mathtt{0x}}{\color{mathgray}}{\color{mathcolor}\mathtt{#1}}}
\newcommand{\nnhexi}[1]{{\color{mathcolor}\mathtt{0x}}{\color{mathgray}}{\color{mathcolor} #1}}
\newcommand{\Rightarrowx}{{\color{mathgray} \  \Rightarrow \ \ }}
\textcolor{mathcolor}{
\begin{align*}
\text{<Type>} \ := \ &\text{SimpleType} \\
| \ &\text{CompositeType} \\
| \ &\text{CustomStruct} \\
\\
\text{<CustomStruct>} \ := \ &\hexi{00} \ \text{Index}:\nnhexi{nn} \Rightarrowx Types(\text{Index}) \\
\\
\text{<SimpleType>} \ := \ &\hexi{01} \ \Rightarrowx \text{u8} \\
| \ &\hexi{02} \ \Rightarrowx \text{u16} \\
| \ &\hexi{03} \ \Rightarrowx \text{u32} \\
| \ &\hexi{04} \ \Rightarrowx \text{u64} \\
| \ &\hexi{05} \ \Rightarrowx \text{u128} \\
| \ &\hexi{06} \ \Rightarrowx \text{i8} \\
| \ &\hexi{07} \ \Rightarrowx \text{i16} \\
| \ &\hexi{08} \ \Rightarrowx \text{i32} \\
| \ &\hexi{09} \ \Rightarrowx \text{i64} \\
| \ &\hexi{0a} \ \Rightarrowx \text{i128} \\
| \ &\hexi{0b} \ \Rightarrowx \text{String} \\
| \ &\hexi{0c} \ \Rightarrowx \text{bool} \\
| \ &\hexi{0d} \ \Rightarrowx \text{Address} \\
\\
\text{<CompositeType>} \ := \ &\hexi{0e} \text{ T:}\text{Type} \Rightarrowx \text{Vec<}\text{T>} \\
| \ &\hexi{0f} \text{ K:}\text{Type}\text{ V:}\text{Type} \Rightarrowx \text{BTreeMap <}\text{K}, \text{V>} \\
| \ &\hexi{10} \text{ T:}\text{Type} \Rightarrowx \text{BTreeSet<}\text{T>} \\
| \ &\hexi{11} \text{ L:}\nnhexi{nn} \Rightarrowx \text{[u8; }\text{L}\text{]} & (\hexi{01} \leq L \leq \hexi{20}) \\
\\
\end{align*}
}
$$

### Sizes for basic types declarations

| Value | Nr of bytes  | Corresponding Rust type
|---|---|---| 
| 0     | 1 + 1 + Size(Custom_Struct) | Custom_Struct
| 1     | 1                  | u8
| 2     | 1                  | u16
| 3     | 1                  | u32
| 4     | 1                  | u64
| 5     | 1                 | u128
| 6     | 1                  | i8
| 7     | 1                  | i16
| 8     | 1                  | i32
| 9     | 1                  | i64
| 10    | 1                 | i128
| 11    | 1 + Size(T)         | Vec<T\> \*
| 12    | 1 + Size(K) + Size(V) | BTreeMap<K, V\> \*\*
| 13    | 1 + Size(T)         | BTreeSet<T\> \*
| 14    | 1                 | Address
| 15    | 1 + 1             | \[u8; n\] \*\*\*

\* T is written as a single u8 deno ting the type index of T in the Types vector in the parent
ContractAbi.

\*\* Same as Vec but two bytes one for S and one for T.

\*\*\* n denotes the length as an u8. Currently we support a max length of 32.

**NOTE:** `BTreeMap` and `BTreeSet` cannot be used as RPC arguments since it's not possible for a
caller to check equality and sort order of the elements without running the code.

### Basic types used to serialize the ABI

| Name | Length | Description |
|---|---|---|
| u8             | 1         |  8-bit integers
| u16            | 2         | 16-bit integers
| u32            | 4         | 32-bit integers
| Vector<T\>     | 2 + n T's | u16 length followed by n elements
| String         | 4 + n     | u32 length followed by n *bytes* UTF-8\*
| Optional<T\>   | 1 + n     | Boolean as u8 followed the element of n length

\* UTF-8 characters are between 1 and 4 bytes each. The length here denotes the number of bytes and
*NOT* the number of character codepoints.

### Structure of the ABI

| Name         | Type        | Description |
|---|---|---|
| Header       | 6* u8       | `PBCABI` in ASCII
| Version      | u16         | The version number
| Contract ABI | ContractAbi | The actual contract ABI

### Complex types

#### ContractAbi

$$
\definecolor{mathcolor}{RGB}{33, 33, 33}
\textcolor{mathcolor}{
\begin{align*}
\text{<AbiFile>} \ := \ \{ \
&\text{Header: 6* u8}, \\
&\text{Version: u16} \ \\
&\text{Contract ABI: ContractAbi} \ \} \\
\\
\text{<ContractAbi>} \ := \ \{ \
&\text{ShortnameLength: u8}, \\
&\text{Types: Vec<TypeAbi>}, \\
&\text{Init: FnAbi}, \\
&\text{Actions: Vec<FnAbi>}, \\
&\text{State: Index} \ \} \\
\\
\text{<TypeAbi>} \ := \ \{ \
&\text{Name: String}, \\
&\text{Fields: Vec<FieldAbi>} \ \} \\
\\
\text{<FnAbi>} \ := \ \{ \
&\text{Name: String}, \\
&\text{Arguments: Vec<ArgumentAbi>} \ \} \\
\\
\text{<FieldAbi>} \ := \ \{ \
&\text{Name: String}, \\
&\text{Type: Type} \ \} \\
\\
\text{<ArgumentAbi>} \ := \ \{ \
&\text{Name: String}, \\
&\text{Type: Type} \ \} \\
\\
\end{align*}
}
$$

| Name | Type | Description |
|---|---|---|
| Shortname length | u8           | The length of the action short name. See *Calling a function* below.
| Types            | Vec<TypeAbi\> | A vector of TypeAbi elements representing all the legal state and RPC types
| Init             | FunctionAbi  | A single FunctionAbi representing the contract initializer
| Actions          | Vec<TypeAbi\> | A vector of TypeAbi elements representing the contract actions
| State            | Index: u8      | The index of the state type in Types


#### Shortname

The shortname of a function is the first four bytes of the function name's SHA-256 hash.

## Serialization of RPC and contract state

The ABI describes how to serialize a type.

## Calling a function

Calling a function requires you to use the shortname of the function followed by the RPC for said
function.

As an example if you have an action that looks like the following:

````rust
pub fn my_action(ctx: ContractContext, state: MyState, address: Address, some_value: u32) -> MyState {
    let new_state = state.clone();
    // do something with address and some_value
    new_state
}
````

The first two arguments are supplied by the runtime. The first is the `ContractContext` which has
information about the transaction, the sender etc. The second argument is a copy of the state of the
contract at call time. The rest of the arguments make up the RPC of the action. The result of the
action is a new contract state that is persisted on chain.

If we want to call the above with the address  `001111111111111111111111111111111111111111` and
some_value `42`, we read the shortname of the action in the ABI (in our example it is `9c3897ac`)
the following RPC to the contract:

```
9c3897ac                                   // 4 bytes shortname
001111111111111111111111111111111111111111 // 21 address bytes
0000002a                                   // 42 in big endian
```

TODO
