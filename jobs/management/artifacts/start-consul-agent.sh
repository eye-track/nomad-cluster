unzip local/consul.zip consul -d local/
chmod +x local/consul
local/consul agent -config=local/artifacts/cfg.consul.hcl