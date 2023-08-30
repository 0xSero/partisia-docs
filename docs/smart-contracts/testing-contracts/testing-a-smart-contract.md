# Testing a smart contract

Tests for your smart contract helps you avoid mistakes and exploits in a contract, you
are developing. After reading this page, you should be able to do the following: 

1. Write a test, that deploys a contract
2. Use the deployment test as setup for another test.
3. Interact with the contract in the test.

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

Create a new test for the Token contract. Create a new java file next to the other tests in the example-contracts folder,
the name could be `MyTokenTest.java`. In that file we can now define our test class:
```java
public final class MyTokenTest extends JunitContractTest {
    // ...
}
```
The test extends the JunitContractTest class, this is the abstract class providing the blockchain object.

To write your first test, you should start by deploying the token contract. The deployed contract is needed to make sure we have a contract to interact with in our tests, you can also use your contract when writing your first test. Lets call this test 'setup', this first setup test will be the starting point for our future tests. 

````java
import static org.assertj.core.api.Assertions.assertThat;

import com.partisiablockchain.BlockchainAddress;
import com.partisiablockchain.language.abicodegen.TokenContract;
import com.partisiablockchain.language.junit.ContractBytes;
import com.partisiablockchain.language.junit.ContractTest;
import com.partisiablockchain.language.junit.JunitContractTest;
import com.partisiablockchain.language.junit.TestBlockchain;

public final class MyTokenTest extends JunitContractTest {

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

There are 5 things to notice here.

1. We have added imports for all the needed libraries and generated classes. 

2. We have declared an instance of `ContractBytes`, where we specify the relative location of the .wasm and .abi file
for our Token contract.
The three paths declared are the path to the wasm, the abi and the local instrumented executable. 
The local instrumented executable is used for code coverage. 

3. The two fields with type BlockchainAddress, `owner` and `token`, these will be populated in the test, where we 
create a public account and when we deploy the contract, the call returns the address the contract 
was deployed at.

4. We have created the first test named `setup`. The method have the annotation `@ContractTest`. This marks the test as a test, that can be used by other tests as their setup. 

5. The generated Java code, that is based on the ABI of the contract, provides a Record object, 
`TokenContract.TokenState`, which can be used to deserialize the contract state into.
The object can then be asserted on using standard Java assertions.


### Second test using the first test as a setup

We can now perform our first interaction with the deployed contract. So we add another test to our test class.
Another account must be created, so we add another field, `receiver`, and create the account.

````java
// Imports from above

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
  @ContractTest(previous = "setup")
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
Notice in the annotation `@ContractTest`, we have provided an argument that points to our previous method,
where we deployed our contract. In our example, that is `setup`.

In this test, we send an action to our contract, the functionality we are testing is just a normal transfer from `owner`
to `receiver`. We call the `.sendAction()`, where we provided the address of the contract, we want to send the action to.
The sender of the action, and the rpc for the call. The rpc in this case contains the receiver of the transfer, and 
the amount to send.

So to sum it up. You have now seen:
1. How to deploy a contract in a test, by specifying the bytes to use for the contract, and rpc for the init call.
2. Use that test as a setup for another test, by pointing to the method name with the previous parameter,
`@ContractTest(previous = "NAME-OF-SETUP-TEST")`.
3. Interact with a contract by sending an action.

If you want to more examples of testing smart contracts, go to 
[example contracts](https://gitlab.com/partisiablockchain/language/example-contracts), where there are multiple tests.


