provider "bigip" {
  address  = var.address
  username = var.username
  password = var.password
  port = var.port
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

 resource "bigip_fast_application" "bnginx-webserver" {
  template        = "ConsulWebinar/ConsulWebinar"
  fast_json   = <<EOF
{
      "tenant": "S2Consul_SD",
      "app": "Nginx",
      "virtualAddress": "120.0.0.200",
      "virtualPort": 8080
}
EOF
  depends_on = [bigip_fast_template.consul-webinar]
}

/*
resource "bigip_fast_application" "example-webserver" {
  template        = "examples/simple_http"
  fast_json   = <<EOF
{
      "tenant": "Consul_SD",
      "application_name": "Nginx",
      "virtualAddress": "10.0.0.200",
      "virtualPort": 8080,
      "server_port": 80
}
EOF
  depends_on = [bigip_fast_template.consul-webinar]
}
*/