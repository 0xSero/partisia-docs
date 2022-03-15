# Run a node on Partisia Blockchain


>**Topics covered:**  
>
- Hardware and software for running your node.   
> - Terminal commands you run for starting and updating the node. And the commands for creating the necessary directories, folders and files and setting their permissions.   
>
>**Skills you need:**     
> - You can use a text editor and change file permissions from a Linux terminal.   
>
>**Scope:**   
> - When you finish this guide you know the necessary node hardware and software. You know how to start and update a node. If you want to know the formal conditions for paticipation in the network you should read [how to become a node operator](bpinclusion.md).   


## Recommended machine specs


- 8 vCPU or 8 cores
- 10 GB RAM (8 GB allocated JVM, 4 GB is absolute minimum)
- 40 GB SSD
- Publicly accessible IP with ports `9888` to `9897` open

## Necessary software

- [Docker](https://docs.docker.com/engine/install/) (Note that the version in your repository may be too old)
- Linux (In this tutorial Ubuntu 20.04.3 was used)
- A text editor (In this tutorial nano 4.3 was used)

## Start your node

This [video](https://asciinema.org/a/UnZCs1xHiIwmg1lPx6WZe6SA3) show the steps below. If you want an overview before you run the commands.

### Step 1 - Creating the folders

In this guide we will be running the nodes from the folder `/opt/pbc-betanet` with user:group `1500:1500`. First we need to create the `conf` and `storage` folders for the application:

```` bash
sudo mkdir -p /opt/pbc-betanet/conf
````
```` bash
sudo mkdir -p /opt/pbc-betanet/storage
````

### Step 2 - Creating `genesis.json` and the node `config.json`

The genesis file specifies the root account of the blockchain and which chain the node is running on. These are combined into the *genesis block* and define the initial state when the blockchain is booted. All nodes on the blockchain share the same `genesis.json`.

Start by opening the file in `nano`:

````bash
sudo nano /opt/pbc-betanet/conf/genesis.json
````

Now paste the following contents:

````json
{
 "chainId": "PARTISIA beta net with accounts",
 "rootAccount": "00047a53311c64239ecdc70ff5bbfd769175b64df0"
}
````

To save the file press `CTRL+O` and then `ENTER` and then `CTRL+X`.

Now do the same for `config.json`:

````bash
sudo nano /opt/pbc-betanet/conf/config.json
````

For a Reader Node paste the following:

````json
{
  "restPort": 8080,
  "floodingPort": 9888,
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

Config for the block producing nodes - baker nodes, ZK nodes and oracle nodes:
````json
{
  "restPort": 8080,
  "floodingPort": 9888,
  "networkKey": "PRIVATE_KEY_FOR_PRODUCTION_IN_HEX",
  "producerConfig": {
    "host": "PUBLIC_IP_OF_THIS_HOST",
    "accountKey": "PRIVATE_KEY_FROM_ACCOUNT_HOLDING STAKE",
    "finalizationKey": "PRIVATE_KEY_FOR_BLS",
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
sudo cat /opt/pbc-betanet/conf/genesis.json
# The genesis file should be printed here

sudo cat /opt/pbc-betanet/conf/config.json
# The config file should be printed here
````

### Step 3 - Setting file permissions

Now we need to make sure the user with uid `1500` has the needed access to the files:

```` bash
sudo chown -R "1500:1500" /opt/pbc-betanet
sudo chmod 500 /opt/pbc-betanet/conf    
sudo chmod 700 /opt/pbc-betanet/storage
sudo chmod 400 /opt/pbc-betanet/conf/genesis.json
sudo chmod 400 /opt/pbc-betanet/conf/config.json
````

The above commands set conservative permissions on the folders the node is using. `chmod 500` makes the config folder readable by the PBC node and root. `chmod 700` makes the storage folder readable and writable for the PBC node and root.

### Step 4 - Pull docker image

You can run the node using the `docker` terminal command or using the slightly more readable `docker-compose`. The latter is not installed by default.

Start by creating a directory `pbc` and add a file named `docker-compose.yml`.

````bash
mkdir -p pbc
cd pbc
nano docker-compose.yml
````

The contents of the file should be the following:

````yaml
version: "2.0"
services:
  pbc-betanet-reader:
    image: registry.gitlab.com/privacyblockchain/demo/betanet-public:latest
    container_name: pbc-betanet-reader
    user: "1500:1500"
    restart: always
    expose:
    - "8080"
    ports:
    - "9888-9897:9888-9897"
    command: [ "/conf/config.json", "/conf/genesis.json", "/storage/" ]
    volumes:
    - /opt/pbc-betanet/conf:/conf
    - /opt/pbc-betanet/storage:/storage
    environment:
    - JAVA_TOOL_OPTIONS="-Xmx8G"
````
Save the file by pressing `CTRL+O` and then `ENTER` and then `CTRL+X`.
Keep an eye on the indentation since YAML is whitespace sensitive, and it won't work if the indentation is off.

You don't yet have access to the Partisia container repository, so you first need to log in.

````bash
sudo docker login -u <GitLab e-mail address> registry.gitlab.com
````

**Note:** If you have two-factor login enabled in GitLab you need to create a [personal access token](https://gitlab.com/-/profile/personal_access_tokens).

You can now start the node:

````bash
sudo docker-compose up -d
````

This should pull the latest image and start the reader node in the background. If the command was executed successfully it won't print anything. To verify that the node is running, run:

````bash
sudo docker logs -f pbc-betanet-reader
````

This should print a bunch of log statements. All the timestamps are in [UTC](https://en.wikipedia.org/wiki/Coordinated_Universal_Time) and can therefore be offset several hours from your local time.



## Logs and storage

The logs of the node are written to the standard output of the container and are therefore managed using the tools provided by Docker. You can read about configuring Docker logs [here](https://docs.docker.com/config/containers/logging/configure/).

The storage of the node is based on RocksDB. It is write-heavy and will increase in size for the foreseeable future. The number and size of reads and writes is entirely dependent on the traffic on the network.

## Updating

Updating the PBC node is a simple 3-step process:

```` bash
cd ~/pbc
sudo docker-compose pull
sudo docker-compose up -d
````

First you change the directory to where you put your `docker-compose.yml` file. You then stop the currently running container, pull the newest image and start it again. You should now be running the newest version of the software.
