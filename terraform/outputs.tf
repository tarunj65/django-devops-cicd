output "jenkins_public_ip" {
  description = "Public IP address of the Jenkins server."
  value       = aws_instance.jenkins.public_ip
}

output "jenkins_private_ip" {
  description = "Private ip address of Jenkins server."
  value       = aws_instance.jenkins.private_ip
}

output "jenkins_public_dns" {
  description = "Public dns names of the Jenkins server."
  value       = aws_instance.jenkins.public_dns
}

output "docker_public_ip" {
  description = "Public IP address of the docker server."
  value       = aws_instance.docker_server.public_ip
}

output "docker_private_ip" {
  description = "Private IP address of the docker server."
  value       = aws_instance.docker_server.private_ip
}

output "docker_public_dns" {
  description = "Public DNS name of the Docker server."
  value       = aws_instance.docker_server.public_dns
}
