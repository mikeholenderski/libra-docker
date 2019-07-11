FROM libra_client_testnet

# use the trusted_peers.config.toml.local with the peers for the local 
COPY libra/terraform/validator-sets/dev/trusted_peers.config.toml /opt/libra/etc/trusted_peers.config.toml

ENTRYPOINT /opt/libra/bin/libra_client -s /opt/libra/etc/trusted_peers.config.toml -f $VALIDATOR_IP:8000 --host $VALIDATOR_IP --port 30307
