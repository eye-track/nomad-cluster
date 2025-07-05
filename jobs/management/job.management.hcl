job "management" {
  datacenters = ["dc1"]
  type        = "system"

  group "consul-agent" {
    task "start-consul-agent" {
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
        source      = "git::git@github.com:eye-track/nomad-cluster.git//jobs/management/artifacts/consul-agent"
        destination = "local/artifacts"
        options {
          sshkey = "${base64encode(file("/home/eye-track/.ssh/id_ed25519"))}"
          ref = "master"
          depth = 1
        }
      }

      resources {
        cpu    = 100
        memory = 128
      }
    }

    //task "stop-consul-agent" {
    //  lifecycle {
    //    hook = "poststop"
    //    sidecar = false
    //  }
    //
    //  driver = "exec"
    //  user = "eye-track"
    //
    //  config {
    //    command = "pkill"
    //    args = ["consul"]
    //  }
    //}
  }

  group "cni-plugin" {
    task "install-cni-plugin" {
      driver = "exec"

      config {
        command = "local/artifacts/install-cni-plugin.sh"
      }

      # Don't restart the task if it exits successfully
      restart {
        attempts = 0
        interval = "0s"
        delay    = "0s"
        mode     = "fail"
      }

      artifact {
        source      = "https://github.com/containernetworking/plugins/releases/download/v1.7.1/cni-plugins-linux-arm64-v1.7.1.tgz"
        destination = "local/cni-plugins.tgz"
        mode = "file"
        options {
          archive = true
          checksum = "sha256:119fcb508d1ac2149e49a550752f9cd64d023a1d70e189b59c476e4d2bf7c497"
        }
      }

      artifact {
        source      = "git::git@github.com:eye-track/nomad-cluster.git//jobs/management/artifacts/cni-plugin"
        destination = "local/artifacts"
        options {
          sshkey = "${base64encode(file("/home/eye-track/.ssh/id_ed25519"))}"
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
