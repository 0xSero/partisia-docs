
# Zero Knowledge language features

This table tracks feature availability, including feature comparison with [the main Rust
project](https://www.rust-lang.org/), and some ZkRust specific features mixed in. This is not a roadmap.

Legend: ✅ Supported, ✨ Supported and distinct from Rust, ❌ Unsupported

| Feature        | Status   | Likelyhood of implementation |
| ---            | ---      | ---      |
| For-in-range          | ✅   |    |
| Public Integers and booleans | ✅   |    |
| `SbiN` (Secret Binary Integers) | ✨   |    |
| Structs with public        | ✅ |    |
| Structs with secret        | ✨ |    |
| Tuple Types                | ✅ |    |
| Type generics              | ✅ |    |
| `continue`, `break`        | ✅ |    |
| Type aliases               | ✅ |    |
| Generalized `for`-in-iterator | ✅ | |
| Arrays                     | ❌ | Very Likely   |
| General derive traits      | ❌ | Very Likely   |
| `enum`                     | ❌ | Likely   |
| `fn` Function declaration  | ❌ | Likely   |
| Assigning to struct fields | ❌ | Likely   |
| `const` Constant items     | ❌ | Possibly |
| Closure expressions        | ❌ | Possibly |
| Constant generics          | ❌ | Possibly |
| Constant evaluation        | ❌ | Possibly |
| [Full iterator interface](https://doc.rust-lang.org/std/iter/trait.Iterator.html)  | ❌ | Possibly |
| Function references and types | ❌ | Possibly |
| Pattern matching and Destructuring | ❌ | Possibly |
| String Type               | ❌ | Possibly |
| [Compound assignment expressions](https://doc.rust-lang.org/reference/expressions/operator-expr.html#compound-assignment-expressions) | ❌ | Possibly |
| [Question mark operator](https://doc.rust-lang.org/reference/expressions/operator-expr.html#the-question-mark-operator) | ❌ | Possibly |
| `match`                   | ❌ | Possibly |
| `union`                   | ❌ | Possibly |
| `f32`, `f64` Floats       | ❌ | Unlikely |
| Associated items          | ❌ | Unlikely |
| `extern crate`            | ❌ | Unlikely |
| Full borrow checking      | ❌ | Unlikely |
| General macro support     | ❌ | Unlikely |
| Generic Associated Types  | ❌ | Unlikely |
| Modules                   | ❌ | Unlikely |
| Trait and impl            | ❌ | Unlikely |
| `dyn`   Trait objects     | ❌ | Unlikely |
| `panic!`                  | ❌ | Unlikely |
| Lifetimes                 | ❌ | Unlikely, due to limited utility |
| References and Pointers   | ❌ | Unlikely, due to limited utility |
| `loop`                    | ❌ | Unlikely, due to gas concerns. |
| `while`                   | ❌ | Unlikely, due to gas concerns. |
| Bitshift with two secrets | ❌ | Unlikely, due to performance concerns. |
| Array indexing with secret-shared index | ❌ | Unlikely, due to performance concerns. |
| Async                  | ❌ | Incompatible with current archtecture. |
| Inline Assembly        | ❌ | Incompatible with current archtecture. |
| Operating System Access| ❌ | Incompatible with current archtecture. |
| `print!` and other IO  | ❌ | Incompatible with current archtecture. |
| Threading              | ❌ | Incompatible with current archtecture. |
| `unsafe`               | ❌ | Incompatible with current archtecture. |

