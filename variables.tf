variable "name" {
  default     = null
  description = "The name of the target group. If null, a unique name is generated."
}

variable "port" {
  default     = null
  description = "Port the target group forwards traffic to on its targets."
}

variable "protocol" {
  default     = "TCP"
  description = "Protocol the target group uses to forward traffic ('TCP', 'UDP', 'TCP_UDP', or 'TLS')."
}

variable "vpc_id" {
  default     = null
  description = "The ID of the VPC the target group belongs to."
}

variable "target_type" {
  default     = "ip"
  description = "Type of target the target group routes to ('ip', 'instance', or 'alb' — the last for routing to an Application Load Balancer)."
}

variable "health_check_protocol" {
  default     = "TCP"
  description = "Protocol the health check itself uses — independent of protocol, since a TCP or UDP target group commonly still wants an HTTP-level health signal from its targets."
}

variable "health_check_port" {
  default     = null
  description = "Port the health check requests. If null, AWS defaults to the traffic port."
}

variable "health_check_path" {
  default     = null
  description = "Path the health check requests, for the 'HTTP'/'HTTPS' health_check_protocol. Not used for 'TCP'."
}

variable "health_check_matcher" {
  default     = null
  description = "HTTP status code(s) the health check treats as healthy, for the 'HTTP'/'HTTPS' health_check_protocol. Not used for 'TCP'."
}

variable "health_check_interval" {
  default     = 30
  description = "Seconds between health checks (10 or 30)."
}

variable "healthy_threshold" {
  default     = 3
  description = "Number of consecutive successful health checks before a target is considered healthy. AWS requires this to equal unhealthy_threshold for a Network Load Balancer."
}

variable "unhealthy_threshold" {
  default     = 3
  description = "Number of consecutive failed health checks before a target is considered unhealthy. AWS requires this to equal healthy_threshold for a Network Load Balancer."
}

variable "stickiness_enabled" {
  default     = null
  description = "Whether to enable source-IP stickiness on the target group. If null, no stickiness block is set (disabled)."
}

variable "proxy_protocol_v2" {
  default     = null
  description = "Whether to enable the Proxy Protocol v2 header, so targets can see the original client IP and port. If null, AWS's own default (false) applies."
}

variable "tags" {
  default     = null
  description = "A map of tags to assign to the target group."
}
