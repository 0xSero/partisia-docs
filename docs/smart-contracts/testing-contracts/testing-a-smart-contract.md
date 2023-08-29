# Testing a smart contract

Tests for your smart contract helps you avoid mistakes and exploits in a contract, you
are developing. 

In the [example contracts](https://gitlab.com/partisiablockchain/language/example-contracts), we have tests, to show the behaviour for all the contracts. These tests are written in
Java, using our testing framework Junit-contract-test. In the test we are provided a blockchain object, where we can
deploy and interact with multiple different contracts. 

To run the tests stand in the root of contract examples and run the following commands in order.

Compile the contracts:
```bash
cargo partisia-contract build --release
```

Go into the test dir, compile the tests and run them.
```bash
cd java-test
mvn test-compile test
```

## Write your first test

Create a new test for the Token contract. Create a new java file in the `java-tests` folder, next to the other tests,
the name could be `MyTokenTests.java`. In that file we can now define our test class:
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
          Path.of("../target/wasm32-unknown-unknown/release/token_contract.abi"),
          Path.of("../target/wasm32-unknown-unknown/release/token_contract_runner"));

  private static final BigInteger TOTAL_SUPPLY = BigInteger.valueOf(123123);

  private BlockchainAddress owner;
  private BlockchainAddress token;

  /** Setup for all the other tests. Deploys token contract and instantiates accounts. */
  @ContractTest
  void setup() {
    owner = blockchain.newAccount(1);

    token = deployTokenContract(blockchain, owner, "My Test Token", "TEST", (byte) 8, TOTAL_SUPPLY);

    TokenContract.TokenState state =
        TokenContract.TokenState.deserialize(blockchain.getContractState(token));

    assertThat(state.totalSupply()).isEqualTo(TOTAL_SUPPLY);
  }
}

````

There are 4 things to notice here.

1. We have declared an instance of `ContractBytes`, where we specify the relative location of the .wasm and .abi file
for our Token contract.
The three paths declared are the path to the wasm, the abi and the local instrumented executable. 
The local instrumented executable is used for code coverage. 

2. The two fields with type BlockchainAddress, `owner` and `token`, these will be populated in the test, where we 
create a public account and when we deploy the contract, the call returns the address the contract 
was deployed at.

3. We have created the first test named `setup`. The method have the annotation `@ContractTest`. This marks the test as
test, that be used by other tests as their setup. 

4. The generated Java code, that is based on the ABI of the contract, provides a Record object, 
`TokenContract.TokenState`, which can be used to deserialize the contract state into.
The object can then be asserted on using standard Java assertions.


### Second test using the first test as a setup

We can now perform our first interaction with the deployed contract. So we add another test to our test class.
Another account must be created, so we add another field, `receiver`, and create the account.

````java
public final class TokenTest extends JunitContractTest {

  public static final ContractBytes CONTRACT_BYTES =
      ContractBytes.fromPaths(
          Path.of("../target/wasm32-unknown-unknown/release/token_contract.wasm"),
          Path.of("../target/wasm32-unknown-unknown/release/token_contract.abi"));

  private static final BigInteger TOTAL_SUPPLY = BigInteger.valueOf(123123);

  private BlockchainAddress owner;
  private BlockchainAddress receiver;
  private BlockchainAddress token;

  /** Setup for all the other tests. Deploys token contract and instantiates accounts. */
  @ContractTest
  void setup() {
    owner = blockchain.newAccount(1);
    receiver = blockchain.newAccount(2);

    token = deployTokenContract(blockchain, owner, "My Test Token", "TEST", (byte) 8, TOTAL_SUPPLY);

    final TokenContract.TokenState state =
        TokenContract.TokenState.deserialize(blockchain.getContractState(token));

    assertThat(state.totalSupply()).isEqualTo(TOTAL_SUPPLY);
  }

  /** Transfer tokens from one account to another. */
  @ContractTest
  void transferTokens() {

    BigInteger amount = BigInteger.TEN;
    final byte[] transferRpc = TokenContract.transfer(receiver, amount);

    blockchain.sendAction(owner, token, transferRpc);

    TokenContract.TokenState state =
        TokenContract.TokenState.deserialize(blockchain.getContractState(token));

    assertThat(state.balances().get(owner)).isEqualTo(TOTAL_SUPPLY.subtract(amount));
    assertThat(state.balances().get(receiver)).isEqualTo(amount);
  }
}

````

