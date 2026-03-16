variable "name" {
  description = "The name of the ALB load balancer"
  type        = string
}

variable "vpc_id" {
  description = "The ID of the VPC where the load balancer will be created"
  type        = string
}

variable "vswitch_ids" {
  description = "List of vSwitch IDs for the load balancer zone mappings. At least two are required"
  type        = list(string)
}

variable "address_type" {
  description = "The address type of the load balancer. Valid values: Internet, Intranet"
  type        = string
  default     = "Internet"
}

variable "load_balancer_edition" {
  description = "The edition of the ALB load balancer. Valid values: Basic, Standard, WAF"
  type        = string
  default     = "Standard"
}

variable "create_eip" {
  description = "Whether to use Fixed address allocation mode for the load balancer"
  type        = bool
  default     = true
}

variable "https_enabled" {
  description = "Whether to enable HTTPS listener instead of HTTP"
  type        = bool
  default     = false
}

variable "http_port" {
  description = "The port for HTTP listener"
  type        = number
  default     = 80
}

variable "https_port" {
  description = "The port for HTTPS listener"
  type        = number
  default     = 443
}

variable "ssl_certificate_id" {
  description = "The ID of the SSL certificate. Required when https_enabled is true"
  type        = string
  default     = null
  sensitive   = true
}

variable "backends" {
  description = "Map of backend server group configurations"
  type = map(object({
    server_group_name = optional(string)
    protocol          = optional(string, "HTTP")
    vpc_id            = string
    servers = list(object({
      server_id   = string
      server_type = string
      port        = number
      weight      = optional(number, 100)
      description = optional(string, null)
    }))
    health_check_config = optional(object({
      health_check_enabled     = optional(bool, true)
      health_check_host        = optional(string, null)
      health_check_path        = optional(string, "/")
      health_check_protocol    = optional(string, "HTTP")
      health_check_http_method = optional(string, "HEAD")
      health_check_timeout     = optional(number, 5)
      health_check_interval    = optional(number, 2)
      healthy_threshold        = optional(number, 3)
      unhealthy_threshold      = optional(number, 3)
      health_check_codes       = optional(list(string), ["http_2xx", "http_3xx"])
    }), {})
    sticky_session_config = optional(object({
      sticky_session_enabled = optional(bool, false)
      sticky_session_type    = optional(string, "Server")
      cookie_timeout         = optional(number, 1000)
      cookie                 = optional(string, null)
    }), null)
  }))
}

variable "tags" {
  description = "A map of tags to assign to the resources"
  type        = map(string)
  default     = {}
}

variable "enable_http2" {
  description = "Whether to enable HTTP/2 for the HTTPS listener"
  type        = bool
  default     = true
}

variable "idle_timeout" {
  description = "The idle timeout in seconds for the listener"
  type        = number
  default     = 60
}

variable "request_timeout" {
  description = "The request timeout in seconds for the listener"
  type        = number
  default     = 60
}

variable "resource_group_id" {
  description = "The ID of the resource group to which the resources belong"
  type        = string
  default     = null
}

variable "rules" {
  description = "Map of ALB forwarding rule configurations. Each rule routes traffic to a backend server group based on conditions"
  type = map(object({
    priority         = number
    server_group_key = string
    rule_conditions = list(object({
      type = string
      host_config = optional(object({
        values = list(string)
      }), null)
      path_config = optional(object({
        values = list(string)
      }), null)
      header_config = optional(object({
        key    = string
        values = list(string)
      }), null)
    }))
  }))
  default = {}
}

variable "pay_type" {
  description = "The billing method of the ALB load balancer. Valid values: PayAsYouGo, Subscription"
  type        = string
  default     = "PayAsYouGo"
}

variable "modification_protection_status" {
  description = "The status of modification protection. Valid values: ConsoleProtection, NonProtection"
  type        = string
  default     = "NonProtection"
}

variable "gzip_enabled" {
  description = "Whether to enable Gzip compression"
  type        = bool
  default     = true
}

variable "http2_enabled_for_http" {
  description = "Whether to enable HTTP/2 for the HTTP listener"
  type        = bool
  default     = false
}

variable "rule_action_order" {
  description = "The order of the forwarding rule action"
  type        = number
  default     = 1
}

variable "x_forwarded_for_enabled" {
  description = "Whether to use the X-Forwarded-For header to obtain the real IP address of the client"
  type        = bool
  default     = true
}

variable "x_forwarded_for_proto_enabled" {
  description = "Whether to use the X-Forwarded-Proto header to obtain the protocol used by the listener"
  type        = bool
  default     = true
}

variable "x_forwarded_for_client_src_port_enabled" {
  description = "Whether to use the X-Forwarded-Client-Srcport header to obtain the client port"
  type        = bool
  default     = true
}
