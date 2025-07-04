datacenter = "dc1"
data_dir  = "local/consul-data"
node_name  = "consul-client-1"

# Network configuration
bind_addr    = "{{ GetInterfaceIP \"tun0\" }}"
client_addr  = "0.0.0.0"
advertise_addr = "{{ GetInterfaceIP \"tun0\" }}"

# This is a client agent
server = false

# Join an existing Consul server node
retry_join = ["10.10.1.143"]


encrypt = "FNEVe7g1bjMOvWnNjo78qw7uP76GfmkZ11+fheIpEYg="

tls {
  defaults {
    ca_file   = "/secrets/consul/consul-agent-ca.pem"
    cert_file = "/secrets/consul/dc1-client-consul-0.pem"
    key_file  = "/secrets/consul/dc1-client-consul-0-key.pem"
    verify_incoming = true
    verify_outgoing = true
  }
  # opzionale, per RPC interno
  internal_rpc {
    verify_server_hostname = true
  }
}

acl {
  tokens {
    default = "04a2d96c-438b-ffdf-b07a-eedb8763e9e4"
  }
}

ports {
  dns = 8600
}