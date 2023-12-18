terraform {
  backend "remote" {
    hostname     = "app.terraform.io"
    organization = "alekspaces"
    workspaces {
      name = "hexlet-terraform"
    }
  }
}