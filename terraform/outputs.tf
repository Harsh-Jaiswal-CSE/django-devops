output "gke_name" {
  value = google_container_cluster.primary.name
}

output "repo_url" {
  value = google_artifact_registry_repository.django_repo.repository_id
}

output "db_instance" {
  value = google_sql_database_instance.postgres.connection_name
}

output "redis_host" {
  value = google_redis_instance.redis.host
}


output "bucket_name" {
  value = google_storage_bucket.bucket.name
}

output "gsa_email" {
  value = google_service_account.django_gsa.email
}
