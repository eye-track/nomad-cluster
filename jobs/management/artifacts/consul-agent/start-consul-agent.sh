#!/bin/bash

echo "Unzip Consul agent..."
unzip -o local/consul.zip consul -d local/

echo "Start Consul agent..."
chmod +x local/consul
local/consul agent -config-file=local/artifacts/cfg.consul.hcl