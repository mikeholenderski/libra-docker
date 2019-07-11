#!/bin/sh

# clone the libra repository
git clone https://github.com/libra/libra.git
cd libra

# build the Libra validator Docker image
docker build -f ./docker/validator/validator.Dockerfile -t libra_e2e .

# build the Libra minter Docker image
docker build -f ./docker/mint/mint.Dockerfile -t libra_mint .

# build the Libra client Docker image for connecting to the testnet
docker build -f ./docker/client/client.Dockerfile -t libra_client_testnet .

# build the Libra client Docker image for connecting to the local validator nodes
# (it is based on the libra_client_testnet image generated above)
cd ..
docker build -t libra_client_local .
