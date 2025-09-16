resource "google_container_cluster" "primary" {
  name     = "django-celery-cluster"
  location = var.region

  enable_autopilot = true
}
