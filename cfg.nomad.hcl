# Set log level
log_level = "INFO"

# Optional: set the data directory (default: /tmp/Nomad)
data_dir  = "/home/eye-track/nomad/data/nomad"

# which interface/IP to listen for incoming connections.
bind_addr = "0.0.0.0"

# which IP to share with other nodes (for HTTP, RPC, Serf).
advertise = {
  http = "{{ GetInterfaceIP \"tun0\" }}"
  rpc = "{{ GetInterfaceIP \"tun0\" }}"
  serf = "{{ GetInterfaceIP \"tun0\" }}"
}

server {
  enabled          = true
  bootstrap_expect = 1
}

client {
  enabled = true

  network_interface = "tun0"
  #cni_path = "/opt/cni/bin"   # path where CNI plugins were installed

  options = {
    "driver.raw_exec.enable" = "1"
  }
  
  host_volume "source-videos-vol" {
    path      = "/home/eye-track/nomad/chairlift-microservices/data/Skistar_Are"
    read_only = false
  }

  host_volume "configuration-vol" {
    path      = "/home/eye-track/nomad/chairlift-microservices/only-edge"
    read_only = false
  }

  host_volume "inference-server-vol" {
    path      = "/home/eye-track/inference_server"
    read_only = false
  }

  host_volume "secrets-vol" {
    path      = "/home/eye-track/nomad/chairlift-microservices/secrets"
    read_only = false
  }

  //meta {
  //  home_dir = "/home/youruser"
  //}
}

consul {
  address = "127.0.0.1:8500"
  auto_advertise = true
  server_service_name = "nomad-server"
  client_service_name = "nomad-client"
  token = "04a2d96c-438b-ffdf-b07a-eedb8763e9e4"
}

plugin "docker" {
  config {
    auth {
      config = "/home/eye-track/.docker/config.json"
    }

    volumes {
      enabled = true
    }

    gc {
      image       = true  # Defaults to true. Changing this to false will prevent Nomad from removing images from stopped tasks.
      image_delay = "3m"
    }
  }
}