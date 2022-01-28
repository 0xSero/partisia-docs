# Partisia Blockchain Smart Contract Binary Formats

A Partisia Smart Contract utilizes three distinct binary formats, which are described in detail below.

- _RPC Format_: When an _action_ of the smart function is invoked the payload is sent to the action as binary data. The payload identifies which action is invoked and the values for all parameters to the action.
- _State Format_: The _state_ of a smart contract is stored as binary data in the blockchain state. The state holds the value of all smart contract state variables. 
- _ABI Format_: Meta-information about the smart contract is also stored as binary data, The ABI holds the list of available actions and their parameters and information about the different state variables.   

## RPC Binary Format

The RPC payload identifies which action is invoked and the values for all parameters to the action.

To decode the payload binary format you have to know which argument types each action expects, 
since the format of the argument values depends on the argument type. 
The _ABI Format_ holds exactly the meta-data needed for finding types of the arguments for each action. 

The RPC payload contains the short name identifying the action being called followed by each of the arguments for the action.

$$\definecolor{mathcolor}{RGB}{33,33,33}
\definecolor{mathgray}{RGB}{100,100,100}
\newcommand{\Rightarrowx}{{\color{mathgray} \  \Rightarrow \ \ }}
\textcolor{mathcolor}{
\begin{align*}
\text{<PayloadRpc>} \ := \ & \text{action:}\text{ShortName}\ \text{arguments:}\text{ArgumentRpc}\text{*}  \Rightarrowx \text{action(arguments)}  \\
\end{align*}
}
$$

The short name of an action is an u32 integer identifier that uniquely identifies the action within the smart contract.
The short name is encoded as [unsigned LEB128 format](https://en.wikipedia.org/wiki/LEB128#Unsigned_LEB128), which means that short names have variable lengths.
It is easy to determine how many bytes a LEB128 encoded number contains by examining bit 7 of each byte.

$$\definecolor{mathcolor}{RGB}{33,33,33}
\definecolor{mathgray}{RGB}{100,100,100}
\newcommand{\Rightarrowx}{{\color{mathgray} \  \Rightarrow \ \ }}
\newcommand{\nnhexi}[1]{{\color{mathcolor}\mathtt{0x}}{\color{mathgray}}{\color{mathcolor} #1}}
\textcolor{mathcolor}{
\begin{align*}
\text{<ShortName>} \ := \ & \text{pre:}\nnhexi{nn}\text{*}\ \text{last:}\nnhexi{nn}\ \Rightarrowx \text{Action}  &\text{(where pre is 0-4 bytes that are &ge;0x80 and last&lt;0x80)} \\
\end{align*}
}
$$

The argument binary format depends on the type of the argument. The argument types for each action is defined by the contract, and can be read from the ABI format. 

$$\definecolor{mathcolor}{RGB}{33,33,33}
\definecolor{mathgray}{RGB}{100,100,100}
\newcommand{\Rightarrowx}{{\color{mathgray} \  \Rightarrow \ \ }}
\newcommand{\nnhexi}[1]{{\color{mathcolor}\mathtt{0x}}{\color{mathgray}}{\color{mathcolor} #1}}
\textcolor{mathcolor}{
\begin{align*}
\text{<ArgumentRpc>} \ := \ & \nnhexi{nn} \ \Rightarrowx \text{u8/i8} & \text{(i8 is twos complement)} \\
| \ & \nnhexi{nn}\text{*2} \ \Rightarrowx \text{u16/i16} & \text{(big endian, i16 is two's complement)} \\
| \ & \nnhexi{nn}\text{*4} \ \Rightarrowx \text{u32/i32} & \text{(big endian, i32 is two's complement)} \\
| \ & \nnhexi{nn}\text{*8} \ \Rightarrowx \text{u64/i64} & \text{(big endian, i64 is two's complement)} \\
| \ & \nnhexi{nn}\text{*16} \ \Rightarrowx \text{u128/i128} & \text{(big endian, i128 is two's complement)} \\
| \ & \text{b:}\nnhexi{nn} \ \Rightarrowx \text{bool} & \text{(false if b==0, true otherwise)} \\
| \ & \nnhexi{nn}\text{*21} \ \Rightarrowx \text{Address} \\
| \ & \nnhexi{nn}\text{*len} \ \Rightarrowx \text{Array }\text{[u8;len]} & \text{(containing the len u8 values)} \\
| \ & \text{len:}\text{LengthRpc} \ \text{utf8:}\nnhexi{nn}\text{*len} \ \Rightarrowx \text{String} & \text{(with len UTF-8 encoded bytes)} \\
| \ & \text{len:}\text{LengthRpc} \ \text{elems:}\text{ArgumentRpc}\text{*len} \ \Rightarrowx \text{Vec&lt;&gt;} & \text{(containing the len elements)} \\
| \ & \text{b:}\nnhexi{nn} \ \text{arg:}\text{ArgumentRpc} \ \Rightarrowx \text{Option&lt;&gt;} & \text{(None if b==0, Some(arg) otherwise)} \\
\end{align*}
}
$$

For arguments with variable lengths, such as Vecs or Strings the number of elements is represented as a big endian 32-bit unsigned integer.  

$$\definecolor{mathcolor}{RGB}{33,33,33}
\definecolor{mathgray}{RGB}{100,100,100}
\newcommand{\Rightarrowx}{{\color{mathgray} \  \Rightarrow \ \ }}
\newcommand{\nnhexi}[1]{{\color{mathcolor}\mathtt{0x}}{\color{mathgray}}{\color{mathcolor} #1}}
\textcolor{mathcolor}{
\begin{align*}
\text{<LengthRpc>} \ := \ & \nnhexi{nn}\text{*4} \ \Rightarrowx \text{u32}  &\text{(big endian)} \\
\end{align*}
}
$$

## State Binary Format

## ABI Binary Format

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
| \ &\hexi{0f} \text{ K:}\text{TypeSpec}\text{ V:}\text{TypeSpec} \Rightarrowx \text{Map <}\text{K}, \text{V>} \\
| \ &\hexi{10} \text{ T:}\text{TypeSpec} \Rightarrowx \text{Set<}\text{T>} \\
| \ &\hexi{11} \text{ L:}\nnhexi{nn} \Rightarrowx \text{[u8; }\text{L}\text{]} & (\hexi{01} \leq L \leq \hexi{20}) \\
| \ &\hexi{12} \text{ T:}\text{TypeSpec} \Rightarrowx \text{Option<}\text{T>} \\
\\
\end{align*}
}
$$

**NOTE:** `Map` and `Set` cannot be used as RPC arguments since it's not possible for a
caller to check equality and sort order of the elements without running the code.

#### ABI File binary format

$$
\definecolor{mathcolor}{RGB}{33, 33, 33}
\textcolor{mathcolor}{
\begin{align*}
\text{<FileAbi>} \ := \ \{ \
&\text{Header: 6* u8},  &\text{The header is always "PBCABI" in ASCII}\\
&\text{VersionBinder: 3* u8} \ \\
&\text{VersionClient: 3* u8} \ \\
&\text{Contract: ContractAbi} \ \} \\
\\
\text{<ContractAbi>} \ := \ \{ \
&\text{ShortnameLength: u8}, \\
&\text{StructTypes: List<StructTypeAbi>}, \\
&\text{Init: FnAbi}, \\
&\text{Actions: List<FnAbi>}, \\
&\text{StateType: TypeSpec} \ \} 
\\
\text{<StructTypeAbi>} \ := \ \{ \
&\text{Name: String}, \\
&\text{Fields: List<FieldAbi>} \ \} \\
\\
\text{<FnAbi>} \ := \ \{ \
&\text{Name: String}, \\
&\text{Arguments: List<ArgumentAbi>} \ \} \\
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

#### Byte size of instantiated Types
| Type  | Size in bytes | Description
|---|---|---|
| Custom_Struct     | Size(Custom_Struct)           | Type index + 
| u8                | 1                             | 
| u16               | 2                             | 
| u32               | 4                             | 
| u64               | 8                             | 
| u128              | 16                            | 
| i8                | 1                             |
| i16               | 2                             | 
| i32               | 4                             | 
| i64               | 8                             | 
| i128              | 16                            |
| bool              | 1                             |
| String            | 4 + n                         |
| List<T\>           | 4 + n \* Size(T)              | Number of elements (n) + n \* Size(T)
| Map<K, V\>   | 4 + Size(K) + Size(V)         | 
| Set<T\>      | 4 + Size(T)                   | 
| Address           | 4 + 20                        | 
| \[u8; n\]         | n                             |
| Option<T\>        | 1 + Size(T)                   |

