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

ZK nodes and reader nodes for development need a reverse proxy server. ZK nodes need it to be able to give and receive
secret inputs. Reader nodes need to set rate limits to prevent DDOS (denial-of-service-attacks).

Your node is running a docker image with the pbc-mainnet software. The source of the image and name of the container is
defined in the "service:"-field of  `docker-compose.yml`. In this example we will set up a reverse proxy by modifying
the `docker-compose.yml`. You add additional services to act as a proxy server for incoming and outgoing traffic.

!!! Info "If input for ZK contracts are safe, why do I need an https endpoint?"

    Inputs given to ZK contracts are preprocessed and cut into randomized parts called secret shares. But if a third party
    gets access to several shares there is a risk that they can guess the original input. For this reason traffic related to
    ZK computations travel through an https endpoint. Baker traffic does not need this because their actions end up on the public ledger.

### Get Domain and create a Domain Name Service Address record (DNS A-record)

Buy a web domain either from your VPS provider or from another reputable
source ([this article has a list](https://www.forbes.com/advisor/business/software/best-web-hosting-services/)). Make
sure to choose a domain name that does not match something proprietary. If you want to associate the name with the
public blockchain Partisia Blockchain that is okay. But Partisia is an independent privately owned company, providing
software and infrastructure and run an infrastructure and reader node on PBC. So, avoid names that give the impression
that your node is run by the company Partisia.

When you have purchased a domain make an address record (A-record) for a subdomain and point it to your node.

!!! Example "You have purchased domain "mynode.com" and have VPS host IP 123.123.123.123"

    1. Sign in to your domain controll panel and find DNS reords
    2. Make an A-record pointing zk.mynode.com to 123.123.123.123

### Install necessary software

This example uses nginx for the proxy server and acme-companion handles automated creation and renewal of the SSL
certificate. Both services are manged by the `docker-compose.yml`.

```BASH
sudo apt update
```

```BASH
sudo apt install nginx
```

For installation of `acme.sh` choose your preferred installation
method [here](https://github.com/acmesh-official/acme.sh?tab=readme-ov-file#1-how-to-install)

### Modify `docker-compose.yml`

The modified docker compose handles two new services in addition to managing the pbc-mainet container: 1) an nginx proxy
server, and 2) an automated certificate manager (acme). We first open the ports used for the proxy server and
certificate renewal, then we modify the `docker-compose.yml`.

```BASH
sudo ufw allow 8443
```
```BASH
sudo ufw allow 80
```

```BASH
cd pbc
```

```BASH
docker stop pbc-mainnet
```

```BASH
nano docker-compose.yml
```

```yaml
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
      - VIRTUAL_HOST=your_sub.domain.com
      - VIRTUAL_PORT=8080
      - LETSENCRYPT_HOST=your_sub.domain.com
  nginx-proxy:
    image: nginxproxy/nginx-proxy:alpine
    container_name: pbc-nginx
    restart: always
    ports:
      - "80:80"
      - "8443:443"
    volumes:
      - conf:/etc/nginx/conf.d
      - vhost:/etc/nginx/vhost.d
      - html:/usr/share/nginx/html
      - certs:/etc/nginx/certs:ro
      - /var/run/docker.sock:/tmp/docker.sock:ro
  acme-companion:
    image: nginxproxy/acme-companion
    container_name: pbc-acme
    restart: always
    volumes_from:
      - nginx-proxy
    volumes:
      - certs:/etc/nginx/certs:rw
      - acme:/etc/acme.sh
      - /var/run/docker.sock:/var/run/docker.sock:ro
    environment:
      - DEFAULT_EMAIL=your@email.address
```

[Check that your file is valid yml-format](https://www.yamllint.com/), then save the file by pressing `CTRL+O` and then `ENTER` and then `CTRL+X`.

Start the docker-compose services and pull the latest images:

```BASH
docker-compose pull
```

```BASH
docker-compose up -d
```
Normally, nginx has new releases monthly, so you do not need to update your proxy server. You can add rules to your auto-update script or update the nginx and acme service manually.

```BASH
docker-compose pull nameOfService
```

```BASH
docker-compose up -d nameOfService
```

## Register your ZK node

Complete the following steps:

1. [Associate](https://browser.partisiablockchain.com/contracts/01a2020bb33ef9e0323c7a3210d5cb7fd492aa0d65/associateTokens)
   75 K MPC tokens to the ZK Node Registry contract
2. [Register](https://browser.partisiablockchain.com/contracts/01a2020bb33ef9e0323c7a3210d5cb7fd492aa0d65/registerAsZkNode)
   as a ZK node (You need to have your https rest endpoint ready)
3. Restart your node

If you have additional tokens you can read how to run a deposit or withdrawal oracle on the following page.    
