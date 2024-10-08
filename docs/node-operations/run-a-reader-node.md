# Run a reader node

This page explains what a reader node is and how to run it on a [VPS](../pbc-fundamentals/dictionary.md#vps).   
A reader node can read the blockchain state, and it does not require
a [stake](../pbc-fundamentals/dictionary.md#stakestaking). You can upgrade from reader to a baker node and from there
to a node running any [node service](start-running-a-node.md).    
The reader gives you access to information about accounts, contracts and specific blocks. If you are developing a dApp
or a front-end you will often need to run your own reader node. When many parties query the same reader, it creates load on the server and can cause slowdowns. Run
your own reader to avoid this.

!!! Warning "You must complete this requirement before you can continue"
    1. Get a [VPS](../pbc-fundamentals/dictionary.md#vps) that satisfies the [minimum specifications](start-running-a-node.md#which-node-should-you-run)

## Secure your [VPS](../pbc-fundamentals/dictionary.md#vps)

Adding our recommended set of security measures minimizes vulnerabilities in your node. This guide teaches you how to
configure file permissions, the firewall and monitor your hardware.

### Understand how user privileges affect the safety of your node

Nodes on Partisia Blockchain need a Linux based operating system, we use Ubuntu in our guides. When you use Ubuntu you
are either working as a root user or an ordinary non-root user. A root user can command access to all directories and
files on the system. A non-root can only access certain commands dependent on what permissions and roles the user have
been assigned. When you put `sudo` in front of a command it means you are executing it as root, and you will need to
provide your user's password. You do not want your node to be running as root, and in general you do not want to be
logged in as root when using the node.   

Therefore, your setup involves two users with different levels of access to files:    

1. **Personal user** without access to
restricted files, in Ubuntu default user is `1000:1000`
2. **User 1500:1500** for the docker service with access to config and storage     

You make a non-root **personal user**. The second user is for the node service. You do not need to create this user (it
is handled by the docker service), but you do need to specify necessary file permissions. Docker is running the node
service from a container. The node service `pbc` has user `1500:1500`. You grant the `pbc` user `1500:1500`
access to the config-file and storage necessary to run the node. Do not change the `pbc` user `1500:1500` to `1000:1000`. 

If you want to see that the config has been created you can check with `sudo ls /opt/pbc-mainnet/conf`.

!!! Note "Follow these 3 rules:"

    1. **Personal user** is non-root, the Ubuntu default user is `1000:1000`
    2. The service `pbc` defined in `docker-compose.yml` has user `1500:1500`
    3. **root** is used when you set up file permissions and when you manually install software on the server - you should avoid being permanently logged in as root

    If you follow these 3 rules it will make it more difficult for hackers to steal private keys, and destroy or compromise your node.

### Change root password

When you get a VPS with Linux OS you receive a root password from the provider. Change the root
password:

````bash
sudo passwd root
````

### Add a non-root personal user

For best security practice root should not be default user. If someone takes over the node, and it is running as root, they can do more damage. 

Add a non-root user:

````bash
sudo adduser userNameHere
````

Make sure that the non-root user can execute superuser commands:

````bash
sudo usermod -aG sudo userNameHere
````

Make sure the user can access system logs:

````bash
sudo usermod -aG systemd-journal userNameHere
````

Switch to the new non-root user:

````bash
su - userNameHere
````

### Install htop

Use `htop` to monitor your CPU and memory. Install `htop`:

````bash
sudo apt install htop
````

### Secure shell (SSH)

Use SSH when connection to your server. Most VPS hosting sites have an SSH guide specific to their hosting platform, so you should follow the specifics of your hosting provider's SSH guide.

### Configure your firewall

Disable firewall, set default to block incoming traffic and allow outgoing:

````bash
sudo ufw disable
````

````bash
sudo ufw default deny incoming
````

````bash
sudo ufw default allow outgoing
````

Allow specific ports for Secure Shell (SSH) and the ports used by the [flooding network](../pbc-fundamentals/dictionary.md#flooding-network):

````bash
sudo ufw allow your-SSH-port-number
````

````bash
sudo ufw allow 9888:9897/tcp
````

Enable rate limiting on your SSH connection:

````bash
sudo ufw limit your-SSH-port-number
````

Enable logging, start the firewall and check status:

````bash
sudo ufw logging on
````

````bash
sudo ufw enable
````

````bash
sudo ufw status
````

## Set up a reader on your VPS

When setting up the node you should use the non-root user you created above.
The node will run as user:group `1500:1500`


### Creating the configuration and storage folders

You run the node from the folder `/opt/pbc-mainnet` with user:group `1500:1500`. First we need
to create the `conf` and `storage` folders for the application:

````bash
sudo mkdir -p /opt/pbc-mainnet/conf
````

````bash
sudo mkdir -p /opt/pbc-mainnet/storage
````

### Setting file permissions

Now we need to make sure the user with id `1500` has the needed access to the files:

````bash
sudo chown -R "1500:1500" /opt/pbc-mainnet
````

````bash
sudo chmod 500 /opt/pbc-mainnet/conf
````

````bash
sudo chmod 700 /opt/pbc-mainnet/storage
````

The above commands set conservative permissions on the folders the node is using. `chmod 500` makes the config folder
readable by the PBC node and root. `chmod 700` makes the storage folder readable and writable for the PBC node and root.


### Pull docker image

This guide assumes you run the node with `docker-compose`.

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

Copy and paste content below into the file:

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

!!! Warning "Make sure your .yml file match the example"
    It won't work if the indentation is off, because .yml is whitespace sensitive.


Keep an eye on the indentation  it won't work if the indentation is off.

### Generating a config for a reader node

The [node-register tool](node-health-and-maintenance.md#the-node-registersh-tool) will help you generate a valid node configuration file.

To generate the `config.json` for a reader node you need following information:

- The IP, port and network public key of at least one other producer on the format `networkPublicKey:ip:port`,
  e.g. `02fe8d1eb1bcb3432b1db5833ff5f2226d9cb5e65cee430558c18ed3a3c86ce1af:172.2.3.4:9999` (give the public key as hexadecimal or Base64). The location of other known
  producers should be obtained by reaching out to the community. You can see how to reach the
  community [here](https://partisiablockchain.gitlab.io/documentation/node-operations/what-is-a-node-operator.html#onboarding).


The tool ensures your `config.json` is well-formed and that it is stored in the correct folder on the machine.

Start the tool by running it with the `create-config` command.

We are creating a reader node. Therefore, your first response needs to be a `no` when creating the config, otherwise the node will attempt to (unsuccessfully) produce blocks.

The config should look like the example below.

??? example "Example: Basic reader config"

    ```
    {
        "networkKey": "YOUR NETWORK KEY"  
    }
    ```

### Starting the node

You can now start the node:

````bash
docker compose up -d
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

## Final step

If you are a developer making an application on PBC, and the application needs to reliably query the state of the
blockchain, then you need a reader node. We recommend that your reader node is set up
with [a reverse proxy](run-a-zk-node.md#set-up-a-reverse-proxy) to block unwanted traffic. You can query without the
reverse proxy being setup, but in general practice we do not recommend this method.

You now have a reader node, running on a secured VPS. On the next page you can learn how to upgrade this to baker node.
A baker node is a required step for all [paid node services](node-payment-rewards-and-risks.md).    
