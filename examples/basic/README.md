# Basic HTTP Load Balancer Example

This example demonstrates how to create a basic HTTP Application Load Balancer (ALB) on Alibaba Cloud using the `http-lb` module.

It provisions a VPC, two vSwitches across different availability zones, and an ALB with a single HTTP listener and one backend server group.

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
