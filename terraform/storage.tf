# Create GCS bucket
resource "google_storage_bucket" "bucket" {
  name     = "${var.project_id}-django-bucket"
  location = var.region
}

# Create a service account for Django app
resource "google_service_account" "django_sa" {
  account_id   = "django-sa"
  display_name = "Django Service Account"
  project      = var.project_id
}

# Grant the service account permission to read/write objects in the bucket
resource "google_storage_bucket_iam_member" "bucket_writer" {
  bucket = google_storage_bucket.bucket.name
  role   = "roles/storage.objectAdmin"
  member = "serviceAccount:${google_service_account.django_sa.email}"
}
