output "load_balancer_id" {
  description = "The ID of the ALB load balancer"
  value       = alicloud_alb_load_balancer.this.id
}

output "load_balancer_dns_name" {
  description = "The DNS name of the ALB load balancer"
  value       = alicloud_alb_load_balancer.this.dns_name
}

output "http_listener_id" {
  description = "The ID of the HTTP listener. Null when HTTPS is enabled"
  value       = var.https_enabled ? null : alicloud_alb_listener.http[0].id
}

output "https_listener_id" {
  description = "The ID of the HTTPS listener. Null when HTTPS is disabled"
  value       = var.https_enabled ? alicloud_alb_listener.https[0].id : null
}

output "server_group_ids" {
  description = "A map of backend server group names to their IDs"
  value = {
    for k, v in alicloud_alb_server_group.this : k => v.id
  }
}

output "load_balancer_status" {
  description = "The status of the ALB load balancer"
  value       = alicloud_alb_load_balancer.this.status
}

output "rule_ids" {
  description = "A map of forwarding rule names to their IDs"
  value = {
    for k, v in alicloud_alb_rule.this : k => v.id
  }
}
