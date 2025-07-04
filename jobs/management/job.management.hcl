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
        destination = "local/artifacts/consul.zip"
        mode = "file"
        options {
          archive = true
          checksum = "sha256:fb53ea04f7deb97919417edda938b7f70f967840f2060158a157e9b130ce725e"
        }
      }

      template {
        destination = "local/start-consul-agent.sh"
        change_mode = "noop"
        data = <<EOF
#!/bin/sh
unzip local/artifacts/consul.zip consul -d local/artifacts
exec local/artifacts/consul agent -dev
    EOF
      }

      resources {
        cpu    = 100
        memory = 128
      }
    }
  }
}
