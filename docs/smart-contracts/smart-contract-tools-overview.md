# Smart Contract Tools overview

This article introduces tools designed to help developers working with smart contracts on the blockchain. These tools
offer a range of capabilities, from testing smart contracts to facilitating command-line interactions with the
blockchain, and even integrating the blockchain with your own applications.

## Partisia Blockchain browser

Partisia blockchain browser is a web-based interface which translates the blockchains data into a user-friendly
application. Partisia blockchain browser is essentially a complete UI for Partisia Blockchain.

Partisia blockchain browser can be used to:

- Display details for the entire ledger: blocks and transactions.
- Display details for all accounts and smart contracts.
- Interact with any smart contract.
- Deploy your own new smart contracts.
- Manage your own account, including your MPC tokens and becoming a Node Operator.
- Create local references of contracts and accounts to help you keep track of already deployed contracts.

Partisia Blockchain browser can be used with the Testnet and the Mainnet:

- [Testnet](https://browser.testnet.partisiablockchain.com)
- [Mainnet](https://browser.partisiablockchain.com)

## Command-line tools

[`cargo pbc`](https://crates.io/crates/cargo-partisia-contract) is an umbrella for multiple sub-tools. The tools assist you in
interacting with the blockchain and working with smart contracts. These tools are thoroughly documented when using them
within `cargo pbc`, enabling you to explore their capabilities inside `cargo pbc`. Below are
a short description and use case for each of these sub-tools.

!!! warning "Pre requisite to use any cargo PBC commands"

    If you want to use any of the command-line tools or below commands you need to install [the smart contract compiler](install-the-smart-contract-compiler.md).

### The Compiler `build`

This is a primary part of developing smart contracts. The `build` command
compiles [rust smart contracts](compile-and-deploy-contracts.md)
and [ZK Rust smart contracts](zk-smart-contracts/compile-and-deploy-zk-contract.md). It compiles and returns `.abi` file
and a `.wasm` for
rust
contracts or `.zkwa` for ZK rust contracts.

### Blockchain interaction

To interact with the blockchain you can use the command line tool: `cargo pbc`.
There are 3 main commands:

- `transaction`
- `account`
- `contract`

It can help you specifically with:

- Sending transactions to smart contracts
- Deploying your own smart contracts
- Showing smart contracts state

To start using the CLI you can try minting some test_coin with the following command:

```
cargo pbc transaction action 02c14c29b2697f3c983ada0ee7fac83f8a937e2ecd feed_me [PublicAddressYouWantMintToGoTo] --gas 60000 --privatekey=PathToPrivatekeyFile
```

If you want to try an action yourself you can type: `cargo pbc transaction action` and the help messages
will help you from there.

Want to explore more possibilities within the CLI? You can go visit
the [cli-execution-reference-tests to see example usage
of the CLI tool](https://gitlab.com/partisiablockchain/language/partisia-cli/-/tree/main/src/test/resources/cli-execution-reference-tests?ref_type=heads)
You can look in the commandline.sh that is placed within each test folder to understand the multitude of applications
this tool can have.

### The ABI tool `abi`

This tool is focused on helping you understand the [ABI](../pbc-fundamentals/dictionary.md#abi) actions and state of a
contract. By using the command `cargo pbc abi show`, you can
access information about a compiled contract's state, initialization, actions, and variables. It simplifies the process
of identifying shortnames for existing contracts using optional arguments. This tool is using
the [abi-client](#abi-client).

Example
command:

```
cargo pbc abi show example-contracts/target/wasm32-unknown-unknown/release/auction_contract.abi
```

??? example "Response from example command"

    ```
    pub struct Bid {
    bidder: Address,
    amount: u128,
    }
    pub struct SecretVarId {
    raw_id: u32,
    }
    pub struct TokenClaim {
    tokens_for_bidding: u128,
    tokens_for_sale: u128,
    }
    #[state]
    pub struct AuctionContractState {
    contract_owner: Address,
    start_time_millis: i64,
    end_time_millis: i64,
    token_amount_for_sale: u128,
    token_for_sale: Address,
    token_for_bidding: Address,
    highest_bidder: Bid,
    reserve_price: u128,
    min_increment: u128,
    claim_map: Map<Address, TokenClaim>,
    status: u8,
    }
    #[init]
    pub fn initialize (
    token_amount_for_sale: u128,
    token_for_sale: Address,
    token_for_bidding: Address,
    reserve_price: u128,
    min_increment: u128,
    auction_duration_hours: u32,
    )
    #[action(shortname = 0x01)]
    pub fn start ()
    #[action(shortname = 0x03)]
    pub fn bid (
    bid_amount: u128,
    )
    #[action(shortname = 0x05)]
    pub fn claim ()
    #[action(shortname = 0x06)]
    pub fn execute ()
    #[action(shortname = 0x07)]
    pub fn cancel ()
    #[callback(shortname = 0x02)]
    pub fn start_callback ()
    #[callback(shortname = 0x04)]
    pub fn bid_callback (
    bid: Bid,
    )
    ```

### The ABI codegen tool `abi codegen`

Codegen produces autogenerated code in both Java & TypeScript to streamline interactions with contract actions and
deserializing contracts states. The
autogenerated code provides methods to
interact with actions based on a smart contracts [abi](../pbc-fundamentals/dictionary.md#abi). If you are working with
Java, we recommend you
follow [the readme here](https://gitlab.com/partisiablockchain/language/abi/abi-client/-/tree/main/maven-plugin?ref_type=heads)
to automate your usage of abi codegen.

Abi codegen can also be used manually. Here is an example of how:

```
cargo pbc abi codegen --ts mySmartContract/target/wasm32-unknown-unknown/release/auction_contract.abi mySmartContract/AutogeneratedCode/auction_contract.ts
```

??? example "Response from example command"

    ```TypeScript
    /* eslint-disable @typescript-eslint/no-unused-vars */
    /* eslint-disable @typescript-eslint/no-non-null-assertion */
    import BN from "bn.js";
    import {
    AbiParser,
    AbstractBuilder, BigEndianReader,
    FileAbi, FnKinds, FnRpcBuilder, RpcReader,
    ScValue,
    ScValueEnum, ScValueOption,
    ScValueStruct,
    StateReader, TypeIndex,
    BlockchainAddress,
    Hash,
    BlockchainPublicKey,
    Signature,
    BlsPublicKey,
    BlsSignature
    } from "@privacyblockchain/ts-abi";
    import {BigEndianByteOutput} from "@secata-public/bitmanipulation-ts";

    const fileAbi: FileAbi = new AbiParser(Buffer.from(
    "50424341424909040005020000000004010000000342696400000002000000066269646465720d00000006616d6f756e7405010000000a546f6b656e436c61696d0000000200000012746f6b656e735f666f725f62696464696e67050000000f746f6b656e735f666f725f73616c6505010000001441756374696f6e436f6e747261637453746174650000000b0000000e636f6e74726163745f6f776e65720d0000001173746172745f74696d655f6d696c6c6973090000000f656e645f74696d655f6d696c6c69730900000015746f6b656e5f616d6f756e745f666f725f73616c65050000000e746f6b656e5f666f725f73616c650d00000011746f6b656e5f666f725f62696464696e670d0000000e686967686573745f62696464657200000000000d726573657276655f7072696365050000000d6d696e5f696e6372656d656e740500000009636c61696d5f6d61700f0d00010000000673746174757301010000000b536563726574566172496400000001000000067261775f69640300000008010000000a696e697469616c697a65ffffffff0f0000000600000015746f6b656e5f616d6f756e745f666f725f73616c65050000000e746f6b656e5f666f725f73616c650d00000011746f6b656e5f666f725f62696464696e670d0000000d726573657276655f7072696365050000000d6d696e5f696e6372656d656e74050000001661756374696f6e5f6475726174696f6e5f686f75727303020000000573746172740100000000030000000e73746172745f63616c6c6261636b0200000000020000000362696403000000010000000a6269645f616d6f756e7405030000000c6269645f63616c6c6261636b04000000010000000362696400000200000005636c61696d05000000000200000007657865637574650600000000020000000663616e63656c07000000000002",
    "hex"
    )).parseAbi();

    type Option<K> = K | undefined;

    export interface Bid {
    bidder: BlockchainAddress;
    amount: BN;
    }

    export function newBid(bidder: BlockchainAddress, amount: BN): Bid {
    return {bidder, amount}
    }

    function fromScValueBid(structValue: ScValueStruct): Bid {
    return {
    bidder: BlockchainAddress.fromBuffer(structValue.getFieldValue("bidder")!.addressValue().value),
    amount: structValue.getFieldValue("amount")!.asBN(),
    };
    }

    function buildRpcBid(value: Bid, builder: AbstractBuilder) {
    const structBuilder = builder.addStruct();
    structBuilder.addAddress(value.bidder.asBuffer());
    structBuilder.addU128(value.amount);
    }

    export interface TokenClaim {
    tokensForBidding: BN;
    tokensForSale: BN;
    }

    export function newTokenClaim(tokensForBidding: BN, tokensForSale: BN): TokenClaim {
    return {tokensForBidding, tokensForSale}
    }

    function fromScValueTokenClaim(structValue: ScValueStruct): TokenClaim {
    return {
    tokensForBidding: structValue.getFieldValue("tokens_for_bidding")!.asBN(),
    tokensForSale: structValue.getFieldValue("tokens_for_sale")!.asBN(),
    };
    }

    export interface AuctionContractState {
    contractOwner: BlockchainAddress;
    startTimeMillis: BN;
    endTimeMillis: BN;
    tokenAmountForSale: BN;
    tokenForSale: BlockchainAddress;
    tokenForBidding: BlockchainAddress;
    highestBidder: Bid;
    reservePrice: BN;
    minIncrement: BN;
    claimMap: Map<BlockchainAddress, TokenClaim>;
    status: number;
    }

    export function newAuctionContractState(contractOwner: BlockchainAddress, startTimeMillis: BN, endTimeMillis: BN, tokenAmountForSale: BN, tokenForSale: BlockchainAddress, tokenForBidding: BlockchainAddress, highestBidder: Bid, reservePrice: BN, minIncrement: BN, claimMap: Map<BlockchainAddress, TokenClaim>, status: number): AuctionContractState {
    return {contractOwner, startTimeMillis, endTimeMillis, tokenAmountForSale, tokenForSale, tokenForBidding, highestBidder, reservePrice, minIncrement, claimMap, status}
    }

    function fromScValueAuctionContractState(structValue: ScValueStruct): AuctionContractState {
    return {
    contractOwner: BlockchainAddress.fromBuffer(structValue.getFieldValue("contract_owner")!.addressValue().value),
    startTimeMillis: structValue.getFieldValue("start_time_millis")!.asBN(),
    endTimeMillis: structValue.getFieldValue("end_time_millis")!.asBN(),
    tokenAmountForSale: structValue.getFieldValue("token_amount_for_sale")!.asBN(),
    tokenForSale: BlockchainAddress.fromBuffer(structValue.getFieldValue("token_for_sale")!.addressValue().value),
    tokenForBidding: BlockchainAddress.fromBuffer(structValue.getFieldValue("token_for_bidding")!.addressValue().value),
    highestBidder: fromScValueBid(structValue.getFieldValue("highest_bidder")!.structValue()),
    reservePrice: structValue.getFieldValue("reserve_price")!.asBN(),
    minIncrement: structValue.getFieldValue("min_increment")!.asBN(),
    claimMap: new Map([...structValue.getFieldValue("claim_map")!.mapValue().map].map(([k1, v2]) => [BlockchainAddress.fromBuffer(k1.addressValue().value), fromScValueTokenClaim(v2.structValue())])),
    status: structValue.getFieldValue("status")!.asNumber(),
    };
    }

    export function deserializeAuctionContractState(bytes: Buffer): AuctionContractState {
    const scValue = new StateReader(bytes, fileAbi.contract).readState();
    return fromScValueAuctionContractState(scValue);
    }

    export interface SecretVarId {
    rawId: number;
    }

    export function newSecretVarId(rawId: number): SecretVarId {
    return {rawId}
    }

    function fromScValueSecretVarId(structValue: ScValueStruct): SecretVarId {
    return {
    rawId: structValue.getFieldValue("raw_id")!.asNumber(),
    };
    }

    export function initialize(tokenAmountForSale: BN, tokenForSale: BlockchainAddress, tokenForBidding: BlockchainAddress, reservePrice: BN, minIncrement: BN, auctionDurationHours: number): Buffer {
    const fnBuilder = new FnRpcBuilder("initialize", fileAbi.contract);
    fnBuilder.addU128(tokenAmountForSale);
    fnBuilder.addAddress(tokenForSale.asBuffer());
    fnBuilder.addAddress(tokenForBidding.asBuffer());
    fnBuilder.addU128(reservePrice);
    fnBuilder.addU128(minIncrement);
    fnBuilder.addU32(auctionDurationHours);
    return fnBuilder.getBytes();
    }

    export function start(): Buffer {
    const fnBuilder = new FnRpcBuilder("start", fileAbi.contract);
    return fnBuilder.getBytes();
    }

    export function bid(bidAmount: BN): Buffer {
    const fnBuilder = new FnRpcBuilder("bid", fileAbi.contract);
    fnBuilder.addU128(bidAmount);
    return fnBuilder.getBytes();
    }

    export function claim(): Buffer {
    const fnBuilder = new FnRpcBuilder("claim", fileAbi.contract);
    return fnBuilder.getBytes();
    }

    export function execute(): Buffer {
    const fnBuilder = new FnRpcBuilder("execute", fileAbi.contract);
    return fnBuilder.getBytes();
    }

    export function cancel(): Buffer {
    const fnBuilder = new FnRpcBuilder("cancel", fileAbi.contract);
    return fnBuilder.getBytes();
    }
    ```

## Libraries

Partisia Blockchain offers a set of different libraries to help you interact with smart
contracts and work with the states of smart contracts on the chain.

### client

Facilitates communication with a blockchain node. It helps you to interact with the blockchain
programmatically. It can get data about blocks, transactions, smart contracts, accounts etc. It has the functionality to
create and send transactions.

- [Client library](https://gitlab.com/partisiablockchain/core/client)

### abi-client

Our Smart Contract Binary Interface Client Library. It offers a standard binary interface for deploying contracts and
creating transactions, making it ideal for several use cases:

- Creating binary RPC, which calls an action with parameters on a smart contract.
- Decode binary contract states to readable types.
- Decode binary parts of transactions and events.

ABI-Client is available in the following programming languages:

- [Java](https://gitlab.com/partisiablockchain/language/abi/abi-client/-/tree/main?ref_type=heads)
- [TypeScript](https://gitlab.com/partisiablockchain/language/abi/abi-client-ts)

When using the abi-client using codegen can help you as a developer to create a plug-and-play interactions with the
blockchain. Abi-client can be used to read from contracts that is not necessarily
linked to a specific contract on the blockchain. The strength of [codegen](#the-abi-codegen-tool-abi-codegen) compared
to abi-client is to
handle specific contracts you want to work with. Whereas abi-client is more generalistic in its approach to contracts
not already know to the system.  
We have created an [example client](#example-client) to showcase how to work with the abi-client.

### zk-client

Sending secret input to ZK Rust smart contracts. The zk-client is a library that can help you interact with the
blockchain. Secondly the zk-client can fetch the secret data that you have ownership of from a
ZK contract deployed onto the chain. You can visit the tests inside the projects to see how
it works and start from there.

zk-client is available in the following programming languages:

- [Java](https://gitlab.com/partisiablockchain/language/abi/zk-client/)
- [TypeScript](https://gitlab.com/partisiablockchain/language/abi/zk-client-ts)

### Example client

This is a front end and a back end example of how to integrate you application with Partisia Blockchain, specifically it
uses the [client](#client) and the [abi-client](#abi-client) to send transactions and read states of the contracts.

Example client is available in the following programming languages:

- [Java](https://gitlab.com/partisiablockchain/language/example-client)
- [TypeScript](https://gitlab.com/partisiablockchain/language/example-web-client)
