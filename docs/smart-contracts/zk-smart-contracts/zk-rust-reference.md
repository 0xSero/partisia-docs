# ZK Rust Reference

Covering the types and functions available in [ZkRust](zk-rust-language-zkrust.md).

## Types

| Type                                                          | Comment |
| ---                                                           |  --- |
| [`bool`](https://doc.rust-lang.org/std/primitive.bool.html)   |        |
| [`i8`](https://doc.rust-lang.org/std/primitive.i8.html)       |        |
| [`i16`](https://doc.rust-lang.org/std/primitive.i16.html)     |        |
| [`i32`](https://doc.rust-lang.org/std/primitive.i32.html)     |        |
| [`u8`](https://doc.rust-lang.org/std/primitive.u8.html)       |        |
| [`u16`](https://doc.rust-lang.org/std/primitive.u16.html)     |        |
| [`u32`](https://doc.rust-lang.org/std/primitive.u32.html)     |        |
| [`usize`](https://doc.rust-lang.org/std/primitive.usize.html) |        |
| [`Range`](https://doc.rust-lang.org/std/ops/struct.Range.html) |        |
| `pbc_zk::Sbi1`    | Secret-shared boolean. |
| `pbc_zk::Sbi8`    | Secret-shared 8-bit signed integer.          |
| `pbc_zk::Sbi16`   | Secret-shared 16-bit signed integer.         |
| `pbc_zk::Sbi32`   | Secret-shared 32-bit signed integer.         |
| `pbc_zk::Sbi64`   | Secret-shared 64-bit signed integer.         |
| `pbc_zk::Sbi128`  | Secret-shared 128-bit signed integer.        |

## Traits

Note that traits are not fully implemented, and these are mostly for
illustrative purposes.

| Trait     | Documentation |
| ---       |  ---     |
| `Public`  | Public types are "normal" Rust types like `i32`, where the data is publicly known, for example because it is directly visible in the contract state. |
| `pbc_zk::Secret` | Secret types are types like `Sbi32` where the data is secret-shared between ZK nodes.  |
| `pbc_zk::SecretBinary` | Sub-interface of `pbc_zk::Secret` where variables are secret-shared as bits. |

## Functions

Does not cover deprecated functions.

| Function                                  | Documentation |
| ---                                       |  ---     |
| `pbc_zk::num_secret_variables() -> i32`           | Determines the number of secret variables available to the computation. _Variable ids are not contiguous and cannot by iterated over using `1..num_secret_variables()`_ |
| `pbc_zk::load_sbi<S: SecretBinary>(id: i32) -> S`       | Loads the secret-shared data associated with variable `id` as the given type `S`. |
| `pbc_zk::load_metadata<P: Public>(id: i32) -> P`  | Loads the public metadata associated with variable `id` as the given type `P`. |
| `pbc_zk::secret_variable_ids() -> Iterator<i32>`  | Creates an iterator for secret variable ids. |

## Lifetime attribute macros
| Macro                                                                                                                                          | Documentation                                                                                 |
|------------------------------------------------------------------------------------------------------------------------------------------------|-----------------------------------------------------------------------------------------------|
| [`zk_on_secret_input`](https://partisiablockchain.gitlab.io/language/contract-sdk/pbc_contract_codegen/attr.zk_on_secret_input.html)           | Declares an endpoint that the contract can be interacted with to add secret variables.        |
| [`zk_on_variable_inputted`](https://partisiablockchain.gitlab.io/language/contract-sdk/pbc_contract_codegen/attr.zk_on_variable_inputted.html) | Declares an automatic hook for when a variable is confirmed inputted.                         |
| [`zk_on_variable_rejected`](https://partisiablockchain.gitlab.io/language/contract-sdk/pbc_contract_codegen/attr.zk_on_variable_rejected.html) | Declares an automatic hook for when a variable is rejected.                                   |
| [`zk_on_compute_complete`](https://partisiablockchain.gitlab.io/language/contract-sdk/pbc_contract_codegen/attr.zk_on_compute_complete.html)   | Declares an automatic hook for when the zero-knowledge computation is finished.               |
| [`zk_on_variables_opened`](https://partisiablockchain.gitlab.io/language/contract-sdk/pbc_contract_codegen/attr.zk_on_variables_opened.html)   | Declares an automatic hook for when secret variables is ready to be read..                    |
| [`zk_on_attestation_complete`](https://partisiablockchain.gitlab.io/language/contract-sdk/pbc_contract_codegen/attr.zk_on_attestation_complete.html)                                                                                                               | Declares an automatic hook for when the contract have asked nodes to attest a piece of data,. |

