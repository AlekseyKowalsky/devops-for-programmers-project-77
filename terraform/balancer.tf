resource "tls_private_key" "private_key" {
  algorithm = "RSA"
}

resource "acme_registration" "reg" {
  account_key_pem = tls_private_key.private_key.private_key_pem
  email_address   = var.admin_email
}

resource "acme_certificate" "cert" {
  account_key_pem = acme_registration.reg.account_key_pem
  common_name     = var.domain_name

  dns_challenge {
    provider = "digitalocean"

    config = {
      DO_AUTH_TOKEN = var.do_token
    }
  }
}

resource "digitalocean_certificate" "cert" {
  name             = "cert"
  type             = "custom"
  private_key      = acme_certificate.cert.private_key_pem
  leaf_certificate = acme_certificate.cert.certificate_pem

  lifecycle {
    create_before_destroy = true
  }
}

resource "digitalocean_loadbalancer" "balancer" {
  name   = "tfhexlet"
  region = "fra1"

  forwarding_rule {
    entry_protocol   = "https"
    entry_port       = 443
    target_protocol  = "http"
    target_port      = var.app_port
    certificate_name = digitalocean_certificate.cert.name
  }

  healthcheck {
    port     = 22
    protocol = "tcp"
  }

  droplet_ids = [for droplet in digitalocean_droplet.web : droplet.id]
}

resource "digitalocean_record" "lb_dns" {
  domain = var.domain_name
  type   = "A"
  name   = "@"
  value  = digitalocean_loadbalancer.balancer.ip
  ttl    = 3600
}