# Reserve an internal IP range for private services
resource "google_compute_global_address" "private_ip_alloc" {
  name          = "private-ip-range"
  purpose       = "VPC_PEERING"
  address_type  = "INTERNAL"
  prefix_length = 16
  network       = "projects/${var.project_id}/global/networks/default"
}

# Create private VPC connection for Cloud SQL
resource "google_service_networking_connection" "private_vpc_connection" {
  network                 = "projects/${var.project_id}/global/networks/default"
  service                 = "servicenetworking.googleapis.com"
  reserved_peering_ranges = [google_compute_global_address.private_ip_alloc.name]
}

resource "google_sql_database_instance" "postgres" {
  name             = "postgres-instance"
  database_version = "POSTGRES_17"
  region           = var.region
  project          = var.project_id

  depends_on = [google_service_networking_connection.private_vpc_connection]

  settings {
    tier = "db-perf-optimized-N-2" # ✅ valid tier

    ip_configuration {
      ipv4_enabled    = false
      private_network = "projects/${var.project_id}/global/networks/default"
    }
  }
}


# Create a database inside the instance
resource "google_sql_database" "app_db" {
  name     = "main_db"
  instance = google_sql_database_instance.postgres.name
  project  = var.project_id
}

# Create a database user
resource "google_sql_user" "app_user" {
  name     = "django_user"
  instance = google_sql_database_instance.postgres.name
  project  = var.project_id
  password = var.db_password
}

output "db_instance_connection_name" {
  value = google_sql_database_instance.postgres.connection_name
}

output "db_name" {
  value = google_sql_database.app_db.name
}

output "db_user" {
  value = google_sql_user.app_user.name
}

output "db_password" {
  value     = var.db_password
  sensitive = true
}
