# Zero-Knowledge Rust

ZK-Rust is the main tool for writing Zero-Knowledge Computations for Partisia
Blockchain. ZK-Rust resembles [Rust](https://rust-lang.com) in syntax, with
a restricted feature set, and an alternative standard library tailored for
Partisia Blockchain.

## Concepts

Zk-Rust's most significant difference from Rust, is it's support for
representing [Secret-shared values](https://en.wikipedia.org/wiki/Secret_sharing),
the basic building blocks for writing Zero-knowledge computations.
This secret-sharing support extends from new syntax to types to runtime behaviour.

### Secret-shared integers

The secret-sharing supported in Zk-Rust is an alternative method of
representing integers. This representation is used when working with the `Sbi`
types (`Sbi1`, `Sbi8`, `Sbi16`, etc.,) which stands for "**S**ecret-shared
**B**inary **I**nteger".  These types are fully fledged integer types,
supporting a variety of infix operations (`+`, `-`, `^`, `|`, etc.) All of
these operations are performed through secret-sharing, ensuring that the result
is itself secret-shared:

```rust
pub fn my_computation() -> Sbi32 {
    let public_1: i32 = 93
    let secret_1: Sbi32 = Sbi32::from(public_1);
    let secret_2: Sbi32 = Sbi32::from(231);
    let secret_3: Sbi32 = secret_1 + secret_2;
    secret_3 * Sbi32::from(2)
}
```

As seen above, secrecy is _contagious_: All operations involving
a secret-shared type produces a new secret-shared type.

This comes from the more general rule that _it must be impossible to learn any
secret information at the public level_, a kind of known as [Information Flow
Control](https://en.wikipedia.org/wiki/Information_flow_(information_theory))
(IFC). The secret-sharing IFC rule is enforced by The Partisia Blockchain,
which prevents leakage of sensitive information.

The following program will not compile, for example:

```rust
pub fn my_computation() -> i32 {
    let secret_1: Sbi32 = Sbi32::from(93);
    let secret_2: Sbi32 = Sbi32::from(231);
    let declassify: i32 = secret_1 + secret_2; // !! Cannot assign secret to public variable!
    declassify * 2
}
```

New `SbiN` values can be created from public integers using `SbiN::from(iN)`.

### Secret Branching

As we've seen above, the operations available on `Sbi` is constrained, due to
IFS. Another situation where Secret-shared values are less flexible that their
public counterparts is when branching.

Consider for example:

```
let secret: Sbi32 = ...;
let mut public: i32 = 9;
if secret == Sbi32::from(4) {
    public = 5;  // !! Cannot assign secret to public variable!
}
```

The above program is disallowed by ZkRust, because it is trying to assign to
a public value while braching upon a secret. This is clearly a break of IFC,
as the value of `public` after the branch would be based upon the value of
`secret`, which again is a break of IFC.

It is possible to assign secrets in secret-braches:

```
let secret: Sbi32 = ...;
let mut secret_2: Sbi32 = Sbi32::from(9);
if secret == Sbi32::from(4) {
    secret_2 = Sbi32::from(5);
}
```

Here the assignment is allowed, as there is no declassification. Note though
that this branch is compiled differently from public branches, and might result
in some performance overhead.

### Inputs and contract state

Computation inputs are accessed by `load_sbi::<S: Secret>(idx: i32): S` and
`load_metadata::<T: Public>(idx: i32): T`. `load_sbi` loads the variable at the
given variable index `idx` as a secret `S` (throwing at runtime if the variable
could not be loaded to that `S`), while `load_metadata` loads
the non-secret `T` that is associated with the variable.

Additionally, the `load_sbi` function supports loading entirely secret structs,
e.g. structs with fields that are themselves entirely secret. For example:

```
#[derive(Secret)]
struct Secret3D {
    x: Sbi32,
    y: Sbi32,
    z: Sbi32,
}

#[derive(Secret)]
struct Polygon3D {
    x: Secret3D,
    y: Secret3D,
    z: Secret3D,
}
```

