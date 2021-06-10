# Node operator

To run a PBC node you need a private key, the genesis state and the Docker image containing the application.  The minimal technical requirements are:

* Quad-core CPU
* 8 GB RAM
* 40 GB SSD
* Docker or compatible container runtime
* Publicly accessible IP with port `9990` open

You also need to know the address of at least one peer on the network and the `genesis.json` for said network.

## Starting a node

The main executable expects a path to the configuration json, the genesis json and to the storage folder. Since the code is running in a container you either need to map appropriate folders into the container or use the built-in volumes.

Assuming the following folder structure:

````
conf/
  - config.json
  - genesis.json

storage/
````

You can then run:

````bash
docker run -it --rm                                                      \
        --name pbc-node                                                  \
        -v "${PWD}/conf:/conf"                                           \
        -v "${PWD}/storage:/storage"                                     \
        registry.gitlab.com/privacyblockchain/demo/betanet-public:latest \
        conf/config.json conf/genesis.json /storage
````

## Logs and storage

The logs of the node are written to the standard output of the container and are therefore managed using the tools provided by your container runtime.

The storage of the node is based on RocksDB. It is write-heavy and will increase in size for the foreseeable future. How much is read and written is entirely dependent on the traffic on the network.

## Updating

Updates of the PBC node are not breaking unless explicitly stated. You update the software by pulling the newest image and recreating the container.

If you are using Docker you run:

````bash
docker pull registry.gitlab.com/privacyblockchain/demo/betanet-public:latest 
````

The newest version of the PBC node container image should now be on your system. You can then restart the container as described in the *Starting a node* section above.