# Running a local Libra network using Docker

This short tutorial describes how to setup a local Libra network running 4 validator nodes, one minter node and one client node using Docker. It assumes that you have a Docker Desktop installed and running on your machine. It has been tested on macOS.

### Build the Docker images

Build the Libra validator, minter and client Docker images:
```
$ sh build.sh
```
This may take a while …

The build will require 40GB of disk space for building the validator, minter and client images, but also intermediate helper images. These images can be removed after the build has completed:
```
docker image prune
```
The remaining images should take 4GB of space.

### Run the Docker containers
Execute the following commands in separate Terminals.

1. Run the validator nodes:
   ```
   $ sh libra/docker/validator/run.sh 
   ```
1. Run the minter node, where `<IP>` is the public IP address of a validator (i.e. the public IP address of your machine running the validator Docker containers):
   ```
   $ sh libra/docker/mint/run.sh libra_mint:latest <IP> 30307 info
   ```
1. Run the client node:
   ```
   $ docker run --rm -it -e VALIDATOR_IP=<IP> --name libra_client libra_client_local
   ```

### Test your Libra network

Execute the following commands inside the client Docker container running the Libra CLI.

1. Confirm that we are running a fresh Libra chain by checking that there is only the genesis transaction
   ```
   libra% query tr 0 1 false
   ```
   This should return the genesis transaction, e.g.
   ```
   >> Getting committed transaction by range
   Transaction at version 0: SignedTransaction { 
     raw_txn: RawTransaction { 
       sender: 0000000000000000000000000000000000000000000000000000000000000000, 
       sequence_number: 0, 
       payload: { 
         transaction: genesis, 
         args: []
       }, 
       max_gas_amount: 0, 
       gas_unit_price: 0, 
       expiration_time: 18446744073709551615s, 
     }, 
     public_key: ..., 
     signature: Signature(...), 
   }
   ```
1. Now, let's try to get the next transaction
   ```
   libra% query tr 1 1 false
   ```
   This should return not return any transactions.
1. Create an account:
   ```
   libra% account create
   ```
1. Check that your account was created:
   ```
   libra% account list
   ```
   You should see a User account with index 0.
1. Check that the created account 0 has no Libra:
   ```
   libra% query balance 0
   ```
1. Mint 72 Libra to your account with index 0:
   ```
   libra% account mint 0 72
   ```
1. Check that the minted Libra was added to your account 0:
   ```
   libra% query balance 0
   ```
1. Stop all the Docker containers:
   ```
   docker stop $(docker ps -aq)
   ```
