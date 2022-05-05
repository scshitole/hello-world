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
      version = "1.11.1"
    }
  }
}


data "archive_file" "template_zip" {
  type        = "zip"
  source_file = "ConsulWebinar.yaml"
  output_path = "ConsulWebinar.zip"
}

resource "bigip_fast_template" "consul-webinar" {
  name = "ConsulWebinar"
  source = "ConsulWebinar.zip"
  md5_hash = filemd5("ConsulWebinar.zip")
  depends_on = [data.archive_file.template_zip]
}
