阿里云应用型负载均衡 (ALB) Terraform 模块

# terraform-alicloud-http-lb

[English](https://github.com/alibabacloud-automation/terraform-alicloud-http-lb/blob/main/README.md) | 简体中文

用于在阿里云上创建应用型负载均衡器 (ALB) 的 Terraform 模块，支持 HTTP/HTTPS 监听器和后端服务器组。该模块旨在替代 GCP 的 [terraform-google-lb-http](https://github.com/terraform-google-modules/terraform-google-lb-http) 模块，在阿里云上提供等效的负载均衡功能。有关 ALB 的更多信息，请参阅 [ALB 产品文档](https://help.aliyun.com/zh/alb/)。

## 使用方法

创建一个具有单个后端服务器组的 HTTP 负载均衡器：

```terraform
module "http_lb" {
  source  = "alibabacloud-automation/http-lb/alicloud"

  name        = "my-http-lb"
  vpc_id      = "vpc-xxxxx"
  vswitch_ids = ["vsw-xxxxx", "vsw-yyyyy"]

  backends = {
    default = {
      protocol = "HTTP"
      vpc_id   = "vpc-xxxxx"
      servers = [
        {
          server_id   = "i-xxxxx"
          server_type = "Ecs"
          port        = 8080
          weight      = 100
        }
      ]
      health_check_config = {
        health_check_enabled = true
        health_check_path    = "/"
      }
    }
  }

  tags = {
    Environment = "production"
  }
}
```

## 示例

* [基础示例](https://github.com/alibabacloud-automation/terraform-alicloud-http-lb/tree/main/examples/basic)
* [高级示例](https://github.com/alibabacloud-automation/terraform-alicloud-http-lb/tree/main/examples/advanced)

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0 |
| <a name="requirement_alicloud"></a> [alicloud](#requirement\_alicloud) | >= 1.200.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_alicloud"></a> [alicloud](#provider\_alicloud) | >= 1.200.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [alicloud_alb_listener.http](https://registry.terraform.io/providers/aliyun/alicloud/latest/docs/resources/alb_listener) | resource |
| [alicloud_alb_listener.https](https://registry.terraform.io/providers/aliyun/alicloud/latest/docs/resources/alb_listener) | resource |
| [alicloud_alb_load_balancer.this](https://registry.terraform.io/providers/aliyun/alicloud/latest/docs/resources/alb_load_balancer) | resource |
| [alicloud_alb_rule.this](https://registry.terraform.io/providers/aliyun/alicloud/latest/docs/resources/alb_rule) | resource |
| [alicloud_alb_server_group.this](https://registry.terraform.io/providers/aliyun/alicloud/latest/docs/resources/alb_server_group) | resource |
| [alicloud_vswitches.selected](https://registry.terraform.io/providers/aliyun/alicloud/latest/docs/data-sources/vswitches) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_address_type"></a> [address\_type](#input\_address\_type) | The address type of the load balancer. Valid values: Internet, Intranet | `string` | `"Internet"` | no |
| <a name="input_backends"></a> [backends](#input\_backends) | Map of backend server group configurations | <pre>map(object({<br/>    server_group_name = optional(string)<br/>    protocol          = optional(string, "HTTP")<br/>    vpc_id            = string<br/>    servers = list(object({<br/>      server_id   = string<br/>      server_type = string<br/>      port        = number<br/>      weight      = optional(number, 100)<br/>      description = optional(string, null)<br/>    }))<br/>    health_check_config = optional(object({<br/>      health_check_enabled     = optional(bool, true)<br/>      health_check_host        = optional(string, null)<br/>      health_check_path        = optional(string, "/")<br/>      health_check_protocol    = optional(string, "HTTP")<br/>      health_check_http_method = optional(string, "HEAD")<br/>      health_check_timeout     = optional(number, 5)<br/>      health_check_interval    = optional(number, 2)<br/>      healthy_threshold        = optional(number, 3)<br/>      unhealthy_threshold      = optional(number, 3)<br/>      health_check_codes       = optional(list(string), ["http_2xx", "http_3xx"])<br/>    }), {})<br/>    sticky_session_config = optional(object({<br/>      sticky_session_enabled = optional(bool, false)<br/>      sticky_session_type    = optional(string, "Server")<br/>      cookie_timeout         = optional(number, 1000)<br/>      cookie                 = optional(string, null)<br/>    }), null)<br/>  }))</pre> | n/a | yes |
| <a name="input_create_eip"></a> [create\_eip](#input\_create\_eip) | Whether to use Fixed address allocation mode for the load balancer | `bool` | `true` | no |
| <a name="input_enable_http2"></a> [enable\_http2](#input\_enable\_http2) | Whether to enable HTTP/2 for the HTTPS listener | `bool` | `true` | no |
| <a name="input_gzip_enabled"></a> [gzip\_enabled](#input\_gzip\_enabled) | Whether to enable Gzip compression | `bool` | `true` | no |
| <a name="input_http2_enabled_for_http"></a> [http2\_enabled\_for\_http](#input\_http2\_enabled\_for\_http) | Whether to enable HTTP/2 for the HTTP listener | `bool` | `false` | no |
| <a name="input_http_port"></a> [http\_port](#input\_http\_port) | The port for HTTP listener | `number` | `80` | no |
| <a name="input_https_enabled"></a> [https\_enabled](#input\_https\_enabled) | Whether to enable HTTPS listener instead of HTTP | `bool` | `false` | no |
| <a name="input_https_port"></a> [https\_port](#input\_https\_port) | The port for HTTPS listener | `number` | `443` | no |
| <a name="input_idle_timeout"></a> [idle\_timeout](#input\_idle\_timeout) | The idle timeout in seconds for the listener | `number` | `60` | no |
| <a name="input_load_balancer_edition"></a> [load\_balancer\_edition](#input\_load\_balancer\_edition) | The edition of the ALB load balancer. Valid values: Basic, Standard, WAF | `string` | `"Standard"` | no |
| <a name="input_modification_protection_status"></a> [modification\_protection\_status](#input\_modification\_protection\_status) | The status of modification protection. Valid values: ConsoleProtection, NonProtection | `string` | `"NonProtection"` | no |
| <a name="input_name"></a> [name](#input\_name) | The name of the ALB load balancer | `string` | n/a | yes |
| <a name="input_pay_type"></a> [pay\_type](#input\_pay\_type) | The billing method of the ALB load balancer. Valid values: PayAsYouGo, Subscription | `string` | `"PayAsYouGo"` | no |
| <a name="input_request_timeout"></a> [request\_timeout](#input\_request\_timeout) | The request timeout in seconds for the listener | `number` | `60` | no |
| <a name="input_resource_group_id"></a> [resource\_group\_id](#input\_resource\_group\_id) | The ID of the resource group to which the resources belong | `string` | `null` | no |
| <a name="input_rule_action_order"></a> [rule\_action\_order](#input\_rule\_action\_order) | The order of the forwarding rule action | `number` | `1` | no |
| <a name="input_rules"></a> [rules](#input\_rules) | Map of ALB forwarding rule configurations. Each rule routes traffic to a backend server group based on conditions | <pre>map(object({<br/>    priority         = number<br/>    server_group_key = string<br/>    rule_conditions = list(object({<br/>      type = string<br/>      host_config = optional(object({<br/>        values = list(string)<br/>      }), null)<br/>      path_config = optional(object({<br/>        values = list(string)<br/>      }), null)<br/>      header_config = optional(object({<br/>        key    = string<br/>        values = list(string)<br/>      }), null)<br/>    }))<br/>  }))</pre> | `{}` | no |
| <a name="input_ssl_certificate_id"></a> [ssl\_certificate\_id](#input\_ssl\_certificate\_id) | The ID of the SSL certificate. Required when https\_enabled is true | `string` | `null` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | A map of tags to assign to the resources | `map(string)` | `{}` | no |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | The ID of the VPC where the load balancer will be created | `string` | n/a | yes |
| <a name="input_vswitch_ids"></a> [vswitch\_ids](#input\_vswitch\_ids) | List of vSwitch IDs for the load balancer zone mappings. At least two are required | `list(string)` | n/a | yes |
| <a name="input_x_forwarded_for_client_src_port_enabled"></a> [x\_forwarded\_for\_client\_src\_port\_enabled](#input\_x\_forwarded\_for\_client\_src\_port\_enabled) | Whether to use the X-Forwarded-Client-Srcport header to obtain the client port | `bool` | `true` | no |
| <a name="input_x_forwarded_for_enabled"></a> [x\_forwarded\_for\_enabled](#input\_x\_forwarded\_for\_enabled) | Whether to use the X-Forwarded-For header to obtain the real IP address of the client | `bool` | `true` | no |
| <a name="input_x_forwarded_for_proto_enabled"></a> [x\_forwarded\_for\_proto\_enabled](#input\_x\_forwarded\_for\_proto\_enabled) | Whether to use the X-Forwarded-Proto header to obtain the protocol used by the listener | `bool` | `true` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_http_listener_id"></a> [http\_listener\_id](#output\_http\_listener\_id) | The ID of the HTTP listener. Null when HTTPS is enabled |
| <a name="output_https_listener_id"></a> [https\_listener\_id](#output\_https\_listener\_id) | The ID of the HTTPS listener. Null when HTTPS is disabled |
| <a name="output_load_balancer_dns_name"></a> [load\_balancer\_dns\_name](#output\_load\_balancer\_dns\_name) | The DNS name of the ALB load balancer |
| <a name="output_load_balancer_id"></a> [load\_balancer\_id](#output\_load\_balancer\_id) | The ID of the ALB load balancer |
| <a name="output_load_balancer_status"></a> [load\_balancer\_status](#output\_load\_balancer\_status) | The status of the ALB load balancer |
| <a name="output_rule_ids"></a> [rule\_ids](#output\_rule\_ids) | A map of forwarding rule names to their IDs |
| <a name="output_server_group_ids"></a> [server\_group\_ids](#output\_server\_group\_ids) | A map of backend server group names to their IDs |
<!-- END_TF_DOCS -->

## 提交问题

如果您在使用此模块时遇到任何问题，请提交一个 [provider issue](https://github.com/aliyun/terraform-provider-alicloud/issues/new) 并告知我们。

**注意：** 不建议在此仓库中提交问题。

## 作者

由阿里云 Terraform 团队创建和维护 (terraform@alibabacloud.com)。

## 许可证

MIT 许可。有关完整详细信息，请参阅 LICENSE。

## 参考

* [Terraform-Provider-Alicloud Github](https://github.com/aliyun/terraform-provider-alicloud)
* [Terraform-Provider-Alicloud Release](https://releases.hashicorp.com/terraform-provider-alicloud/)
* [Terraform-Provider-Alicloud Docs](https://registry.terraform.io/providers/aliyun/alicloud/latest/docs)
