output "instance_id" {
  description = "EC2 instance ID"
  value       = aws_instance.testec2.id
}

output "instance_public_ip" {
  description = "EC2 public IP"
  value       = aws_instance.testec2.public_ip
}

output "instance_public_dns" {
  description = "EC2 public DNS"
  value       = aws_instance.testec2.public_dns
}

output "instance_state" {
  description = "EC2 instance state"
  value       = aws_instance.testec2.instance_state
}
