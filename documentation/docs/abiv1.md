# Draft: PBC contract ABI version 1.0

## ABI serialization

### BNF for types
$$
\begin{align*}
<\text{Type}> \ := \ &\text{SimpleType} \\
| \ &\text{CompositeType} \\
| \ &\text{CustomStruct} \\
\\
<\text{CustomStruct}> \ := \ &\mathtt{0x00} \ \text{Index}:\mathtt{0xnn} \Rightarrow Types(\text{Index}) \\
\\
<\text{SimpleType}> \ := \ &\mathtt{0x01} \ \Rightarrow \text{u8} \\
| \ &\mathtt{0x02} \ \Rightarrow \text{u16} \\
| \ &\mathtt{0x03} \ \Rightarrow \text{u32} \\
| \ &\mathtt{0x04} \ \Rightarrow \text{u64} \\
| \ &\mathtt{0x05} \ \Rightarrow \text{u128} \\
| \ &\mathtt{0x06} \ \Rightarrow \text{i8} \\
| \ &\mathtt{0x07} \ \Rightarrow \text{i16} \\
| \ &\mathtt{0x08} \ \Rightarrow \text{i32} \\
| \ &\mathtt{0x09} \ \Rightarrow \text{i64} \\
| \ &\mathtt{0x0a} \ \Rightarrow \text{i128} \\
| \ &\mathtt{0x0b} \ \Rightarrow \text{String} \\
| \ &\mathtt{0x0c} \ \Rightarrow \text{bool} \\
| \ &\mathtt{0x0d} \ \Rightarrow \text{Address} \\
\\
<\text{CompositeType}> \ := \ &\mathtt{0x0d} \text{ T:}\text{Type} \Rightarrow \text{Vec}<\text{T}> \\
| \ &\mathtt{0x0f} \text{ K:}\text{Type}\text{ V:}\text{Type} \Rightarrow \text{BTreeMap}<\text{K}, \text{V}> \\
| \ &\mathtt{0x10} \text{ T:}\text{Type} \Rightarrow \text{BTreeSet}<\text{T}> \\
| \ &\mathtt{0x11} \text{ L:}\mathtt{0xnn} \Rightarrow \text{[u8; }\text{L}\text{]} & (\mathtt{0x01} \leq L \leq \mathtt{0x20}) \\
\\
\end{align*}
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
\begin{align*}
<\text{Name}> \ := \ &\text{String} \\
<\text{TypeAbi}> \ := \{ \ &\text{Name},\ \ \text{Vec<FieldAbi>}  \ \}\\
<\text{FunctionAbi}> \ := \{ \ &\text{Name},\ \ \text{Vec<ArgumentAbi>}  \ \}\\
<\text{FieldAbi}> \ := \{ \ &\text{Type},\ \ \text{Index}, \text{Name} \ \}\\
<\text{ArgumentAbi}> \ := \{ \ &\text{Type},\ \ \text{Index}, \text{Name} \ \}\\
<\text{ContractAbi}> \ := \{ \ &\text{Shortname Length : u8}\ ,\ \ \text{Types : Vec<TypeAbi>},\ \ \text{Init : FunctionAbi}, \ \ \text{Actions : Vec<TypeAbi>}, \ \ \text{State name : String}  \ \}\\
\end{align*}
$$


| Name | Type | Description |
|---|---|---|
| Shortname length | u8           | The length of the action short name. See *Calling a function* below.
| Types            | Vec<TypeAbi\> | A vector of TypeAbi elements representing all the legal state and RPC types
| Init             | FunctionAbi  | A single FunctionAbi representing the contract initializer
| Actions          | Vec<TypeAbi\> | A vector of TypeAbi elements representing the contract actions
| State            | String       | A string denoting the state type of the contract


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
