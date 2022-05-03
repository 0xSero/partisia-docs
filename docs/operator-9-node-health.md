# Node health and maintenance

If your node is unattended for to long it can run into problems. Problems that may affect your node's earning potential and the safety of your stake. Your node has to be up-to-date to participate in the committee. If your  node is not updated regularly, it is bound to fall out of committee. Only nodes up-to-date can participate in forming a new committee, so every time a new committee is formed from registered nodes, only nodes with newest version of Partisia Software can be included. 
Your node can only perform services and by extension earn rewards when in the committee. After you are included you want to make sure your node is able to continue to participate.  
To optimize your nodes earning potential you should implement automatic updates and check up on the node's performance regularly.

**Your node is working when:**   

- Your node is producing blocks when chosen as producer. At the moment nodes take turns based on their index from the list of [committee members](https://dashboard.partisiablockchain.com/info/consensus). This can be affirmed in the metrics explained below.   
- Your node is signing blocks. Can be checked in the logs as explained below.   
- Your node is running the newest version of Partisia Software. The easiest way to assure this is by implementing automatic updates.    


### The following section covers how to:

- Update your node manually.   
- Implement automatic updates.   
- Check your IP accessibility and version of Partisia Software.   
- Metrics of node performance - See if your node is producing blocks and have a reasonable finalization time.   
- Interpret log messages and debugging problems - See if your node is signing blocks.   


## Updating

In the following it is assumed we assume you are using `~/pbc` as directory for your `docker-compose.yml`.

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

## Get automatic updates

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

DATETIME=`date -u`
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

**3. Set update frequency to 30 minutes:**

````bash
crontab -e
````
This command allows you to add a rule for a scheduled event. You will be asked to choose your preferred text editor to edit the cron rule. If you have not already chosen a preference.   

Paste and add the rule to the scheduler. **NB**. No "#" in front of the rule:
````bash
*/30 * * * * /home/pbc/update_docker.sh >> /home/pbc/update.log 2>&1
````
Press `CTRL+X` and then `Y` and then `ENTER`.

This rule will make the script run and thereby check for available updates every 30 minutes.

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

## Check software version and uptime with your personal endpoint

Your node can only get registered as a block producer and participate in the committee if your host IP is reachable, and you are running the newest version of the Partisia software. 
Replace the letters in the URL below with the IP of the server hosting your node. This should navigate you to a page showing a JSON, with the following information:

http://PUBLIC_IP_OF_SERVER_HOSTING_THIS_NODE:9888/status


````json
{
versionIdentifier: "VERSION_NUMBER",  
uptime: number,
- knownPeersNetworkKeys: [listOfProducers],
  networkKey: "NETWORK_PUBLIC_KEY",
  blockchainAddress: "BLOCKCHAIN_ADDRESS"
````
You can see which version of Partisia software you are running. Uptime is measured in milliseconds, and show how long your server has been running uninterrupted.

If you cannot open your status endpoint there is probably a problem with the opening of ports of the VPS. See which ports are allowed through the firewall:   


````bash
sudo ufw status
````
Make sure you have opened for ports 9888-9897. If not consult instructions [here](operator-4-security.md).

## How to find and use metrics to measure performance

You should visit the metrics, where you can get important indicators of your node's performance. It is possible to see metrics for one shard, or for the whole chain, you can also see specifics of your node.

**Make the metrics give you the information you are looking for:**
In this example I will look at the latest 400 minutes on **Shard2**. Notice, that you add the time you wish to look back in the end of the URL, in this case 400 minutes. You can change shard number in the URL to see **Shard0** and **Shard1**. It takes about a day (1500 minutes) for all producers to have had their turn. If there are a lot of votes due to reset blocks, it can take longer.


<https://betareader.partisiablockchain.com/shards/Shard2/metrics/blocks/400>

In case of problems it makes sense  to look at each shard, because failures can be shard specific. And different tasks happen on different shards.

It is highly recommendable to use a json extension for your browser, or paste the text into an IDE, otherwise it might be quite difficult to read the json file.     
Explanation of the terms in the output follows below.
Your output should look like the ordered list you see here:   

````json
{
  earliestBlockProductionTime: 1651026257696,
  latestBlockProductionTime: 1651050197085,
  transactionCount: 1298,
  eventTransactionCount: 15,
  blockCount: 967,
  resetBlockCount: 1,
  committees: {
    2: {
      producers: {
        63: {
          blocksProduced: 42,
          medianFinalizationTime: 2704
        },
        65: {
          blocksProduced: 99,
          medianFinalizationTime: 2726
        },
        66: {
          blocksProduced: 100,
          medianFinalizationTime: 3056
        },
        67: {
          blocksProduced: 100,
          medianFinalizationTime: 2799.5
        },
        68: {
          blocksProduced: 100,
          medianFinalizationTime: 3035
        },
        69: {
          blocksProduced: 100,
          medianFinalizationTime: 3159
        },
        70: {
          blocksProduced: 100,
          medianFinalizationTime: 3061
        },
        71: {
          blocksProduced: 100,
          medianFinalizationTime: 2853
        },
        72: {
          blocksProduced: 100,
          medianFinalizationTime: 3259
        },
        73: {
          blocksProduced: 100,
          medianFinalizationTime: 3045
        },
        74: {
          blocksProduced: 25,
          medianFinalizationTime: 3572
        },
        -1: {
          blocksProduced: 1,
          medianFinalizationTime: -1
        }
      }
    }
  }
}
````
The index of your node on this list corresponds to the index of listed committee members [here](https://dashboard.partisiablockchain.com/info/consensus).   
**NB.** You index can change every time a new committee is formed. 

The number of blocks your node produced should be 100, unless a producer at the previous index was offline or did not finish producing their 100 blocks. If there is a quota of leftover blocks from the previous producer, they will be produced by your node minus one reset block to change current producer. So if the node before yours produced 20 blocks and then stopped, your node would optimally produce 79 blocks.


**resetBlockCount:**   
The first number to notice is *resetBlockCount*, this number is in our case different from zero, which means some nodes in the network have performed suboptimally. A node produces 100 blocks each time it is chosen as producer, unless it has to produce leftover blocks from a previous producer, or if one or more reset blocks have been used to skip offline producers.
We can see in the *resetBlockCount* that 1 reset blocks were produced. The reset block was caused by the producer with index 64 offline or misconfigured. The nodes with index 65 only produced 99 blocks because one reset block is expended when skipping the unavailable producer. The first and last producer on the list might look like they did not perform, but that is due to the time when we pull the list.

**medianFinalizationTime:**    
Each node has a *medianFinalizationTime*, the median time used by the node to produce a block. If this number is significantly higher for your node than the rest on the list. Then your node might have to weak hardware or something is causing the node to under perform.   

You can see blocks produced on the entire chain by modifying the URL:   

<https://betareader.partisiablockchain.com/metrics/blocks/400>

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
docker logs --since 1h pbc-betanet-reader | grep "Signing BlockState"
````

This will give you the blocks you have signed the last hour. You might also want to look for blocks you created when you were chosen as producer ``| grep "Created Block"``.