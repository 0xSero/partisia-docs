# How to run a reader node


## Why you need a reader node

Readers are useful for getting information from the blockchain. Be it from the state of accounts and contracts or information about specific blocks. If you are developing a dApp or a front-end you will probably need to run your own reader node. If many parties query the same reader, it might be slowed down or become unstable. For this reason you will want to have your own reader for development.

???+ note

    The "public" [reader](https://reader.partisiablockchain.com/) has a built-in traffic limit that prevents any single application from using it to much. If you encounter this limit the solution is for you to run your own reader node. 

## Step by step

To get your reader node you are first completing 4 of the 10 steps from the block producer node guide, then setting up automatic updates and a reverse proxy. Use the links below, so you do not end up following unnecessary steps.

1. [Recommended hardware and software](recommended-hardware-and-software.md)
2. [Get a VPS](vps.md)
3. [Secure your VPS](secure-your-vps.md)
4. [Set up a reader on VPS](reader-node-on-vps.md) 
5. [Automatically update the node software](https://partisiablockchain.gitlab.io/documentation/node-operations/node-health-and-maintenance.html#get-automatic-updates)
6. [Set up reverse proxy using example in ZK node guide](https://drive.google.com/file/d/1WOzM63QsBntSVQMpWhG7oDuEWYJE2Ass/view)

