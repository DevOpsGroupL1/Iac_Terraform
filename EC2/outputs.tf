output "ec2_sg_id-public" {
  description = "The ID of the security group."
  value       = aws_security_group.sg-public[0].id
}

output "ec2-public_ip" {
  description = "The public IP address of the instance."
  value       = [for instance in aws_instance.ec2-public : instance.public_ip]
}

