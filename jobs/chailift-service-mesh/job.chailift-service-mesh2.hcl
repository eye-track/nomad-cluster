job "sample-service" {
  datacenters = ["dc1"]
  
  group "service" {
    network {
      mode = "bridge"
      port "http" {
        to = 8080
      }
    }
    
    service {
      name = "sample"
      port = "http"
      
      connect {
        sidecar_service {
          proxy {
            upstreams {
              destination_name = "database"
              local_bind_port  = 5432
            }
          }
        }
      }
      
      check {
        type     = "http"
        path     = "/health"
        interval = "10s"
        timeout  = "2s"
      }
    }
    
    task "app" {
      driver = "docker"
      
      config {
        image = "our-sample-service:latest"
        ports = ["http"]
      }
      
      env {
        DB_HOST = "localhost"
        DB_PORT = "5432"
      }
    }
  }
}