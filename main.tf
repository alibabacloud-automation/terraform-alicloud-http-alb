data "alicloud_vswitches" "selected" {
  ids = var.vswitch_ids
}

resource "alicloud_alb_load_balancer" "this" {
  load_balancer_name     = var.name
  load_balancer_edition  = var.load_balancer_edition
  address_type           = var.address_type
  vpc_id                 = var.vpc_id
  address_allocated_mode = local.address_allocated_mode
  resource_group_id      = var.resource_group_id

  tags = var.tags

  load_balancer_billing_config {
    pay_type = var.pay_type
  }

  dynamic "zone_mappings" {
    for_each = var.vswitch_ids
    content {
      vswitch_id = zone_mappings.value
      zone_id    = local.vswitch_zone_map[zone_mappings.value]
    }
  }

  modification_protection_config {
    status = var.modification_protection_status
  }
}

resource "alicloud_alb_listener" "http" {
  count = var.https_enabled ? 0 : 1

  load_balancer_id     = alicloud_alb_load_balancer.this.id
  listener_protocol    = "HTTP"
  listener_port        = var.http_port
  listener_description = "${var.name}-http-listener"

  default_actions {
    type = "ForwardGroup"
    forward_group_config {
      server_group_tuples {
        server_group_id = alicloud_alb_server_group.this[keys(var.backends)[0]].id
      }
    }
  }

  gzip_enabled    = var.gzip_enabled
  http2_enabled   = var.http2_enabled_for_http
  idle_timeout    = var.idle_timeout
  request_timeout = var.request_timeout

  x_forwarded_for_config {
    x_forwarded_for_enabled                 = var.x_forwarded_for_enabled
    x_forwarded_for_proto_enabled           = var.x_forwarded_for_proto_enabled
    x_forwarded_for_client_src_port_enabled = var.x_forwarded_for_client_src_port_enabled
  }
}

resource "alicloud_alb_listener" "https" {
  count = var.https_enabled ? 1 : 0

  load_balancer_id     = alicloud_alb_load_balancer.this.id
  listener_protocol    = "HTTPS"
  listener_port        = var.https_port
  listener_description = "${var.name}-https-listener"

  default_actions {
    type = "ForwardGroup"
    forward_group_config {
      server_group_tuples {
        server_group_id = alicloud_alb_server_group.this[keys(var.backends)[0]].id
      }
    }
  }

  certificates {
    certificate_id = var.ssl_certificate_id
  }

  gzip_enabled    = var.gzip_enabled
  http2_enabled   = var.enable_http2
  idle_timeout    = var.idle_timeout
  request_timeout = var.request_timeout

  x_forwarded_for_config {
    x_forwarded_for_enabled                 = var.x_forwarded_for_enabled
    x_forwarded_for_proto_enabled           = var.x_forwarded_for_proto_enabled
    x_forwarded_for_client_src_port_enabled = var.x_forwarded_for_client_src_port_enabled
  }
}

resource "alicloud_alb_server_group" "this" {
  for_each = var.backends

  protocol          = each.value.protocol
  vpc_id            = each.value.vpc_id
  server_group_name = each.value.server_group_name != null ? each.value.server_group_name : "${var.name}-${each.key}"
  resource_group_id = var.resource_group_id
  tags              = var.tags

  dynamic "health_check_config" {
    for_each = each.value.health_check_config != null ? [each.value.health_check_config] : []
    content {
      health_check_enabled  = health_check_config.value.health_check_enabled
      health_check_host     = health_check_config.value.health_check_host
      health_check_path     = health_check_config.value.health_check_path
      health_check_protocol = health_check_config.value.health_check_protocol
      health_check_method   = health_check_config.value.health_check_http_method
      health_check_timeout  = health_check_config.value.health_check_timeout
      health_check_interval = health_check_config.value.health_check_interval
      healthy_threshold     = health_check_config.value.healthy_threshold
      unhealthy_threshold   = health_check_config.value.unhealthy_threshold
      health_check_codes    = health_check_config.value.health_check_codes
    }
  }

  dynamic "sticky_session_config" {
    for_each = [each.value.sticky_session_config != null ? each.value.sticky_session_config : { sticky_session_enabled = false, sticky_session_type = null, cookie_timeout = null, cookie = null }]
    content {
      sticky_session_enabled = sticky_session_config.value.sticky_session_enabled
      sticky_session_type    = sticky_session_config.value.sticky_session_enabled ? sticky_session_config.value.sticky_session_type : null
      cookie_timeout         = sticky_session_config.value.sticky_session_enabled ? sticky_session_config.value.cookie_timeout : null
      cookie                 = sticky_session_config.value.sticky_session_enabled ? sticky_session_config.value.cookie : null
    }
  }

  dynamic "servers" {
    for_each = each.value.servers
    content {
      server_id   = servers.value.server_id
      server_type = servers.value.server_type
      port        = servers.value.port
      weight      = servers.value.weight
      description = servers.value.description
    }
  }
}

resource "alicloud_alb_rule" "this" {
  for_each = var.rules

  listener_id = var.https_enabled ? alicloud_alb_listener.https[0].id : alicloud_alb_listener.http[0].id
  rule_name   = "${var.name}-${each.key}"
  priority    = each.value.priority

  dynamic "rule_conditions" {
    for_each = each.value.rule_conditions
    content {
      type = rule_conditions.value.type

      dynamic "host_config" {
        for_each = rule_conditions.value.host_config != null ? [rule_conditions.value.host_config] : []
        content {
          values = host_config.value.values
        }
      }

      dynamic "path_config" {
        for_each = rule_conditions.value.path_config != null ? [rule_conditions.value.path_config] : []
        content {
          values = path_config.value.values
        }
      }

      dynamic "header_config" {
        for_each = rule_conditions.value.header_config != null ? [rule_conditions.value.header_config] : []
        content {
          key    = header_config.value.key
          values = header_config.value.values
        }
      }
    }
  }

  rule_actions {
    type  = "ForwardGroup"
    order = var.rule_action_order
    forward_group_config {
      server_group_tuples {
        server_group_id = alicloud_alb_server_group.this[each.value.server_group_key].id
      }
    }
  }
}
