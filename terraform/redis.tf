resource "google_redis_instance" "redis" {
  name                    = "django-redis"
  tier                    = "STANDARD_HA"
  memory_size_gb          = 1
  location_id             = "asia-south1-a"       # primary zone
  alternative_location_id = "asia-south1-b"       # secondary zone in same region
  project                 = var.project_id

  authorized_network = "projects/${var.project_id}/global/networks/default"
  redis_version      = "REDIS_7_2"
  display_name       = "django-redis"

  depends_on = [google_service_networking_connection.private_vpc_connection]
}

