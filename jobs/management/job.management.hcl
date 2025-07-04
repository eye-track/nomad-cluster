job "management" {
  datacenters = ["dc1"]
  type        = "system"

  group "init-node" {
    volume "secrets-vol" {
      type = "host"
      source = "secrets-vol"
      read_only = false
    }

    task "consul-agent" {
      driver = "exec"

      config {
        command = "local/artifacts/start-consul-agent.sh"
      }

      artifact {
        source      = "https://releases.hashicorp.com/consul/1.21.2/consul_1.21.2_linux_arm64.zip"
        destination = "local/consul.zip"
        mode = "file"
        options {
          archive = true
          checksum = "sha256:fb53ea04f7deb97919417edda938b7f70f967840f2060158a157e9b130ce725e"
        }
      }

      artifact {
        source      = "git::git@github.com:eye-track/nomad-cluster.git//jobs/management/artifacts"
        destination = "local/artifacts"
        options {
          sshkey = "${base64encode(file("/home/eye-track/.ssh/id_ed25519"))}"
          ref = "master"
          depth = 1
        }
      }

      artifact {
        source      = "file::/home/eye-track/consul_agent/certs"
        destination = "local/certs"
      }
      
      volume_mount {
        volume      = "secrets-vol"
        destination = "secrets"
      }

      resources {
        cpu    = 100
        memory = 128
      }
    }
  }
}
