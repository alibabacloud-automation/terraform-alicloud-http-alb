output "load_balancer_id" {
  description = "The ID of the ALB load balancer"
  value       = module.http_lb.load_balancer_id
}

output "load_balancer_dns_name" {
  description = "The DNS name of the ALB load balancer"
  value       = module.http_lb.load_balancer_dns_name
}

output "load_balancer_status" {
  description = "The status of the ALB load balancer"
  value       = module.http_lb.load_balancer_status
}

output "web_server_group_id" {
  description = "The ID of the web backend server group"
  value       = module.http_lb.server_group_ids["web"]
}

output "api_server_group_id" {
  description = "The ID of the API backend server group"
  value       = module.http_lb.server_group_ids["api"]
}

output "http_listener_id" {
  description = "The ID of the HTTP listener"
  value       = module.http_lb.http_listener_id
}
