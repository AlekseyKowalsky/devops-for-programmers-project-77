variable "do_token" {
  description = "Access token to Digital Ocean platform"
  sensitive = true
}

variable "datadog_api_key" {
  description = "API key of Datadog"
  sensitive = true
}

variable "datadog_app_key" {
  description = "App key of Datadog"
  sensitive = true
}


variable "path_to_store_server_ips" {
  description = "Path to a yaml file keeping IPs addresses of created servers"
  default = "../ansible/group_vars/all/server-ips.yaml"
  sensitive = false
}

variable "admin_email" {
  description = "Email to receive alerts and create certificates"
  default = "al.kowalsky7@gmail.com"
}

variable "domain_name" {
  description = "General domain name managing by cloud provider"
  default = "alekspaces.com"
}

variable "app_port" {
  description = "App port for forwarding traffic throughout the balancer to droplets"
  default = 3000
}