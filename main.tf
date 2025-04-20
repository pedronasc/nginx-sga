terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0.2"
    }
  }
}

provider "docker" {
  host = "unix:///var/run/docker.sock"
}

resource "docker_network" "traefik" {
  name = "traefik"
  #internal = false
}

resource "docker_image" "nginx_sga" {
  name = "nginx-sga:v1.0"
  build {
    context    = "."
    dockerfile = "dockerfile"
  }
}

resource "docker_container" "nginx_sga" {
  name  = "nginx-sga"
  image = docker_image.nginx_sga.image_id

  ports {
    internal = 80
    external = 8180
  }

  volumes {
    container_path = "/var/www/html/sga-web"
    host_path      = "/home/ubuntu/docker/nginx-sga/htm/sga-web"
  }

  volumes {
    container_path = "/etc/nginx/sites-available/default"
    host_path      = "/home/ubuntu/docker/nginx-sga/config/default.conf"
  }

  restart = "unless-stopped"

  labels {
    label = "traefik.http.routers.nginx-sga.rule"
    value = "Host(`sga-docker.unifev.corp.br`)"
  }

  labels {
    label = "traefik.http.routers.nginx-sga.entrypoints"
    value = "web"
  }

  # Bloco environment (corrigido)
  env = [
    "DEBIAN_FRONTEND=noninteractive",
    "LD_LIBRARY_PATH=/opt/oracle"
  ]

  networks_advanced {
    name = docker_network.traefik.name
  }
}
