# terraform-aws-nlb-target-group

Terraform module for a Network Load Balancer target group.

## Cost

A target group has no charge of its own — its capacity is billed as
part of the Network Load Balancer Capacity Units its load balancer
consumes. See
[`terraform-aws-nlb`](https://github.com/kn47ytv9mv/terraform-aws-nlb)'s
Cost section for where that charge originates.

## Design

`health_check_protocol` is independent of `protocol` — a `TCP` or
`UDP` target group commonly still wants an `HTTP` health signal from
its targets (an application-layer check is a better health proxy than
a bare TCP handshake), so the two are not tied together the way
[`terraform-aws-alb-target-group`](https://github.com/kn47ytv9mv/terraform-aws-alb-target-group)
ties its single HTTP-only protocol to its health check.

`healthy_threshold` and `unhealthy_threshold` default equal (`3` and
`3`) because AWS requires them to match for a Network Load Balancer —
unlike an Application Load Balancer, which allows them to differ.

`target_type` accepts `'alb'` in addition to `'ip'`/`'instance'` — an
NLB can route to an Application Load Balancer as its target, a real
pattern for exposing an ALB behind a static IP or for cross-account
PrivateLink access via an NLB endpoint service.

## Usage

```hcl
module "target_group" {
  source = "kn47ytv9mv/nlb-target-group/aws"

  port   = 443
  vpc_id = module.vpc.id
}
```

Or directly from this repository, an HTTP health check on a TCP target
group:

```hcl
module "target_group" {
  source = "github.com/kn47ytv9mv/terraform-aws-nlb-target-group"

  port                   = 8080
  vpc_id                 = module.vpc.id
  health_check_protocol  = "HTTP"
  health_check_path      = "/health"
}
```

## Requirements

| Name | Version |
|---|---|
| terraform | >= 1.0 |
| aws | ~> 6.61 |
| random | ~> 3.9 |

## Providers

| Name | Version |
|---|---|
| aws | ~> 6.61 |
| random | ~> 3.9 |

## Inputs

| Name | Description | Default | Required |
|---|---|---|---|
| name | The name of the target group. If null, a unique name is generated. | `null` | no |
| port | Port the target group forwards traffic to on its targets. | `null` | no |
| protocol | Protocol the target group uses to forward traffic ('TCP', 'UDP', 'TCP_UDP', or 'TLS'). | `"TCP"` | no |
| vpc_id | The ID of the VPC the target group belongs to. | `null` | no |
| target_type | Type of target the target group routes to ('ip', 'instance', or 'alb' — the last for routing to an Application Load Balancer). | `"ip"` | no |
| health_check_protocol | Protocol the health check itself uses — independent of protocol, since a TCP or UDP target group commonly still wants an HTTP-level health signal from its targets. | `"TCP"` | no |
| health_check_port | Port the health check requests. If null, AWS defaults to the traffic port. | `null` | no |
| health_check_path | Path the health check requests, for the 'HTTP'/'HTTPS' health_check_protocol. Not used for 'TCP'. | `null` | no |
| health_check_matcher | HTTP status code(s) the health check treats as healthy, for the 'HTTP'/'HTTPS' health_check_protocol. Not used for 'TCP'. | `null` | no |
| health_check_interval | Seconds between health checks (10 or 30). | `30` | no |
| healthy_threshold | Number of consecutive successful health checks before a target is considered healthy. AWS requires this to equal unhealthy_threshold for a Network Load Balancer. | `3` | no |
| unhealthy_threshold | Number of consecutive failed health checks before a target is considered unhealthy. AWS requires this to equal healthy_threshold for a Network Load Balancer. | `3` | no |
| stickiness_enabled | Whether to enable source-IP stickiness on the target group. If null, no stickiness block is set (disabled). | `null` | no |
| proxy_protocol_v2 | Whether to enable the Proxy Protocol v2 header, so targets can see the original client IP and port. If null, AWS's own default (false) applies. | `null` | no |
| tags | A map of tags to assign to the target group. | `null` | no |

## Outputs

| Name | Description |
|---|---|
| id | The ID of the target group. |
| arn | The ARN of the target group. |
| name | The name of the target group. |

## License

MIT — see [LICENSE.md](LICENSE.md).
