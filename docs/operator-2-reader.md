# Run a reader node on your local machine

### Step 1 - Creating the folders

First we need to create the `conf` and `storage` folders for the application:

```` bash
sudo mkdir -p /opt/pbc-mainnet/conf
````
```` bash
sudo mkdir -p /opt/pbc-mainnet/storage
````

### Step 2 - Creating the node `config.json`

Start by opening the file in `nano`:

````bash
sudo nano /opt/pbc-mainnet/conf/config.json
````
You paste this into `config.json`:
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

To save the file press `CTRL+O` and then `ENTER` and then `CTRL+X`.

You can verify the contents of the files are what you expect by opening them with `cat`:

````bash
sudo cat /opt/pbc-mainnet/conf/config.json
# The config file should be printed here
````

### Step 3 - Setting file permissions

Now we need to make sure the user with uid `1500` has the needed access to the files:

```` bash
sudo chown -R "1500:1500" /opt/pbc-betanet
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

The above commands set conservative permissions on the folders the node is using. `chmod 500` makes the config folder readable by the PBC node and root. `chmod 700` makes the storage folder readable and writable for the PBC node and root.

### Step 4 - Pull docker image

You can run the node using the `docker-compose`.

Start by creating a directory `pbc` and add a file named `docker-compose.yml`.
````bash
cd ~
````
````bash
mkdir -p pbc
````
We put the folder containing `docker-compose.yml` in home directory to prevent users who access docker from gaining easy access to information in the `config.json`. Therefor you can execute the following docker commands without superuser privileges.
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

You don't yet have access to the Partisia container repository, so you first need to log in.

````bash
docker login -u <GitLab e-mail address> registry.gitlab.com
````

**Note:** If you have two-factor login enabled in GitLab you need to create a [personal access token](https://gitlab.com/-/profile/personal_access_tokens).

You can now start the node:

````bash
docker-compose up -d
````

This should pull the latest image and start the reader node in the background. If the command was executed successfully it won't print anything. To verify that the node is running, run:

````bash
docker logs -f pbc-betanet-reader
````

This should print a bunch of log statements. All the timestamps are in [UTC](https://en.wikipedia.org/wiki/Coordinated_Universal_Time) and can therefore be offset several hours from your local time.

