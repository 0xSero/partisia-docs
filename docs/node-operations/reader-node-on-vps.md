# Reader node on VPS

<div class="dot-navigation" markdown>
   [](create-an-account-on-pbc.md)
   [](get-mpc-tokens.md)
   [](recommended-hardware-and-software.md)
   [](vps.md)
   [](secure-your-vps.md)
   [*.*](reader-node-on-vps.md)
   [](complete-synaps-kyb.md)
   [](run-a-block-producing-node.md)
   [](register-your-node.md)
   [](node-health-and-maintenance.md)
</div>

When setting up the node you should use the non-root user you created in the previous [step](../node-operations/secure-your-vps.md). 
You need to install the [recommended software](../node-operations/recommended-hardware-and-software.md#recommended-software) before you start.
The node will run as user:group `1500:1500`


### Creating the configuration and storage folders

In this guide we will be running the node from the folder `/opt/pbc-mainnet` with user:group `1500:1500`. First we need
to create the `conf` and `storage` folders for the application:

````bash
sudo mkdir -p /opt/pbc-mainnet/conf
````

````bash
sudo mkdir -p /opt/pbc-mainnet/storage
````

### Setting file permissions

Now we need to make sure the user with uid `1500` has the needed access to the files:

````bash
sudo chown -R "1500:1500" /opt/pbc-mainnet
````

````bash
sudo chmod 500 /opt/pbc-mainnet/conf
````

````bash
sudo chmod 700 /opt/pbc-mainnet/storage
````

````bash
sudo chmod 400 /opt/pbc-mainnet/conf/config.json
````

The above commands set conservative permissions on the folders the node is using. `chmod 500` makes the config folder
readable by the PBC node and root. `chmod 700` makes the storage folder readable and writable for the PBC node and root.


### Pull docker image

The guide assumes the node is run using `docker-compose`.

Start by creating a directory `pbc` and add a file named `docker-compose.yml`.

````bash
mkdir -p pbc
````

````bash
cd pbc
````

````bash
nano docker-compose.yml
````

The contents of the file should be the following:

````yaml
version: "2.0"
services:
  pbc:
    image: registry.gitlab.com/partisiablockchain/mainnet:latest
    container_name: pbc-mainnet
    user: "1500:1500"
    restart: always
    expose:
    - "8080"
    ports:
    - "9888-9897:9888-9897"
    command: [ "/conf/config.json", "/storage/" ]
    volumes:
    - /opt/pbc-mainnet/conf:/conf
    - /opt/pbc-mainnet/storage:/storage
    environment:
    - JAVA_TOOL_OPTIONS="-Xmx8G"
````

Save the file by pressing `CTRL+O` and then `ENTER` and then `CTRL+X`.
Keep an eye on the indentation since YAML is whitespace sensitive, and it won't work if the indentation is off.

### The `node-register.sh` script

The `node-register.sh` script will help you generate a valid node configuration file.
The newest version is located on [GitLab](https://gitlab.com/partisiablockchain/main/-/raw/main/scripts/node-register.sh).

```shell
curl https://gitlab.com/partisiablockchain/main/-/raw/main/scripts/node-register.sh --output node-register.sh
```

Once it is downloaded you need to make it executable:

```shell
chmod +x node-register.sh
```

You are now ready to generate your `config.json` file.

### Generating your `config.json` file

The `node-register.sh` script makes it easy to generate a reader node config.
The tool ensures your `config.json` is well-formed and that it is stored in the correct folder on the machine.

Start the tool with the `create-config` argument:

```shell
./node-register.sh create-config
```

As we are creating a reader node we will not be producing blocks.
Your first response needs to be a `no` when creating the config, otherwise the node will attempt to (unsuccessfully) produce blocks.

### Starting the node

You can now start the node:

````bash
docker-compose up -d
````

If the command is successful it will pull the latest image and start the reader node in the background. 
To verify that the node is running, run:

````bash
docker logs -f pbc-mainnet
````

This will print your log statements. All the timestamps are
in [UTC](https://en.wikipedia.org/wiki/Coordinated_Universal_Time) and can therefore be offset several hours from your
local time.

## Logs and storage

The logs of the node are written to the standard output of the container and are therefore managed using the tools
provided by Docker. You can read about configuring Docker
logs [here](https://docs.docker.com/config/containers/logging/configure/).

The storage of the node is based on RocksDB. It is write-heavy and will increase in size for the foreseeable future. The
number and size of reads and writes is entirely dependent on the traffic on the network.
