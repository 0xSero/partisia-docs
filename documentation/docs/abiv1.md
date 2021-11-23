# Draft: PBC contract ABI version 1.0

## ABI serialization

### Type Specifier binary format
$$\definecolor{mathcolor}{RGB}{33,33,33}
\definecolor{mathgray}{RGB}{100,100,100}
\newcommand{\hexi}[1]{{\color{mathcolor}\mathtt{0x}}{\color{mathgray}}{\color{mathcolor}\mathtt{#1}}}
\newcommand{\nnhexi}[1]{{\color{mathcolor}\mathtt{0x}}{\color{mathgray}}{\color{mathcolor} #1}}
\newcommand{\Rightarrowx}{{\color{mathgray} \  \Rightarrow \ \ }}
\textcolor{mathcolor}{
\begin{align*}
\text{<TypeSpec>} \ := \ &\text{SimpleTypeSpec} \\
| \ &\text{CompositeTypeSpec} \\
| \ &\text{StructTypeSpec} \\
\\
\text{<StructTypeSpec>} \ := \ &\hexi{00} \ \text{Index}:\nnhexi{nn} \Rightarrowx StructTypes(\text{Index}) \\
\\
\text{<SimpleTypeSpec>} \ := \ &\hexi{01} \ \Rightarrowx \text{u8} \\
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
\text{<CompositeTypeSpec>} \ := \ &\hexi{0e} \text{ T:}\text{TypeSpec} \Rightarrowx \text{Vec<}\text{T>} \\
| \ &\hexi{0f} \text{ K:}\text{TypeSpec}\text{ V:}\text{TypeSpec} \Rightarrowx \text{BTreeMap <}\text{K}, \text{V>} \\
| \ &\hexi{10} \text{ T:}\text{TypeSpec} \Rightarrowx \text{BTreeSet<}\text{T>} \\
| \ &\hexi{11} \text{ L:}\nnhexi{nn} \Rightarrowx \text{[u8; }\text{L}\text{]} & (\hexi{01} \leq L \leq \hexi{20}) \\
\\
\end{align*}
}
$$

**NOTE:** `BTreeMap` and `BTreeSet` cannot be used as RPC arguments since it's not possible for a
caller to check equality and sort order of the elements without running the code.

#### ABI File binary format

$$
\definecolor{mathcolor}{RGB}{33, 33, 33}
\textcolor{mathcolor}{
\begin{align*}
\text{<FileAbi>} \ := \ \{ \
&\text{Header: 6* u8},  &\text{The header is always "PBCABI" in ASCII}\\
&\text{AbiVersion: u16} \ \\
&\text{Contract: ContractAbi} \ \} \\
\\
\text{<ContractAbi>} \ := \ \{ \
&\text{ShortnameLength: u8}, \\
&\text{StructTypes: Vec<StructTypeAbi>}, \\
&\text{Init: FnAbi}, \\
&\text{Actions: Vec<FnAbi>}, \\
&\text{StateType: Index} \ \} &\text{Index in StructTypes}\\
\\
\text{<StructTypeAbi>} \ := \ \{ \
&\text{Name: String}, \\
&\text{Fields: Vec<FieldAbi>} \ \} \\
\\
\text{<FnAbi>} \ := \ \{ \
&\text{Name: String}, \\
&\text{Arguments: Vec<ArgumentAbi>} \ \} \\
\\
\text{<FieldAbi>} \ := \ \{ \
&\text{Name: String}, \\
&\text{Type: TypeSpec} \ \} \\
\\
\text{<ArgumentAbi>} \ := \ \{ \
&\text{Name: String}, \\
&\text{Type: TypeSpec} \ \} \\
\\
\end{align*}
}
$$

#### Shortname

The shortname of a function is the first four bytes of the function name's SHA-256 hash.

#### Byte size of instantiated Types
| Type  | Size in bytes | Description
|---|---|---|
| Custom_Struct     | 1 + 1 + Size(Custom_Struct)   | Type index + 
| u8                | 1                             | 
| u16               | 2                             | 
| u32               | 3                             | 
| u64               | 4                             | 
| u128              | 5                             | 
| i8                | 1                             |
| i16               | 2                             | 
| i32               | 3                             | 
| i64               | 4                             | 
| i128              | 5                             |
| bool              | 1                             |
| String            | 1 +                              |
| Vec<T\>           | 1 + n \* Size(T)              | Number of elements (n) + n \* Size(T)
| BTreeMap<K, V\>   | 1 + Size(K) + Size(V)         | 
| BTreeSet<T\> \*   | 1 + Size(T)                   | 
| Address           | 1                             | 
| \[u8; n\]         | 1 + 1                         | 

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
