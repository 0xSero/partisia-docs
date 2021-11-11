# Draft: PBC contract ABI version 1

## Basic types

| Name | Length | Description |
|---    |--- |---|
| u8  | 1 | 8-bit integers | 
| u16 | 2 |16-bit integers |
| u32 | 4 |32-bit integers |
| u32 | 4 |32-bit integers |
| Vector\<T\> | 4 + n T's | u32 length followed by n elements.  |
| String | 4 + n | u32 length followed by n *bytes* UTF-8 encoded characters.  |
| Optional\<T\> | 1 + n | Boolean as u8 followed the element of n length |

All integers are big endian.

## Complex types

### ContractAbi

| Name | Type | Description |
|---    |--- |---|
| Shortname length | u8 | The length of the shortname field
| Types            | Vec<TypeAbi> | A vector of TypeAbi elements representing all the legal state and RPC types
| Init             | FunctionAbi  | A single FunctionAbi representing the contract initializer
| Actions          | Vec<TypeAbi> | A vector of TypeAbi elements representing the contract actions
| State            | String       | A string denoting the state type of the contract

### TypeAbi

| Name | Type | Description |
|---    |--- |---|
| Name | String | The name of the type
| Fields| Vector<FieldAbi> | A vector of FieldAbi elements, one for each field in the struct.

### FieldAbi

| Name | Type | Description |
|---    |--- |---|
| Datatype | Optional<u8> | Denotes the type of the field. `0` marks a user-defined, named struct. Positive integers denote a built-in type, see below.
| Type index     | u8 | The index of the user-defined struct in the Types vector.
| Fields   | Vec\<FieldAbi\> | A vector of FieldAbi elements, one for each field of the user-defined struct.

Built-in types are the following:

| Value | Corresponding Rust type
|---    |--- 
0  |  CUSTOM_STRUCT
1  |  u8
2  |  u16
3  |  u32
4  |  u64
5  |  u128
6  |  "i8
7  |  i16
8  |  i32
9  |  i64
10 |  i128
11 |  Vec\<T\> \*
12 |  BTreeMap\<S, T\> \*\*
13 |  BTreeSet
14 |  \[u8; 1\]
15 |  \[u8; 2\]
.. |
46 |  \[u8; 32\]

\* T is written as a single u8 denoting the type index of T in the Types vector in the parent
ContractAbi.  
\*\* Same as Vec but two bytes one for S and one for T.

### ArgumentAbi

| Name | Type | Description |
|---    |--- |---|
| Name | String | The name of the field
| Type index     | u8 | The index of the user-defined struct in the Types vector.


## Structure

| Name | Type | Description |
|---    |--- |---|
| Header | 6* u8 | `PBCABI` in ASCII| 
| Version | u16 | The version number
| Shortname length | u8 | The length of the shortname field
| Types | Vec<TypeAbi> | A vector of TypeAbi elements. 

