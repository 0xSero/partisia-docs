# Run a block producing node
<div class="dot-navigation" markdown>
   [](create-an-account-on-pbc.md)
   [](get-mpc-tokens.md)
   [](recommended-hardware-and-software.md)
   [](vps.md)
   [](secure-your-vps.md)
   [](reader-node-on-vps.md)
   [](complete-synaps-kyb.md)
   [*.*](run-a-block-producing-node.md)
   [](register-your-node.md)
   [](node-health-and-maintenance.md)
</div>

This page will describe how to change your node config from reader to block producer.

You must finish the previous section [Reader node on VPS](../node-operations/reader-node-on-vps.md) before you can continue.

### Step 1 - Stop your reader node

Change the directory to the folder where you have your `docker-compose.yml` file:

```shell
cd ~/pbc
```

Stop the node container:

```bash
docker-compose down
```

### Step 2 - Change `config.json` to support block production

To fill out the config.json for a block producing node you need to add the following information:

- Account key (the account you've staked MPC with)
- IP address of the server hosting your node (You get this from your VPS service provider)
- Ethereum and Polygon API endpoint. This is a URL address pointing to an Ethereum reader node on the Ethereum Mainnet (You should use a source you find trustworthy). [This user made guide](https://docs.google.com/spreadsheets/d/1Eql-c0tGo5hDqUcFNPDx9v-6-rCYHzZGbITz2QKCljs/edit#gid=0) has a provider list and further information about endpoints.
- The IP, port, and network public key of at least one other producer on the format `networkPublicKey:ip:port`. The location of other known producers should be obtained by reaching out to the community. You can see how to reach the community [here](https://partisiablockchain.gitlab.io/documentation/node-operations/what-is-a-node-operator.html#onboarding).

To fill out the needed information we will use the `node-register.sh` tool:

```bash
./node-register.sh create-config
```

When asked if the node is a block producing node, answer `yes`.
The tool validates your inputs, and you will not be able to finish the configuration generation without inputting *all*
the required information.

???+ note

    Be sure to back up the keys the tool prints at the end. They are written in `config.json` and  cannot be
    recovered if it is deleted.

You can verify the contents of the files are what you expect by opening them with `cat`:

```bash
sudo cat /opt/pbc-mainnet/conf/config.json
# The config file should be printed here
```

Your file should have similar contents to the one in the example below.

??? example "Example: Block producing config"

    ```
    {
        "restPort": 8080,
        "floodingPort": 9888,
        "knownPeers": [
            // your known peers
        ],
        "networkKey": "YOUR NETWORK KEY",
        "producerConfig": {
            "accountKey": "YOUR ACCOUNT KEY",
            "finalizationKey": "YOUR FINALIZATION KEY",
            "ethereumUrl": "https://example.com",
            "polygonUrl": "https://example.com",
            "bnbSmartChainUrl": "https://example.com",
            "host": "YOUR IP"
        }
    }
    ```

## Start your block producing node

```bash
docker-compose up -d
```

This should pull the latest image and start the reader node in the background. If the command was executed successfully it won't print anything. To verify that the node is running, run:

````bash
docker logs -f pbc-mainnet
````

This should print a bunch of log statements. All the timestamps are in [UTC](https://en.wikipedia.org/wiki/Coordinated_Universal_Time) and can therefore be offset several hours from your local time.

In the [maintenance section](../node-operations/node-health-and-maintenance.md) you can see what the logs mean.
