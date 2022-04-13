# Node health and maintenance

This section covers how to:

- Update your node   
- Implement automatic updates   
- Check your IP accessibility and version of Partisia Software   
- Using metrics   
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

## Automatic update

Derive from this: https://discord.com/channels/819902335567265792/826622883614818384/899973806922285066

## Logs and storage

The logs of the node are written to the standard output of the container and are therefore managed using the tools provided by Docker. You can read about configuring Docker logs [here](https://docs.docker.com/config/containers/logging/configure/).

The storage of the node is based on RocksDB. It is write-heavy and will increase in size for the foreseeable future. The number and size of reads and writes is entirely dependent on the traffic on the network.
