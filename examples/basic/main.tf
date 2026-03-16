data "alicloud_vpcs" "default" {
  name_regex = "^default-NODELETING$"
}

data "alicloud_vswitches" "default" {
  vpc_id = data.alicloud_vpcs.default.ids[0]
}

locals {
  vswitch_ids = [for vs in slice(data.alicloud_vswitches.default.vswitches, 0, 2) : vs.id]
}

resource "random_integer" "default" {
  min = 10000
  max = 99999
}

module "http_lb" {
  source = "../.."

  name        = "tf-example-basic-${random_integer.default.result}"
  vpc_id      = data.alicloud_vpcs.default.ids[0]
  vswitch_ids = local.vswitch_ids

  https_enabled = false
  http_port     = 80

  backends = {
    default = {
      protocol = "HTTP"
      vpc_id   = data.alicloud_vpcs.default.ids[0]
      servers  = []
      health_check_config = {
        health_check_enabled  = true
        health_check_path     = "/"
        health_check_protocol = "HTTP"
      }
    }
  }

  tags = {
    Environment = "tftest"
    Module      = "http-lb-basic"
  }
}
