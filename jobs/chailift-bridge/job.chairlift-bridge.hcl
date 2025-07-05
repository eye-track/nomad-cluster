job "SKSTR/ARE/VI02" {
  datacenters = ["dc1"]
  type        = "service"

  group "SKSTR/ARE/VI02" {
    network {
      mode = "bridge"

      # Ports
      port "inference-server-webapp" {
        to = 5000
      }

      port "inference-server-http" {
        to = 8000
      }

      port "inference-server-grpc" {
        to = 8001 
      }
      
      port "broadcaster-webapp" {
        static = 8091
      }

      port "broadcaster-message_broker" {}

      port "chairlift-webapp" {
        static = 8090
      }

      port "chairlift-message_broker" {
        static = 5673
        to = 5673
      }

      port "streamer-webapp" {
        static = 8092
        to = 8092
      }

      port "streamer-rtsp" {
        static = 8560
        to = 8560
      }
    }

    # Volumes
    volume "source-videos-vol" {
      type = "host"
      source = "source-videos-vol"
      read_only = true
    }

    volume "configuration-vol" {
      type = "host"
      source = "configuration-vol"
      read_only = true
    }

    volume "inference-server-vol" {
      type = "host"
      source = "inference-server-vol"
      read_only = false
    }

    volume "secrets-vol" {
      type = "host"
      source = "secrets-vol"
      read_only = false
    }

    task "broadcaster" {
      driver = "docker"
      config {
        image        = "565688099982.dkr.ecr.eu-west-1.amazonaws.com/streaming/broadcaster:git-sha-dev-bdcc9beb62d05f9288092448607967f2b5cae9f5"
        command      = "/local/config.json"
        ports        = ["broadcaster-webapp", "broadcaster-message_broker"]
      }
    
      volume_mount {
        volume      = "source-videos-vol"
        destination = "/source"
      }

      service {
        name = "broadcaster"
        provider = "consul"
        port = "broadcaster-webapp"
        tags = ["webapp"]
        check {
          type     = "http"
          path     = "/monitoring/health"
          interval = "10s"
          timeout  = "2s"
        }
      }

      service {
        name = "broadcaster"
        provider = "consul"
        port = "broadcaster-message_broker"
        tags = ["message_broker"]
      }

      template {
        destination = "local/config.json"
        change_mode = "restart"
        change_signal = "SIGINT"
        data = <<EOF
{{- $service := env "NOMAD_TASK_NAME" -}}
{{- $plant := env "NOMAD_JOB_NAME" -}}
{{- $prefix := print "chairlift/staging/" $service "/" $plant -}}
{{- tree $prefix | explode | toJSONPretty -}}
EOF
      }
    }

    //task "output_controller" {
    //  driver = "docker"
    //  config {
    //    image   = "565688099982.dkr.ecr.eu-west-1.amazonaws.com/safety/output_controller:git-sha-dev-60596f9f5e79c8a3775e108b3c692c6ee8ade672"
    //    ports   = ["output"]
    //    command = "/etc/configuration.json 8069"
    //    volumes = ["/home/eye-track/repos/chairlift_sit/microservices/configuration/configuration_output_controller.json:/etc/configuration.json"]
    //  }
    //}

    task "chairlift" {
      driver = "docker"
      config {
        image   = "565688099982.dkr.ecr.eu-west-1.amazonaws.com/chairlift/base:git-sha-dev-c6aeeed321616fe4bb954b3277903c060681f4ac"
        command = "/local/config.json"
        ports   = ["chairlift-webapp", "chairlift-message_broker"]
      }
    
      env {
        INFER_SERVER_HOSTNAME = "localhost"
      }

      resources {
        memory = 2000 # MB
      }

      service {
        name = "chairlift"
        provider = "consul"
        port = "chairlift-webapp"
        tags = ["webapp"]
        check {
          type     = "http"
          path     = "/monitoring/health"
          interval = "10s"
          timeout  = "2s"
        }
      }
    
      service {
        name = "chairlift"
        provider = "consul"
        port = "chairlift-message_broker"
        tags = ["message_broker"]
      }

      template {
        destination = "local/config.json"
        change_mode = "restart"
        change_signal = "SIGINT"
        data = <<EOF
{{- $service := env "NOMAD_TASK_NAME" -}}
{{- $plant := env "NOMAD_JOB_NAME" -}}
{{- $prefix := print "chairlift/staging/" $service "/" $plant -}}
{{- tree $prefix | explode | toJSONPretty -}}
EOF
      }
    }

    task "inference_server" {
      driver = "docker"
      config {
        image   = "565688099982.dkr.ecr.eu-west-1.amazonaws.com/inference-server/base:1.1.0"
        ports   = ["inference-server-webapp", "inference-server-http", "inference-server-grpc"]
      }
    
      volume_mount {
        volume      = "inference-server-vol"
        destination = "/mnt"
      }
    
      volume_mount {
        volume      = "secrets-vol"
        destination = "/run/secrets"
      }
    
      env {
        JETSON_P_NUMBER = "p3767-0000" # jetson_release | grep -oP 'P-Number.*?\Kp\d{4}-\d{4}'
      }
    
      resources {
        cpu = 10000
        memory = 6000 # MB
      }
    
      service {
        name = "inference-server"
        provider = "consul"
        port = "inference-server-webapp"
        tags = ["webapp"]
        check {
          type     = "http"
          path     = "/health"
          interval = "10s"
          timeout  = "2s"
        }
      }
    
      service {
        name = "inference-server"
        provider = "consul"
        port = "inference-server-grpc"
        tags = ["grpc"]
      }
    }


    //task "annotator" {
    //  driver = "docker"
    //  config {
    //    image   = "light-speed/annotator:latest"
    //    ports   = ["annotator"]
    //    command = "/etc/configuration.json"
    //    volumes = ["/home/eye-track/repos/chairlift_sit/microservices/configuration/configuration_annotator.json:/etc/configuration.json"]
    //  }
    //  service {
    //    name = "annotator"
    //    port = "annotator"
    //    check {
    //      type     = "http"
    //      path     = "/monitoring/health"
    //      interval = "10s"
    //      timeout  = "2s"
    //    }
    //  }
    //}

    task "streamer" {
      driver = "docker"
      config {
        image        = "565688099982.dkr.ecr.eu-west-1.amazonaws.com/streaming/streamer:git-sha-dev-d01ac0ee19592984ac178e97fe3cdcfdc1aa239f"
        command      = "/etc/config/configuration_streamer.json"
        ports        = ["streamer-webapp", "streamer-rtsp"]
      }
      
      volume_mount {
        volume      = "configuration-vol"
        destination = "/etc/config"
      }

      service {
        name = "streamer"
        provider = "consul"
        port = "streamer-webapp"
        tags = ["webapp"]
        check {
          type     = "http"
          path     = "/monitoring/health"
          interval = "10s"
          timeout  = "2s"
        }
      }

      service {
        name = "streamer"
        provider = "consul"
        port = "streamer-rtsp"
        tags = ["rtsp"]
      }

      template {
        destination = "local/config.json"
        change_mode = "restart"
        change_signal = "SIGINT"
        data = <<EOF
{{- $service := env "NOMAD_TASK_NAME" -}}
{{- $plant := env "NOMAD_JOB_NAME" -}}
{{- $prefix := print "chairlift/staging/" $service "/" $plant -}}
{{- tree $prefix | explode | toJSONPretty -}}
EOF
      }
    }
  }
}
