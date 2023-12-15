data "digitalocean_ssh_key" "key" {
  name = "Mac Pro 13"
}

resource "digitalocean_droplet" "web-1" {
  image  = "docker-20-04"
  name   = "tfhexlet-1"
  region = "fra1"
  size   = "s-1vcpu-1gb"

  ssh_keys = [data.digitalocean_ssh_key.key.id]
}

resource "digitalocean_droplet" "web-2" {
  image  = "docker-20-04"
  name   = "tfhexlet-2"
  region = "fra1"
  size   = "s-1vcpu-1gb"

  ssh_keys = [data.digitalocean_ssh_key.key.id]
}

resource "null_resource" "gen_yaml" {
  depends_on = [digitalocean_droplet.web-1, digitalocean_droplet.web-1]

  provisioner "local-exec" {
    command = "echo 'server_1_ip: ${digitalocean_droplet.web-1.ipv4_address}\nserver_2_ip: ${digitalocean_droplet.web-2.ipv4_address}' > ${var.path_to_store_server_ips}"
  }
}
