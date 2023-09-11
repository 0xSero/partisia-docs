# Run a block producing node
<div class="dot-navigation" markdown>
   [](what-is-a-node-operator.md)
   [](recommended-hardware-and-software.md)
   [](run-a-reader-node-on-your-local-machine.md)
   [](vps.md)
   [](secure-your-vps.md)
   [](reader-node-on-vps.md)
   [](create-an-account-on-pbc.md)
   [](get-mpc-tokens.md)
   [](complete-synaps-kyb.md)
   [](keys-for-bp-config-and-registration.md)
   [*.*](run-a-block-producing-node.md)
   [](register-your-node.md)
   [](node-health-and-maintenance.md)
</div>

How to change node config from reader to block producer

You must finish the previous two sections([Reader node on VPS](../node-operations/reader-node-on-vps.md) and [Keys for BP](../node-operations/keys-for-bp-config-and-registration.md)) is a prerequisite.

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
- Ethereum and Polygon API endpoint. This is a URL address pointing to an Ethereum reader node on the Ethereum Mainnet (You should use a source you find trustworthy). [This user made guide](https://docs.google.com/spreadsheets/d/1Eql-c0tGo5hDqUcFNPDx9v-6-rCYHzZGbITz2QKCljs/edit#gid=0) has a provider list and further information about endpoints.
- Ip and network public key of at least one other producer on the format 'networkPublicKey:ip:port', e.g. '02fe8d1eb1bcb3432b1db5833ff5f2226d9cb5e65cee430558c18ed3a3c86ce1af:172.2.3.4:9999'. The location of other known producers should be obtained by reaching out to the community.

Go to your VPS and open `config.json` in `nano`:


````bash
sudo nano /opt/pbc-mainnet/conf/config.json
````

Config for the block producing nodes - baker nodes, ZK nodes and oracle nodes Put your private [keys](../node-operations/keys-for-bp-config-and-registration.md) and IP inside the quotation marks replacing descriptions in capital letters. The IP address must be a public IPv4.:
````json
{
  "restPort": 8080,
  "floodingPort": 9888,
  "networkKey": "NETWORK_PRIVATE_KEY",
  "producerConfig": {
    "host": "PUBLIC_IPV4_OF_SERVER_HOSTING_THIS_NODE",
    "accountKey": "PRIVATE_KEY_FROM_ACCOUNT_HOLDING STAKE",
    "finalizationKey": "FINALIZATION_PRIVATE_KEY_BLS",
    "ethereumUrl": "ETHEREUM_MAINNET_HTTP_ENDPOINT",
    "polygonUrl": "POLYGON_MAINNET_HTTP_ENDPOINT",
    "bnbSmartChainUrl": "BNB_SMART_CHAIN_MAINNET_ENDPOINT"
  },
  "knownPeers": [
    "PUBLIC_KEY_IP_PORT_OF_OTHER_PRODUCER(S)"
  ]
}
````

To save the file press `CTRL+O` and then `ENTER` and then `CTRL+X`.

You can verify the contents of the files are what you expect by opening them with `cat`:

````bash
sudo cat /opt/pbc-mainnet/conf/config.json
# The config file should be printed here
````

## Start your block producing node

````bash
docker-compose up -d
````

This should pull the latest image and start the reader node in the background. If the command was executed successfully it won't print anything. To verify that the node is running, run:

````bash
docker logs -f pbc-mainnet
````

This should print a bunch of log statements. All the timestamps are in [UTC](https://en.wikipedia.org/wiki/Coordinated_Universal_Time) and can therefore be offset several hours from your local time.

In the [maintenance section](../node-operations/node-health-and-maintenance.md) you can see what the logs mean.
