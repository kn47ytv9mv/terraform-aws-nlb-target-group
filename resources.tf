resource "random_uuid" "resource" {}

resource "aws_lb_target_group" "resource" {
  name        = coalesce(var.name, substr(random_uuid.resource.id, 0, 32))
  port        = var.port
  protocol    = var.protocol
  vpc_id      = var.vpc_id
  target_type = var.target_type

  proxy_protocol_v2 = var.proxy_protocol_v2

  health_check {
    protocol            = var.health_check_protocol
    port                = var.health_check_port
    path                = var.health_check_path
    matcher             = var.health_check_matcher
    interval            = var.health_check_interval
    healthy_threshold   = var.healthy_threshold
    unhealthy_threshold = var.unhealthy_threshold
  }

  dynamic "stickiness" {
    for_each = var.stickiness_enabled[*]

    content {
      type    = "source_ip"
      enabled = stickiness.value
    }
  }

  tags = var.tags
}

output "id" {
  description = "The ID of the target group."
  value       = aws_lb_target_group.resource.id
}

output "name" {
  description = "The name of the target group."
  value       = aws_lb_target_group.resource.name
}

output "arn" {
  description = "The ARN of the target group."
  value       = aws_lb_target_group.resource.arn
}
