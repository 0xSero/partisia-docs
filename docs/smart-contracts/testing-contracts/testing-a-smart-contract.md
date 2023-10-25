# Testing a smart contract

Tests for your smart contract helps you avoid mistakes and exploits in a contract, you
are developing. After reading this page, you should be able to do the following:

1. Write a test, that deploys a contract
2. Use the deployment test as setup for another test.
3. Interact with the contract in the test.

In the [example contracts](https://gitlab.com/partisiablockchain/language/example-contracts), we have tests to demonstrate the
behaviour for all the contracts. These tests are written in
Java, utilizing our testing framework Junit-contract-test. During the test we are, provided a blockchain object,
which allows us to deploy and interact with multiple different contracts.

To run the tests, navigate to the root of contract examples and execute the following commands in order.

Compile the contracts:

```bash
cargo partisia-contract build --release
```

Go into the test dir, compile the tests and run them.

```bash
cd java-test
mvn test-compile test
```

You can also run the provided script `run-java-tests.sh`, where a build flag, `-b`, for compiling the contracts before
test run, can
be given. This would be equivalent to running the above commands in order.

````bash
./run-java-tests.sh -b
````

To run a single test class, use the maven option `-Dtest="Name of Test Class"`, and run it while standing in the test
dir.

```bash
mvn test -Dtest="VotingTest"
```

### Run test with code coverage

To see that the tests hits the different parts of the smart contract code, we can run the tests with coverage enabled.
The tests will generate coverage information, which can be compiled into a report. To run the tests with coverage enabled,
execute `run-java-tests.sh` with the build flag, `-b`, and the coverage flag, `-c`.t pyu

````bash
./run-java-tests.sh -c -b
````

This will create the instrumented executable, and run the test with coverage enabled.

## Break down of a test
The following section is an example of a test of a "voting"
 smart contract. The most important aspects of this example will be explained in the following sections.
````java
import com.partisiablockchain.BlockchainAddress;
import com.partisiablockchain.language.abicodegen.Voting;
import com.partisiablockchain.language.junit.ContractBytes;
import com.partisiablockchain.language.junit.ContractTest;
import com.partisiablockchain.language.junit.JunitContractTest;
import com.partisiablockchain.language.junit.exceptions.ActionFailureException;

import java.nio.file.Path;
import java.util.List;

import org.assertj.core.api.Assertions;

/** Test suite for the Voting contract. */
public final class VotingTest extends JunitContractTest {

  private static final ContractBytes VOTING_CONTRACT_BYTES =
      ContractBytes.fromPaths(
          Path.of("../target/wasm32-unknown-unknown/release/voting.wasm"),
          Path.of("../target/wasm32-unknown-unknown/release/voting.abi"),
          Path.of("../target/wasm32-unknown-unknown/release/voting_runner"));
  private BlockchainAddress voter1;
  private BlockchainAddress voter2;
  private BlockchainAddress voter3;
  private BlockchainAddress voting;

  /** Setup for all the other tests. Deploys a voting contract and instantiates accounts. */
  @ContractTest
  void setUp() {
    voter1 = blockchain.newAccount(2);
    voter2 = blockchain.newAccount(3);
    voter3 = blockchain.newAccount(4);

    // Initialize a voting with a proposal ID, a list of voters and a deadline.
    byte[] initRpc = Voting.initialize(10, List.of(voter1, voter2, voter3), 60 * 60 * 1000);
    voting = blockchain.deployContract(voter1, VOTING_CONTRACT_BYTES, initRpc);
  }

  /** An eligible voter can cast a vote. */
  @ContractTest(previous = "setUp")
  public void castVote() {
    byte[] votingRpc = Voting.vote(true);
    // An eligible voter casts a vote
    blockchain.sendAction(voter1, voting, votingRpc);
    // Get the current state of the voting contract 
    Voting.VoteState state = Voting.VoteState.deserialize(blockchain.getContractState(voting));

    // One vote should be cast, and it should be "true"
    Assertions.assertThat(state.votes().size()).isEqualTo(1);
    Assertions.assertThat(state.votes().get(voter1)).isTrue();
  }
}

````

### Imports and Abstract Class

The test extends the JunitContractTest class, this is the extension providing the blockchain object. This enables
testing
of smart contracts. This enables automated testing of smart contracts, since the tests can be run on a single machine.

???+ info "Imports explained:"

    ```java
    import org.assertj.core.api.Assertions; // Library to make assertions on objects during test run.

    import com.partisiablockchain.BlockchainAddress; // The Blockchain Address type, used create transactions and target contracts deployed at them.
    import com.partisiablockchain.language.abicodegen.Voting; // Code generated from the contract, to help with the serialization of rpc and deserialization of state.
    import com.partisiablockchain.language.junit.ContractBytes; // The type used to bundle all the bytecode needed to deploy a contract, and run tests to generate coverage. 
    import com.partisiablockchain.language.junit.ContractTest; // The annotation to mark a test a 'ContractTest'.
    import com.partisiablockchain.language.junit.JunitContractTest; // The abstract class, setting up the test environment for smart contact testing.

    import java.nio.file.Path; // Paths used for specifying the location of the contact bytecode.
    import java.util.List; 
    
    public final class MyTokenTest extends JunitContractTest { // The test class must extend to JunitContractTest, to run Smart Contract Tests.
        // Fields and tests.
    }
    ```

### Deploying smart contract bytecode


In order to test a smart contract, you need to deploy the contract, which is done using `ContractBytes`.  
We have declared an instance of `ContractBytes`, where we specify the relative location of the .wasm and .abi file
for
our [example Voting contract](https://gitlab.com/partisiablockchain/language/example-contracts/-/tree/main/voting?ref_type=heads).
The three paths declared are the path to the wasm, the abi and the local instrumented executable.
The local instrumented executable is used for code coverage, the executable is named runner after the contract name.

???+ info "ContractBytes explained:"

    ````java
        private static final ContractBytes VOTING_CONTRACT_BYTES =
          ContractBytes.fromPaths(
                  Path.of("../target/wasm32-unknown-unknown/release/voting.wasm"),  // The relative path of the WASM of the contract.
                  Path.of("../target/wasm32-unknown-unknown/release/voting.abi"),   // The relative path of the ABI of the contract.
                  Path.of("../target/wasm32-unknown-unknown/release/voting_runner") // The relative path to the instrumented executable.
          );
    ````

### BlockchainAddress Fields - Values transferred

The four fields with type BlockchainAddress, `voter1`, `voter2`, `voter3` and `voting`,
these will be populated in the test, where a public account is created for each voter,
and when deploying the voting contract, the call returns the address the contract
was deployed at.

These fields will be transferred to tests depending on the test, if the field is populated at the end of test execution.
This means we only have to instantiate the field once. To create an account, we call the `blockchain.newAccount(1)`,
where `1` is the secret key for the Address created.

The address for the contract, is created when it is deployed. To deploy a contract, the address sending the transaction
is needed,
the bytecode to deploy and the arguments for the initialize call, creating the initial state of the contract.

???+ info "Addresses - By deployment or creation"

    ````java
    voter1 = blockchain.newAccount(2); // Create an account with secret key '2' and return the related BlockchainAddress.
    voter2 = blockchain.newAccount(3); // Create an account with secret key '3' and return the related BlockchainAddress.
    voter3 = blockchain.newAccount(4); // Create an account with secret key '4' and return the related BlockchainAddress.
    
    byte[] initRpc = 
        Voting.initialize(10, List.of(voter1, voter2, voter3), 60 * 60 * 1000); // The rpc for the init function when creating a contract. 
    
    voting = 
        blockchain.deployContract(voter1, VOTING_CONTRACT_BYTES, initRpc); // Deployment of a contract, returns the address the contract is deployed at.
    ````

#### Using ABI codegen for RPC

In the deployment call, the RPC is serialized using code generated with the ABI for the contract. This can either be
generated
with [ABI client](https://partisiablockchain.gitlab.io/documentation/smart-contracts/smart-conract-tools-overview.html#the-abi-codegen-tool-abi-codegen),
or using
the [Maven plugin](https://gitlab.com/partisiablockchain/language/abi/abi-client/-/tree/main/maven-plugin?ref_type=heads).

The generated code provides methods for serializing the RPC for all actions in the contract. It also provides a
state deserialization method, which deserializes a state given in bytes, to a record object, which can be used to assert
on state in a test. An example of the state serialization is in the second test.

???+ State deserialization

    ````java
    Voting.VoteState state = // The state variable created from the deserialization. 
        Voting.VoteState.deserialize(blockchain.getContractState(voting)); // The call to the generated deserialize state method

    Assertions.assertThat(state.votes().size()).isEqualTo(1); // Assertion on the amount of votes currently.
    Assertions.assertThat(state.votes().get(voter1)).isTrue(); // Assertion on who voted.
    ````
### Continue from another test
Smart contracts are great since the order of operations are clear, from the perspective of behavioural execution. This also means
that everytime we would have to test 2 different actions, meaning two different behaviours, on the same state.
Tests would have to perform all the actions up to that point, to then perform one of the actions, 
and then perform them all again for the other action. 

Here the testing framework helps, the methods with the annotation `@ContractTest`, 
can be used as setup for other tests. 

???+ @ContractTest and previous

      ````java
     @ContractTest // The annotation with no previous, means the test is independent of other test, also called 'root-test'. 
     void setUp() {
       // Omitted
     }
   
     /** An eligible voter can cast a vote. */
     @ContractTest(previous = "setUp") // The previous for the test, is the 'setUp', so for the test to succeed the 'setUp' test must be run before this test.
     public void castVote() {
       // Omitted
     }
      ````

### Sending an Action to a deployed contract.
Interaction with the contract, is made by sending an action to a deployed contract. The action needs three parameters,
the address for the contract the action is targeting, the address of the sender and the RPC, which specifies the arguments
for the action call. 

???+ Send action.

      ````java
     @ContractTest(previous = "setUp")
     public void castVote() {
     byte[] votingRpc = Voting.vote(true); // Create the RPC with the generated code.
     blockchain.sendAction(voter1, voting, votingRpc); // Send the action, with the sender, the target contract and the RPC.
     Voting.VoteState state = Voting.VoteState.deserialize(blockchain.getContractState(voting)); // Get the state of the contract and deserialize.

     Assertions.assertThat(state.votes().size()).isEqualTo(1); // Assert the vote is registered.
     Assertions.assertThat(state.votes().get(voter1)).isTrue(); // Assert the registered vote is from 'voter1'.
}
      ````
### Second test using the first test as a setup

We can now perform our first interaction with the deployed contract. So we add another test to our test class.
Another account must be created, so we add another field, `receiver`, and create the account.

Notice in the annotation `@ContractTest`, we have provided an argument that points to our previous method,
where we deployed our contract. In our example, that is `setup`.

In this test, we send an action to our contract, the functionality we are testing is just a normal transfer from `owner`
to `receiver`. We call the `.sendAction()`, where we provided the address of the contract, we want to send the action
to.
The sender of
the [action](https://partisiablockchain.gitlab.io/documentation/smart-contracts/programmers-guide-to-smart-contracts.html#action),
and
the [rpc](https://partisiablockchain.gitlab.io/documentation/smart-contracts/programmers-guide-to-smart-contracts.html#events)
for the call. The rpc in this case contains the receiver of the transfer, and
the amount to send.

After reading the article, you should now be able to:

1. Deploy a contract in a test, by specifying the bytes to use for the contract, and rpc for the init call.
2. Use that test as a setup for another test, by pointing to the method name with the previous parameter,
   `@ContractTest(previous = "NAME-OF-SETUP-TEST")`.
3. Interact with a contract by sending an action.

If you want to more examples of testing smart contracts, go to
[example contracts](https://gitlab.com/partisiablockchain/language/example-contracts), where there are multiple tests.


