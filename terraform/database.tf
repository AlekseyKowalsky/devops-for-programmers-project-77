resource "digitalocean_database_cluster" "postgres_cluster" {
  name       = "tfhexlet"
  engine     = "pg"
  version    = "15"
  size       = "db-s-1vcpu-1gb"
  region     = "fra1"
  node_count = 1
}

resource "digitalocean_database_db" "postgres_db" {
  cluster_id = digitalocean_database_cluster.postgres_cluster.id
  name       = "tfhexlet"
  depends_on = [digitalocean_database_cluster.postgres_cluster]
}

resource "digitalocean_database_user" "postgres_user" {
  cluster_id = digitalocean_database_cluster.postgres_cluster.id
  name       = "tfhexlet"
  depends_on = [digitalocean_database_cluster.postgres_cluster]
}