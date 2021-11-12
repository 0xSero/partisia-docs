# Draft: PBC contract ABI version 1.0

## Basic types used to serialize the ABI

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

## Basic types used to serialize RPC calls and contract state

| Value | Length  | Corresponding Rust type
|---|---|---| 
| 0     | 1 + n              | CUSTOM_STRUCT
| 1     | 1                  | u8
| 2     | 2                  | u16
| 3     | 4                  | u32
| 4     | 8                  | u64
| 5     | 16                 | u128
| 6     | 1                  | i8
| 7     | 2                  | i16
| 8     | 4                  | i32
| 9     | 8                  | i64
| 10    | 16                 | i128
| 11    | 4 + n \* T         | Vec<T\> \*
| 12    | 1 + 1 + n \* (S+T) | BTreeMap<S, T\> \*\*
| 13    | 1 + n \* T         | BTreeSet<T>                       
| 14    | 1 + n              | \[u8; n\] \*\*\*
                             
\* T is written as a single u8 denoting the type index of T in the Types vector in the parent
ContractAbi.

\*\* Same as Vec but two bytes one for S and one for T.

\*\*\* n denotes the length as an u8. Currently we support a max length of 32.

## Structure

| Name         | Type        | Description |
|---|---|---|
| Header       | 6* u8       | `PBCABI` in ASCII
| Version      | u16         | The version number
| Contract ABI | ContractAbi | The actual contract ABI

## Complex types

### ContractAbi

| Name | Type | Description |
|---|---|---|
| Shortname length | u8           | The length of the shortname field
| Types            | Vec<TypeAbi> | A vector of TypeAbi elements representing all the legal state and RPC types
| Init             | FunctionAbi  | A single FunctionAbi representing the contract initializer
| Actions          | Vec<TypeAbi> | A vector of TypeAbi elements representing the contract actions
| State            | String       | A string denoting the state type of the contract

### TypeAbi

| Name | Type | Description |
|---|--- |---|
| Name      | String           | The name of the type
| Fields    | Vector<FieldAbi> | A vector of FieldAbi elements, one for each field in the struct.

### FieldAbi

| Name | Type | Description |
|---|---|---|
| Datatype     | Optional<u8>   | Denotes the type of the field. `0` marks a user-defined, named struct. Positive integers denote a built-in type, see below.
| Type index   | u8             | The index of the user-defined struct in the Types vector.
| Fields       | Vec<FieldAbi\> | A vector of FieldAbi elements, one for each field of the user-defined struct.

### ArgumentAbi

| Name | Type | Description |
|---|---|---|
| Name           | String | The name of the field
| Type index     | u8     | The index of the user-defined struct in the Types vector.


