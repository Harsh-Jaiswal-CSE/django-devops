# Django Google Service Account
resource "google_service_account" "django_gsa" {
  account_id   = "django-gsa"
  display_name = "Django GSA"
  project      = var.project_id
}

# Allow Django to read/write to GCS
resource "google_project_iam_binding" "storage" {
  project = var.project_id
  role    = "roles/storage.objectAdmin"
  members = [
    "serviceAccount:${google_service_account.django_gsa.email}"
  ]
}

# Allow Django to connect to Cloud SQL
resource "google_project_iam_binding" "sql" {
  project = var.project_id
  role    = "roles/cloudsql.client"
  members = [
    "serviceAccount:${google_service_account.django_gsa.email}"
  ]
}

# Bind GCP Service Account to Kubernetes Service Account (Workload Identity)
resource "google_service_account_iam_binding" "workload_identity_binding" {
  service_account_id = google_service_account.django_gsa.name
  role               = "roles/iam.workloadIdentityUser"
  members = [
    "serviceAccount:${var.project_id}.svc.id.goog[default/django-k8s-sa]"
  ]
}
