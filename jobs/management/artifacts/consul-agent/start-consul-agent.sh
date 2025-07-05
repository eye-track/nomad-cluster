#!/bin/bash

echo "[START] Unzip Consul agent..."
unzip -o local/consul.zip consul -d local/
echo "[END] Unzip Consul agent"

echo "[START] Consul agent..."
chmod +x local/consul
local/consul agent -config-file=local/artifacts/cfg.consul.hcl
echo "[END] Consul agent"