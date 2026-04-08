output "ansible_control_instance_id" {
  description = "Instance ID of the Ansible control node"
  value       = aws_instance.ansible_control.id
}

output "web_server_1_instance_id" {
  description = "Instance ID of web server 1"
  value       = aws_instance.web_server_1.id
}

output "web_server_2_instance_id" {
  description = "Instance ID of web server 2"
  value       = aws_instance.web_server_2.id
}

output "ansible_control_private_ip" {
  description = "Private IP of the Ansible control node"
  value       = aws_instance.ansible_control.private_ip
}

output "web_server_1_private_ip" {
  description = "Private IP of web server 1"
  value       = aws_instance.web_server_1.private_ip
}

output "web_server_2_private_ip" {
  description = "Private IP of web server 2"
  value       = aws_instance.web_server_2.private_ip
}

output "ssm_connect_commands" {
  description = "Commands to connect to instances via SSM Session Manager"
  value = {
    ansible_control = "aws ssm start-session --target ${aws_instance.ansible_control.id}"
    web_server_1    = "aws ssm start-session --target ${aws_instance.web_server_1.id}"
    web_server_2    = "aws ssm start-session --target ${aws_instance.web_server_2.id}"
  }
} 