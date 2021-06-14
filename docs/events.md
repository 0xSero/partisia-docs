# Event transactions

An event transaction is a special type of transcation that is spawned during the execution of another transaction. Events are used to communicate across different contracts and/or shards.

Events have the same basic properties as ordinary transactions except for the maximum cost. Events are sent through the flooding network and have the same validity rules as ordinary transactions. When a transaction is executed the network and CPU fees are collected, the rest of the cost is distributed evenly between any events that said transaction spawns. Events are executed the same way as ordinary transactions meaning they can *also* spawn events. This means one can implement asynchronous, indefinite recursion which will eventually terminate since the events will run out of gas to pay the fees.
