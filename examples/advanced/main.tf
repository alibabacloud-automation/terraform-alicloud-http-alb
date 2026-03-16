data "alicloud_vpcs" "default" {
  name_regex = "^default-NODELETING$"
}

data "alicloud_vswitches" "default" {
  vpc_id = data.alicloud_vpcs.default.ids[0]
}

resource "random_integer" "default" {
  min = 10000
  max = 99999
}

locals {
  name        = "tf-example-advanced-${random_integer.default.result}"
  vswitch_ids = [for vs in slice(data.alicloud_vswitches.default.vswitches, 0, 2) : vs.id]
}

module "http_lb" {
  source = "../.."

  name        = local.name
  vpc_id      = data.alicloud_vpcs.default.ids[0]
  vswitch_ids = local.vswitch_ids

  https_enabled = false
  http_port     = 80

  backends = {
    web = {
      server_group_name = "${local.name}-web-group"
      protocol          = "HTTP"
      vpc_id            = data.alicloud_vpcs.default.ids[0]
      servers           = []
      health_check_config = {
        health_check_enabled     = true
        health_check_path        = "/health"
        health_check_protocol    = "HTTP"
        health_check_http_method = "GET"
        health_check_timeout     = 5
        health_check_interval    = 2
        healthy_threshold        = 3
        unhealthy_threshold      = 3
        health_check_codes       = ["http_2xx", "http_3xx"]
      }
      sticky_session_config = {
        sticky_session_enabled = true
        sticky_session_type    = "Insert"
        cookie_timeout         = 1800
      }
    }
    api = {
      server_group_name = "${local.name}-api-group"
      protocol          = "HTTP"
      vpc_id            = data.alicloud_vpcs.default.ids[0]
      servers           = []
      health_check_config = {
        health_check_enabled     = true
        health_check_path        = "/status"
        health_check_protocol    = "HTTP"
        health_check_http_method = "GET"
        health_check_timeout     = 5
        health_check_interval    = 3
        healthy_threshold        = 2
        unhealthy_threshold      = 2
        health_check_codes       = ["http_2xx"]
      }
    }
  }

  rules = {
    web-path-rule = {
      priority         = 10
      server_group_key = "web"
      rule_conditions = [
        {
          type = "Path"
          path_config = {
            values = ["/", "/home", "/about", "/products/*"]
          }
        }
      ]
    }
    api-path-rule = {
      priority         = 20
      server_group_key = "api"
      rule_conditions = [
        {
          type = "Path"
          path_config = {
            values = ["/api/*", "/v1/*", "/v2/*"]
          }
        }
      ]
    }
  }

  tags = {
    Environment = "tftest"
    Module      = "http-lb-advanced"
    Team        = "platform"
  }
}
