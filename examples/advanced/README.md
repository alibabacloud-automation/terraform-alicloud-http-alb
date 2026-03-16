# Advanced HTTP Load Balancer Example

This example demonstrates advanced usage of the `http-lb` module on Alibaba Cloud, including:

- Multiple backend server groups (web and API)
- Custom health check configurations per group
- Sticky session support
- Path-based routing rules using ALB forwarding rules

## Usage

```bash
terraform init
terraform plan
terraform apply
```

## Cleanup

```bash
terraform destroy
```

## Cost

This example creates billable resources on Alibaba Cloud. Please refer to the [ALB pricing](https://www.alibabacloud.com/product/application-load-balancer/pricing) for details.
