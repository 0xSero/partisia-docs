# Testing a smart contract

A smart contract is an atomic operation program. So to avoid mistakes and exploits in a contract, 
which are permanent actions, we should have a form of testing.

In the example contracts, we have tests, to show the behaviour for all the contracts. These tests are written in
Java, using our testing framework Junit-contract-test. In the test we are provided a blockchain object, where we can
deploy and interact with multiple different contracts. 

To run the tests stand in the root of contract examples and run the following commands in order.

Compile the contracts:
```bash
cargo partisia-contract build --release
```

Compile the tests and run them.
```bash
mvn test-compile test
```

## Write your first test

Create a new test for the Token contract. Create a new java file in the `java-tests` folder, the name could be 
`MyTokenTests.java`. In that file we can now define our test class
```java
public final class MyTokenTest extends JunitContractTest {
    // ...
}
```
The test extends the JunitContractTest class, this is the abstract class providing the blockchain object.

We can now write our first test. First we should deploy the token contract, such that we have a
deployed contract to interact with in our tests. We can call this test `setup`, since we will be using this test
as a starting point for our other tests.

````java
public final class TokenTest extends JunitContractTest {

  public static final ContractBytes CONTRACT_BYTES =
      ContractBytes.fromPaths(
          Path.of("../target/wasm32-unknown-unknown/release/token_contract.wasm"),
          Path.of("../target/wasm32-unknown-unknown/release/token_contract.abi"));

  private static final BigInteger TOTAL_SUPPLY = BigInteger.valueOf(123123);

  private BlockchainAddress account1;
  private BlockchainAddress token;

  /** Setup for all the other tests. Deploys token contract and instantiates accounts. */
  @ContractTest
  void setup() {
    account1 = blockchain.newAccount(1);

    token =
        deployTokenContract(blockchain, account1, "My Test Token", "TEST", (byte) 8, TOTAL_SUPPLY);

    assertStateInvariants(state);
    assertThat(state.totalSupply()).isEqualTo(TOTAL_SUPPLY);
  }
}
````

There are 3 things to notice here.

1. We have declared an instance of `ContractBytes`, where we specify the relative location of the .wasm and .abi file
for our Token contract.
The three paths declared are the path to the wasm, the abi and the local instrumented executable.

2. The two fields with type BlockchainAddress, `account1` and `token`, these will be populated in the test, where we 
create a public account and when we deploy the contract, the call returns the address the contract 
was deployed at.

3. We have created the first test named `setup`. The method have the annotation `@ContractTest`. This marks the test as
test, that be used by other tests as their setup. 

We use the generated Java code, that is based on the ABI of the contract. This provides a Record object, which can be
to deserialize the contract state into. The object can then be asserted on using standard Java assertions.