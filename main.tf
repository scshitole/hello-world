provider "bigip" {
  address  = var.address
  username = var.username
  password = var.password
}
# pin to 1.1.2
terraform {
  required_providers {
    bigip = {
      source = "F5Networks/bigip"
      version = "1.5.0"
    }
  }
}


data "archive_file" "template_zip" {
  type        = "zip"
  source_file = "ConsulWebinar.yaml"
  output_path = "ConsulWebinar.zip"
}

