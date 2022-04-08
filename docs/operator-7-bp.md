# Run a block producing node on Partisia Blockchain


You must finish the previous two sections([Reader node on VPS](operator-5-reader-vps.md) and [Keys for BP](operator-6-keys.md)) is a prerequisite.

### Step 1 - Stop your reader node

Find the reader node container name:

```` bash
docker ps
````

Stop the reader node:

```` bash
docker stop yourContainerNamer
````

### Step 2 - Change `config.json` to support block production

To fill out the config.json for a block producing node you need to add the following information:

- Network privateKey   
- Account privateKey   
- Finalization privateKey   
- IP address of the server hosting your node (You get this from your VPS service provider)   
- URL address of an Ethereum reader node on the Ropsten network (You should use a source you find trustworthy)   

Start by opening the `config.json` in `nano`:


````bash
sudo nano /opt/pbc-betanet/conf/config.json
````

Config for the block producing nodes - baker nodes, ZK nodes and oracle nodes Put your private [keys](operator-6-keys.md) and IP inside the quotation marks replacing descriptions in capital letters. The IP address must be a public IPv4.:
````json
{
  "restPort": 8080,
  "floodingPort": 9888,
  "networkKey": "NETWORK_PRIVATE_KEY",
  "producerConfig": {
    "host": "PUBLIC_IP_OF_SERVER_HOSTING_THIS_NODE",
    "accountKey": "PRIVATE_KEY_FROM_ACCOUNT_HOLDING STAKE",
    "finalizationKey": "FINALIZATION_PRIVATE_KEY_BLS",
    "ethereumUrl": "ETHEREUM_ROPSTEN_HTTP_ENDPOINT"
  },
  "knownPeers": [
    "188.180.83.49:9090",
    "188.180.83.49:9190",
    "188.180.83.49:9290",
    "188.180.83.49:9390",
    "174.138.2.217:9888",
    "172.93.110.125:9888",
    "107.189.1.171:9888",
    "176.78.42.5:9888"
  ]
}
````

To save the file press `CTRL+O` and then `ENTER` and then `CTRL+X`.

You can verify the contents of the files are what you expect by opening them with `cat`:

````bash
sudo cat /opt/pbc-betanet/conf/config.json
# The config file should be printed here
````

## Start your block producing node

````bash
docker-compose up -d
````

This should pull the latest image and start the reader node in the background. If the command was executed successfully it won't print anything. To verify that the node is running, run:

````bash
docker logs -f pbc-betanet-reader
````

This should print a bunch of log statements. All the timestamps are in [UTC](https://en.wikipedia.org/wiki/Coordinated_Universal_Time) and can therefore be offset several hours from your local time.



## Logs and storage

The logs of the node are written to the standard output of the container and are therefore managed using the tools provided by Docker. You can read about configuring Docker logs [here](https://docs.docker.com/config/containers/logging/configure/).

The storage of the node is based on RocksDB. It is write-heavy and will increase in size for the foreseeable future. The number and size of reads and writes is entirely dependent on the traffic on the network.

## Updating

Updating the PBC node is a simple 3-step process:

````bash
cd ~/pbc
````
````bash
docker-compose pull
````
````bash
docker-compose up -d
````

First you change the directory to where you put your `docker-compose.yml` file. You then stop the currently running container, pull the newest image and start it again. You should now be running the newest version of the software.
