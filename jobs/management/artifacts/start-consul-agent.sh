#!/bin/bash

echo "Unzip Consul agent..."
unzip local/consul.zip consul -d local/

echo "Starting Consul agent..."
chmod +x local/consul
#local/consul agent -config-file=local/artifacts/cfg.consul.hcl