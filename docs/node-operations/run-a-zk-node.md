# Run a ZK node

This page explains how to change the configuration of your baker node to ZK node's and how to
register your node for the service. ZK nodes do
[ZK computations](../pbc-fundamentals/dictionary.md#mpc) in addition to their baker node work of
signing and producing blocks. By completing the steps below your node will be eligible to be
allocated for specific computations by
[ZK smart contracts](../smart-contracts/zk-smart-contracts/zk-smart-contracts.md) and earning
revenue for the zero knowledge computations performed.

## Requirements of a ZK node

<!-- prettier-ignore -->
!!! Warning "You must complete these requirements before you can go to [registration](run-a-zk-node.md#register-your-zk-node)"

    1. [Run baker node](run-a-baker-node.md)
    2. [Stake 75K MPC tokens](https://browser.partisiablockchain.com/node-operation). You need a total staking balance of 100K for both ZK and baker node.
    3. You have set up a reverse proxy. This includes:

        - Web domain with a valid SSL/TSL certificate for an HTTPS REST endpoint
        - A modified `docker-compose.yml` defining a docker service acting as proxy

    4. Verify that your ZK node domain maps to the IPv4 address of your host VPS, use <https://www.nslookup.io/> or similar

## Set up a reverse proxy

ZK nodes and [reader nodes for development](run-a-reader-node.md#final-step) need a reverse proxy
server. ZK nodes need it to be able to give and receive secret inputs. Reader nodes need to set rate
limits to prevent denial-of-service-attacks (DDOS).

Your node is running a docker image with the pbc-mainnet software. The source of the image and name of the container is
defined in the "service:"-field of `docker-compose.yml`. In this example we will set up a reverse proxy by modifying
the `docker-compose.yml`. You add additional services to act as a proxy server for incoming and outgoing traffic.

!!! Info "If input for ZK contracts are safe, why do I need an HTTPS REST endpoint?"

    Inputs given to ZK contracts are preprocessed and cut into randomized parts called secret shares. But if a third party
    gets access to several shares there is a risk that they can guess the original input. For this reason traffic related to
    ZK computations travel through an HTTPS endpoint. Baker traffic does not need this since their actions end up on the public ledger.

### Get Domain and create a Domain Name Service Address record (DNS A-record)

Buy a web domain either from your VPS provider or from another reputable source. Make sure to choose a domain name that
does not match something proprietary.
It is allowed to associate your domain name with Partisia Blockchain since it is a public network where your node participates, e.g. you can name the domain pbcnode.com or similar.  
Avoid the name Partisia as a stand-alone term. Partisia is an independent privately owned company. Partisia provides software and infrastructure for PBC by running an
infrastructure node and a reader node. Avoid names which give the impression that your node is run by the company
Partisia.

When you have purchased a domain make an address record (A-record) for a subdomain and point it to
your node.

!!! Example "You have purchased domain "pbcnode.com" and have VPS host IP 123.123.123.123"

    1. Sign in to your domain control panel and find DNS records
    2. Make an A-record pointing a subdomain (e.g. zk.pbcnode.com) to 123.123.123.123

### How nginx and acme run as services in docker containers

This example uses [nginx](https://hub.docker.com/r/nginxproxy/nginx-proxy) for the proxy server and
[acme-companion](https://hub.docker.com/r/nginxproxy/acme-companion) handles automated creation and
renewal of the SSL certificate. Both services are manged by the `docker-compose.yml`.

Docker Compose automates the process of downloading, building, and running the specified containers,
along with their dependencies. This is why you don't have to manually install and configure software
on your host machine. This is one of the key benefits of running a service in a docker container.

### Modify `docker-compose.yml`

The modified docker compose handles two new services in addition to managing the pbc-mainnet container: 1) _pbc-nginx_ an nginx proxy
server, and 2) _pbc-acme_ running an automated certificate manager. We first open the ports host ports used for the proxy server and
certificate renewal, then we modify the `docker-compose.yml`.

![New Docker Compose Diagram](./img/run-a-zk-node-00.png)

Our new docker services will utilize ports that are currently closed by your firewall.

??? note "Using a non-standard HTTPS port"

    In this guide we have assumed that you use the standard port 443 as host port for HTTPS traffic. The commands for the firewall and the `docker-compose.yml` reflect this.
    If you use a non-standard port for HTTPS (8443), then the endpoint you register with the [ZK Node Registry contract](https://browser.partisiablockchain.com/contracts/01a2020bb33ef9e0323c7a3210d5cb7fd492aa0d65) should also point to 8443, e.g. zk.pbcnode.com:8443, and you must adjust the firewall settings and the `docker-compose.yml` template to fit your choice.

We allow HTTPS traffic through the firewall on port 443:

```BASH
sudo ufw allow 443
```

We allow HTTP traffic through the firewall on port 80:

```BASH
sudo ufw allow 80
```

HTTP traffic is necessary for getting and renewing SSL/TSL certificate of your domain. The acme service requests a
certificate. The certificate provider demands a proof of control of the domain. The proof consist of the server
(nginx) placing a token on a specified path using HTTP on port 80.

We stop docker compose before we make modifications:

```BASH
cd pbc
```

```BASH
docker stop
```

```BASH
nano docker-compose.yml
```

Paste the new docker compose. Change each `environment` of the services to fit with your domain e.g.
zk.pbcnode.com:

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
        command: ["/conf/config.json", "/storage/"]
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
            - "443:443"
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

volumes:
    conf:
    vhost:
    html:
    certs:
    acme:
```

[Check that your file is valid yml-format](https://www.yamllint.com/), then save the file by
pressing `CTRL+O` and then `ENTER` and then `CTRL+X`.

Start the Docker Compose services and pull the latest images:

```BASH
docker compose pull
```

```BASH
docker compose up -d
```

Normally, nginx has new releases monthly, therefore you do not need to check for updates for your
proxy server daily like you do with pbc software. You can add cron rules to your auto-update script
or update the nginx and acme service manually

Update the nginx proxy:

```BASH
docker compose pull nginx-proxy
```

```BASH
docker compose up -d nginx-proxy
```

Update the acme-companion

```BASH
docker compose pull acme-companion
```

```BASH
docker compose up -d acme-companion
```

!!! note "If you used different names for your docker services than the `docker-compose.yml` template"

    Correct the command by using the name of your docker service:
    ```BASH
    docker compose pull nameOfService
    docker compose up -d nameOfService
    ```

## Register as a ZK node

Complete the following steps:

1. [Register](https://browser.partisiablockchain.com/contracts/01a2020bb33ef9e0323c7a3210d5cb7fd492aa0d65/registerAsZkNode)
   as a ZK node (You need to have your HTTPS REST endpoint ready)
2. [Associate](https://browser.partisiablockchain.com/contracts/01a2020bb33ef9e0323c7a3210d5cb7fd492aa0d65/associateTokens)
   75 K MPC tokens to the ZK node registry contract
3. Restart your node

### Confirm that proxy server, certificate renewal and blockchain image are running

Confirm that all 3 of your docker containers are running. Use the command below, and get a list of
running docker containers:

```BASH
docker ps
```

You can see the running logs of each service by calling for the logs and specifying container name.

```BASH
  docker logs -f [container_id_or_name]
```

At this point you should have a fully functioning ZK node. If any of the docker-containers are not
running or shut down unexpectedly, then
[go to the node health and maintenance section](node-health-and-maintenance.md#for-zk-and-reader-nodes-sorting-logs-of-nginx-proxy-and-acme)

If you have additional tokens you can read how to run a deposit or withdrawal oracle on the following page.

## ZK Node Scoring

When your node is registered it can be selected as a ZK node for a newly deployed ZK contract. To incentivize having a
working node your ZK node is being scored on how well it performs the required actions for the allocated ZK contract.
A ZK Node Score consists of three sub scores

-   **Allocated**: The total number of contracts your node has been allocated to.
-   **Success**: The number of contracts that has ended with your node having performed the necessary actions.
-   **Failure**: The number of contracts where some required actions have not been performed.

It will always be the case that `Allocated = Success + Failure`. You can see your node's score in
the
[ZK node registry contract](https://browser.partisiablockchain.com/contracts/01a2020bb33ef9e0323c7a3210d5cb7fd492aa0d65?tab=state).

### Calculating the score

Whenever a ZK contract is finished computing, the participating nodes' scores are updated in the ZK node registry.
Which score that is updated depends on the way the ZK contract finishes its computation.

-   The contracts' calculation status gets moved to Done. All participating nodes gets Success.
-   The contracts' calculation status gets moved to Malicious. All participating nodes gets Failure.
-   The contract is deleted. All participating nodes gets Success.
-   The contract reaches its computation deadline. The score status for a node depends on whether there exists any
    work that a node has not performed. If a node is missing any of the following its status will be Failure, otherwise
    Success.
    -   Pending on-chain inputs.
    -   Pending on-chain opens.
    -   Attestations.
    -   Finished computations.
    -   Whether there is an ongoing computation. If so everyone gets Failure.

## Deregister as a ZK node

To deregister as a ZK node you need to disassociate your tokens from the ZK node registry contract.
In some cases your tokens might not be immediately available for disassociation. Please follow the
[flowchart](#flowchart-how-to-deregister-as-zk-node) below in order to disassociate your tokens.

After disassociating token from the ZK node registry, these tokens will no longer be available when
selecting nodes for new ZK work.

<span id="flowchart-how-to-deregister-as-zk-node"></>

!!!tip

    The steps in flowchart are clickable.

```mermaid
flowchart TD
    are-tokens-allocated[Are the tokens allocated to ZK work?]
    are-tokens-pending-unlock[Are the tokens pending being unlocked?]
    reserve-tokens-locked[Reserve tokens for disassociation]
    reserve-tokens-pending-unlock[Reserve tokens for disassociation]
    wait-for-allocation-enddate[Wait for the node allocation end date]
    wait-for-tokens-unlock[Wait for pending tokens being unlocked]
    disassociate-tokens[Disassociate tokens]

    are-tokens-allocated-- Yes --> reserve-tokens-locked
    are-tokens-allocated-- No --> are-tokens-pending-unlock
    are-tokens-pending-unlock-- Yes --> reserve-tokens-pending-unlock
    are-tokens-pending-unlock -- No --> disassociate-tokens
    reserve-tokens-locked --> wait-for-allocation-enddate
    reserve-tokens-pending-unlock --> wait-for-tokens-unlock
    wait-for-allocation-enddate --> wait-for-tokens-unlock
    wait-for-tokens-unlock --> disassociate-tokens

    click are-tokens-allocated "#how-to-check-if-your-tokens-are-allocated-to-zk-work" _self
    click are-tokens-pending-unlock "#how-to-check-if-your-tokens-are-pending-unlock" _self
    click reserve-tokens-locked "#how-to-reserve-tokens-for-disassociation" _self
    click reserve-tokens-pending-unlock "#how-to-reserve-tokens-for-disassociation" _self
    click wait-for-allocation-enddate "#how-long-does-it-take-for-allocated-tokens-to-become-released" _self
    click wait-for-tokens-unlock "#how-long-does-it-take-for-pending-tokens-to-become-unlocked" _self
    click disassociate-tokens "#how-to-disassociate-tokens" _self
```

### How to check if your tokens are allocated to ZK work

1. Open the
   [ZK node registry contract state](https://browser.partisiablockchain.com/contracts/01a2020bb33ef9e0323c7a3210d5cb7fd492aa0d65?tab=state)
2. Open the map `stakedTokens`
3. Search for your blockchain address `CTRL+f`
4. Open the struct next to your blockchain address
5. Open the map `allocatedTokens`
6. You can see the addresses of the ZK contracts your node is selected for

### How to check if your tokens are pending unlock

1. Open the
   [ZK node registry contract state](https://browser.partisiablockchain.com/contracts/01a2020bb33ef9e0323c7a3210d5cb7fd492aa0d65?tab=state).
2. Open the map `stakedTokens`.
3. Search for your blockchain address `CTRL+f`.
4. Open the struct next to your blockchain address.
5. Open the map `pendingUnlock`.
6. You can see the amount of tokens and the timestamp indicating when the tokens were released from
   ZK work.

### How to reserve tokens for disassociation

!!! info

    Reserving tokens for disassociation can prevent a node from being allocated to new ZK work.
    If allocating tokens to ZK work would cause the number of free tokens to fall below the
    amount reserved for disassociation, the node will not be selected for ZK work.

1. Sign in to the browser.
2. Navigate to
   ['Set reserved tokens'](https://browser.partisiablockchain.com/contracts/01a2020bb33ef9e0323c7a3210d5cb7fd492aa0d65/setReservedTokens)
   on the ZK node registry contract.
3. Specify the new amount of tokens you want to reserve.
4. Confirm by pressing `SET RESERVED TOKENS`.

### How long does it take for allocated tokens to become released?

After being allocated the tokes will be locked for ZK work until the node allocation end date.
Please follow the steps below to find the node allocation end date for a ZK contract:

1. Open the browser.
2. Paste the address of the ZK contract into the search field.
3. Press enter to navigate to the contract.
4. Open the 'ZK nodes' tab and find the 'Allocation end date'.

### How long does it take for pending tokens to become unlocked?

After being released from ZK work allocated tokens will be pending for 14 days before being
unlocked.

### How to disassociate tokens

1. Sign in to the browser.
2. Navigate to
   ['Disassociate tokens'](https://browser.partisiablockchain.com/contracts/01a2020bb33ef9e0323c7a3210d5cb7fd492aa0d65/disassociateTokens)
   on the ZK node registry contract.
3. Specify the amount you want to disassociate.
4. Confirm by pressing `DISASSOCIATE TOKENS`.
