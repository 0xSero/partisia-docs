# Getting started with PBC

Starting and running a PBC node is fairly simple but requires some prerequisites:

1. You have at least seen a Linux terminal before
1. You know how to edit a file in the terminal
1. You understand basic file permissions
1. You have access to a server/VPS running Docker

## Linux terminal basics

If the sight of a command prompt makes you shiver, worry not, there are a lot  of great resources out there to ease your anxiousness (in no particular order):

- [Linux Journey](https://linuxjourney.com/)
- [Linux Survival](https://linuxsurvival.com/linux-tutorial-introduction/)
- [TechSpot: A Beginner's Guide to the Linux Command Line](https://www.techspot.com/guides/835-linux-command-line-basics/)

And if you prefer your text printed on trees of yore, there are plenty of affordable books:

- [The Linux Command Line, 2nd edition](https://www.amazon.com/Linux-Command-Line-2nd-Introduction/dp/1593279523/ref=sr_1_1?dchild=1&keywords=linux+terminal&qid=1623401267&sr=8-1)
- [The Linux Command Line Beginner's Guide](https://www.amazon.com/Linux-Command-Line-Beginners-Guide-ebook/dp/B007CD3SOI/ref=sr_1_9?dchild=1&keywords=linux+terminal&qid=1623401267&sr=8-9)
- [Linux Pocket Guide, 3rd edition](https://www.amazon.com/Linux-Pocket-Guide-Essential-Commands/dp/1491927577/ref=sr_1_11?dchild=1&keywords=linux+terminal&qid=1623401267&sr=8-11)

## A note on text editors

There are many different text editors available on the terminal. The most widely used are `vi` and `nano`. Both assume some prior experience but `nano` is generally considered more user-friendly than `vi`.

For the rest of the text we will assume you are using `nano`.

## Recommended machine specs

The recommended technical requirements are:

- Quad-core CPU
- 8 GB RAM
- 40 GB SSD
- Docker or compatible container runtime
- Publicly accessible IP with ports `9888` to `9897` open

## Starting a node

To run a PBC node you need a private key, the genesis state, your own node config and the Docker image containing the application. For the rest of the guide we assume you are running Ubuntu 18.04 with Docker installed.

### Creating the folders

In this guide we will be running the nodes from the folder `/opt/pbc-betanet` with user:group `1500:1500`. First we need to create the `conf` and `storage` folders for the application:

```` bash
sudo mkdir -p /opt/pbc-betanet/conf
sudo mkdir -p /opt/pbc-betanet/storage
````

Now we need to make sure the the user with uid `1500` has the needed access to the files:

```` bash
sudo chown -R "1500:1500" /opt/pbc-betanet
sudo chmod 500 /opt/pbc-betanet/conf    
sudo chmod 700 /opt/pbc-betanet/storage
````

The above commands set conservative permissions on the folders the node is using. `chmod 500` makes the config folder readable by the PBC node and root. `chmod 700` makes the storage folder readable and writable for the PBC node and root.

### Creating `genesis.json` and the node `config.json`

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

Then paste the following:

````json
{
  "modules": [
    {
      "fullyQualifiedClass": "io.privacyblockchain.server.rest.RestNode",
      "configuration": {
        "enabled": true
      }
    }
  ],
  "restPort": 80,
  "floodingPort": 9888,
  "knownPeers": [
    "188.180.83.49:9090",
    "188.180.83.49:9190",
    "188.180.83.49:9290",
    "188.180.83.49:9390",
    "174.138.2.217:9888",
    "172.93.110.125:9888",
    "164.68.103.244:9888",
    "176.78.42.5:9888"
  ]
}
````

To save the file press `CTRL+O` and then `ENTER` and then `CTRL+X`.
Next ensure that the newly created files have the correct permissions:

````bash
sudo chown "1500:1500" /opt/pbc-betanet/conf/genesis.json
sudo chown "1500:1500" /opt/pbc-betanet/conf/config.json
sudo chmod 400 /opt/pbc-betanet/conf/genesis.json
sudo chmod 400 /opt/pbc-betanet/conf/config.json
````

You can verify the contents of the files are what you expect by opening them with `cat`:

````bash
sudo cat /opt/pbc-betanet/conf/genesis.json
# The genesis file should be printed here

sudo cat /opt/pbc-betanet/conf/config.json
# The config file should be printed here
````

### Start the node

You can run the node using the `docker` terminal command or using the slightly more readable `docker-compose`. The latter is not installed by default.

Start by creating a directory `pbc` and add a file named `docker-compose.yml`.

````bash
mkdir -p pbc
cd pbc
nano docker-compose.yml
````

The contents of the file should be the following:

````yaml
version: "2.1"
pbc-betanet-reader:
  image: registry.gitlab.com/privacyblockchain/demo/betanet-public:latest
  container_name: pbc-betanet-reader
  restart: always
  expose:
  - "80"
  ports:
  - "9888-9897:9888-9897"
  command: [ "/conf/config.json", "/conf/genesis.json", "/storage/" ]
  volumes:
  - /opt/pbc-betanet/conf:/conf
  - /opt/pbc-betanet/storage:/storage
  environment:
  - JAVA_TOOL_OPTIONS="-Xmx1G"
````

Save the file by presssing `CTRL+O` and then `ENTER` and then `CTRL+X`.
Keep an eye on the indentation since YAML is whitespace sensitive and it won't work if the indentaion is off.

You don't yet have access to the Partisia container repository so you first need to login.

````bash
sudo docker login -u <GitLab e-mail address> registry.gitlab.com
````

**Note:** If you have two-factor login enabled in GitLab you need to create a [personal access token](https://gitlab.com/-/profile/personal_access_tokens).

You can now start the node:

````bash
sudo docker-compose up -d
````

This should pull the latest image and start the reader node in the background. If the command was executed succesfully it won't print anything. To verify that the node is running run:

````bash
sudo docker logs -f pbc-betanet-reader
````

This should print a bunch of log statements. All the timestamps are in [UTC](https://en.wikipedia.org/wiki/Coordinated_Universal_Time) and can therefore be offset several hours from your local time.

## Logs and storage

The logs of the node are written to the standard output of the container and are therefore managed using the tools provided by Docker. You can read about configuring Docker logs [here](https://docs.docker.com/config/containers/logging/configure/).

The storage of the node is based on RocksDB. It is write-heavy and will increase in size for the foreseeable future. The number and size of reads and writes is entirely dependent on the traffic on the network.

## Updating

Updating the PBC node is a simple 4-step process:

```` bash
cd ~/pbc
sudo docker-compose down
sudo docker-compose pull
sudo docker-compose up -d
````

First you change the directory to where you put your `docker-compose.yml` file. You then stop the currently running container, pull the newest image and start it again. You should now be running the newest version of the software.
