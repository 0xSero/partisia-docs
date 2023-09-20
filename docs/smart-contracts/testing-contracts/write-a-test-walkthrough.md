# Walkthrough: Write a Smart Contract Test

Create a new test for the [Token contract](https://gitlab.com/partisiablockchain/language/example-contracts/-/tree/main/token?ref_type=heads). Create a new java file next to the other tests in the example-contracts folder,
the name could be `MyTokenTest.java`. In that file we can now define our test class:
```java
public final class MyTokenTest extends JunitContractTest {
    // ...
}
```

To write your first test, you should start by deploying the token contract.
The deployed contract is needed to make sure we have a contract to interact with in our tests, 
you can also use your contract when writing your first test. Lets call this test 'setup', 
this first setup test will be the starting point for our future tests.
