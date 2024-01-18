# Run a ZK node

This page explains how to change the configuration of your baker node to ZK node's and how to register your node for the
service. ZK nodes do [ZK computations](../pbc-fundamentals/dictionary.md#mpc) in addition to their baker node work of
signing and producing blocks. By completing the steps below your node will be eligible to be allocated for specific
computations by [ZK smart contracts](../smart-contracts/zk-smart-contracts/zk-smart-contracts.md) and earning revenue
for the zero knowledge computations performed.

## Requirements of a ZK node

!!! Warning " You must complete these requirements before you can go to registration"   

    For a reader node only set up reverse proxy - step 3

    1. [Stake 100 K MPC tokens](https://browser.partisiablockchain.com/node-operation) including the 25 K for baker service    
    2. [Run baker node](run-a-baker-node.md)
    3. You have set up a reverse proxy. This includes:
        - Web domain with a valid SSL/TSL certificate for an https endpoint
        - A modified `docker-compose.yml` defining a docker service acting as proxy  
    4. Verify that your ZK node domain maps to the ipv4 address of your host VPS, use <https://www.nslookup.io/> or similar


## Set up a reverse proxy

ZK nodes and reader nodes for development need a reverse proxy server.  ZK nodes need it to be able to give and receive secret inputs. Reader nodes need to set rate limits to prevent DDOS (denial-of-service-attacks).

Your node is running a docker image with the pbc-mainnet software. The source of the image and name of the container is defined in the "service:"-field of  `docker-compose.yml`. In this example we will set up a reverse proxy by modifying the `docker-compose.yml`. You add additional services to act as a proxy server for incoming and outgoing traffic.

### Get Domain

### Get SSL certificate

We show you how to get an SSL certificate.

### Modify `docker-compose.yml`

The modified docker compose handles to new services in addition to managing the pbc-mainet container: 1) an nginx proxy server, and an automated certificate manager (acme).

### Set autoupdate script to target the new services at an alternate scheduel



## Register your ZK node 

Complete the following steps:

1. [Associate](https://browser.partisiablockchain.com/contracts/01a2020bb33ef9e0323c7a3210d5cb7fd492aa0d65/associateTokens) 75 K MPC tokens to the ZK Node Registry contract
2. [Register](https://browser.partisiablockchain.com/contracts/01a2020bb33ef9e0323c7a3210d5cb7fd492aa0d65/registerAsZkNode) as a ZK node (You need to have your https rest endpoint ready)
3. Restart your node

If you have additional tokens you can read how to run a deposit or withdrawal oracle on the following page.    
