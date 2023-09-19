# What is Gas?

<div class="dot-navigation" markdown>
   [*.*](what-is-gas.md)
   [](transaction-gas-prices.md)
   [](storage-gas-price.md)
   [](zk-computation-gas-fees.md)
   [](how-to-get-testnet-gas.md)
   [](efficient-gas-practices.md)
   [](contract-to-contract-gas-estimation.md)
</div>

Gas is a unit of computational effort on blockchain networks. It serves as a measure of the resources consumed during
contract execution. Each operation in a smart contract, such as reading or writing data, executing computations, or
interacting with other contracts, consumes a specific amount of gas. The gas cost for deploying or interacting with a
contract in Partisia blockchain is determined by considering three main factors: network, CPU
and [storage](storage-gas-price.md). You can read [the pricing for CPU and network here](transaction-gas-prices.md)
and [the pricing for storage here](storage-gas-price.md).

### Gas value and contract balance

Gas is bought through [BYOC](../../pbc-fundamentals/byoc.md), any brought coin represents an amount of gas where you
slowly siphon away the value of the brought coin when using the gas. The brought coins value slowly dimishes when you
convert the value to gas. The gas is used when a
user [sends a transaction](transaction-gas-prices.md#transaction-gas-prices) to a smart contract, the contract needs gas
to do its computation on the blockchain to pay the node operators for their work. Smart contracts themselves has a gas
balance and this needs to stay positive
for [the contract to keep alive](storage-gas-price.md#negative-contract-gas-balance). If you send more gas than the
transaction cost it
will go to the contract balance. When
creating [contract-to-contract transactions](contract-to-contract-gas-estimation.md#contract-to-contract-gas-estimation)
it is paid by the incoming transaction by default, but can be changed to use the contracts own balance.

If you want to learn more about being efficient with gas consumption you can
visit [our best practice article](efficient-gas-practices.md). Rules of thumb when working with gas optimization is to
reduce the effort of the
cpu and use less network traffic. The CPU usage is the most expensive consumer when
working with large data sets, whereas network traffic can cost a lot depending on the size of the contract. Ideally you
would want to optimize your cpu usage and minimize the size of your contracts as a developer.
