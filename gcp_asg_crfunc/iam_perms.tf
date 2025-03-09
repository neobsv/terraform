# IAM entry for an SA to invoke the function
resource "google_cloudfunctions2_function_iam_member" "invoker" {
  project        = google_cloudfunctions2_function.deploy0.project
  location       = google_cloudfunctions2_function.deploy0.location
  cloud_function = google_cloudfunctions2_function.deploy0.name
  role           = "roles/cloudfunctions.invoker"
  member         = "serviceAccount:${google_service_account.default.email}"

  depends_on = [google_cloudfunctions2_function.deploy0]
}

resource "google_cloud_run_service_iam_member" "cloud_run_invoker" {
  project  = google_cloudfunctions2_function.deploy0.project
  location = google_cloudfunctions2_function.deploy0.location
  service  = google_cloudfunctions2_function.deploy0.name
  role     = "roles/run.invoker"
  member   = "serviceAccount:${google_service_account.default.email}"

  depends_on = [google_cloudfunctions2_function.deploy0]
}
