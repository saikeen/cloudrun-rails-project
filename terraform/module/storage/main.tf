resource "google_storage_bucket" "bucket" {
  name          = "${var.sys_name}-${var.env}-images"
  location      = "ASIA"
  force_destroy = true

  uniform_bucket_level_access = true
}

resource "google_storage_bucket" "import_data_bucket" {
  name          = "${var.sys_name}-${var.env}-import-data"
  location      = "ASIA"
  force_destroy = true

  uniform_bucket_level_access = true
}
