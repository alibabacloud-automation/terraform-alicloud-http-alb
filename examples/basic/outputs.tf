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
