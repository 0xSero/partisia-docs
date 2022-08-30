### Compiling Zero-Knowledge contracts

As an example of compiling a zk-contract we will make use of the second-price auction contract. The
contract can be found in the SDK archive at: `contracts/example-zk-second-price-auction`.

The zk-contracts consist of two main parts. The contract itself as well as a zero-knowledge computation.
To compile a zero-knowledge contract you will first need to compile the contract using the `partisia-contract`
cargo command similarly to a [normal contract](compile-sdk.md). Afterward the zk-computation can be compiled using the included `zk-compiler.jar`:

```bash
java -jar zk-compiler.jar contracts/example-zk-second-price-auction/src/zk_compute.rs --link contracts/example-zk-second-price-auction/target/wasm32-unknown-unknown/release/zk_second_price.wasm -odir contracts/example-zk-second-price-auction/target/wasm32-unknown-unknown/release/
```

This creates the linked byte file with the zk bytecode as well as the wasm file which can be found in `contracts/example-zk-second-price-auction/target/wasm32-unknown-unknown/release`. 
This file is used for [deployment](compile-sdk.md) instead of the normal .wasm file.
In addition to the normal deploy cost and initialization arguments a zk contract also need MPC tokens for deployment.