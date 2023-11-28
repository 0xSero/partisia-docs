# Node health and maintenance

The maintenance page takes you through the following node issues: 

- Is your baker node working   
- Update your node manually   
- Check your IP accessibility and peers    
- Tools for measuring node performance   
- Interpret log messages and debugging problems - See if your node is signing blocks   
- Confirm that your BYOC endpoints are working
- How to migrate your node to a different VPS

## Is your baker node working

If your node is unattended for to long it can run into problems. Problems that may affect your node's earning potential and the safety of your stake. Your node has to be up-to-date to participate in the committee. If your  node is not updated regularly, it is bound to fall out of committee. Only nodes up-to-date can participate in forming a new committee, so every time a new committee is formed from registered nodes, only nodes with the newest version of Partisia Software can be included. 
Your node can only perform services and by extension earn rewards when in the committee. After you are included you want to make sure your node is able to continue to participate.  
To optimize your nodes earning potential you should implement automatic updates and check up on the node's performance regularly.

**Your baker node is working when:**   

- Your node is producing blocks when chosen as producer. At the moment nodes take turns based on their index from the list of [committee members](https://browser.partisiablockchain.com/accounts?tab=node_operators). This can be affirmed in the metrics explained below      
- Your node is signing blocks. Can be checked in the logs as explained below    
- Your node is running the newest version of Partisia Software. The easiest way to ensure this is by implementing [automatic updates](run-a-reader-node.md#get-automatic-updates)

You can confirm that your node software is up-to-date with the following command:

````BASH
docker inspect --format='{{.Image}}' YOUR_CONTAINER_NAME
````

The number must match the latest [configuration digest](https://gitlab.com/partisiablockchain/mainnet/container_registry/3175145).

## Updating

You should always have enabled [automatic updates](run-a-reader-node.md#get-automatic-updates) on your node. But, there can be situation where you want to update it manually if you have had a problem on the node.

In the following it is assumed you are using `~/pbc` as directory for your `docker-compose.yml`.

Updating the PBC node is a simple 3-step process:


````bash
cd ~/pbc
````
````bash
docker-compose pull
````
````bash
docker-compose up -d
````

First you change the directory to where you put your `docker-compose.yml`. You then pull the newest image and start it again. You should now be running the newest version of the software.


## Check your connection to the peers in the network and your uptime

Your node can only get registered as a block producer and participate in the committee if your host IP is reachable. 
Replace the letters in the URL below with the IP of the server hosting your node. This should navigate you to a page showing a JSON, with the following information:

`http://PUBLIC_IP_OF_SERVER_HOSTING_THIS_NODE:9888/status`


````json
{
  "versionIdentifier": "Version number of PBC",
  "uptime": 11552567,
  "systemTime": 1700491419888,
  "knownPeersNetworkKeys": ["network addresses (Base64) of connected baker nodes"],
  "networkKey": "Network address(Base64)",
  "blockchainAddress": "account address (Hex)",
  "finalizationKey": "finalization publicKey (base64)",
  "numberOfProcessors": 8,
  "systemLoad": 0.51,
  "freeMemory": 1574211176,
  "totalMemory": 2701131776,
  "maxMemory": 17179869184
}
````
Uptime is measured in milliseconds, and show how long your server has been running uninterrupted.

If you cannot open your status endpoint there is probably a problem with the opening of ports of the [VPS](../pbc-fundamentals/dictionary.md#vps). See which ports are allowed through the firewall:   


````bash
sudo ufw status
````
Make sure you have opened for ports 9888-9897. If not consult the instructions [here](../node-operations/run-a-reader-node.md).

## How to monitor node performance

The node operator community has made several tools that can help you monitor the performance of your node:

Check block production and finalization time with MPC Node Stats:    
- [Browser Version](https://mpcnodestats.dreamhosters.com/)   
- [iPhone](https://apps.apple.com/gr/app/mpc-node-stats/id1661132518)   
- [Android](https://play.google.com/store/apps/details?id=com.mpcnodeio.mpcstats&pli=1)   

Compare your received stake delegations with that of other committee members:   
- [Parti Scan](https://partiscan.io/)    


## Logs and storage

You use the docker logs to see activity on the chain and if your node is signing blocks. The logs of the node are written to the standard output of the container and are therefore managed using the tools provided by Docker. You can read about configuring Docker logs [here](https://docs.docker.com/config/containers/logging/configure/).

The storage of the node is based on RocksDB. It is write-heavy and will increase in size for the foreseeable future. The number and size of reads and writes is entirely dependent on the traffic on the network.

### Common log messages

**Signing BlockState** - All is well.   
**Not signing as shutdown is active** - You may assume all is well. Shutdown happens when chosen producer fails to produce a block, a reset block is made, and then a new node is chosen for the role of producer.   
**Not signing** - This is not a good sign, you are not signing blocks. First, check if you are on the list of [current committee members](https://mpcexplorer.com/validators), if you are not, and you have already sent the Register Transaction, then you should search for your PBC account address in the state the [Block Producer Orchestration Contract](https://dashboard.partisiablockchain.com/info/contract/04203b77743ad0ca831df9430a6be515195733ad91) (BPOC). There is a field for each producer called "status": - after this you will see either "CONFIRMED" or "PENDING". Confirmed means you are registered as a block producer and are formally eligible to participate in the committee. Pending means your public information is still awaiting manual approval from the team cross-checking the information you have given. If you cannot find your address in the BPOC at all you need to resend your registration. Alternatively, if you are on the list of committee members and still get persistent “Not signing” then you almost certainly have some problem in your config.json Probably you have a wrong or no key in one of the fields: networkKey, accountKey or finalizationKey, or you forgot to add the host IP address.   
**Got a message with wrong protocol identifier** - This message comes every time a shutdown has occurred (in other words whenever a producer has not produced the block he is supposed to). So, on its own that message does not indicate a problem. But, if the log just repeats and don't change to a new message saying Executing Block… it could suggest you are running an outdated version of our software, a version that does not pull the newest docker image automatically.   
**WebApplicationException. Status=404** - You may assume all is well. You may encounter different types of not found errors in the logs. Most of them are not indicative of a problem at your end. They occur when a node in the network has not received what it expected you can in most cases see the address or producer index of the nodes related to the error.    

### Sorting the logs

**Latest logs:**

````bash
docker logs -f nameOfDockerContainer
````

This will show the latest logs after they have caught up to present.

**Sorting by time:**   

````bash
docker logs --since 1h  nameOfDockerContainer
````
This will give you the latest hour of logs

**Sorting by number of lines:**

````bash
docker logs --tail 1000  nameOfDockerContainer
````
This will give you the latest 1000 lines of logs.

````bash
docker logs --tail 1000 -f  nameOfDockerContainer
````
You can add the ``-f`` after a command to continue the logs afterwards.

**Sort for specific messages:**

You can use the *grep command* to get logs containing a specific string.

````bash
docker logs --since 1h pbc-mainnet | grep "Signing BlockState"
````

This will give you the blocks you have signed the last hour. You might also want to look for blocks you created when you were chosen as producer ``| grep "Created Block"``.

## Confirm that your BYOC endpoints are working

Check if your BYOC endpoints for other chains in config.json are working:

```BASH
curl "ENDPOINT_YOU_WANT_TO_CHECK" \
  -X POST \
  -H "Content-Type: application/json" \
  --data '{"method":"eth_chainId","params":[],"id":1,"jsonrpc":"2.0"}'
```
Alternatively:

```BASH
curl -X POST "ENDPOINT_YOU_WANT_TO_CHECK" \
  -H 'Content-Type: application/json' \
  --data '{"method":"eth_blockNumber", "jsonrpc":"2.0", "params":[],"id":1}'
```

If the block number is way off, or if you don't get anything with either command, there is likely a problem with the endpoint, replace it!

### How to migrate your node to a different VPS

When changing VPS there are a few important precautions you take ensuring a problem free migration.

**You may never run two nodes performing baker services at the same time**   
Running two nodes with same config can be interpreted as malicious behavior.You can start a [reader node](../node-operations/run-a-reader-node.md) on the new VPS. Then, when you are ready to change the `config.json` to the BP version, you stop the node from running on the old server:

````bash
docker stop  nameOfDockerContainer
````

**If you change host IP, you need to correct your `config.json`**   
In `config.json` correct the IPv4:

````json
"host": "PUBLIC_IP_OF_SERVER_HOSTING_THIS_NODE",
````

**You must migrate certain files for your node to participate in voting on a new committee (Large Oracle)**   
From the storage directory `/opt/pbc-mainnet/storage` of your old node host you move the 3 files below to the storage directory of the new server:   

`large-oracle-backup-database.db`, `large-oracle-database.db` and `peers.json`
