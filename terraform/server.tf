data "digitalocean_ssh_key" "key" {
  name = "Mac Pro 13"
}

variable "droplet_count" {
  description = "Number of droplets to create"
  default     = 2
}

resource "digitalocean_droplet" "web" {
  count = var.droplet_count

  image  = "docker-20-04"
  name   = "tfhexlet-${count.index + 1}"
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

resource "terraform_data" "formatted_ips" {
  depends_on = [digitalocean_droplet.web]

  input = join("\n", formatlist("server_%d_ip: %s", range(1, var.droplet_count + 1), digitalocean_droplet.web.*.ipv4_address))
}

resource "null_resource" "gen_yaml" {
  depends_on = [digitalocean_droplet.web]

  provisioner "local-exec" {
    command = "echo '${terraform_data.formatted_ips.input}' > ${var.path_to_store_server_ips}"
  }
}
