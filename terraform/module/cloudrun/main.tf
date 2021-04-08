resource "google_cloud_run_service" "app" {
  name     = "${var.sys_name}-${var.env}-app"
  location = var.region
  autogenerate_revision_name = true
  template {
    spec {
      containers {
        image = "gcr.io/cloudrun/hello"
        env {
          name = "RAILS_ENV"
          value = var.env
        }
        env {
          name = "RAILS_DB_HOST"
          value = var.db_host
        }
        env {
          name = "RAILS_DB_PASSWORD"
          value = var.db_user_pass
        }
        resources {
          limits = {
            "memory" : var.app_memory
            "cpu"    : var.app_cpu
          }
        }
      }
    }
    metadata {
      annotations = {
        "run.googleapis.com/client-name"          = "terraform"
        "run.googleapis.com/cloudsql-instances"   = var.db_conn_name
        "run.googleapis.com/vpc-access-connector" = var.sva_conn_name
      }
    }
  }
  lifecycle {
    ignore_changes = [
      template[0].spec[0].service_account_name,
      template[0].spec[0].containers[0].image,
      template[0].spec[0].containers[0].env,
      template[0].metadata,
    ]
  }
}
