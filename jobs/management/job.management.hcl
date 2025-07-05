job "management" {
  datacenters = ["dc1"]
  type        = "system"

  group "install-deps" {
    task "install-deps" {
      driver = "raw_exec"

      config {
        command = "local/artifacts/install-deps.sh"
      }

      # Don't restart the task if it exits successfully
      restart {
        attempts = 0
        interval = "0s"
        delay    = "0s"
        mode     = "fail"
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
        source      = "https://github.com/containernetworking/plugins/releases/download/v1.7.1/cni-plugins-linux-arm64-v1.7.1.tgz"
        destination = "local/cni-plugins.tgz"
        mode = "file"
        options {
          archive = true
          checksum = "sha256:119fcb508d1ac2149e49a550752f9cd64d023a1d70e189b59c476e4d2bf7c497"
        }
      }

      artifact {
        source      = "curl -O https://releases.hashicorp.com/consul-cni/1.7.2/consul-cni_1.7.2_linux_arm64.zip"
        destination = "local/consul-cni.zip"
        mode = "file"
        options {
          archive = true
          checksum = "sha256:a39935a82c3c9aabeaa32ef093876fd58ff3b0e5d16a89535521c4865ccf0e10"
        }
      }

      artifact {
        source      = "git::git@github.com:eye-track/nomad-cluster.git//jobs/management/artifacts/install-deps"
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

  group "consul-agent" {
    task "start-consul-agent" {
      driver = "exec"

      config {
        command = "agent"
        args = ["-config-file=/local/artifacts/cfg.consul.hcl"]
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
}
