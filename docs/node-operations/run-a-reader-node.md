# Run a reader node

This page explains what a reader node is and how to run it on a [VPS](../pbc-fundamentals/dictionary.md#vps).

### What is a reader node

A reader node can read the blockchain state, it does not require
a [stake](../pbc-fundamentals/dictionary.md#stakestaking). You can upgrade from reader to a baker node and from there
to a node running any node service.    
The reader gives you access to information about accounts, contracts and specific blocks. If you are developing a dApp
or a front-end you will often need to run your own reader node. When parties query the same reader, it slows down. Run
your own reader to avoid this.

!!! Warning " You must complete this requirements before you can continue"   
    - Get a [VPS](../pbc-fundamentals/dictionary.md#vps) with that fulfill the [minimum specifications](start-running-a-node.md)

## Secure your [VPS](../pbc-fundamentals/dictionary.md#vps)

You need to set up security measures to minimise the risks of your node crashing or being hacked. You now learn how to
configure the firewall and monitor your hardware.

### Change root password

When you get a VPS with Lixux OS you receive a root password from the provider. Change the root
password:

````bash
sudo passwd root
````

### Add a non-root user

For best security practice root should not be default user. Add a non-root user:

````bash
sudo adduser userNameHere
````

### Install Network Time Protocol

To avoid time drift use Network Time Protocol (NTP). First install:

````bash
 sudo apt-get update
````

````bash
 sudo apt-get install ntp ntpdate
````

Stop NTP service and point to NTP server:

````bash
sudo service ntp stop
````

````bash
sudo ntpdate pool.ntp.org
````

Start NTP service and check status:

````bash
sudo service ntp start
````

````bash
sudo systemctl status ntp
````

### Install Htop

Use Htopoto monitor your CPU and memory. Install Htop:

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

## Set up a reader on VPS

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

!!! Warning "Beware of indentation in YAML files"
    YAML is whitespace sensitive. It won't work if the indentation is off.


Keep an eye on the indentation  it won't work if the indentation is off.

### The `node-register.sh` script

The `node-register.sh` script will help you generate a valid node configuration file.

To generate the `config.json` for a reader node you need following information:

- The IP and network public key of at least one other producer on the format `networkPublicKey:ip:port`, e.g. `02fe8d1eb1bcb3432b1db5833ff5f2226d9cb5e65cee430558c18ed3a3c86ce1af:172.2.3.4:9999`. The location of other known producers should be obtained by reaching out to the community.You can see how to reach the community [here](https://partisiablockchain.gitlab.io/documentation/node-operations/what-is-a-node-operator.html#onboarding).


The newest version of `node-register.sh` is located on [GitLab](https://gitlab.com/partisiablockchain/main/-/raw/main/scripts/node-register.sh).

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


## Get automatic updates

All nodes independent of type should be set up to update their software automatically.
To set up automatic updates you will need Cron, which is a time based job scheduler. See if you have the Cron package installed:

````bash
dpkg -l cron
````

If not:

````bash
apt-get install cron
````

Now you are ready to start.

**1. Create the auto update script:**

Go to the directory where `docker-compose.yml` is located.

````bash
cd ~/pbc
````

Open the file in nano:

````bash
nano update_docker.sh
````

Paste the following content into the file:

````yaml
#!/bin/bash

DATETIME=$(date -u)
echo "$DATETIME"

cd ~/pbc

/usr/local/bin/docker-compose pull
/usr/local/bin/docker-compose up -d
````
Save the file by pressing `CTRL+O` and then `ENTER` and then `CTRL+X`.

**2. Make the file executable:**

````bash
chmod +x update_docker.sh
````

Type ``ls -l`` and confirm *update_docker.sh*  has an x in its first group of attributes, that means it is now executable.

**3. Set update frequency to once a day at a random time:**

````bash
crontab -e
````
This command allows you to add a rule for a scheduled event. You will be asked to choose your preferred text editor to edit the cron rule. If you have not already chosen a preference.

Paste and add the rule to the scheduler. **NB**. No "#" in front of the rule:
````bash
m h * * * /home/pbc/update_docker.sh >> /home/pbc/update.log 2>&1
````
For minutes (m) choose a random number between 0 and 59, and for hours (h) choose a random number between 0 and 23.
If you are in doubt about what the cron rule means you can use this page:
<https://crontab.guru/> to see the rule expressed in words.

Press `CTRL+X` and then `Y` and then `ENTER`.

This rule will make the script run and thereby check for available updates once every day.

To see if the script is working you can read the update log with the *cat command*:

````bash
cat update.log
````
You might want to change the timing the first time, so you do not have to wait 30 minutes to confirm that it works.

If your version is up-to-date, you should see:
````
YOUR_CONTAINER_NAME is up-to-date
````
If you are currently updating you should see:
````
Pulling YOUR_CONTAINER_NAME ... pulling from privacyblockchain/de...
````
**NB.** Never include a shutdown command in your update script, otherwise your node will go offline every time checks for updates.

## Final step

If you plan on using your reader node for development or if you plan to upgrade your node to a zk node, then you will need to [set up reverse proxy using example in ZK node guide](run-a-zk-node.md). Otherwise, you can go to the next page to upgrade to a [baker node](run-a-baker-node.md). 

You should now have a reader node, running on a secured VPS. On the next page you can learn how to upgrade this to baker node. A baker node is a required step for all [paid node services](node-payment-rewards-and-risks.md).