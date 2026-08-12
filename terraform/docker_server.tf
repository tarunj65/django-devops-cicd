resource "aws_instance" "docker_server" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = "t3.micro"
  subnet_id              = aws_subnet.public.id
  vpc_security_group_ids = [aws_security_group.docker_server.id]
  key_name               = "test-key"

  associate_public_ip_address = true
  tags = {
    Name = "terraform-docker-server"
  }
}
