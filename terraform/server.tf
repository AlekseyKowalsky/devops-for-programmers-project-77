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