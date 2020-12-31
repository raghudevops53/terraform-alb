output "PRIVATE_ALB_LISTENER_ARN" {
  value = aws_lb_listener.default.arn
}

output "PRIVATE_ALB_DNS" {
  value = aws_lb.private.dns_name
}