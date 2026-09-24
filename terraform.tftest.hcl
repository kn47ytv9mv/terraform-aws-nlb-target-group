mock_provider "aws" {
}

run "default_config_creates_expected_resource" {
  command = apply

  variables {
    port   = 443
    vpc_id = "vpc-0123456789abcdef0"
  }

  assert {
    condition     = aws_lb_target_group.resource.protocol == "TCP"
    error_message = "protocol should default to 'TCP'."
  }

  assert {
    condition     = aws_lb_target_group.resource.target_type == "ip"
    error_message = "target_type should default to 'ip'."
  }

  assert {
    condition     = aws_lb_target_group.resource.health_check[0].protocol == "TCP"
    error_message = "health_check_protocol should default to 'TCP'."
  }

  assert {
    condition     = aws_lb_target_group.resource.health_check[0].healthy_threshold == aws_lb_target_group.resource.health_check[0].unhealthy_threshold
    error_message = "healthy_threshold and unhealthy_threshold should default equal, matching AWS's own requirement for a Network Load Balancer."
  }

  assert {
    condition     = length(aws_lb_target_group.resource.stickiness) == 0
    error_message = "stickiness_enabled was not set, so no stickiness block should be rendered."
  }
}

run "http_health_check_uses_path_and_matcher" {
  command = apply

  variables {
    port                  = 443
    vpc_id                = "vpc-0123456789abcdef0"
    health_check_protocol = "HTTP"
    health_check_path     = "/health"
    health_check_matcher  = "200-299"
  }

  assert {
    condition     = aws_lb_target_group.resource.health_check[0].protocol == "HTTP"
    error_message = "health_check_protocol should pass through unchanged."
  }

  assert {
    condition     = aws_lb_target_group.resource.health_check[0].path == "/health"
    error_message = "health_check_path should pass through unchanged."
  }
}

run "alb_target_type_for_alb_backed_target_group" {
  command = plan

  variables {
    port        = 443
    vpc_id      = "vpc-0123456789abcdef0"
    target_type = "alb"
  }

  assert {
    condition     = aws_lb_target_group.resource.target_type == "alb"
    error_message = "target_type should pass through unchanged."
  }
}

run "stickiness_enabled_renders_source_ip_stickiness" {
  command = apply

  variables {
    port               = 443
    vpc_id             = "vpc-0123456789abcdef0"
    stickiness_enabled = true
  }

  assert {
    condition     = aws_lb_target_group.resource.stickiness[0].type == "source_ip"
    error_message = "stickiness_enabled = true should render a source_ip stickiness block."
  }

  assert {
    condition     = aws_lb_target_group.resource.stickiness[0].enabled == true
    error_message = "stickiness.enabled should pass through unchanged."
  }
}

run "proxy_protocol_v2_passes_through" {
  command = plan

  variables {
    port              = 443
    vpc_id            = "vpc-0123456789abcdef0"
    proxy_protocol_v2 = true
  }

  assert {
    condition     = aws_lb_target_group.resource.proxy_protocol_v2 == true
    error_message = "proxy_protocol_v2 should pass through unchanged."
  }
}

run "readme_default_usage" {
  command = plan

  variables {
    port   = 443
    vpc_id = "vpc-0123456789abcdef0"
  }
}

run "readme_http_health_check_example" {
  command = plan

  variables {
    port                  = 8080
    vpc_id                = "vpc-0123456789abcdef0"
    health_check_protocol = "HTTP"
    health_check_path     = "/health"
  }
}
