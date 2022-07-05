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
  source_file = "FastWAF.yaml"
  output_path = "FastWAF.zip"
}

resource "bigip_fast_template" "consul-webinar" {
  name = "FastWAF"
  source = "FastWAF.zip"
  md5_hash = filemd5("FastWAF.zip")
  depends_on = [data.archive_file.template_zip]
}

 resource "bigip_fast_application" "nginx-webserver" {
  template        = "FastWAF/FastWAF"
  fast_json   = <<EOF
{
      "tenant": "Consul_SD",
      "app": "Nginx",
      "virtualAddress": "10.0.0.200",
      "virtualPort": 8080,
      "defpool": "nginx_pool"
}
EOF
  depends_on = [bigip_fast_template.consul-webinar]
}

resource "bigip_fast_application" "nginx-app100" {
  template        = "FastWAF/FastWAF"
  fast_json   = <<EOF
{
      "tenant": "App100",
      "app": "App100",
      "virtualAddress": "11.0.0.200",
      "virtualPort": 8080,
      "defpool": "app100_pool"
}
EOF
  depends_on = [bigip_fast_template.consul-webinar]
}
/*resource "bigip_fast_application" "bbnginx-webserver" {
  template        = "ConsulWebinar/ConsulWebinar"
  fast_json   = <<EOF
{
      "tenant": "S22Consul_SD",
      "app": "Nginx",
      "virtualAddress": "122.0.0.200",
      "virtualPort": 8080
}
EOF
  depends_on = [bigip_fast_template.consul-webinar]
}*/

