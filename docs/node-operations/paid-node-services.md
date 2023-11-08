# Paid node services



### Types of services


Node operators get paid for running 3 types of services:

- Baker services - signing transaction, block production and voting on updates
- ZK services - preprocessing data, calculations on secret shared data
- Oracle services - services related to BYOC, including transfer and price monitoring

ZK and oracle nodes are upgrades services. Higher paying services depend on first registering for baker services.

### Conditions for running a service


Node services are handled by specific [system contracts](insert link for governace overview when merged). To sign up for services a node operator associates a stake of token to the contract administrating the service 
([see amount to stake for specific services](what-is-a-node-operator.md#requirements-of-a-node-operator)). Stakes work as an incentive against malicious behaviour.

All nodes running a paid service must first register as block producers in the block producer orchestration contract. This makes the node eligible to perform baker services. While a service is being performed the tokens are locked to the contract. A node operator can resign from a service 

### Payment for services

When a user commits a transaction on the blockchain he pays a gas cost in [BYOC](../pbc-fundamentals/byoc.md). That gas covers the fee for the service performed by the nodes.