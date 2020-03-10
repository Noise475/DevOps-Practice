# Output IP address for testing

output "elb_dns" {
  value = aws_lb.alb.dns_name
}
