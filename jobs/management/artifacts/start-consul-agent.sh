echo "Unzip Consul agent..."
unzip local/consul.zip consul -d local/

echo "Starting Consul agent..."
exec local/consul agent -config=local/artifacts/cfg.consul.hcl