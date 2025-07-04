#!/bin/bash

echo "Unzip Consul agent..."
unzip local/consul.zip consul -d local/

echo "Starting Consul agent..."
chmod +x local/consul
local/consul agent -config=local/artifacts/cfg.consul.hcl