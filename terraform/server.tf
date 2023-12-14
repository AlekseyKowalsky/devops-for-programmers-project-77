resource "digitalocean_droplet" "web-1" {
  image  = "docker-20-04"
  name   = "tfhexlet-1"
  region = "fra1"
  size   = "s-1vcpu-1gb"
}

resource "digitalocean_droplet" "web-2" {
  image  = "docker-20-04"
  name   = "tfhexlet-2"
  region = "fra1"
  size   = "s-1vcpu-1gb"
}

output "web-1-ip" {
  value = digitalocean_droplet.web-1.ipv4_address
}

output "web-2-ip" {
  value = digitalocean_droplet.web-2.ipv4_address
}