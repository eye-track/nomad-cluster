#!/bin/bash

echo "Unzip Consul agent..."
unzip -o local/consul.zip consul -d local/

echo "Starting Consul agent..."
cat /home/eye-track/consul_agent/certs/consul-agent-ca.pem
chmod +x local/consul
#local/consul agent -config-file=local/artifacts/cfg.consul.hcl
while true; do echo "Still running..."; sleep 60; done