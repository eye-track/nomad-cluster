job "management" {
  datacenters = ["dc1"]
  type        = "system"

  group "init-node" {
    task "consul-agent" {
      driver = "exec"

      config {
        command = "local/start-consul-agent.sh"
      }

      artifact {
        source      = "https://releases.hashicorp.com/consul/1.21.2/consul_1.21.2_linux_arm64.zip"
        destination = "local/consul"
        options {
          archive = true
          checksum = "fb53ea04f7deb97919417edda938b7f70f967840f2060158a157e9b130ce725e"
        }
      }

      artifact {
        source      = "git::https://github.com/eye-track/nomad-cluster.git//jobs/management/artifacts/start-consul-agent.sh"
        destination = "local/start-consul-agent.sh"
        options {
          ref = "master"
          depth = 1
        }
      }

      artifact {
         source      = "git::https://github.com/eye-track/nomad-cluster.git//jobs/management/artifacts/cfg.consul.hcl"
         destination = "local/cfg.consul.hcl"
         options {
          ref = "master"
          depth = 1
        }
      }

      resources {
        cpu    = 100
        memory = 128
      }
    }
  }
}
