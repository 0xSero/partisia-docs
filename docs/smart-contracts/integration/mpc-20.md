# MPC-20 Token Contract

A token is a standardized digital asset on the Partisia blockchain, the token standard is inspired from the guidelines outlined in the [Ethereum Improvement Proposal (EIP) 20](https://eips.ethereum.org/EIPS/eip-20). The token standard provides basic functionality to transfer tokens as well as approve the transfer of the token. 

A contract is detected as a valid Token Contract if:
The following actions exists where names and types match exactly:
```
#[action(shortname=0x01)] transfer(to: Address, amount: u128)
#[action(shortname=0x03)] transfer_from(from: Address, to: Address, amount: u128)
#[action(shortname=0x05)] approve(spender: Address, amount: u128)
```

The root state struct has the following state fields in the root state struct or a sub-struct that has a 1-1 composition with the root state struct where names and types match exactly:
```
balances: Map<Address, u128>
name: String
symbol: String
decimals: u8
```

You can dive into our [token example contract](https://gitlab.com/partisiablockchain/language/example-contracts/-/tree/main/token) to explore this standard.

#### References:
[https://ethereum.org/en/developers/docs/standards/tokens/erc-20/](https://ethereum.org/en/developers/docs/standards/tokens/erc-20/)

[https://gitlab.com/partisiablockchain/language/example-contracts/-/tree/main/token](https://gitlab.com/partisiablockchain/language/example-contracts/-/tree/main/token)
