resource "google_artifact_registry_repository" "django_repo" {
  project       = var.project_id
  location      = var.region
  repository_id = "django-repo"
  format        = "DOCKER"
}

output "artifact_registry_repo" {
  value = google_artifact_registry_repository.django_repo.repository_id
}

output "artifact_registry_url" {
  value = "${var.region}-docker.pkg.dev/${var.project_id}/${google_artifact_registry_repository.django_repo.repository_id}"
}



