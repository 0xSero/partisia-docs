# How to run a reader node


## Why you need a reader node

Readers are useful for getting information from the blockchain. Be it from the state of accounts and contracts or information about specific blocks. It is more than likely that you will need to utilize a reader for any dApp. If many parties query the same reader, it might be slowed down or become unstable. For this reason you will want to have your own reader for development.

## Step by step

To get your reader node you are first completing 4 of the 10 steps from the block producer node guide, then setting up automatic updates and a reverse proxy. Use the links below, so you do not end up following unnecessary steps.

1. [Recommended hardware and software](recommended-hardware-and-software.md)
2. [Get a VPS](vps.md)
3. [Secure your VPS](secure-your-vps.md)
4. [Set up a reader on VPS]((reader-node-on-vps.md)) **NB.** Stop before running `node-register.sh` and go to step 5
5. [Automatically update the node software]((reader-node-on-vps.md))
6. [Set up reverse proxy using example in ZK node guide](rhttps://drive.google.com/file/d/1WOzM63QsBntSVQMpWhG7oDuEWYJE2Ass/view) (You can choose a hostname different from ZK)
7. [Create reader config with node register tool](https://partisiablockchain.gitlab.io/documentation/node-operations/reader-node-on-vps.html#the-node-registersh-script)
