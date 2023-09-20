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

You can also run the provided script 'run-java-tests.sh', where a build flag, '-b', for compiling the contracts before test run, can
be given. This would be equivalent to running the above commands in order.
````bash
./run-java-tests.sh -b
````
## Run test with code coverage

To see that the tests hits the different parts of the code, we can run the tests, where all events are propagated to
an instrumented executable. This will generate the coverage information, which can be made into a report. 
Run the tests with coverage enabled, by running the 'run-java-tests.sh' with the build flag, '-b', and the coverage flag,
'-c'.
````bash
./run-java-tests.sh -c -b
````
This will create the instrumented executable, and run the test with coverage enabled.


# Break down of a test

````java
import static org.assertj.core.api.Assertions.assertThat;

import com.partisiablockchain.BlockchainAddress;
import com.partisiablockchain.language.abicodegen.TokenContract;
import com.partisiablockchain.language.junit.ContractBytes;
import com.partisiablockchain.language.junit.ContractTest;
import com.partisiablockchain.language.junit.JunitContractTest;
import com.partisiablockchain.language.junit.TestBlockchain;

import java.math.BigInteger;
import java.nio.file.Path;

public final class MyTokenTest extends JunitContractTest {

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

    byte[] initRpc = TokenContract.initialize("My Test Token", "TEST", (byte) 8, TOTAL_SUPPLY);

    token = blockchain.deployContract(owner, CONTRACT_BYTES, initRpc);

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

## Imports and Abstract Class
The test extends the JunitContractTest class, this is the abstract class providing the blockchain object, it is also the
class that provides the use of chain-state from a previous test as setup. 

The imports:

???
````java
import static org.assertj.core.api.Assertions.assertThat; // Library to make assertions on objects during test run.

import com.partisiablockchain.BlockchainAddress; // The Blockchain Address type, used create transactions and target contracts deployed at them.
import com.partisiablockchain.language.abicodegen.TokenContract; // Code generated from the contract, to help with the serialization of rpc and deserialization of state.
import com.partisiablockchain.language.junit.ContractBytes; // The type used to bundle all the bytecode needed to deploy a contract, and run tests to generate coverage. 
import com.partisiablockchain.language.junit.ContractTest; // The annotation to mark a test a 'ContractTest'.
import com.partisiablockchain.language.junit.JunitContractTest; // The abstract class, setting up the test environment for smart contact testing.
import com.partisiablockchain.language.junit.TestBlockchain; // The blockchain used for test, implementing different helper methods, to ease of testing smart contracts.

import java.math.BigInteger; // The Big Integer type.
import java.nio.file.Path; // Paths used for specifying the location of the contact bytecode.

````


## Specify the bytecode to deploy - ContractBytes

We have declared an instance of `ContractBytes`, where we specify the relative location of the .wasm and .abi file
for our [example Token contract](https://gitlab.com/partisiablockchain/language/example-contracts/-/tree/main/token?ref_type=heads).
The three paths declared are the path to the wasm, the abi and the local instrumented executable. 
The local instrumented executable is used for code coverage.


The two fields with type BlockchainAddress, `owner` and `token`, these will be populated in the test, where we 
create a public account and when we deploy the contract, the call returns the address the contract 
was deployed at.

We have created the first test named `setup`. The method have the annotation `@ContractTest`. This marks the test as a test, that can be used by other tests as their setup. 

The generated Java code, that is based on the ABI of the contract, provides a Record object, 
`TokenContract.TokenState`, which can be used to deserialize the contract state into.
The object can then be asserted on using standard Java assertions.

Now try running the test. If you only want to run one test, you can run the following command while standing `java-test`:

```bash
mvn test -Dtest="MyTokenTest"
```

### Second test using the first test as a setup

We can now perform our first interaction with the deployed contract. So we add another test to our test class.
Another account must be created, so we add another field, `receiver`, and create the account.


Notice in the annotation `@ContractTest`, we have provided an argument that points to our previous method,
where we deployed our contract. In our example, that is `setup`.

In this test, we send an action to our contract, the functionality we are testing is just a normal transfer from `owner`
to `receiver`. We call the `.sendAction()`, where we provided the address of the contract, we want to send the action to.
The sender of the [action](https://partisiablockchain.gitlab.io/documentation/smart-contracts/programmers-guide-to-smart-contracts.html#action), and the [rpc](https://partisiablockchain.gitlab.io/documentation/smart-contracts/programmers-guide-to-smart-contracts.html#events) for the call. The rpc in this case contains the receiver of the transfer, and 
the amount to send.

After reading the article, you should now be able to: 
1. Deploy a contract in a test, by specifying the bytes to use for the contract, and rpc for the init call.
2. Use that test as a setup for another test, by pointing to the method name with the previous parameter,
`@ContractTest(previous = "NAME-OF-SETUP-TEST")`.
3. Interact with a contract by sending an action.

If you want to more examples of testing smart contracts, go to 
[example contracts](https://gitlab.com/partisiablockchain/language/example-contracts), where there are multiple tests.


