# Node health and maintenance

This section covers how to:

- Update your node   
- Implement automatic updates   
- Check your IP accessibility and version of Partisia Software   
- Metrics of node performance   
- Interpret log messages and debugging problems  



## Updating

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

First you change the directory to where you put your `docker-compose.yml` file. You then pull the newest image and start it again. You should now be running the newest version of the software.

## Get automatic updates

To setup automatic updates you will need Cron, which is a time based job scheduler. See if you have the Cron package installed:

````bash
dpkg -l cron
````

If not:   

````bash
apt-get install cron
````

Now you are ready to start.

**1. Create the auto update script:**

Go to the directory where `docker-compose.yml` is located, in this guide we assume you are using `~/pbc`.

````bash
cd ~/pbc
````

Open the file in nano:

````bash
sudo nano update_docker.sh
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
sudo chmod +x update_docker.sh
````

Type ``ls`` and confirm *update_docker.sh*  file name is shown in green, that means it is now executable.

**3. Set update frequency to 30 minutes:**

````bash
crontab -e
````
This will let you chose your preferred text editor.

````bash
 */30 * * * * /home/update_docker.sh >> /home/update.log 2>&1
````
This rule will make the script run and thereby check for available updates every 30 minutes.

To see if the script is working you can read the update log with the *cat command*

````bash
cat update.log
````

If your version is up-to-date, you should see:   
````
yourContainerName is up-to-date
````
If you are currently updating you should see:
````
Pulling pbc-betanet-reader ... pulling from privacyblockchain/de...
````
**NB.** Never include a shutdown command in your update script, otherwise your node will go offline every time checks for updates.
## Your personal status endpoint

http://yourHostIP:9888/status

Replace the letters in the URL with the IP of the server hosting your node. This should navigate you to a page showing a JSON, with the following information:

````json
{
versionIdentifier: "versionNumber",  
uptime: number,
- knownPeersNetworkKeys: [listOfProducers],
  networkKey: "yourNetworkPublicKey",
  blockchainAddress: "blockchainAddress"
````
You can see which version of Partisia software you are running. Uptime is measured in milliseconds, and show how long your IP has been reachable uninterrupted.

If you cannot open your status endpoint there is probably a problem with the opening of ports of the VPS. See which ports are allowed through the firewall:   


````bash
sudo ufw status
````
Make sure you have opened for ports 9888-9897. If not consult instructions [here](operator-4-security.md).

## Metrics of node performance

You should visit the metrics, where you can get important indicators of your node's performance. It is possible to see metrics for one shard, or for the whole chain, you can also see specifics of your node.

In this example I will look at the latest 11 hours on **Shard1**. Notice I add the time I wish to look back in the end of the URL, in this case 660 minutes. You can change shard number in the URL to see **Shard0** and **Shard2**

https://betareader.partisiablockchain.com/shards/Shard1/metrics/blocks/660

It is highly recommendable to use a json extension for your browser, or paste the text into an IDE, otherwise it might be quite difficult to read the json file.     

**resetBlockCount:**   
The first number to notice is *resetBlockCount*, this number is in our case different from zero, which means some nodes in the network have performed suboptimally. A node produces 100 blocks each time it is chosen as producer, unless it has to produce leftover blocks from a previous producer, or if one or more reset blocks have been used to skip offline producers.
We can see in the *resetBlockCount* that 2 reset blocks were produced. They were caused by producers with index 10 and 18 being offline or misconfigured. The nodes with index 11 and 19 only produced 99 blocks because one reset block is expended when skipping the unavailable producer. The first and last producer on the list might look like they did not perform, but that is due to the time when we pull the list.    

**medianFinalizationTime:**    
Each node has a *medianFinalizationTime*, the median time used by the node to produce a block. If this number is significantly higher for your node than the rest on the list. Then your node might have to weak hardware or something is causing the node to under perform.   

````json
{
  earliestBlockProductionTime: 1650838645989,
  latestBlockProductionTime: 1650878219379,
  transactionCount: 1973,
  eventTransactionCount: 3723,
  blockCount: 1667,
  resetBlockCount: 2,
  committees: {
    2: {
      producers: {
        8: {
          blocksProduced: 26,
          medianFinalizationTime: -1
        },
        9: {
          blocksProduced: 100,
          medianFinalizationTime: 3647
        },
        11: {
          blocksProduced: 99,
          medianFinalizationTime: 2491.5
        },
        12: {
          blocksProduced: 100,
          medianFinalizationTime: 2938.5
        },
        13: {
          blocksProduced: 100,
          medianFinalizationTime: 2801
        },
        14: {
          blocksProduced: 100,
          medianFinalizationTime: 2904
        },
        15: {
          blocksProduced: 100,
          medianFinalizationTime: 2676.5
        },
        16: {
          blocksProduced: 100,
          medianFinalizationTime: 4083.5
        },
        17: {
          blocksProduced: 100,
          medianFinalizationTime: 3326
        },
        19: {
          blocksProduced: 99,
          medianFinalizationTime: 2884.5
        },
        20: {
          blocksProduced: 100,
          medianFinalizationTime: 3506
        },
        21: {
          blocksProduced: 100,
          medianFinalizationTime: 3339.5
        },
        22: {
          blocksProduced: 100,
          medianFinalizationTime: 3536
        },
        23: {
          blocksProduced: 100,
          medianFinalizationTime: 3336.5
        },
        24: {
          blocksProduced: 100,
          medianFinalizationTime: 2943
        },
        25: {
          blocksProduced: 100,
          medianFinalizationTime: 3887
        },
        26: {
          blocksProduced: 100,
          medianFinalizationTime: 3618
        },
        27: {
          blocksProduced: 41,
          medianFinalizationTime: 3297
        },
        -1: {
          blocksProduced: 2,
          medianFinalizationTime: -1
        }
      }
    }
  }
}
````

You can see blocks produced on the entire chain:   

https://betareader.partisiablockchain.com/metrics/blocks/660

But in case of problems it makes sense  to look at each shard, because failures can be shard specific. And different tasks happen on different shards.

## Logs and storage

The logs of the node are written to the standard output of the container and are therefore managed using the tools provided by Docker. You can read about configuring Docker logs [here](https://docs.docker.com/config/containers/logging/configure/).

The storage of the node is based on RocksDB. It is write-heavy and will increase in size for the foreseeable future. The number and size of reads and writes is entirely dependent on the traffic on the network.

### Common log messages

**Signing** - All is well.   
**Not signing as shutdown is active** - You may assume all is well. Shutdown happens when chosen producer fails to produce a block, a reset block is made, and then a new node is chosen for the role of producer.   
**Not signing** - This is not a good sign, you are not signing blocks. First, check if you are on the list of [current committee members](https://mpcexplorer.com/validators), if you are not and you have already filled out the survey, then you need to notify us so we can update betanet and have you added. If you are on the list and still get “Not signing” then you almost certainly have some problem in your config.json Probably you have a wrong or no key in one of the fields: networkKey, accountKey or finalizationKey.   
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