resource "aws_instance" "jenkins" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = "t3.micro"
  subnet_id              = aws_subnet.public.id
  vpc_security_group_ids = [aws_security_group.jenkins.id]
  key_name               = "test-key"

  associate_public_ip_address = true

  user_data = <<-EOF
#!/bin/bash
set -e

apt update
apt install -y git ca-certificates curl

install -m 0755 -d /etc/apt/keyrings

curl -fsSL https://download.docker.com/linux/ubuntu/gpg \
  -o /etc/apt/keyrings/docker.asc

chmod a+r /etc/apt/keyrings/docker.asc

echo "Types: deb" > /etc/apt/sources.list.d/docker.sources
echo "URIs: https://download.docker.com/linux/ubuntu" >> /etc/apt/sources.list.d/docker.sources
echo "Suites: $(. /etc/os-release && echo "$${UBUNTU_CODENAME:-$$VERSION_CODENAME}")" >> /etc/apt/sources.list.d/docker.sources
echo "Components: stable" >> /etc/apt/sources.list.d/docker.sources
echo "Architectures: $(dpkg --print-architecture)" >> /etc/apt/sources.list.d/docker.sources
echo "Signed-By: /etc/apt/keyrings/docker.asc" >> /etc/apt/sources.list.d/docker.sources

apt update

apt install -y \
  docker-ce \
  docker-ce-cli \
  containerd.io \
  docker-buildx-plugin \
  docker-compose-plugin

systemctl enable docker
systemctl start docker

usermod -aG docker ubuntu


until docker info >/dev/null 2>&1; do
  sleep 2
done


docker pull tarunjuneja06/custom-jenkins:latest


DOCKER_GID=$(stat -c '%g' /var/run/docker.sock)

docker volume create jenkins_home
JENKINS_HOME=$(docker volume inspect -f '{{.Mountpoint}}' jenkins_home)
mkdir -p "$JENKINS_HOME/.ssh"

cat > "$JENKINS_HOME/.ssh/id_ed25519" <<'SSH_PRIVATE_KEY'
${tls_private_key.jenkins_deploy.private_key_openssh}
SSH_PRIVATE_KEY

chmod 600 "$JENKINS_HOME/.ssh/id_ed25519"

cat > "$JENKINS_HOME/.ssh/id_ed25519.pub" <<'SSH_PUBLIC_KEY'
${tls_private_key.jenkins_deploy.public_key_openssh}
SSH_PUBLIC_KEY

chmod 644 "$JENKINS_HOME/.ssh/id_ed25519.pub"

chown -R 1000:1000 "$JENKINS_HOME"

docker run -d \
  --name jenkins \
  --restart unless-stopped \
  --group-add "$DOCKER_GID" \
  -p 8080:8080 \
  -p 50000:50000 \
  -v jenkins_home:/var/jenkins_home \
  -v /var/run/docker.sock:/var/run/docker.sock \
  tarunjuneja06/custom-jenkins:latest
EOF

  tags = {
    Name = "terraform-jenkins-server"
  }
}
