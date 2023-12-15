variable "do_token" {
  description = "Access token to Digital Ocean platform"
  sensitive = true
}

variable "path_to_store_server_ips" {
  description = "Path to a yaml file keeping IPs addresses of created servers"
  default = "../ansible/group_vars/all/server-ips.yaml"
  sensitive = false
}