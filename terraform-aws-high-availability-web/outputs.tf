output "instance_public_ips" {
  value = [
    aws_instance.ec2_1.public_ip,
    aws_instance.ec2_2.public_ip
  ]
}

output "alb_dns_name" {
  description = "Application Load Balancer URL"
  value       = aws_lb.this.dns_name
}